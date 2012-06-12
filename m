Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2FLNXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab2FLNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:23:46 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 4/5] i7core_edac: properly handle error count
Date: Tue, 12 Jun 2012 10:23:30 -0300
Message-Id: <2929dcfc65de7f37aa078142111e4667dbdba770.1339507096.git.mchehab@redhat.com>
In-Reply-To: <cover.1339507094.git.mchehab@redhat.com>
References: <cover.1339507094.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of generating a burst of errors or reporting the error
count via driver-specific details, use the new way provided by
edac_mc_handle_error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index a95686e..a3c9a37 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1536,18 +1536,6 @@ error:
 /****************************************************************************
 			Error check routines
  ****************************************************************************/
-static void i7core_rdimm_update_errcount(struct mem_ctl_info *mci,
-				      const int chan,
-				      const int dimm,
-				      const int add)
-{
-	int i;
-
-	for (i = 0; i < add; i++) {
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, 0, 0, 0,
-				     chan, dimm, -1, "error", "");
-	}
-}
 
 static void i7core_rdimm_update_ce_count(struct mem_ctl_info *mci,
 					 const int chan,
@@ -1586,12 +1574,17 @@ static void i7core_rdimm_update_ce_count(struct mem_ctl_info *mci,
 
 	/*updated the edac core */
 	if (add0 != 0)
-		i7core_rdimm_update_errcount(mci, chan, 0, add0);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, add0,
+				     0, 0, 0,
+				     chan, 0, -1, "error", "");
 	if (add1 != 0)
-		i7core_rdimm_update_errcount(mci, chan, 1, add1);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, add1,
+				     0, 0, 0,
+				     chan, 1, -1, "error", "");
 	if (add2 != 0)
-		i7core_rdimm_update_errcount(mci, chan, 2, add2);
-
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, add2,
+				     0, 0, 0,
+				     chan, 2, -1, "error", "");
 }
 
 static void i7core_rdimm_check_mc_ecc_err(struct mem_ctl_info *mci)
@@ -1710,7 +1703,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 				    const struct mce *m)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	char *type, *optype, *err, msg[80];
+	char *type, *optype, *err;
 	enum hw_event_mc_err_type tp_event;
 	unsigned long error = m->status & 0x1ff0000l;
 	bool uncorrected_error = m->mcgstatus & 1ll << 61;
@@ -1788,20 +1781,18 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 		err = "unknown";
 	}
 
-	snprintf(msg, sizeof(msg), "count=%d %s", core_err_cnt, optype);
-
 	/*
 	 * Call the helper to output message
 	 * FIXME: what to do if core_err_cnt > 1? Currently, it generates
 	 * only one event
 	 */
 	if (uncorrected_error || !pvt->is_registered)
-		edac_mc_handle_error(tp_event, mci, 1,
+		edac_mc_handle_error(tp_event, mci, core_err_cnt,
 				     m->addr >> PAGE_SHIFT,
 				     m->addr & ~PAGE_MASK,
 				     syndrome,
 				     channel, dimm, -1,
-				     err, msg);
+				     err, optype);
 }
 
 /*
-- 
1.7.10.2

