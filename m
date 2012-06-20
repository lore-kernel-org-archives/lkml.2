Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2FTBlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:41:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57128 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2FTBlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:41:01 -0400
From: "NickCheng" <nick.cheng@areca.com.tw>
To: "'James Bottomley'" <James.Bottomley@HansenPartnership.com>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1340121415.3004.57.camel@dabdike.int.hansenpartnership.com>
Subject: RE: [Fwd: [patch] [SCSI] arcmsr: fix misuse of | instead of &]
Date: Wed, 20 Jun 2012 09:38:10 +0800
Message-ID: <02F0C1478CF5442C9D543E3A87B82B82@arecaaebe11fae>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac1ONCr7kh2bxkRMQCS2L+D1se/SwwAUOZAQ
In-Reply-To: <1340121415.3004.57.camel@dabdike.int.hansenpartnership.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,
Sorry for be late response.
I am OK with it.
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Tuesday, June 19, 2012 11:57 PM
To: Nick Cheng
Subject: [Fwd: [patch] [SCSI] arcmsr: fix misuse of | instead of &]

Is this OK with you?

James

-------- Forwarded Message --------
From: Dan Carpenter <dan.carpenter@oracle.com>
To: James E.J. Bottomley <JBottomley@parallels.com>
Cc: David Howells <dhowells@redhat.com>, Nick Cheng
<nick.cheng@areca.com.tw>, , kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] arcmsr: fix misuse of | instead of &
Date: Sat, 9 Jun 2012 12:10:19 +0300

ARCMSR_ARC1880_DiagWrite_ENABLE is 0x00000080 so (x | 0x00000080) is
never zero.  The intent here was to test that loop until
ARCMSR_ARC1880_DiagWrite_ENABLE was turned on, but because the test was
wrong, we would do five loops regardless of whether it succeed or not.

Also I simplified the condition a little by removing the unused
assignement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  I do not own this hardware.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
index cbde1dc..def24a1 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2821,7 +2821,7 @@ static void arcmsr_hardware_reset(struct
AdapterControlBlock *acb)
 	int i, count = 0;
 	struct MessageUnit_A __iomem *pmuA = acb->pmuA;
 	struct MessageUnit_C __iomem *pmuC = acb->pmuC;
-	u32 temp = 0;
+
 	/* backup pci config data */
 	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
 	for (i = 0; i < 64; i++) {
@@ -2839,7 +2839,7 @@ static void arcmsr_hardware_reset(struct
AdapterControlBlock *acb)
 			writel(0x2, &pmuC->write_sequence);
 			writel(0x7, &pmuC->write_sequence);
 			writel(0xD, &pmuC->write_sequence);
-		} while ((((temp = readl(&pmuC->host_diagnostic)) |
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+		} while (((readl(&pmuC->host_diagnostic) &
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC1880_RESET_ADAPTER,
&pmuC->host_diagnostic);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


