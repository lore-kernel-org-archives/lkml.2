Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1K3Jmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:42:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:36980 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1K3Jmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:42:53 -0500
Date: Wed, 30 Nov 2011 10:42:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, drivers_pci@kernel-bugs.osdl.org,
        =?ISO-8859-15?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [Bug 41132] [BISECTED][REGRESSION] Regression with the IRQ
 subsystem introduced in 2.6.39 (and present in the 3.x version)
In-Reply-To: <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1111301038560.2735@ionos>
References: <bug-41132-5003@https.bugzilla.kernel.org/> <201108160554.p7G5soeq002083@demeter2.kernel.org> <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com> <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Nov 2011, Linus Torvalds wrote:

> Thomas, Ingo?
> 
> I haven't seen any response to this one, and while clearly commit
> fa27271bc8d2 ("genirq: Fixup poll handling") was *supposed* to be a
> no-op, it isn't.
> 
> The commit message says "Shorter version with the same
> functionality.", but since it causes a regression, it clearly is not
> with the same functionality at all. And I assume that Thomas doesn't
> have a machine that actually ever triggers the spurious irq issue to
> begin with, so it probably was never tested.
> 
> In short, it really sounds like this should just be reverted, since
> the code clearly doesn't do what the commit message claims it does.
> 
> Comments?

Yes, Edward tracked it down already. One part of the fix is already in
your tree commit 52553ddffad. The second half is in my queue.

See below. Thanks,

    tglx

------>
>From edward.donovan@numble.net Sun Nov 20 02:57:17 2011
Date: Sat, 19 Nov 2011 20:54:23 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: [PATCH] genirq: fix second 2.6.39 regression in irqfixup, irqpoll

commit fa2727("genirq: Fixup poll handling") introduced a
regression that broke irqfixup/irqpoll for some hardware
configurations.  That patch removed a test that checked for
'action->handler' returning IRQ_HANDLED, before acting on the
IRQ.  Putting this test back restores the functionality lost
since 2.6.39.  In the current set of tests after 'action' is set,
it must precede '!action->next' to take effect.

With this and the previous patch to spurious.c, c75d720fca8a, all
IRQ regressions that I have encountered are fixed.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index b5f4742..dc813a9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -84,7 +84,9 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) || !action->next)
+	    (action->flags & __IRQF_TIMER) ||
+	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
+	    !action->next)
 		goto out;
 
 	/* Already running on another processor */
-- 
1.7.5.4


