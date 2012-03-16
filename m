Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032299Ab2CPKG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:06:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:44998 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2CPKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:06:55 -0400
Date: Fri, 16 Mar 2012 11:06:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ido Yariv <ido@wizery.com>
cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Flush the irq thread on synchronization
In-Reply-To: <20120315225952.GA18032@WorkStation>
Message-ID: <alpine.LFD.2.02.1203161102190.2466@ionos>
References: <1322843052-7166-1-git-send-email-ido@wizery.com> <tip-7140ea1980f2fae9c7aaeac5f6b35317e1389ee6@git.kernel.org> <20120315190755.GA6732@dhcp-26-207.brq.redhat.com> <20120315225952.GA18032@WorkStation>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Ido Yariv wrote:
> On Thu, Mar 15, 2012 at 08:07:56PM +0100, Alexander Gordeev wrote:
> > Nevertheless, wake_threads_waitq() gets called and desc->threads_active gets
> > decremented. As result, if desc->threads_active initially was decremented, we
> > might wrongly wake up the queue while some threaded handler is still running.
> > 
> > By contrast, if we choose not to wake up here, we might stuck in
> > synchronize_irq(). Which is probably better than a fooling synchronize_irq().
> 
> AFAICT, IRQTF_RUNTHREAD and the desc->threads_active are always modified
> together:
> desc->threads_active is incremented if and only if IRQTF_RUNTHREAD is
> set after being cleared (in irq_wake_thread()).
> desc->threads_active is decremented in wake_threads_waitq(), which is
> only called when IRQTF_RUNTHREAD is cleared.
> 
> It seems that if we get to this point, either IRQTF_RUNTHREAD is set and
> desc->threads_active was not decremented, or it is not set.
> 
> Do you see any case where the two will be out of sync?

There is really no way, that the flag is set when we come out this
regular exit path.

__free_irq()
	remove action
	synchronize_irq()
	kthread_stop()

So after the action is removed and synchronize_irq() made sure that
the thread has finished IRQTF_RUNTHREAD cannot be set. Neither can we
have a stale threads_oneshot bit set from this action.

That's a leftover of the old code and I really did not think it
through fully and kept the stuff along with paranoid warnings.

I'm going to remove all of it.

Thanks,

	tglx
