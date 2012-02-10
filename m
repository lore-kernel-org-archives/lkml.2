Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2BJAE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 23/31] edac: Simplify logs for i7core and sb edac drivers
Date: Thu,  9 Feb 2012 22:01:22 -0200
Message-Id: <1328832090-9166-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the MCE log is printed, we can remove some redundant
info from the message log

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    9 ++-------
 drivers/edac/sb_edac.c     |   29 ++++++++++++++---------------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 39d0b14..c30cbf7 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1625,7 +1625,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				    const struct mce *m)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *err, *msg;
+	char *type, *optype, *err, msg[80];
 	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
 	bool uncorrected_error = m->mcgstatus & 1ll << 61;
@@ -1703,10 +1703,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	msg = kasprintf(GFP_ATOMIC,
-		"addr=0x%08llx cpu=%d count=%d Err=%08llx:%08llx (%s: %s))\n",
-		(long long) m->addr, m->cpu, core_err_cnt,
-		(long long)m->status, (long long)m->misc, optype, err);
+	snprintf(msg, sizeof(msg), "count=%d %s", core_err_cnt, optype);
 
 	/*
 	 * Call the helper to output message
@@ -1720,8 +1717,6 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				     syndrome,
 				     channel, dimm, -1,
 				     err, msg, m);
-
-	kfree(msg);
 }
 
 /*
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 4745c94..9ae7d9e 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1421,23 +1421,22 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
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

