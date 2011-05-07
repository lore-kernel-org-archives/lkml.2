Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1EGCzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:55:42 -0400
Received: from nm20.access.bullet.mail.sp2.yahoo.com ([98.139.44.147]:48112
	"HELO nm20.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755234Ab1EGCzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:55:15 -0400
X-Yahoo-Newman-Id: 635366.83463.bm@omp1015.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: vLAF.aMVM1n0a3iMTfT_jVGzBCfM9o8oATz3b4Fg32e1YcG
 6YE59qxLs0441flbtfpVSd0m1QY.E6T0fQHAcx0Koj6_O0mfTnEz9BZgHBpc
 EgFDsNTGZZozjXtxGnMGptH7dRNwdA3pYbMIWRymiO8rTlDfL_5oNTJGo0Ua
 Zk1CXp.uZ9Nc8Ngiiq5IBaEEVjw7YCONVNHbW._r1tis4_KQxLvz1o5nJ_Rg
 N73OeV2Y4vfMrTPf6jyBbfCTSas_GXW1jLT5Rb4BFB5JygQjKehF6Oc_SMZf
 qi5V422imxLTd.aaiNR0ExEVXsXXZzCKCZ7bVcTdhM8toDjgEEG_MeAqoJ1A
 9BqCGx1s-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        "Robert W. Love" <robert.w.love@intel.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Fix multi task->task_sg[] chaining logic bug
Date: Fri,  6 May 2011 19:54:56 -0700
Message-Id: <1304736898-10830-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
References: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
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

Reported-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
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

