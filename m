Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2LWEDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 23:03:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43064 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2LWEDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 23:03:02 -0500
Message-ID: <1356235377.3696.5.camel@falcor>
Subject: [PATCH] ima: fallback to MODULE_SIG_ENFORCE for existing kernel
 module syscall
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: ": Rusty Russell" <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sat, 22 Dec 2012 23:02:57 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122304-5518-0000-0000-00000A3C54E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new kernel module syscall appraises kernel modules based
on policy.   If the IMA policy requires kernel module checking,
fallback to module signature enforcing for the existing syscall,
if enabled.  Otherwise return INTEGRITY_UNKNOWN.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima.h        |    1 +
 security/integrity/ima/ima_main.c   |   12 ++++++++----
 security/integrity/ima/ima_policy.c |    3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3b2adb7..079a85d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -139,6 +139,7 @@ void ima_delete_rules(void);
 /* Appraise integrity measurements */
 #define IMA_APPRAISE_ENFORCE	0x01
 #define IMA_APPRAISE_FIX	0x02
+#define IMA_APPRAISE_MODULES	0x04
 
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(struct integrity_iint_cache *iint,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 45de18e..60bd509 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -291,11 +291,15 @@ EXPORT_SYMBOL_GPL(ima_file_check);
  */
 int ima_module_check(struct file *file)
 {
-	int rc;
+	int rc = 0;
 
-	if (!file)
-		rc = INTEGRITY_UNKNOWN;
-	else
+	if (!file) {
+		if (ima_appraise & IMA_APPRAISE_MODULES) {
+#ifndef CONFIG_MODULE_SIG_FORCE
+			rc = INTEGRITY_UNKNOWN;
+#endif
+		}
+	} else
 		rc = process_measurement(file, file->f_dentry->d_name.name,
 					 MAY_EXEC, MODULE_CHECK);
 	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index af7d182..479fca9 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -523,7 +523,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	}
 	if (!result && (entry->action == UNKNOWN))
 		result = -EINVAL;
-
+	else if (entry->func == MODULE_CHECK)
+		ima_appraise |= IMA_APPRAISE_MODULES;
 	audit_log_format(ab, "res=%d", !result);
 	audit_log_end(ab);
 	return result;
-- 
1.7.7.6



