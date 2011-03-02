Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1CBXxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:53:17 -0500
Received: from nm28-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.246]:38648 "HELO
	nm28-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756176Ab1CBXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:53:16 -0500
X-Yahoo-Newman-Id: 222366.55957.bm@omp1035.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ampBplAVM1njKTUfBXmWmk7OqLOOExhjvhjOmtZ_BmIAKug
 3LhuuqZBLShIVgHGdCe5h_QjpSluzGFJBswXU7pLx58erBFw1NDL4Mg0fWrA
 QHXBrMApXwIgwGDeBvoxknim6IK6A6d_zGZgUV39l4uirtHtBM7eDnSvmob5
 DL5MChbguicEptwKJI5EMP1Ob.NIoL7dENFaypPnx5Ok2FEXL8tEWoiYE7EZ
 pJ6kE97xCVmluPSMIsbaoKLCyXdqo5GEWnFlyC5i672CfaaMLuadXRcQpEP2
 ffN1uB_k0_sH6dLDJCfAgRQFp8jxEhoe06ts-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Ben Jarvis <bjarvismn@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-FOR-38] target: Fix READ_CAPACITY_16 regression
Date: Wed,  2 Mar 2011 15:52:51 -0800
Message-Id: <1299109971-27268-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

This patch fixes a regression for READ_CAPACITY to trigger SAI READ_CAPACITY_16 for
>= 0xffffffff virtual backends.  This occured during v4.0.0-rc6 when the backend
read_capacity* handlers where moved into generic target_core_cdb.c code, and the
'unsigned long long blocks_long' piece was dropped from target_emulate_readcapacity().

This fix has been tested with TCM_Loop on .38-rc7 with lio-4.1 and is working as expected
with large block virtual backends:

[67826.897061] TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
[67826.897061] scsi 7:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
[67826.900933] sd 7:0:1:0: [sdd] 2621440000001 512-byte logical blocks: (1.34 PB/1.19 PiB)
[67826.901510] sd 7:0:1:0: [sdd] Write Protect is off
[67826.901684] sd 7:0:1:0: [sdd] Mode Sense: 2f 00 00 00

Please include into scsi-rc-fixes going to Linus for-38 mainline target code.

Reported-by: Ben Jarvis <bjarvismn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 366080b..7f19c8b 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -667,7 +667,13 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *buf = cmd->t_task->t_task_buf;
-	u32 blocks = dev->transport->get_blocks(dev);
+	unsigned long long blocks_long = dev->transport->get_blocks(dev);
+	u32 blocks;
+
+	if (blocks_long >= 0x00000000ffffffff)
+		blocks = 0xffffffff;
+	else
+		blocks = (u32)blocks_long;
 
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
-- 
1.5.6.5

