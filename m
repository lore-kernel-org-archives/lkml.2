Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1F2TxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:53:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33480 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab1F2Tw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:52:56 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v7 14/16] evm: replace hmac_status with evm_status
Date: Wed, 29 Jun 2011 15:50:36 -0400
Message-Id: <1309377038-4550-15-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

We will use digital signatures in addtion to hmac.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/evm_main.c |   14 +++++++-------
 security/integrity/iint.c         |    2 +-
 security/integrity/integrity.h    |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index bfe44df..eb07f9d 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -56,8 +56,8 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	struct evm_ima_xattr_data xattr_data;
 	int rc;
 
-	if (iint->hmac_status == INTEGRITY_PASS)
-		return iint->hmac_status;
+	if (iint->evm_status == INTEGRITY_PASS)
+		return iint->evm_status;
 
 	/* if status is not PASS, try to check again - against -ENOMEM */
 
@@ -71,18 +71,18 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 			   sizeof xattr_data, GFP_NOFS);
 	if (rc < 0)
 		goto err_out;
-	iint->hmac_status = INTEGRITY_PASS;
-	return iint->hmac_status;
+	iint->evm_status = INTEGRITY_PASS;
+	return iint->evm_status;
 
 err_out:
 	switch (rc) {
 	case -ENODATA:		/* file not labelled */
-		iint->hmac_status = INTEGRITY_NOLABEL;
+		iint->evm_status = INTEGRITY_NOLABEL;
 		break;
 	default:
-		iint->hmac_status = INTEGRITY_FAIL;
+		iint->evm_status = INTEGRITY_FAIL;
 	}
-	return iint->hmac_status;
+	return iint->evm_status;
 }
 
 static int evm_protected_xattr(const char *req_xattr_name)
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index 991df20..0a23e07 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -157,7 +157,7 @@ static void init_once(void *foo)
 	iint->version = 0;
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
-	iint->hmac_status = INTEGRITY_UNKNOWN;
+	iint->evm_status = INTEGRITY_UNKNOWN;
 }
 
 static int __init integrity_iintcache_init(void)
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 7efbf56..880bbee 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -37,7 +37,7 @@ struct integrity_iint_cache {
 	unsigned char flags;
 	u8 digest[SHA1_DIGEST_SIZE];
 	struct mutex mutex;	/* protects: version, flags, digest */
-	enum integrity_status hmac_status;
+	enum integrity_status evm_status;
 };
 
 /* rbtree tree calls to lookup, insert, delete
-- 
1.7.3.4

