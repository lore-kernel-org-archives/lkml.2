Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162537Ab1FAIV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:21:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:44621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162503Ab1FAIVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:32 2011
Message-Id: <20110601081131.938716980@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:41 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kiran Patil <kiran.patil@intel.com>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [071/165] [SCSI] target: Fix multi task->task_sg[] chaining logic bug
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 3386
Lines: 94

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 97868c8905a1537153d406c4a3aa39a503a5c299 upstream.

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
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4776,18 +4776,20 @@ void transport_do_task_sg_chain(struct s
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
@@ -4798,9 +4800,12 @@ void transport_do_task_sg_chain(struct s
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
@@ -4809,21 +4814,20 @@ void transport_do_task_sg_chain(struct s
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
 


