Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1F2Twt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:52:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59516 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab1F2Twn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:52:43 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v7 13/16] evm: evm_verify_hmac must not return INTEGRITY_UNKNOWN
Date: Wed, 29 Jun 2011 15:50:35 -0400
Message-Id: <1309377038-4550-14-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1309377038-4550-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

If EVM is not supported or enabled, evm_verify_hmac() returns
INTEGRITY_UNKNOWN, which ima_appraise_measurement() ignores and sets
the appraisal status based solely on the security.ima verification.

evm_verify_hmac() also returns INTEGRITY_UNKNOWN for other failures, such
as temporary failures like -ENOMEM, resulting in possible attack vectors.
This patch changes the default return code for temporary/unexpected
failures, like -ENOMEM, from INTEGRITY_UNKNOWN to INTEGRITY_FAIL, making
evm_verify_hmac() fail safe.

As a result, failures need to be re-evaluated in order to catch both
temporary errors, such as the -ENOMEM, as well as errors that have been
resolved in fix mode.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/evm/evm_main.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 0fa8261..bfe44df 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -56,13 +56,15 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	struct evm_ima_xattr_data xattr_data;
 	int rc;
 
-	if (iint->hmac_status != INTEGRITY_UNKNOWN)
+	if (iint->hmac_status == INTEGRITY_PASS)
 		return iint->hmac_status;
 
+	/* if status is not PASS, try to check again - against -ENOMEM */
+
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
 			   xattr_value_len, xattr_data.digest);
 	if (rc < 0)
-		return INTEGRITY_UNKNOWN;
+		goto err_out;
 
 	xattr_data.type = EVM_XATTR_HMAC;
 	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, (u8 *)&xattr_data,
@@ -77,11 +79,8 @@ err_out:
 	case -ENODATA:		/* file not labelled */
 		iint->hmac_status = INTEGRITY_NOLABEL;
 		break;
-	case -EINVAL:
-		iint->hmac_status = INTEGRITY_FAIL;
-		break;
 	default:
-		iint->hmac_status = INTEGRITY_UNKNOWN;
+		iint->hmac_status = INTEGRITY_FAIL;
 	}
 	return iint->hmac_status;
 }
-- 
1.7.3.4

