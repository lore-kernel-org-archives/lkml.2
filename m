Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1LDAl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 19:41:26 -0500
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:50233 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1LDAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 19:41:23 -0500
X-Greylist: delayed 995 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Dec 2011 19:41:22 EST
From: psomas@gentoo.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net
Subject: [PATCH] scsi/sym53c8xx_2: Fix NULL pointer dereference in slave_destroy
Date: Sun,  4 Dec 2011 02:23:54 +0200
Message-Id: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Sun, 04 Dec 2011 02:23:56 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stratos Psomadakis <psomas@gentoo.org>

sym53c8xx_slave_destroy unconditionally assumes that sym53c8xx_slave_alloc has
succesesfully allocated a sym_lcb. This can lead to a NULL pointer dereference
(exposed by commit 4e6c82b).

Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
Cc: stable@vger.kernel.org
---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b4543f5..76432f8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -839,6 +839,10 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
 	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
 	unsigned long flags;
 
+	/* if slave_alloc returned before allocating a sym_lcb, return */
+	if (!lp)
+		return;
+
 	spin_lock_irqsave(np->s.host->host_lock, flags);
 
 	if (lp->busy_itlq || lp->busy_itl) {
-- 
1.7.8.rc1
