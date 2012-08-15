Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2HOUUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:20:41 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62944 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2HOTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Anton Blanchard <anton@samba.org>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 066/165] ipr: Always initiate hard reset in kdump kernel
Date: Wed, 15 Aug 2012 15:46:50 -0400
Message-ID: <1345060109-9187-67-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5d7c20b7fa5c6ca19e871b4050e321c99d32bd43 upstream.

During kdump testing I noticed timeouts when initialising each IPR
adapter. While the driver has logic to detect an adapter in an
indeterminate state, it wasn't triggering and each adapter went
through a 5 minute timeout before finally going operational.

Some analysis showed the needs_hard_reset flag wasn't getting set.
We can check the reset_devices kernel parameter which is set by
kdump and force a full reset. This fixes the problem.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 520461b..771eb42 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8543,7 +8543,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
 	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg32);
 	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
 		ioa_cfg->needs_hard_reset = 1;
-	if (interrupts & IPR_PCII_ERROR_INTERRUPTS)
+	if ((interrupts & IPR_PCII_ERROR_INTERRUPTS) || reset_devices)
 		ioa_cfg->needs_hard_reset = 1;
 	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
 		ioa_cfg->ioa_unit_checked = 1;
-- 
1.7.12.rc2

