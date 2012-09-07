Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2IGPci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:32:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2IGPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:31 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 10/11] target: do not submit a zero-bio I/O request
Date: Fri,  7 Sep 2012 17:30:41 +0200
Message-Id: <1347031842-2531-11-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_setup_fs_cmnd does not like to receive requests with no
bios attached to it.  Special-case zero-length reads and writes,
by not submitting any bio.

Testcase: sg_raw /dev/sdb 28 00 00 00 00 00 00 00 00 00
    should not fail
    panics with the rest of the series but not this patch
    behaves correctly without or with this series

---
 drivers/target/target_core_iblock.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9ba4954..167c5e1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -657,6 +657,12 @@ static int iblock_execute_rw(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
+	if (!sgl_nents) {
+		atomic_set(&ibr->pending, 1);
+		iblock_complete_cmd(cmd);
+		return 0;
+	}
+
 	bio = iblock_get_bio(cmd, block_lba, sgl_nents);
 	if (!bio)
 		goto fail_free_ibr;
-- 
1.7.1


