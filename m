Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966998Ab0GSVkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:40:00 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53694 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966883Ab0GSViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:55 -0400
Message-Id: <20100719213854.419179673@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:38 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 20/25] GRU - add gsh information to gru dumps
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_kdump
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add support for dumpping the GRU GSH state. This provides addition debugging information
for GRU failures.

Add missing cache flush instructions. For performance reasons, the CBE does not
alway maintain cache-coherency.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grukdump.c |   17 ++++++++++++++++-
 drivers/misc/sgi-gru/grulib.h   |    2 ++
 2 files changed, 18 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grukdump.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukdump.c	2010-07-19 10:23:08.926244572 -0500
+++ linux/drivers/misc/sgi-gru/grukdump.c	2010-07-19 13:10:56.766719840 -0500
@@ -54,10 +54,16 @@ static int gru_dump_context_data(void *g
 	cb = gseg + GRU_CB_BASE;
 	cbe = grubase + GRU_CBE_BASE;
 	tfh = grubase + GRU_TFH_BASE;
+	sync_core();
+	gru_flush_cache(cbe);
 
 	for_each_cbr_in_allocation_map(i, &cch->cbr_allocation_map, scr) {
-		if (flush_cbrs)
+		if (flush_cbrs) {
 			gru_flush_cache(cb);
+			gru_flush_cache(tfh + i * GRU_HANDLE_STRIDE);
+		}
+		gru_flush_cache(cbe + i * GRU_HANDLE_STRIDE);
+		sync_core();
 		if (gru_user_copy_handle(&ubuf, cb))
 			goto fail;
 		if (gru_user_copy_handle(&ubuf, tfh + i * GRU_HANDLE_STRIDE))
@@ -130,6 +136,7 @@ static int gru_dump_context(struct gru_s
 	memset(&hdr, 0, sizeof(hdr));
 	grubase = gru->gs_gru_base_vaddr;
 	cch = get_cch(grubase, ctxnum);
+	gru_flush_cache(cch);
 	for (try = 0; try < CCH_LOCK_ATTEMPTS; try++) {
 		cch_locked =  trylock_cch_handle(cch);
 		if (cch_locked)
@@ -184,6 +191,12 @@ fail:
 	unlock_cch_handle(cch);
 	return -EFAULT;
 }
+static void dump_gsh_state(struct gru_state *gru,
+			   struct gru_dump_chiplet_state_req *req)
+{
+	memset(&req->gsh_cb_state, 0, sizeof(req->gsh_cb_state));
+	memset(&req->gsh_cch_state, 0, sizeof(req->gsh_cch_state));
+}
 
 int gru_dump_chiplet_request(unsigned long arg)
 {
@@ -214,6 +227,8 @@ int gru_dump_chiplet_request(unsigned lo
 		goto fail;
 	ubuf += ret;
 
+	dump_gsh_state(gru, &req);
+
 	for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
 		if (req.ctxnum == ctxnum || req.ctxnum < 0) {
 			ret = gru_dump_context(gru, ctxnum, ubuf, ubufend,
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2010-07-19 10:25:54.334243996 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2010-07-19 13:10:35.154917927 -0500
@@ -130,6 +130,8 @@ struct gru_dump_chiplet_state_req {
 	size_t		buflen;
 	/* ---- output --- */
 	unsigned int	num_contexts;
+	unsigned long	gsh_cb_state[16];
+	unsigned long	gsh_cch_state[16];
 };
 
 #define GRU_DUMP_MAGIC	0x3474ab6c

