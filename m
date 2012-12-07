Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423558Ab2LGA7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:59:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423518Ab2LGA7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [ 09/27] target: Fix handling of aborted commands
Date: Thu,  6 Dec 2012 16:58:53 -0800
Message-Id: <20121207005828.262252687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 3ea160b3e8f0de8161861995d9901f61192fc0b0 upstream.

- If we stop processing an already-aborted command in
  target_execute_cmd(), then we need to complete t_transport_stop_comp
  to wake up the the TMR handling thread, or else it will end up
  waiting forever.

- If we've a already sent an "aborted" status for a command in
  transport_check_aborted_status() then we should bail out of
  transport_send_task_abort() to avoid freeing the command twice.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1756,8 +1756,10 @@ void target_execute_cmd(struct se_cmd *c
 	/*
 	 * If the received CDB has aleady been aborted stop processing it here.
 	 */
-	if (transport_check_aborted_status(cmd, 1))
+	if (transport_check_aborted_status(cmd, 1)) {
+		complete(&cmd->t_transport_stop_comp);
 		return;
+	}
 
 	/*
 	 * Determine if IOCTL context caller in requesting the stopping of this
@@ -3029,7 +3031,7 @@ void transport_send_task_abort(struct se
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
+	if (cmd->se_cmd_flags & (SCF_SENT_CHECK_CONDITION | SCF_SENT_DELAYED_TAS)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}


