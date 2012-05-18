Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2ERQdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484Ab2ERQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>
Subject: [PATCH EDAC v26 35/66] edac: Cleanup the logs for i7core and sb edac drivers
Date: Fri, 18 May 2012 13:32:22 -0300
Message-Id: <1337358773-6919-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some information that it is duplicated at the MCE log,
and don't have much usage for the error. Those data will be
added again, when creating a trace function that outputs both
memory errors and MCE fields.

Cc: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    9 ++-------
 drivers/edac/sb_edac.c     |   42 ++++++++++++++++++------------------------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 6d89c78..2aacd95 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1623,7 +1623,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				    const struct mce *m)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *err, *msg;
+	char *type, *optype, *err, msg[80];
 	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
 	bool uncorrected_error = m->mcgstatus & 1ll << 61;
@@ -1701,10 +1701,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	msg = kasprintf(GFP_ATOMIC,
-		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
-		(long long) m->addr, m->cpu, core_err_cnt,
-		(long long)m->status, (long long)m->misc, optype, err);
+	snprintf(msg, sizeof(msg), "count=%d %s", core_err_cnt, optype);
 
 	/*
 	 * Call the helper to output message
@@ -1718,8 +1715,6 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				     syndrome,
 				     channel, dimm, -1,
 				     err, msg, m);
-
-	kfree(msg);
 }
 
 /*
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 2f95a1b..e834dfd 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -788,7 +788,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 				 u8 *socket,
 				 long *channel_mask,
 				 u8 *rank,
-				 char *area_type, char *msg)
+				 char **area_type, char *msg)
 {
 	struct mem_ctl_info	*new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
@@ -843,7 +843,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		sprintf(msg, "Can't discover the memory socket");
 		return -EINVAL;
 	}
-	area_type = get_dram_attr(reg);
+	*area_type = get_dram_attr(reg);
 	interleave_mode = INTERLEAVE_MODE(reg);
 
 	pci_read_config_dword(pvt->pci_sad0, interleave_list[n_sads],
@@ -1342,7 +1342,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	enum hw_event_mc_err_type tp_event;
-	char *type, *optype, msg[256], *recoverable_msg;
+	char *type, *optype, msg[256];
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -1355,7 +1355,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	long channel_mask, first_channel;
 	u8  rank, socket;
 	int rc, dimm;
-	char *area_type = "Unknown";
+	char *area_type = NULL;
 
 	if (uncorrected_error) {
 		if (ripv) {
@@ -1407,7 +1407,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	}
 
 	rc = get_memory_error_data(mci, m->addr, &socket,
-				   &channel_mask, &rank, area_type, msg);
+				   &channel_mask, &rank, &area_type, msg);
 	if (rc < 0)
 		goto err_parsing;
 	new_mci = get_mci_for_node_id(socket);
@@ -1427,29 +1427,23 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	else
 		dimm = 2;
 
-	if (uncorrected_error && recoverable)
-		recoverable_msg = " recoverable";
-	else
-		recoverable_msg = "";
 
 	/*
-	 * FIXME: What should we do with "channel" information on mcelog?
-	 * Probably, we can just discard it, as the channel information
-	 * comes from the get_memory_error_data() address decoding
+	 * FIXME: On some memory configurations (mirror, lockstep), the
+	 * Memory Controller can't point the error to a single DIMM. The
+	 * EDAC core should be handling the channel mask, in order to point
+	 * to the group of dimm's where the error may be happening.
 	 */
 	snprintf(msg, sizeof(msg),
-			"%d error(s)%s: %s%s: cpu=%d Err=%04x:%04x addr = 0x%08llx socket=%d Channel=%ld(mask=%ld), rank=%d\n",
-			core_err_cnt,
-			overflow ? " OVERFLOW" : "",
-			area_type,
-			recoverable_msg,
-			m->cpu,
-			mscod, errcode,
-			(long long) m->addr,
-			socket,
-			first_channel,		/* This is the real channel on SB */
-			channel_mask,
-			rank);
+		 "count:%d%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
+		 core_err_cnt,
+		 overflow ? " OVERFLOW" : "",
+		 (uncorrected_error && recoverable) ? " recoverable" : "",
+		 area_type,
+		 mscod, errcode,
+		 socket,
+		 channel_mask,
+		 rank);
 
 	debugf0("%s", msg);
 
-- 
1.7.8

