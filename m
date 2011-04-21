Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1DUILa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:11:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38904 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1DUIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:11:27 -0400
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [V2] net/9p: Handle get_user_pages_fast return properly
Date: Thu, 21 Apr 2011 13:41:22 +0530
Message-Id: <1303373482-7076-1-git-send-email-mohan@in.ibm.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper data type to handle get_user_pages_fast error condition. Also
do not treat EFAULT error as fatal.

Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
---
Changes from previous version:
Retain printing error message in case get_user_pages_fast fails

 net/9p/client.c       |    2 +-
 net/9p/trans_common.c |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 691a04a..1612142 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -614,7 +614,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
-		if (err != -ERESTARTSYS)
+		if (err != -ERESTARTSYS && err != -EFAULT)
 			c->status = Disconnected;
 		goto reterr;
 	}
diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index 14265e8..0e73e07 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -63,7 +63,7 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
 		int nr_pages, u8 rw)
 {
 	uint32_t first_page_bytes = 0;
-	uint32_t pdata_mapped_pages;
+	int32_t pdata_mapped_pages;
 	struct trans_rpage_info  *rpinfo;
 
 	*pdata_off = (__force size_t)req->tc->pubuf & (PAGE_SIZE-1);
@@ -75,13 +75,11 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
 	rpinfo = req->tc->private;
 	pdata_mapped_pages = get_user_pages_fast((unsigned long)req->tc->pubuf,
 			nr_pages, rw, &rpinfo->rp_data[0]);
-
-	if (pdata_mapped_pages < 0) {
+	if (pdata_mapped_pages <= 0) {
 		printk(KERN_ERR "get_user_pages_fast failed:%d udata:%p"
 				"nr_pages:%d\n", pdata_mapped_pages,
 				req->tc->pubuf, nr_pages);
-		pdata_mapped_pages = 0;
-		return -EIO;
+		return pdata_mapped_pages ;
 	}
 	rpinfo->rp_nr_pages = pdata_mapped_pages;
 	if (*pdata_off) {
-- 
1.7.4

