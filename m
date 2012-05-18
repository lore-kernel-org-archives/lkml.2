Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178Ab2ERQpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562Ab2ERQdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 59/66] i5000: Fix the fatal error handling
Date: Fri, 18 May 2012 13:32:46 -0300
Message-Id: <1337358773-6919-60-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fatal error channel bits point to a single channel, and not
to a range of channels. Fix the code to properly report it,
instead of printing messages like:
	kernel: EDAC MC0: INTERNAL ERROR: channel-b out of range (4 >= 4)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5000_edac.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index df93080..a7da4c7 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -474,7 +474,6 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 	char msg[EDAC_MC_LABEL_LEN + 1 + 160];
 	char *specific = NULL;
 	u32 allErrors;
-	int branch;
 	int channel;
 	int bank;
 	int rank;
@@ -486,8 +485,7 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 	if (!allErrors)
 		return;		/* if no error, return now */
 
-	branch = EXTRACT_FBDCHAN_INDX(info->ferr_fat_fbd);
-	channel = branch;
+	channel = EXTRACT_FBDCHAN_INDX(info->ferr_fat_fbd);
 
 	/* Use the NON-Recoverable macros to extract data */
 	bank = NREC_BANK(info->nrecmema);
@@ -496,9 +494,9 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 	ras = NREC_RAS(info->nrecmemb);
 	cas = NREC_CAS(info->nrecmemb);
 
-	debugf0("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
-		"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-		rank, channel, channel + 1, branch >> 1, bank,
+	debugf0("\t\tCSROW= %d  Channel= %d "
+		"(DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+		rank, channel, bank,
 		rdwr ? "Write" : "Read", ras, cas);
 
 	/* Only 1 bit will be on */
@@ -539,7 +537,7 @@ static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
 
 	/* Call the helper to output message */
 	edac_mc_handle_error(HW_EVENT_ERR_FATAL, mci, 0, 0, 0,
-			     branch >> 1, -1, rank,
+			     channel >> 1, channel & 1, rank,
 			     rdwr ? "Write error" : "Read error",
 			     msg, NULL);
 }
-- 
1.7.8

