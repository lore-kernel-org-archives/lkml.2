Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0JROlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:41:05 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51355 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab0JROlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:41:01 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanchit Garg <sancgarg@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] net/9p: Return error on read with NULL buffer
Date: Mon, 18 Oct 2010 20:10:53 +0530
Message-Id: <1287412853-24700-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287412853-24700-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1287412853-24700-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanchit Garg <sancgarg@linux.vnet.ibm.com>

This patch ensures that a read(fd, NULL, 0 ) returns  EFAULT on a 9p file.

Signed-off-by: Sanchit Garg <sancgarg@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index e141e46..d5344d8 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1313,6 +1313,11 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
 	rsize = fid->iounit;
 	if (!rsize || rsize > clnt->msize-P9_IOHDRSZ)
 		rsize = clnt->msize - P9_IOHDRSZ;
+	/*
+	 * A read with NULL user buffer cause EFAULT error
+	 */
+	if (!data && !udata)
+		return -EFAULT;
 
 	if (count < rsize)
 		rsize = count;
@@ -1333,16 +1338,13 @@ p9_client_read(struct p9_fid *fid, char *data, char __user *udata, u64 offset,
 
 	if (data) {
 		memmove(data, dataptr, count);
-	}
-
-	if (udata) {
+	} else {
 		err = copy_to_user(udata, dataptr, count);
 		if (err) {
 			err = -EFAULT;
 			goto free_and_error;
 		}
 	}
-
 	p9_free_req(clnt, req);
 	return count;
 
-- 
1.7.1

