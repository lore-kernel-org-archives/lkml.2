Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1BCH4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 02:56:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49677 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1BCH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 02:56:24 -0500
Date: Thu, 3 Feb 2011 08:56:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [patch 6/8] arm: ns9xxx: Remove private irq flow handler
Message-ID: <20110203075623.GB30452@pengutronix.de>
References: <20110202212258.546660886@linutronix.de>
 <20110202212552.299898447@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110202212552.299898447@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Feb 02, 2011 at 09:41:27PM -0000, Thomas Gleixner wrote:
> handle_prio_irq is almost identical with handle_fasteoi_irq. The
> subtle differences are
> 
> 1) The handler checks for IRQ_DISABLED after the device handler has
>    been called. In case it's set it masks the interrupt.
> 
> 2) When the handler sees IRQ_DISABLED on entry it masks the interupt
>    in the same way as handle_fastoei_irq, but does not set the
>    IRQ_PENDING flag.
> 
> 3) Instead of gracefully handling a recursive interrupt it crashes the
>    kernel.
> 
> #1 is just relevant when a device handler calls disable_irq_nosync()
>    and it does not matter whether we mask the interrupt right away or
>    not. We handle lazy masking for disable_irq anyway, so there is no
>    real reason to have this extra mask in place.
> 
> #2 will prevent the resend of a pending interrupt, which can result in
>    lost interrupts for edge type interrupts. For level type interrupts
>    the resend is a noop in the generic code. According to the
>    datasheet all interrupts are level type, so marking them as such
>    will result in the exact same behaviour as the private
>    handle_prio_irq implementation.
> 
> #3 is just stupid. Crashing the kernel instead of handling a problem
>    gracefully is just wrong. With the current semantics- all handlers
>    run with interrupts disabled - this is even more wrong.
> 
> Rename ack to eoi, remove the unused mask_ack, switch to
> handle_fasteoi_irq and remove the private function.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
I have no access to a ns9xxx machine, but this looks sane.

Acked-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
