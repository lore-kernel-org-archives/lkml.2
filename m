Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1EPOsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:48:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42593 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1EPOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:48:19 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 18/21] evm: evm_verify_hmac must not return INTEGRITY_UNKNOWN
Date: Mon, 16 May 2011 10:45:12 -0400
Message-Id: <1305557115-15652-19-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
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
index 944783c..245ef23 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -57,14 +57,16 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 	char hmac_val[MAX_DIGEST_SIZE + 1];
 	int rc;
 
-	if (iint->hmac_status != INTEGRITY_UNKNOWN)
+	if (iint->hmac_status == INTEGRITY_PASS)
 		return iint->hmac_status;
 
+	/* if status is not PASS, try to check again - against -ENOMEM */
+
 	memset(hmac_val, 0, sizeof hmac_val);
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
 			   xattr_value_len, hmac_val + 1);
 	if (rc < 0)
-		return INTEGRITY_UNKNOWN;
+		goto err_out;
 
 	hmac_val[0] = EVM_XATTR_HMAC;
 	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, hmac_val, sizeof hmac_val,
@@ -79,11 +81,8 @@ err_out:
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

