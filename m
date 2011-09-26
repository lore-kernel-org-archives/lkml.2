Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1IZQy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:54:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37266 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab1IZQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:54:27 -0400
Date: Mon, 26 Sep 2011 17:50:24 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Huajun Li <huajun.li.lee@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Question about memory leak detector giving false positive
 report for net/core/flow.c
Message-ID: <20110926165024.GA21617@e102109-lin.cambridge.arm.com>
References: <CA+v9cxadZzWr35Q9RFzVgk_NZsbZ8PkVLJNxjBAMpargW9Lm4Q@mail.gmail.com>
 <1317054774.6363.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317054774.6363.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 05:32:54PM +0100, Eric Dumazet wrote:
> Le lundi 26 septembre 2011 à 23:17 +0800, Huajun Li a écrit :
> > Memory leak detector gives following memory leak report, it seems the
> > report is triggered by net/core/flow.c, but actually, it should be a
> > false positive report.
> > So, is there any idea from kmemleak side to fix/disable this false
> > positive report like this?
> > Yes, kmemleak_not_leak(...) could disable it, but is it suitable for this case ?
...
> CC lkml and percpu maintainers (Tejun Heo & Christoph Lameter ) as well
> 
> AFAIK this false positive only occurs if percpu data is allocated
> outside of embedded pcu space. 
> 
>  (grep pcpu_get_vm_areas /proc/vmallocinfo)
> 
> I suspect this is a percpu/kmemleak cooperation problem (a missing
> kmemleak_alloc() ?)
> 
> I am pretty sure kmemleak_not_leak() is not the right answer to this
> problem.

kmemleak_not_leak() definitely not the write answer. The alloc_percpu()
call does not have any kmemleak_alloc() callback, so it doesn't scan
them.

Huajun, could you please try the patch below:

8<--------------------------------
kmemleak: Handle percpu memory allocation

From: Catalin Marinas <catalin.marinas@arm.com>

This patch adds kmemleak callbacks from the percpu allocator, reducing a
number of false positives caused by kmemleak not scanning such memory
blocks.

Reported-by: Huajun Li <huajun.li.lee@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/percpu.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index bf80e55..c47a90b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -67,6 +67,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/kmemleak.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -833,7 +834,9 @@ fail_unlock_mutex:
  */
 void __percpu *__alloc_percpu(size_t size, size_t align)
 {
-	return pcpu_alloc(size, align, false);
+	void __percpu *ptr = pcpu_alloc(size, align, false);
+	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
+	return ptr;
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);
 
@@ -855,7 +858,9 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
  */
 void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
 {
-	return pcpu_alloc(size, align, true);
+	void __percpu *ptr = pcpu_alloc(size, align, true);
+	kmemleak_alloc(ptr, size, 1, GFP_KERNEL);
+	return ptr;
 }
 
 /**
@@ -915,6 +920,8 @@ void free_percpu(void __percpu *ptr)
 	if (!ptr)
 		return;
 
+	kmemleak_free(ptr);
+
 	addr = __pcpu_ptr_to_addr(ptr);
 
 	spin_lock_irqsave(&pcpu_lock, flags);

-- 
Catalin
