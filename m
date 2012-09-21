Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2IUJ2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:28:47 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:4028 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353Ab2IUJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:28:46 -0400
Message-ID: <1348219723.1581.5.camel@x61.thuisdomein>
Subject: [PATCH] aic7xxx_old: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 11:28:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2012 09:28:44.0070 (UTC) FILETIME=[7E915C60:01CD97DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the aic7xxx_old driver triggers these GCC warnings:
    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]

Fix these warnings by adopting the idiom used elsewhere in this driver.
Since AHC_EISA and AHC_VL are only ever set for AHC_AIC7770 this fix
should not lead to any functional change.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed these warnings while building v3.6-rc6 on current Fedora
17, using Fedora's default config.

1) Compile tested only.

2) This patch is not checkpatch clean. But this file actually triggers
thousands of checkpatch errors and warnings:
    total: 4779 errors, 7528 warnings, 11149 lines checked

So I didn't bother to fix the few errors and warnings this patch
triggers by sticking to this file (lack of) coding style.

 drivers/scsi/aic7xxx_old.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..1a381c8 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -7893,12 +7893,12 @@ aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
 
   printk(KERN_INFO "(scsi%d) <%s> found at ", p->host_no,
     board_names[p->board_name_index]);
-  switch(p->chip)
+  switch(p->chip & ~AHC_CHIPID_MASK)
   {
-    case (AHC_AIC7770|AHC_EISA):
+    case AHC_EISA:
       printk("EISA slot %d\n", p->pci_device_fn);
       break;
-    case (AHC_AIC7770|AHC_VL):
+    case AHC_VL:
       printk("VLB slot %d\n", p->pci_device_fn);
       break;
     default:
@@ -8505,16 +8505,16 @@ aic7xxx_load_seeprom(struct aic7xxx_host *p, unsigned char *sxfrctl1)
   {
     printk(KERN_INFO "aic7xxx: Loading serial EEPROM...");
   }
-  switch (p->chip)
+  switch (p->chip & ~AHC_CHIPID_MASK)
   {
-    case (AHC_AIC7770|AHC_EISA):  /* None of these adapters have seeproms. */
+    case AHC_EISA:  /* None of these adapters have seeproms. */
       if (aic_inb(p, SCSICONF) & TERM_ENB)
         p->flags |= AHC_TERM_ENB_A;
       if ( (p->features & AHC_TWIN) && (aic_inb(p, SCSICONF + 1) & TERM_ENB) )
         p->flags |= AHC_TERM_ENB_B;
       break;
 
-    case (AHC_AIC7770|AHC_VL):
+    case AHC_VL:
       have_seeprom = read_284x_seeprom(p, (struct seeprom_config *) scarray);
       break;
 
-- 
1.7.11.4

