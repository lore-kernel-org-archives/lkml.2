Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1KUOSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:18:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43976 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1KUOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:18:48 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
        srajiv@linux.vnet.ibm.com, Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH] ima: add new kernel parameter ima_denycall_on_errors
Date: Mon, 21 Nov 2011 15:18:10 +0100
Message-Id: <1321885097-14166-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----29AF5B6CBADEFA9E236BA59ABDEE2A64"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------29AF5B6CBADEFA9E236BA59ABDEE2A64

The new kernel parameter tells IMA the action that must be done when an
error in the measurement process occurs. If 'ima_denycall_on_errors' is
equal to 1, the IMA hooks return an error, so that the system call will
not be executed. Otherwise, the default behavior is to execute the system
call and, eventually, to include in the measurements list those entries
for which the PCR extend operation was failed.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/kernel-parameters.txt |    8 ++++
 security/integrity/ima/ima.h        |    5 ++-
 security/integrity/ima/ima_api.c    |   12 ++++--
 security/integrity/ima/ima_init.c   |   11 ++++--
 security/integrity/ima/ima_main.c   |   65 ++++++++++++++++++++++++-----------
 security/integrity/ima/ima_queue.c  |    9 +++--
 6 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..6fe6634 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -995,6 +995,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			programs exec'd, files mmap'd for exec, and all files
 			opened for read by uid=0.
 
+	ima_denycall_on_errors=
+			[IMA]
+			Format: { "0" | "1" }
+			0 -- execute the system call even if the inode was not
+			     measured. (Default)
+			1 -- deny the system call execution if the inode
+			     measurement was failed.
+
 	init=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /sbin/init as init
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3ccf7ac..79e259c 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -38,6 +38,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 
 /* set during initialization */
 extern int ima_initialized;
+extern int ima_enforce;
 extern int ima_used_chip;
 extern char *ima_hash;
 
@@ -77,7 +78,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 int ima_calc_hash(struct file *file, char *digest);
 int ima_calc_template_hash(int template_len, void *template, char *digest);
 int ima_calc_boot_aggregate(char *digest);
-void ima_add_violation(struct inode *inode, const unsigned char *filename,
+int ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause);
 
 /*
@@ -101,7 +102,7 @@ static inline unsigned long ima_hash_key(u8 *digest)
 int ima_must_measure(struct inode *inode, int mask, int function);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file);
-void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
+int ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 88a2788..bae5b9e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -67,7 +67,7 @@ int ima_store_template(struct ima_template_entry *entry,
  * By extending the PCR with 0xFF's instead of with zeroes, the PCR
  * value is invalidated.
  */
-void ima_add_violation(struct inode *inode, const unsigned char *filename,
+int ima_add_violation(struct inode *inode, const unsigned char *filename,
 		       const char *op, const char *cause)
 {
 	struct ima_template_entry *entry;
@@ -90,6 +90,7 @@ void ima_add_violation(struct inode *inode, const unsigned char *filename,
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 			    op, cause, result, 0);
+	return result;
 }
 
 /**
@@ -157,7 +158,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
  *
  * Must be called with iint->mutex held.
  */
-void ima_store_measurement(struct integrity_iint_cache *iint,
+int ima_store_measurement(struct integrity_iint_cache *iint,
 			   struct file *file, const unsigned char *filename)
 {
 	const char *op = "add_template_measure";
@@ -171,15 +172,18 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	if (!entry) {
 		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
 				    op, audit_cause, result, 0);
-		return;
+		return result;
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
 	memcpy(entry->template.digest, iint->digest, IMA_DIGEST_SIZE);
 	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
 
 	result = ima_store_template(entry, violation, inode);
-	if (!result || result == -EEXIST)
+	if (!result || result == -EEXIST) {
 		iint->flags |= IMA_MEASURED;
+		result = 0;
+	}
 	if (result < 0)
 		kfree(entry);
+	return result;
 }
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 17f1f06..7e29d6f 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -39,7 +39,7 @@ int ima_used_chip;
  * a different value.) Violations add a zero entry to the measurement
  * list and extend the aggregate PCR value with ff...ff's.
  */
-static void __init ima_add_boot_aggregate(void)
+static int __init ima_add_boot_aggregate(void)
 {
 	struct ima_template_entry *entry;
 	const char *op = "add_boot_aggregate";
@@ -66,10 +66,12 @@ static void __init ima_add_boot_aggregate(void)
 	result = ima_store_template(entry, violation, NULL);
 	if (result < 0)
 		kfree(entry);
-	return;
+	goto out;
 err_out:
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,
 			    audit_cause, result, 0);
+out:
+	return result;
 }
 
 int __init ima_init(void)
@@ -85,7 +87,10 @@ int __init ima_init(void)
 	if (!ima_used_chip)
 		pr_info("IMA: No TPM chip found, activating TPM-bypass!\n");
 
-	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
+	rc = ima_add_boot_aggregate();	/* boot aggregate must be first entry */
+	if (rc != 0)
+		return -EACCES;
+
 	ima_init_policy();
 
 	return ima_fs_init();
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 1eff5cb..9f2edf5 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -27,6 +27,20 @@
 #include "ima.h"
 
 int ima_initialized;
+int ima_enforce;
+
+/* ima_denycall_setup - deny syscall execution when inode measurement fails */
+int ima_denycall_on_errors;
+static int __init ima_denycall_setup(char *str)
+{
+	unsigned long deny;
+
+	ima_denycall_on_errors = 0;
+	if (!kstrtoul(str, 0, &deny))
+		ima_denycall_on_errors = deny ? 1 : 0;
+	return 1;
+}
+__setup("ima_denycall_on_errors=", ima_denycall_setup);
 
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
@@ -47,16 +61,16 @@ __setup("ima_hash=", hash_setup);
  * 	  could result in a file measurement error.
  *
  */
