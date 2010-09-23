Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0IWXi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:38:59 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:28813 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756561Ab0IWXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:38:57 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Y6JWXrMVM1k4AF4hnWJPi6GKbeY7mmy1RQoT3nKMgtZ74zq
 RNwWNQr.CdwnAksDQZ7k0wquohgV8TIHQz5qdAEw2erwOQm2gRA7ARI6QkUU
 DXQpNWJ4BTkbXNeUBKvOsWYtVvSXuk8GfOCoj1Vhq_YF9cPpgI1PPB4jL.u2
 yNsgcxN10eCa3sqYMUrmgNy3SykfVNDVKKdTv5UP_UT4jkcO8KN5Ge6.umce
 cYxFuh42i30G_3Oqg24rVgP7E1ZyTSs45ppQZBDgrNBptS_NzO49DddCjr.V
 IK7mHZRGRpSPN9IDhCaCYoGc9wVKYp7f07xknuS2VdbZdSp4Y35Wx6X76Tvx
 rVOAiAM_71Ch2DGCJZg--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v3 10/15] buslogic: Remove host_lock unlock() + lock() from BusLogic_QueueCommand()
Date: Thu, 23 Sep 2010 16:38:54 -0700
Message-Id: <1285285134-16531-1-git-send-email-nab@linux-iscsi.org>
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

