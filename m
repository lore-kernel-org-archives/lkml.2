Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0H3A0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:26:24 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:31465 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753357Ab0H3A0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:26:23 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 3UFr7EgVM1kW2MsRWs1QD6YLJqzJDTwbJdo7sHy.Uzxra6f
 Po4QJjShArC73DOa5JFsNGEOC8uDu7a2Trf3BeLUlC7l1P9vnk.IR2cJcq0O
 mYWeobQU3m7Jl1VdJ9PMXNjyAFLM8YcDw1FugYlXeX7G_bvpiL_01xHBa2Je
 OySaKceMBBidR5ZJPJ0TgNh1CtAjV_6TlUCNxN5AjqP4.6ZRwZRkidn5Ekba
 0EotY9ryT_aDolCD6lQWfI9GCIOMTqX7zMsJU2p2qFgVzFcrI3jpgkbWwEbp
 iCI_70k45.Z4ApS5KYImMxRgpBEbCqs.QU_AYi74la5WLg_mQ9arZKCmAKfL
 Fd3UVhasGbRkIkeLW1w--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm/pscsi: Convert struct bio->bi_rw assignment to use REQ_WRITE
Date: Sun, 29 Aug 2010 17:26:18 -0700
Message-Id: <1283127978-13861-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings hch and tejun,

This patch updates pscsi_map_task_SG() to use the new .36-rc REQ_WRITE
macro in include/linux/blk_types.h when setting struct bio->bi_rw for
WRITE I/O.  This replaces the legacy (1 << BIO_RW) assignment, for which
the new REQ_WRITE macro expands to:

    #define REQ_WRITE       (1 << __REQ_WRITE)

to match the old BIO_RW assignement.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 517268d..64808f1 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -30,6 +30,7 @@
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/blkdev.h>
+#include <linux/blk_types.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
@@ -1103,11 +1104,9 @@ static int pscsi_map_task_SG(struct se_task *task)
 				bio = pscsi_get_bio(pdv, nr_vecs);
 				if (!(bio))
 					goto fail;
-				/*
-				 * FIXME: Use bio_set_dir() when avaliable
-				 */
+
 				if (rw)
-					bio->bi_rw |= (1 << BIO_RW);
+					bio->bi_rw |= REQ_WRITE;
 
 				DEBUG_PSCSI("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
-- 
1.5.6.5