-static void ima_rdwr_violation_check(struct file *file)
+static int ima_rdwr_violation_check(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
-	int rc;
+	int rc = 0;
 	bool send_tomtou = false, send_writers = false;
 
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
-		return;
+		return 0;
 
 	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
 
@@ -67,8 +81,10 @@ static void ima_rdwr_violation_check(struct file *file)
 	}
 
 	rc = ima_must_measure(inode, MAY_READ, FILE_CHECK);
-	if (rc < 0)
+	if (rc < 0) {
+		rc = 0;
 		goto out;
+	}
 
 	if (atomic_read(&inode->i_writecount) > 0)
 		send_writers = true;
@@ -76,11 +92,12 @@ out:
 	mutex_unlock(&inode->i_mutex);
 
 	if (send_tomtou)
-		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
-				  "ToMToU");
+		rc = ima_add_violation(inode, dentry->d_name.name,
+				       "invalid_pcr", "ToMToU");
 	if (send_writers)
-		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
-				  "open_writers");
+		rc = ima_add_violation(inode, dentry->d_name.name,
+				       "invalid_pcr", "open_writers");
+	return (!rc) ? 0 : -EACCES;
 }
 
 static void ima_check_last_writer(struct integrity_iint_cache *iint,
@@ -130,28 +147,31 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 
 	rc = ima_must_measure(inode, mask, function);
 	if (rc != 0)
-		return rc;
+		return 0;
 retry:
 	iint = integrity_iint_find(inode);
 	if (!iint) {
 		rc = integrity_inode_alloc(inode);
-		if (!rc || rc == -EEXIST)
+		if (!rc || rc == -EEXIST) {
+			rc = 0;
 			goto retry;
+		}
 		return rc;
 	}
 
 	mutex_lock(&iint->mutex);
 
-	rc = iint->flags & IMA_MEASURED ? 1 : 0;
-	if (rc != 0)
+	if (iint->flags & IMA_MEASURED)
 		goto out;
 
 	rc = ima_collect_measurement(iint, file);
-	if (!rc)
-		ima_store_measurement(iint, file, filename);
+	if (rc != 0)
+		goto out;
+
+	rc = ima_store_measurement(iint, file, filename);
 out:
 	mutex_unlock(&iint->mutex);
-	return rc;
+	return (!rc) ? 0 : -EACCES;
 }
 
 /**
@@ -167,14 +187,14 @@ out:
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	int rc;
+	int rc = 0;
 
 	if (!file)
 		return 0;
 	if (prot & PROT_EXEC)
 		rc = process_measurement(file, file->f_dentry->d_name.name,
 					 MAY_EXEC, FILE_MMAP);
-	return 0;
+	return (ima_enforce) ? rc : 0;
 }
 
 /**
@@ -196,7 +216,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
 
 	rc = process_measurement(bprm->file, bprm->filename,
 				 MAY_EXEC, BPRM_CHECK);
-	return 0;
+	return (ima_enforce) ? rc : 0;
 }
 
 /**
@@ -213,11 +233,15 @@ int ima_file_check(struct file *file, int mask)
 {
 	int rc;
 
-	ima_rdwr_violation_check(file);
+	rc = ima_rdwr_violation_check(file);
+	if (rc != 0 && ima_enforce)
+		goto out;
+
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
-	return 0;
+out:
+	return (ima_enforce) ? rc : 0;
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
 
@@ -226,6 +250,7 @@ static int __init init_ima(void)
 	int error;
 
 	error = ima_init();
+	ima_enforce |= ima_denycall_on_errors;
 	ima_initialized = 1;
 	return error;
 }
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 7ae1e9a..cc1989f 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -147,9 +147,12 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	if (result != 0) {
 		audit_cause = "TPM error";
 		audit_info = 0;
-		result = -ECOMM;
-		kfree(qe);
-		goto out;
+		result = 1;
+		if (ima_enforce) {
+			result = -ECOMM;
+			kfree(qe);
+			goto out;
+		}
 	}
 
 	ima_add_digest_entry(qe);
-- 
1.7.6.4


------29AF5B6CBADEFA9E236BA59ABDEE2A64
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTExMjExNDE4MTZaMCMGCSqG
SIb3DQEJBDEWBBQ7FnEV2V5TPzp2w4dUP8EFvo978zB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCHw/LwQziQU7dhqnTy3hiQJEP7
/W7+mzbHYQzR1poeTWp+zx4RHejnEN3PZXZSt2YdyzCXPd3NPnHovtW8zwm7sqwY
fNsB8l3b/ZsvBMG8FJBUud8SKkyLUXhcDCE0epMU67D+3LkMWnCwA9XIMt4EAT1Z
FITBZnErIIZP8BxbUsVe+2rYJQHkmS6PxsRgI7q45dsk/O1Va6VYAS0ppXc70tEZ
Wi+bp/6dV3yL0xQ8zoVGTx9iFsfiBvihnSmgD/ZQECAWJfes/pKdaNl9ixTkQN94
mgRfgS/zL0kPRLxHdT/lGenLdZcMKWvtcYvyakzcJbvOzld3siGpFjR1P1ML

------29AF5B6CBADEFA9E236BA59ABDEE2A64--


