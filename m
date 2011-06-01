Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161737Ab1FAINH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:13:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:43609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161718Ab1FAIM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:12:57 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:39 2011
Message-Id: <20110601080338.271276295@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:11 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [075/146] [SCSI] target: Fix task->task_execute_queue=1 clear bug +
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 LUN_RESET OOPs

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit af57c3ac9947990da2608561b71f4799eb7795c6 upstream.

This patch fixes a bug where task->task_execute_queue=1 was not being
cleared once se_task had been removed from se_device->execute_task_list,
resulting in an OOPs in core_tmr_lun_reset() for the task->task_active=0
case where transport_remove_task_from_execute_queue() was incorrectly
being called.

This patch fixes two cases in transport_get_task_from_execute_queue()
and transport_remove_task_from_execute_queue() to properly clear
task->task_execute_queue=0 once list_del(&task->t_execute_list) has
been called.

It also adds an explict check in transport_remove_task_from_execute_queue()
to dump_stack + return if called with task->task_execute_queue=0.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1197,6 +1197,7 @@ transport_get_task_from_execute_queue(st
 		break;
 
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 
 	return task;
@@ -1212,8 +1213,14 @@ void transport_remove_task_from_execute_
 {
 	unsigned long flags;
 
+	if (atomic_read(&task->task_execute_queue) == 0) {
+		dump_stack();
+		return;
+	}
+
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }


