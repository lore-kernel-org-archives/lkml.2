Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162572Ab1FAIVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:21:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162552Ab1FAIVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:34 2011
Message-Id: <20110601081133.772162278@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:44 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [074/165] [SCSI] target: Fix task->task_execute_queue=1 clear bug +
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 LUN_RESET OOPs
Content-Length: 1731
Lines: 52

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
@@ -1194,6 +1194,7 @@ transport_get_task_from_execute_queue(st
 		break;
 
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 
 	return task;
@@ -1209,8 +1210,14 @@ void transport_remove_task_from_execute_
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


