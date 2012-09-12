Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2ILK1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:27:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:29596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab2ILK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:27:18 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 1/1] digsig: add hash size comparision on signature verification
Date: Wed, 12 Sep 2012 13:26:55 +0300
Message-Id: <a686758774e2817d1ff7fced54a6a08f85e66062.1347445596.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b35e286a640f31d619a637332972498b51f3fd90 introduced the bug.

When pkcs_1_v1_5_decode_emsa() returns without error and hash sizes do not
match, hash comparision is not done and digsig_verify_rsa() returns no error.
This is a bug and this patch fixes it.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/digsig.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 286d558..8c0e629 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -163,9 +163,11 @@ static int digsig_verify_rsa(struct key *key,
 	memcpy(out1 + head, p, l);
 
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
+	if (err)
+		goto err;
 
-	if (!err && len == hlen)
-		err = memcmp(out2, h, hlen);
+	if (len != hlen || memcmp(out2, h, hlen))
+		err = -EINVAL;
 
 err:
 	mpi_free(in);
-- 
1.7.9.5

