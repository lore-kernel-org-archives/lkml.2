Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1HWWf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:35:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54469 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1HWWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:35:22 -0400
Date: Wed, 24 Aug 2011 00:35:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110823223518.GI2803@mtj.dyndns.org>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
 <201108232351.55432.rjw@sisk.pl>
 <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
 <20110823220056.GK3895@n2100.arm.linux.org.uk>
 <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
 <20110823221314.GL3895@n2100.arm.linux.org.uk>
 <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:17:03AM +0200, Tejun Heo wrote:
> if (freezing() && IRQ disabled) {
>       bust on IRQ;
>       try_to_freeze();
>       replug IRQ;
> }
> 
> But, that can't be right. The current code isn't triggering warning
> from scheduler code, right? If the above is the case, it should be
> triggering that. What am I missing?

I think the refrigerator() code was actually doing that through
spin_[un]lock_irq(), so it was accidentally masking the problem.  It
definitely seems to need fixing.

Anyways, for now, we can do two things,

1. if (freezing()) { irq_save; try_to_freeze(); irq_restore; } w/ BIG
   FAT UGLY comment.

2. Drop might_sleep() from try_to_freeze().  Moving it to
   refrigerator() wouldn't help much.  It would just trigger more
   sporadically during freeze, which is arguably worse than now.

I'd prefer #1 given that it documents the breakage while also
restoring the IRQ state afterwards FWIW.

Thanks.

-- 
tejun
