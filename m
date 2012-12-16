Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2LPDEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 22:04:44 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:59799 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab2LPDEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 22:04:43 -0500
Date: Sun, 16 Dec 2012 03:04:42 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121216030442.GA28172@dcvr.yhbt.net>
References: <20121215005448.GA7698@dcvr.yhbt.net>
 <20121216024520.GH9806@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216024520.GH9806@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 15, 2012 at 12:54:48AM +0000, Eric Wong wrote:
> > Applications streaming large files may want to reduce disk spinups and
> > I/O latency by performing large amounts of readahead up front.
> > Applications also tend to read files soon after opening them, so waiting
> > on a slow fadvise may cause unpleasant latency when the application
> > starts reading the file.
> > 
> > As a userspace hacker, I'm sometimes tempted to create a background
> > thread in my app to run readahead().  However, I believe doing this
> > in the kernel will make life easier for other userspace hackers.
> > 
> > Since fadvise makes no guarantees about when (or even if) readahead
> > is performed, this change should not hurt existing applications.
> > 
> > "strace -T" timing on an uncached, one gigabyte file:
> > 
> >  Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832>
> >   After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>
> 
> You've basically asked fadvise() to readahead the entire file if it
> can. That means it is likely to issue enough readahead to fill the
> IO queue, and that's where all the latency is coming from. If all
> you are trying to do is reduce the latency of the first read, then
> only readahead the initial range that you are going to need to read...

Yes, I do want to read the whole file, eventually.  So I want to put
the file into the page cache ASAP and allow the disk to spin down.
But I also want the first read() to be fast.

> Also, Pushing readahead off to a workqueue potentially allows
> someone to DOS the system because readahead won't ever get throttled
> in the syscall context...

Yes, I'm a little worried about this, too.
Perhaps squashing something like the following will work?

diff --git a/mm/readahead.c b/mm/readahead.c
index 56a80a9..51dc58e 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -246,16 +246,18 @@ void wq_page_cache_readahead(struct address_space *mapping, struct file *filp,
 {
 	struct wq_ra_req *req;
 
+	nr_to_read = max_sane_readahead(nr_to_read);
+	if (!nr_to_read)
+		goto skip_ra;
+
 	req = kzalloc(sizeof(*req), GFP_ATOMIC);
 
 	/*
 	 * we are fire-and-forget, not having enough memory means readahead
 	 * is not worth doing anyways
 	 */
-	if (!req) {
-		fput(filp);
-		return;
-	}
+	if (!req)
+		goto skip_ra;
 
 	INIT_WORK(&req->work, wq_ra_req_fn);
 	req->mapping = mapping;
@@ -264,6 +266,9 @@ void wq_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	req->nr_to_read = nr_to_read;
 
 	queue_work(readahead_wq, &req->work);
+
+skip_ra:
+	fput(filp);
 }
 
 /*
