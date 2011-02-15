Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1BONw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:52:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1BONwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ovZGr7FLvtLqzdog3W/WfEil7u12HV9upvPMb9n4ACjtF6R6OOySzjbeMn1vC+V+b1
         +c+0XthU+xpq6rrqCrMeeleLauMpvmAE5bdKU2KPSBd4dHkLnD5rMyFn4ehnr/ezLq+K
         nQ7F11zx4rh8lErQUdQeRsPq4Pi1ehAEQUJBo=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 2/2] Fix pci id check.
Date: Tue, 15 Feb 2011 19:44:10 +0530
Message-Id: <1297779250-26798-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1297779151-26595-1-git-send-email-anoop.pa@gmail.com>
References: <1297779151-26595-1-git-send-email-anoop.pa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Pci id check was failing on most of the evaluation boards.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h |    6 +++++-
 arch/mips/pci/ops-pmcmsp.c                         |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
index 4156069..c74daca 100644
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
@@ -26,7 +26,11 @@
 #ifndef _MSP_PCI_H_
 #define _MSP_PCI_H_
 
-#define MSP_HAS_PCI(ID)	(((u32)(ID) <= 0x4236) && ((u32)(ID) >= 0x4220))
+#define MSP_HAS_PCI(ID)  ((((u32)(ID) <= (0x4236)) && \
+			((u32)(ID) >= (0x4220))) || \
+			((u32)(ID) == (0x7140)))
+#define MSP_PCI_READ_REG32(base, byte_offset) \
+	(*((volatile u32 *)((u8 *)(base) + (byte_offset))))
 
 /*
  * It is convenient to program the OATRAN register so that
diff --git a/arch/mips/pci/ops-pmcmsp.c b/arch/mips/pci/ops-pmcmsp.c
index caedf9a..8d5c2e6 100644
--- a/arch/mips/pci/ops-pmcmsp.c
+++ b/arch/mips/pci/ops-pmcmsp.c
@@ -966,9 +966,9 @@ void __init msp_pci_init(void)
 	u32 id;
 
 	/* Extract Device ID */
-	id = read_reg32(PCI_JTAG_DEVID_REG, 0xFFFF) >> 12;
+	id = (MSP_PCI_READ_REG32(PCI_JTAG_DEVID_REG, 0) >> 12) & 0x0FFFF;
 
-	/* Check if JTAG ID identifies MSP7120 */
+	/* Check if JTAG ID identifies MSP71xx */
 	if (!MSP_HAS_PCI(id)) {
 		printk(KERN_WARNING "PCI: No PCI; id reads as %x\n", id);
 		goto no_pci;
-- 
1.7.0.4

