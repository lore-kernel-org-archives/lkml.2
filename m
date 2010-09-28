Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab0I1CHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:07:42 -0400
Received: from nm12.bullet.mail.ne1.yahoo.com ([98.138.90.75]:26757 "HELO
	nm12.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933634Ab0I1CHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:37 -0400
X-Yahoo-Newman-Id: 122970.52376.bm@omp1008.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: uVACc5cVM1mt62ci5IiZle0pCKbAux71QNKhs1XmajcKsTq
 4OTxcuby7LLtlv1QMbg25aNwIjbAklB_AilVtSj4rPR9GVWm5nP7C6bilflA
 2myfVHtQytfd4BWCS72uYtSbL0uYN.q918sT4qUlnyyqgSTgWrkkj.cCzlqF
 0CKSZ1ZwBWL6igOBgeUP98bA8WktXrvc.1nY6sYBPHWGX8cDhkETLAxYQPFp
 QvGzpr3Tj3e0ZyFrWS0Qgh6xNBcjaHkr7KwGcfLAxceZMWgZDcMxWM.uHb1p
 Wn1xBx7nB2Vlpo4cLWl3WciHl.EAg8aOpQHuRJYQSUZbqRT5CsVpycR5olYo
 fFkR_sX.ISeSeFus_bAi69CWB52emDJSpvH.8RHlM
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 14/19] buslogic: Remove host_lock unlock() + lock() from BusLogic_QueueCommand()
Date: Mon, 27 Sep 2010 19:07:31 -0700
Message-Id: <1285639651-7485-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from buslogic.c:BusLogic_QueueCommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/BusLogic.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index fc0b4b8..f39b4fc 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2837,9 +2837,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	 */
 	CCB = BusLogic_AllocateCCB(HostAdapter);
 	if (CCB == NULL) {
-		spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 		BusLogic_Delay(1);
-		spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 		CCB = BusLogic_AllocateCCB(HostAdapter);
 		if (CCB == NULL) {
 			Command->result = DID_ERROR << 16;
@@ -2965,10 +2963,8 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		   error as a Host Adapter Hard Reset should be initiated soon.
 		 */
 		if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
-			spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 			BusLogic_Warning("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", HostAdapter);
 			BusLogic_Delay(1);
-			spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 			if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
 				BusLogic_Warning("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", HostAdapter);
 				BusLogic_DeallocateCCB(CCB);
-- 
1.7.3

