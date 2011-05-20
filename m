Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1ETDTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:19:30 -0400
Received: from nm27.access.bullet.mail.mud.yahoo.com ([66.94.237.92]:32340
	"HELO nm27.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755783Ab1ETDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:19:26 -0400
X-Yahoo-Newman-Id: 261559.91296.bm@omp1027.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QkSdivkVM1mr3F_zm77G584zTu5hmSAi2tNL_n0NMaJyaVN
 DpBdGRodof8T0fYTcmPHaut8hwpbti9iZmn9UKBUGw5cpD9n7qRlSVxzlPUf
 AmN2S3V_LZr_7JoYDeP9kALDPrh38m2Vd_e85KhIqPxK6sjzvKQ0yuVNHP2H
 3mT2C68fjKm2VA8WH9DosuBo6Co1z80wkF60sSQW0Wo43prhGqp1ihKWhDLH
 xHUmpw2i5Z9Q5Iz7IK_yDUT95cBEd2rfOQjUmVDSdSP0Nul..TKh_mOfsgAn
 oUr9Vu15HC9K3epb_J33IniOIPA_oDrq.b_loZRzprhReXR9ng2XNkcD9OVT
 Q6jUFaNHjj1plPK398O2ASG7K2ip4P3mozIfZbcuTKVH6xmmtLE0J9qszZg5
 2N60qhVjDxMJB6FLVnq5dA9Qk6A--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/6] target: Fix multi task->task_sg[] chaining logic bug
Date: Thu, 19 May 2011 20:19:09 -0700
Message-Id: <1305861554-29960-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in transport_do_task_sg_chain() used by HW target
mode modules with sg_chain() to provide a single sg_next() walkable memory
layout for use with pci_map_sg() and friends.  This patch addresses an
issue with mapping multiple small block max_sector tasks across multiple
struct se_task->task_sg[] mappings for HW target mode operation.

This was causing OOPs with (cmd->t_task->t_tasks_no > 1) I/O traffic for
HW target drivers using transport_do_task_sg_chain(), and has been tested
so far with tcm_fc(openfcoe), tcm_qla2xxx, and ib_srpt fabrics with
t_tasks_no > 1 IBLOCK backends using a smaller max_sectors to trigger the
original issue.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Acked-by: Kiran Patil <kiran.patil@intel.com>
---
 drivers/target/target_core_transport.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9583b23..fefe10a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4776,18 +4776,20 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 				sg_end_cur->page_link &= ~0x02;
 
 				sg_chain(sg_head, task_sg_num, sg_head_cur);
-				sg_count += (task->task_sg_num + 1);
-			} else
 				sg_count += task->task_sg_num;
+				task_sg_num = (task->task_sg_num + 1);
+			} else {
+				sg_chain(sg_head, task_sg_num, sg_head_cur);
+				sg_count += task->task_sg_num;
+				task_sg_num = task->task_sg_num;
+			}
 
 			sg_head = sg_head_cur;
 			sg_link = sg_link_cur;
-			task_sg_num = task->task_sg_num;
 			continue;
 		}
 		sg_head = sg_first = &task->task_sg[0];
 		sg_link = &task->task_sg[task->task_sg_num];
-		task_sg_num = task->task_sg_num;
 		/*
 		 * Check for single task..
 		 */
@@ -4798,9 +4800,12 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 			 */
 			sg_end = &task->task_sg[task->task_sg_num - 1];
 			sg_end->page_link &= ~0x02;
-			sg_count += (task->task_sg_num + 1);
-		} else
 			sg_count += task->task_sg_num;
+			task_sg_num = (task->task_sg_num + 1);
+		} else {
+			sg_count += task->task_sg_num;
+			task_sg_num = task->task_sg_num;
+		}
 	}
 	/*
 	 * Setup the starting pointer and total t_tasks_sg_linked_no including
@@ -4809,21 +4814,20 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	T_TASK(cmd)->t_tasks_sg_chained = sg_first;
 	T_TASK(cmd)->t_tasks_sg_chained_no = sg_count;
 
-	DEBUG_CMD_M("Setup T_TASK(cmd)->t_tasks_sg_chained: %p and"
-		" t_tasks_sg_chained_no: %u\n", T_TASK(cmd)->t_tasks_sg_chained,
+	DEBUG_CMD_M("Setup cmd: %p T_TASK(cmd)->t_tasks_sg_chained: %p and"
+		" t_tasks_sg_chained_no: %u\n", cmd, T_TASK(cmd)->t_tasks_sg_chained,
 		T_TASK(cmd)->t_tasks_sg_chained_no);
 
 	for_each_sg(T_TASK(cmd)->t_tasks_sg_chained, sg,
 			T_TASK(cmd)->t_tasks_sg_chained_no, i) {
 
-		DEBUG_CMD_M("SG: %p page: %p length: %d offset: %d\n",
-			sg, sg_page(sg), sg->length, sg->offset);
+		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d, magic: 0x%08x\n",
+			i, sg, sg_page(sg), sg->length, sg->offset, sg->sg_magic);
 		if (sg_is_chain(sg))
 			DEBUG_CMD_M("SG: %p sg_is_chain=1\n", sg);
 		if (sg_is_last(sg))
 			DEBUG_CMD_M("SG: %p sg_is_last=1\n", sg);
 	}
-
 }
 EXPORT_SYMBOL(transport_do_task_sg_chain);
 
-- 
1.7.5.1

