Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0G1VBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:01:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33812 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0G1VAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:00:24 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH] staging:ti dspbridge: avoid errors if stream id is zero
Date: Wed, 28 Jul 2010 16:04:57 -0500
Message-Id: <1280351097-3346-6-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280351097-3346-5-git-send-email-ernesto@ti.com>
References: <1280351097-3346-1-git-send-email-ernesto@ti.com>
 <1280351097-3346-2-git-send-email-ernesto@ti.com>
 <1280351097-3346-3-git-send-email-ernesto@ti.com>
 <1280351097-3346-4-git-send-email-ernesto@ti.com>
 <1280351097-3346-5-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'zero' can be a perfectly good id, it can be picked up as
a NULL from userspace, avoid issues in API and user apps if stream
handle is zero.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 47892dd..7b42f72 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -1527,7 +1527,7 @@ inline void find_strm_handle(struct strm_res_object **strmres,
 {
 	rcu_read_lock();
 	*strmres = idr_find(((struct process_context *)pr_ctxt)->stream_id,
-							(int)hstream);
+							(int)hstream - 1);
 	rcu_read_unlock();
 	return;
 }
@@ -1724,6 +1724,7 @@ u32 strmwrap_open(union trapped_args *args, void *pr_ctxt)
 	struct strm_res_object *strm_res_obj;
 	struct dsp_streamattrin strm_attr_in;
 	struct node_res_object *node_res;
+	int strmid;
 
 	find_node_handle(&node_res, pr_ctxt, args->args_strm_open.hnode);
 
@@ -1745,7 +1746,10 @@ u32 strmwrap_open(union trapped_args *args, void *pr_ctxt)
 			   args->args_strm_open.direction,
 			   args->args_strm_open.index, &attr, &strm_res_obj,
 			   pr_ctxt);
-	CP_TO_USR(args->args_strm_open.ph_stream, &strm_res_obj->id, status, 1);
+	if (!status) {
+		strmid = strm_res_obj->id + 1;
+		CP_TO_USR(args->args_strm_open.ph_stream, &strmid, status, 1);
+	}
 	return status;
 }
 
-- 
1.5.4.5

