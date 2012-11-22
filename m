Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab2KVVvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:51:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab2KVSkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: [ 66/83] SCSI: isci: Allow SSP tasks into the task management path.
Date: Wed, 21 Nov 2012 16:42:28 -0800
Message-Id: <20121122004219.813989862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

commit 54b46677757ff8d6c282305fc7710f466b63d6dc upstream.

This commit fixes a driver bug for SSP tasks that require task management
in the target after they complete in the SCU hardware.  The problem was
manifested in the function "isci_task_abort_task", which tests
to see if the sas_task.lldd_task is non-NULL before allowing task
management; this bug would always NULL lldd_task in the SCU I/O completion
path even if target management was required, which would prevent
task / target manangement from happening.

Note that in the case of SATA/STP targets, error recovery is provided by
the libata error handler which is why SATA/STP device recovery worked
correctly even though SSP handling did not.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/host.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1079,7 +1079,6 @@ static void sci_controller_completion_ha
 
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task)
 {
-	task->lldd_task = NULL;
 	if (!test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags) &&
 	    !(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (test_bit(IREQ_COMPLETE_IN_TARGET, &ireq->flags)) {
@@ -1087,16 +1086,19 @@ void ireq_done(struct isci_host *ihost,
 			dev_dbg(&ihost->pdev->dev,
 				"%s: Normal - ireq/task = %p/%p\n",
 				__func__, ireq, task);
-
+			task->lldd_task = NULL;
 			task->task_done(task);
 		} else {
 			dev_dbg(&ihost->pdev->dev,
 				"%s: Error - ireq/task = %p/%p\n",
 				__func__, ireq, task);
-
+			if (sas_protocol_ata(task->task_proto))
+				task->lldd_task = NULL;
 			sas_task_abort(task);
 		}
-	}
+	} else
+		task->lldd_task = NULL;
+
 	if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
 		wake_up_all(&ihost->eventq);
 


