Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2ITRte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:49:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2ITRtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:49:32 -0400
Date: Thu, 20 Sep 2012 10:49:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-ID: <20120920174927.GD28934@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
 <20120919145228.80f72f59.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919145228.80f72f59.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Sep 19, 2012 at 02:52:28PM -0700, Andrew Morton wrote:
> I have a bunch of fairly trivial comments, and one head-scratcher for
> Tejun: what's up with the local-irqs-disabled requirement in sg_miter_next()?

> > +static bool sg_compare_to_buffer(struct scatterlist *sg,
> > +					int offset, u8 *buffer, size_t len)
> > +{
> > +	unsigned long flags;
> > +	int retval = 0;
> > +	struct sg_mapping_iter miter;
> > +
> > +	local_irq_save(flags);
> 
> hm, the "IRQ disabled if SG_MITER_ATOMIC" requirement of
> sg_miter_next() is weird and unexpected.
> 
> Tejun's 137d3edb48425f8 added the code whch has this strange
> requirement, but it is unexplained.  Wazzup?

Heh, that's long time ago.  Trying to remember... so it was written
before kmap_atomic() is converted to stack based implementation and
had to be supplied with the specific KMAP index.  Atomic mapping
iterator should be useable from irq context too (and there were other
irq handler paths using KM_BIO_SRC_IRQ as the name implies), so it
couldn't allow irq to happen while mapping is in use.  At the time,
having to disable IRQ to use any of KM_*_IRQs was rather self-evident.

I think we now can relax the requirement.  All that's required is not
to sleep or preempted while mapped.  Something like the following is
in order?

--------8<--------
Subject: scatterlist: atomic sg_mapping_iter no longer needs disabling IRQ

SG mapping iterator w/ SG_MITER_ATOMIC set required IRQ disabled
because it originally used KM_BIO_SRC_IRQ to allow use from IRQ
handlers.  kmap_atomic() has long been updated to handle stacking
atomic mapping requests on per-cpu basis and only requires not
sleeping while mapped.

Update sg_mapping_iter such that atomic iterators only require
disabling preemption instead of disabling IRQ.

While at it, convert wte weird @ARG@ notations to @ARG in the comment
of sg_miter_start().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/scatterlist.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index fadae77..e76d85c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -404,14 +404,13 @@ EXPORT_SYMBOL(sg_miter_start);
  * @miter: sg mapping iter to proceed
  *
  * Description:
- *   Proceeds @miter@ to the next mapping.  @miter@ should have been
- *   started using sg_miter_start().  On successful return,
- *   @miter@->page, @miter@->addr and @miter@->length point to the
- *   current mapping.
+ *   Proceeds @miter to the next mapping.  @miter should have been started
+ *   using sg_miter_start().  On successful return, @miter->page,
+ *   @miter->addr and @miter->length point to the current mapping.
  *
  * Context:
- *   IRQ disabled if SG_MITER_ATOMIC.  IRQ must stay disabled till
- *   @miter@ is stopped.  May sleep if !SG_MITER_ATOMIC.
+ *   Preemption disabled if SG_MITER_ATOMIC.  Preemption must stay disabled
+ *   till @miter is stopped.  May sleep if !SG_MITER_ATOMIC.
  *
  * Returns:
  *   true if @miter contains the next mapping.  false if end of sg
@@ -465,7 +464,8 @@ EXPORT_SYMBOL(sg_miter_next);
  *   resources (kmap) need to be released during iteration.
  *
  * Context:
- *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ *   Preemption disabled if the SG_MITER_ATOMIC is set.  Don't care
+ *   otherwise.
  */
 void sg_miter_stop(struct sg_mapping_iter *miter)
 {
@@ -479,7 +479,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 			flush_kernel_dcache_page(miter->page);
 
 		if (miter->__flags & SG_MITER_ATOMIC) {
-			WARN_ON(!irqs_disabled());
+			WARN_ON_ONCE(preemptible());
 			kunmap_atomic(miter->addr);
 		} else
 			kunmap(miter->page);
