Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3AGCAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 21:00:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:58115 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab3AGCAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 21:00:18 -0500
Date: Mon, 7 Jan 2013 13:00:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Fix for regression in integrity subsystem
Message-ID: <alpine.LRH.2.02.1301071258290.13741@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull for 3.8.

Description from Tetsuo:

Commit fdf90729 "ima: support new kernel module syscall" by error modified 
init_module() to return INTEGRITY_UNKNOWN (which is 4) to user space if 
kernel was built with CONFIG_IMA_APPRAISE=y. As a result, user space can 
no longer load kernel modules using init_module(). This commit fixes this 
regression.


The following changes since commit 5f243b9b46a22e5790dbbc36f574c2417af49a41:
  Linus Torvalds (1):
        Merge tag 'arm64-fixes' of git://git.kernel.org/.../cmarinas/linux-aarch64

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      Merge branch 'for-Linus' of git://git.kernel.org/.../zohar/linux-integrity into for-linus

Mimi Zohar (1):
      ima: fallback to MODULE_SIG_ENFORCE for existing kernel module syscall

 security/integrity/ima/ima.h        |    1 +
 security/integrity/ima/ima_main.c   |   12 ++++++++----
 security/integrity/ima/ima_policy.c |    3 ++-
 3 files changed, 11 insertions(+), 5 deletions(-)

---

commit a7f2a366f62319dfebf8d4dfe8b211f631c78457
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Fri Dec 21 08:34:21 2012 -0500

    ima: fallback to MODULE_SIG_ENFORCE for existing kernel module syscall
    
    The new kernel module syscall appraises kernel modules based
    on policy.   If the IMA policy requires kernel module checking,
    fallback to module signature enforcing for the existing syscall.
    Without CONFIG_MODULE_SIG_FORCE enabled, the kernel module's
    integrity is unknown, return -EACCES.
    
    Changelog v1:
    - Fix ima_module_check() return result (Tetsuo Handa)
    
    Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Reviewed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

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
index 45de18e..dba965d 100644
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
+			rc = -EACCES;	/* INTEGRITY_UNKNOWN */
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
