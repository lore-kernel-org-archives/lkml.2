Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031374Ab2COXAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:00:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57636 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2COXAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:00:01 -0400
Date: Fri, 16 Mar 2012 00:59:52 +0200
From: Ido Yariv <ido@wizery.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Flush the irq thread on synchronization
Message-ID: <20120315225952.GA18032@WorkStation>
References: <1322843052-7166-1-git-send-email-ido@wizery.com>
 <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org>
 <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Thu, Mar 15, 2012 at 08:07:56PM +0100, Alexander Gordeev wrote:
> > -	/* Prevent a stale desc->threads_oneshot */
> > -	irq_finalize_oneshot(desc, action, true);
> > +	/*
> > +	 * This is the regular exit path. __free_irq() is stopping the
> > +	 * thread via kthread_stop() after calling
> > +	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
> > +	 * oneshot mask bit should be set.
> > +	 *
> > +	 * Verify that this is true.
> > +	 */
> > +	if (WARN_ON(test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags)))
> > +		wake_threads_waitq(desc);
> 
> If we hit this warning we do not know if this IRQTF_RUNTHREAD bit's count in
> desc->threads_active was decremented or not.
> 
> Nevertheless, wake_threads_waitq() gets called and desc->threads_active gets
> decremented. As result, if desc->threads_active initially was decremented, we
> might wrongly wake up the queue while some threaded handler is still running.
> 
> By contrast, if we choose not to wake up here, we might stuck in
> synchronize_irq(). Which is probably better than a fooling synchronize_irq().

AFAICT, IRQTF_RUNTHREAD and the desc->threads_active are always modified
together:
desc->threads_active is incremented if and only if IRQTF_RUNTHREAD is
set after being cleared (in irq_wake_thread()).
desc->threads_active is decremented in wake_threads_waitq(), which is
only called when IRQTF_RUNTHREAD is cleared.

It seems that if we get to this point, either IRQTF_RUNTHREAD is set and
desc->threads_active was not decremented, or it is not set.

Do you see any case where the two will be out of sync?


> > +
> > +	if (WARN_ON(desc->threads_oneshot & action->thread_mask))
> > +		irq_finalize_oneshot(desc, action, true);
> 
> This check is called when the action is already removed in __free_irq() and no
> desc->lock is held. Hence, a concurrent __setup_irq() could reallocate the very
> same bit in the meantime. So neither irq_finalize_oneshot() nor the warning
> are legitimate here.

That's interesting. However, it doesn't seem to be a regression that's
caused by this patch (the irq_finalize_oneshot() was there before), so
it might be a good idea to fix this separately.

Thanks,
Ido.
