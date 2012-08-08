Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030467Ab2HHRD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:03:56 -0400
Received: from mail.ispras.ru ([83.149.199.43]:44704 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030442Ab2HHRDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:03:54 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Sachin Bhamare <sbhamare@panasas.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] exofs: check for allocation failure in uri_store()
Date: Wed,  8 Aug 2012 21:02:37 +0400
Message-Id: <1344445357-986-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no memory allocation failure check in uri_store().
That can lead to NULL pointer dereference.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/exofs/sys.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/exofs/sys.c b/fs/exofs/sys.c
index 5a7b691..1b4f2f9 100644
--- a/fs/exofs/sys.c
+++ b/fs/exofs/sys.c
@@ -80,8 +80,13 @@ static ssize_t uri_show(struct exofs_dev *edp, char *buf)
 
 static ssize_t uri_store(struct exofs_dev *edp, const char *buf, size_t len)
 {
+	uint8_t *new_uri;
+
 	edp->urilen = strlen(buf) + 1;
-	edp->uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
+	new_uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
+	if (new_uri == NULL)
+		return -ENOMEM;
+	edp->uri = new_uri;
 	strncpy(edp->uri, buf, edp->urilen);
 	return edp->urilen;
 }
-- 
1.7.9.5

