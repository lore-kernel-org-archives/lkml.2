Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0IQSXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:23:32 -0400
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:40591 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756187Ab0IQSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:23:29 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: FMOOBG8VM1mwfYbq2DQQVjYhbteXLBgjxQhRHJ2JQIAAWP1
 Bh5ocj.OIJn.MhvjG6x7Y_ulKQBd9Uu1qksw4pDxA_gVpWqjz1VBliYTWv6f
 TJfqWSo7OEYd4csuQKCgmRnEAHl4ri6TtJcQQZXMR7Pd4GEyMZUemimdvEHN
 Xxz9Q8AAZqXR42HONvbEkQB4qlF5A1uk3cN5vyX.EOifNynXDUwtMI5lAYQV
 MYf6uq_A3ssTt310vhnHVzkzhWKgDuvAlFfZdXwlzwFqSwJ_1BsA10cVkN3P
 yzrY_QPgAqA3_K9H0QfRLKCHGvbq3x377.vuHpBwKofjDtAsF7EEoMT5fO5z
 gbWr7_FgMAuek9VUdRyfOfNhVKC3jnbhw6blMLvB1osNmtPnzplld0zJZX2b
 YE55gEoHl7EurnR_T1cghxHn6M484g1rpGWdjEdRyeGJHmNQsUFY6ZibfQXD
 Cd6sLUB6dZQql
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
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 11/11] buslogic: Remove host_lock unlock() + lock() from BusLogic_QueueCommand()
Date: Fri, 17 Sep 2010 11:23:24 -0700
Message-Id: <1284747804-21052-1-git-send-email-nab@linux-iscsi.org>
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
1.7.2.3

