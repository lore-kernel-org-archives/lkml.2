Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964990Ab1KJEge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:36:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964902Ab1KJDgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:46 2011
Message-Id: <20111109213146.153603496@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [040/264] target: Prevent transport_send_task_abort when CHECK_CONDITION status
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit c252f003470a99d319db4ebd12f4a9e4710a65db upstream.

This patch fixes a bug where transport_send_task_abort() could be called
during LUN_RESET to return SAM_STAT_TASK_ABORTED + tfo->queue_status(), when
SCF_SENT_CHECK_CONDITION -> tfo->queue_status() has already been sent from
within another context via transport_send_check_condition_and_sense().

Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4920,6 +4920,15 @@ EXPORT_SYMBOL(transport_check_aborted_st
 
 void transport_send_task_abort(struct se_cmd *cmd)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	/*
 	 * If there are still expected incoming fabric WRITEs, we wait
 	 * until until they have completed before sending a TASK_ABORTED


