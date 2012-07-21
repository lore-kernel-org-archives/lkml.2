Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2GUGpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 02:45:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59566 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2GUGpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 02:45:51 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Kurt Garloff <garloff@suse.de>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tmscsim: spin_unlock_irq in interrupt handler fix
Date: Sat, 21 Jul 2012 10:48:03 +0400
Message-Id: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The replacement of spin_lock_irq/spin_unlock_irq pair in interrupt
handler by spin_lock_irqsave/spin_lock_irqrestore pair.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/scsi/tmscsim.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a1baccc..0b9d68a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -654,6 +654,7 @@ DC390_Interrupt(void *dev_id)
     u8  phase;
     void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
     u8  istate, istatus;
+    unsigned long flags;
 
     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
@@ -665,7 +666,7 @@ DC390_Interrupt(void *dev_id)
     //dstatus = DC390_read8 (DMA_Status);
     //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
 
-    spin_lock_irq(pACB->pScsiHost->host_lock);
+    spin_lock_irqsave(pACB->pScsiHost->host_lock, flags);
 
     istate = DC390_read8 (Intern_State);
     istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
@@ -736,7 +737,7 @@ DC390_Interrupt(void *dev_id)
     }
 
  unlock:
-    spin_unlock_irq(pACB->pScsiHost->host_lock);
+    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, flags);
     return IRQ_HANDLED;
 }
 
-- 
1.7.7

