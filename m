Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2HOUSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:18:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:36872 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2HOTvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vasily Averin <vvs@parallels.com>, Vasily Averin <vvs@sw.ru>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 055/165] aacraid: reset should disable MSI interrupt
Date: Wed, 15 Aug 2012 15:46:39 -0400
Message-ID: <1345060109-9187-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Averin <vvs@parallels.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d0efab26f89506387a1bde898556660e06d7eb15 upstream.

scsi reset on hardware with enabled MSI interrupts generates WARNING message

[11027.798722] aacraid: Host adapter abort request (0,0,0,0)
[11027.798814] aacraid: Host adapter reset request. SCSI hang ?
[11087.762237] aacraid: SCSI bus appears hung
[11135.082543] ------------[ cut here ]------------
[11135.082646] WARNING: at drivers/pci/msi.c:658 pci_enable_msi_block+0x251/0x290()

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/aacraid/commsup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 94d2954..2cb663f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1242,6 +1242,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	kfree(aac->queues);
 	aac->queues = NULL;
 	free_irq(aac->pdev->irq, aac);
+	if (aac->msi)
+		pci_disable_msi(aac->pdev);
 	kfree(aac->fsa_dev);
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
-- 
1.7.12.rc2

