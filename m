Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0DASXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:23:24 -0400
Received: from www.tglx.de ([62.245.132.106]:36251 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab0DASXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:23:19 -0400
Date: Thu, 1 Apr 2010 20:23:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 2.6.33.1-rt11 - BUG?
In-Reply-To: <l2me6bf505b1004011042oce87e64fn94bef56c78a1b10d@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004012015070.32352@localhost.localdomain>
References: <l2me6bf505b1004011042oce87e64fn94bef56c78a1b10d@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Xianghua Xiao wrote:

> I'm testing 2.6.33.1 on ppc 834x with rt11 patch. After system is up I keep
> seeing this same message from dmesg:
> 
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
> pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 16, name: events/0
> Call Trace:
> [cf85be80] [c00096cc] show_stack+0x6c/0x1a4 (unreliable)
> [cf85beb0] [c001f928] __might_sleep+0x104/0x108
> [cf85bec0] [c03cb444] rt_spin_lock+0xa0/0xa4
> [cf85bed0] [c0270b6c] lock_tx_qs+0x40/0x68
> [cf85bef0] [c02712cc] adjust_link+0x4c/0x240
> [cf85bf20] [c026d5ec] phy_state_machine+0x3bc/0x628
> [cf85bf40] [c003e69c] worker_thread+0x148/0x1f0
> [cf85bfa0] [c0042ec0] kthread+0x84/0x88
> [cf85bff0] [c00137f8] kernel_thread+0x4c/0x68
> BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
> pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 16, name: events/0
> 
> #uname -a
> Linux 2.6.33.1-rt11 #3 PREEMPT RT Thu Apr 1 11:58:25 CDT 2010 ppc unknown
> 
> This does not hang/lock the system yet...google reported similar 'bug' on
> older kernels. Is this a bug from 2.6.33.1-rt11 patch or I have to change
> phy.c somehow to avoid it? This traces back to a mutex lock in phy.c.

No, it traces back to a call to lock_tx_qs() which is a spinlock in
mainline and gets converted to a "sleeping" spinlock in -RT. That
means it can't be called with interrupts disabled. But the code in
adjust_link does exaclty that.

Does the patch below fix it ?

Thanks,

	tglx
---
Subject: net-gianfar-fix-rt-splat.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 01 Apr 2010 20:20:57 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/gianfar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/net/gianfar.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/gianfar.c
+++ linux-2.6-tip/drivers/net/gianfar.c
@@ -2717,7 +2717,7 @@ static void adjust_link(struct net_devic
 	struct phy_device *phydev = priv->phydev;
 	int new_state = 0;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	lock_tx_qs(priv);
 
 	if (phydev->link) {
@@ -2785,7 +2785,7 @@ static void adjust_link(struct net_devic
 	if (new_state && netif_msg_link(priv))
 		phy_print_status(phydev);
 	unlock_tx_qs(priv);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 /* Update the hash table based on the current list of multicast




