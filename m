Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1EaC3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:29:17 -0400
Received: from fbr03.mfg.siteprotect.com ([64.26.60.138]:48634 "EHLO
	fbr03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab1EaC3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:29:15 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 22:29:15 EDT
Date: Mon, 30 May 2011 21:33:05 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Vince Weaver <vweaver1@eecs.utk.edu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
Message-ID: <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu> 
 <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
 <1306578144.1200.1150.camel@twins> <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Vince Weaver wrote:

> On Sat, 28 May 2011, Peter Zijlstra wrote:
> 
> > On Fri, 2011-05-27 at 23:38 -0400, Vince Weaver wrote:
> > > on that note (and while trying to document exactly what the ioctls do) it 
> > > seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
> > > than one does not work on kernels 2.6.36 and newer.  The behavior acts
> > > as if 1 was passed, even if you pass in, say, 3.
> > 
> > Urgh, no that should definitely work. Thanks for the test-case, I'll
> > work on that (probably not until Monday though, but who knows).
> > 
> 
> after a painfully long bisection, it turns out that this problem was in
> theory introduced by the following commit:
> 
>   d57e34fdd60be7ffd0b1d86bfa1a553df86b7172
> 
>   perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed
> 
> I'll see if I can come up with a patch, but it's a bit non-obvious why
> this commit is affecting the REFRESH value at all.

the problem was the mentioned commit tried to optimize the use of 
watermark and wakeup_watermark without taking into account that 
wakeup_watermark is a union with wakeup_events.

The patch below *should* fix it, but something unrelated has broken 
overflow support between 2.6.39 and 3.0-rc1 which I haven't had time to 
investigate.  The overflow count is suddenly about 10x what it should be 
though.  So the below is semi-untested and I possibly need to do another 
bisect.  *sigh*

Vince

Signed-off-by: Vince Weaver <vweaver1@cl320.eecs.utk.edu>


diff --git a/kernel/events/core.c b/kernel/events/core.c
index d863b3c..e3ff283 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3403,12 +3403,14 @@ unlock:
 static unsigned long perf_data_size(struct perf_buffer *buffer);
 
 static void
-perf_buffer_init(struct perf_buffer *buffer, long watermark, int flags)
+perf_buffer_init(struct perf_buffer *buffer, 
+		 long watermark, 
+		 long wakeup_watermark, int flags)
 {
 	long max_size = perf_data_size(buffer);
 
 	if (watermark)
-		buffer->watermark = min(max_size, watermark);
+		buffer->watermark = min(max_size, wakeup_watermark);
 
 	if (!buffer->watermark)
 		buffer->watermark = max_size / 2;
@@ -3451,7 +3453,8 @@ static void *perf_mmap_alloc_page(int cpu)
 }
 
 static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
+perf_buffer_alloc(int nr_pages, long watermark, 
+		  long wakeup_watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
 	unsigned long size;
@@ -3476,7 +3479,7 @@ perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 
 	buffer->nr_pages = nr_pages;
 
-	perf_buffer_init(buffer, watermark, flags);
+	perf_buffer_init(buffer, watermark, wakeup_watermark, flags);
 
 	return buffer;
 
@@ -3568,7 +3571,8 @@ static void perf_buffer_free(struct perf_buffer *buffer)
 }
 
 static struct perf_buffer *
-perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
+perf_buffer_alloc(int nr_pages, long watermark, 
+		  long wakeup_watermark, int cpu, int flags)
 {
 	struct perf_buffer *buffer;
 	unsigned long size;
@@ -3592,7 +3596,7 @@ perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 	buffer->page_order = ilog2(nr_pages);
 	buffer->nr_pages = 1;
 
-	perf_buffer_init(buffer, watermark, flags);
+	perf_buffer_init(buffer, watermark, wakeup_watermark, flags);
 
 	return buffer;
 
@@ -3787,7 +3791,9 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		flags |= PERF_BUFFER_WRITABLE;
 
-	buffer = perf_buffer_alloc(nr_pages, event->attr.wakeup_watermark,
+	buffer = perf_buffer_alloc(nr_pages, 
+				   event->attr.watermark,
+				   event->attr.wakeup_watermark,
 				   event->cpu, flags);
 	if (!buffer) {
 		ret = -ENOMEM;
