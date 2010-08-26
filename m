Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0HZNYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:24:22 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38415 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751696Ab0HZNVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:24 -0400
Message-Id: <20100826132124.087884614@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:44 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 07/25] GRU - add context lock flag to gru status
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_proc_cch_locked
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add a flag to the GRU cch_status file to indicate if the cch is locked.
This is useful for debugging.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gruprocfs.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:42.043954832 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:42.456084620 -0500
@@ -190,21 +190,22 @@ static int cch_seq_show(struct seq_file
 	const char *mode[] = { "??", "UPM", "INTR", "OS_POLL" };
 
 	if (gid == 0)
-		seq_printf(file, "#%5s%5s%6s%7s%9s%6s%8s%8s\n", "gid", "bid",
-			   "ctx#", "asid", "pid", "cbrs", "dsbytes", "mode");
+		seq_printf(file, "#%5s%5s%6s%7s%9s%6s%8s%8s%7s\n", "gid", "bid",
+			   "ctx#", "asid", "pid", "cbrs", "dsbytes", "mode", "locked");
 	if (gru)
 		for (i = 0; i < GRU_NUM_CCH; i++) {
 			ts = gru->gs_gts[i];
 			if (!ts)
 				continue;
-			seq_printf(file, " %5d%5d%6d%7d%9d%6d%8d%8s\n",
+			seq_printf(file, " %5d%5d%6d%7d%9d%6d%8d%8s%7s\n",
 				   gru->gs_gid, gru->gs_blade_id, i,
 				   is_kernel_context(ts) ? 0 : ts->ts_gms->ms_asids[gid].mt_asid,
 				   is_kernel_context(ts) ? 0 : ts->ts_tgid_owner,
 				   ts->ts_cbr_au_count * GRU_CBR_AU_SIZE,
-				   ts->ts_cbr_au_count * GRU_DSR_AU_BYTES,
+				   ts->ts_dsr_au_count * GRU_DSR_AU_BYTES,
 				   mode[ts->ts_user_options &
-					GRU_OPT_MISS_MASK]);
+					GRU_OPT_MISS_MASK],
+				   mutex_is_locked(&ts->ts_ctxlock) ? "LOCKED" : "-");
 		}
 
 	return 0;

