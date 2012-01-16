Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2APSxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:53:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab2APStl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:19 2012
Message-Id: <20120116184519.271598812@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:45:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [42/48] ima: fix invalid memory reference
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@polito.it>

commit 7b7e5916aa2f46e57f8bd8cb89c34620ebfda5da upstream.

Don't free a valid measurement entry on TPM PCR extend failure.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_queue.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -23,6 +23,8 @@
 #include <linux/slab.h>
 #include "ima.h"
 
+#define AUDIT_CAUSE_LEN_MAX 32
+
 LIST_HEAD(ima_measurements);	/* list of all measurements */
 
 /* key: inode (before secure-hashing a file) */
@@ -94,7 +96,8 @@ static int ima_pcr_extend(const u8 *hash
 
 	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
 	if (result != 0)
-		pr_err("IMA: Error Communicating to TPM chip\n");
+		pr_err("IMA: Error Communicating to TPM chip, result: %d\n",
+		       result);
 	return result;
 }
 
@@ -106,8 +109,9 @@ int ima_add_template_entry(struct ima_te
 {
 	u8 digest[IMA_DIGEST_SIZE];
 	const char *audit_cause = "hash_added";
+	char tpm_audit_cause[AUDIT_CAUSE_LEN_MAX];
 	int audit_info = 1;
-	int result = 0;
+	int result = 0, tpmresult = 0;
 
 	mutex_lock(&ima_extend_list_mutex);
 	if (!violation) {
@@ -129,9 +133,11 @@ int ima_add_template_entry(struct ima_te
 	if (violation)		/* invalidate pcr */
 		memset(digest, 0xff, sizeof digest);
 
-	result = ima_pcr_extend(digest);
-	if (result != 0) {
-		audit_cause = "TPM error";
+	tpmresult = ima_pcr_extend(digest);
+	if (tpmresult != 0) {
+		snprintf(tpm_audit_cause, AUDIT_CAUSE_LEN_MAX, "TPM_error(%d)",
+			 tpmresult);
+		audit_cause = tpm_audit_cause;
 		audit_info = 0;
 	}
 out:


