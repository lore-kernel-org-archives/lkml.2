Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0JROlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:41:03 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37137 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab0JROlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:41:00 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] net/9p: Return error if we fail to encode protocol data
Date: Mon, 18 Oct 2010 20:10:52 +0530
Message-Id: <1287412853-24700-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to return error in case we fail to encode data in protocl buffer.
This patch also return error in case of a failed copy_from_user.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c   |    2 ++
 net/9p/protocol.c |    5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index b2b066a..e141e46 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -579,6 +579,8 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	va_start(ap, fmt);
 	err = p9pdu_vwritef(req->tc, c->proto_version, fmt, ap);
 	va_end(ap);
+	if (err)
+		goto reterr;
 	p9pdu_finalize(req->tc);
 
 	err = c->trans_mod->request(c, req);
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 3acd3af..45c15f4 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -122,9 +122,8 @@ static size_t
 pdu_write_u(struct p9_fcall *pdu, const char __user *udata, size_t size)
 {
 	size_t len = MIN(pdu->capacity - pdu->size, size);
-	int err = copy_from_user(&pdu->sdata[pdu->size], udata, len);
-	if (err)
-		printk(KERN_WARNING "pdu_write_u returning: %d\n", err);
+	if (copy_from_user(&pdu->sdata[pdu->size], udata, len))
+		len = 0;
 
 	pdu->size += len;
 	return size - len;
-- 
1.7.1

