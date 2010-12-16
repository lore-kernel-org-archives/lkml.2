Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0LPJFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:05:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33005 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0LPJFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tRdf0KRIuPB/A2abHZl3O53sV4NyqdVPqm8/xjWaG6zphuPpgkLk7P04kMXG/Lvp7L
         TrEcTWXbFEMaRMbFoOP6vYo+4mu/Hz0DuBO0TR7wOk2MzYjOO49l37w6PTPAwFRupXW/
         n4NcdMPrO7XW6GSGbQpqIRabZPhMqB6XP5lwc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikJFCvSQana-x9xCwSfOELdQXApd=kYyZX5OpF2@mail.gmail.com>
References: <AANLkTi=vd4J8DfnLgPROrNC2Q-jxSCsrv=nv371Rhq5i@mail.gmail.com>
	<AANLkTikJFCvSQana-x9xCwSfOELdQXApd=kYyZX5OpF2@mail.gmail.com>
Date: Thu, 16 Dec 2010 10:05:41 +0100
Message-ID: <AANLkTimaUqL+qiNP2_5cxTAGkg3O1=3+1ODJfY6XFmwz@mail.gmail.com>
Subject: Unbalanced enable for IRQ => phy_change
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I am currently using a MPC8548 PowerPC board, and I have encountered
the following problem :
[   19.867849] Unbalanced enable for IRQ 48
[   19.867855] ------------[ cut here ]------------
[   19.873819] Badness at /.../kernel/irq/manage.c:174
[   19.873823] NIP: c0044acc LR: c0044acc CTR: c0018480
[   19.873828] REGS: dfc2be60 TRAP: 0700   Tainted: P
(2.6.24.7_www.men.de_1.1)
[   19.873831] MSR: 00021000 <ME>  CR: 24000022  XER: 00000000
[   19.873839] TASK = dfc204e0[5] 'events/0' THREAD: dfc2a000
[   19.873842] GPR00: c0044acc dfc2bf10 dfc204e0 0000002f 00021000
00000000 00000000 00000000
[   19.873854] GPR08: 00000034 ffffffff 0000574e de821b20 24000024
100607bc 00008000 00001020
[   19.873865] GPR16: c0447b44 c0447b2c 00fff018 033327d2 00000008
c044b2c8 c048d1a8 c044b300
[   19.873877] GPR24: dfc206a0 dfc204e0 dfc01f30 dfc2a000 00029000
c04cb714 00000030 c04cb6e4
[   19.873890] NIP [c0044acc] enable_irq+0x6c/0xdc
[   19.873903] LR [c0044acc] enable_irq+0x6c/0xdc
[   19.873908] Call Trace:
[   19.873911] [dfc2bf10] [c0044acc] enable_irq+0x6c/0xdc (unreliable)
[   19.873919] [dfc2bf30] [c0217868] phy_change+0x74/0xe4
[   19.873926] [dfc2bf50] [c002fb2c] run_workqueue+0xc4/0x15c
[   19.873933] [dfc2bf90] [c002ffb0] worker_thread+0x74/0xd4
[   19.873940] [dfc2bfd0] [c0034360] kthread+0x48/0x84
[   19.873946] [dfc2bff0] [c00047bc] kernel_thread+0x44/0x60
[   19.873953] Instruction dump:
[   19.873957] 7fe04a14 3bbf0030 7fa3eb78 483a9461 813f001c 7c7c1b78
2f890000 409e0038
[   19.873968] 3c60c045 7fc4f378 3863f1d4 4bfd9129 <0fe00000> 7fa3eb78
7f84e378 483a91a5


When looking at the phy_change function in drivers/net/phy/phy.c I
have noticed something quite strange :
We are calling phy_disable_interrupts() and after some operations, enable_irq().
The first thing I thought about is why aren't we calling
disable_irq/enable_irq or phy_disable_interrupts/phy_enable_interrupts
but a mix ?

Next, I took a more deep look at phy_disable_interrupts() and
sepcifically at the phy_config_interrupt() function :

       int err = 0;

       phydev->interrupts = interrupts;
       if (phydev->drv->config_intr)
               err = phydev->drv->config_intr(phydev);

       return err;

If phydev->drv->config_intr is not implemented (this is my use case :
I am using the drivers/net/gianfar.c driver), then, nothing will be
done, and there is no disable_irq() call.

I don't know what is better : using disable_irq/enable_irq or the phy
specific functions, but I think that we should avoid using a mix...
Am I wrong ?

Thanks in advance,
Regards,
JM
