Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1HYMOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:14:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56913 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1HYMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:14:32 -0400
Date: Thu, 25 Aug 2011 13:14:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825121416.GB8883@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com> <201108232351.55432.rjw@sisk.pl> <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com> <20110823220056.GK3895@n2100.arm.linux.org.uk> <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com> <20110823221314.GL3895@n2100.arm.linux.org.uk> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:17:03AM +0200, Tejun Heo wrote:
> On Wed, Aug 24, 2011 at 12:13 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Thereby entirely preventing threads from being frozen?  You're asking
> > me to effectively disable suspend/resume on an architecture where it's
> > heavily used.  That's not a good idea, and would be an out-right
> > regression.
> 
> Eh? So, it's supposed to enter refrigerator with IRQ disabled? Then,
> moving might_sleep() inside refrigerator() doesn't help either, does
> it? Then we should be doing is,
> 
> if (freezing() && IRQ disabled) {
>       bust on IRQ;
>       try_to_freeze();
>       replug IRQ;
> }
> 
> But, that can't be right. The current code isn't triggering warning
> from scheduler code, right? If the above is the case, it should be
> triggering that. What am I missing?

The scheduler code does not check for CPU IRQs being masked.  It just
checks the preempt count, nothing more.

might_sleep() on the other hand checks the preempt count _and_ CPU IRQ
mask state.

Note that your 'IRQ disabled' will always be true for ARM at this point
at the moment - and conditionalizing this won't help (see below).

Given that get_signal_to_deliver() already forcefully enables IRQs,
I think our syscall restarting is already horribly racy here in the
way I've previously described.

It also looks to me like get_signal_to_deliver() already handles the
freezing stuff, so does ARM even need this call here?  Maybe when:

commit fc558a7496bfab3d29a68953b07a95883fdcfbb1
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Mar 23 03:00:05 2006 -0800

    [PATCH] swsusp: finally solve mysqld problem

was introduced, every other architecture should have been updated for
that change...  So this call in the ARM signal handling code to
try_to_freeze() should just be deleted as it should've been done five
years ago.
