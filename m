Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2CGMFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab2CGMFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:05:51 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: Cleanup the logs for i7core and sb edac drivers
Date: Wed,  7 Mar 2012 09:05:44 -0300
Message-Id: <1331121944-28307-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some information that it is duplicated at the MCE log,
and don't have much usage for the error. Those data will be
added again, when creating a trace function that outputs both
memory errors and MCE fields.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

PS.: This patch requires the FB-DIMM/modern Intel DDR2/DDR3 memory controller
     fixes to be applied before it.

 drivers/edac/i7core_edac.c |    9 ++-------
 drivers/edac/sb_edac.c     |   29 ++++++++++++++---------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index edb6bac..b47910e 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1627,7 +1627,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				    const struct mce *m)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *err, *msg;
+	char *type, *optype, *err, msg[80];
 	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
 	bool uncorrected_error = m->mcgstatus & 1ll << 61;
@@ -1705,10 +1705,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	msg = kasprintf(GFP_ATOMIC,
-		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
-		(long long) m->addr, m->cpu, core_err_cnt,
-		(long long)m->status, (long long)m->misc, optype, err);
+	snprintf(msg, sizeof(msg), "count=%d %s", core_err_cnt, optype);
 
 	/*
 	 * Call the helper to output message
@@ -1722,8 +1719,6 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				     syndrome,
 				     channel, dimm, -1,
 				     err, msg, m);
-
-	kfree(msg);
 }
 
 /*
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 4752a7f..5a3a1f6 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1423,23 +1423,22 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 		recoverable_msg = "";
 
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
+		 "%d error(s)%s: %s%s: Err=%04x:%04x socket=%d channel=%ld/mask=%ld rank=%d",
+		 core_err_cnt,
+		 overflow ? " OVERFLOW" : "",
+		 area_type,
+		 recoverable_msg,
+		 mscod, errcode,
+		 socket,
+		 first_channel,
+		 channel_mask,
+		 rank);
 
 	debugf0("%s", msg);
 
-- 
1.7.8

