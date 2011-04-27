Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab1D0MhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:37:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54954 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759174Ab1D0MhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:37:00 -0400
X-Sasl-enc: 6w2+vmTBsFaDPCENp5v5NHGlRpu3nZzKPV7Kz0z5/+Sg 1303907819
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 7/7] ima: added new LSM conditions in the policy
Date: Wed, 27 Apr 2011 14:34:15 +0200
Message-Id: <1303907657-18366-8-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----7980DD12C8618D03EA5E05F812D0F250"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------7980DD12C8618D03EA5E05F812D0F250

The new parameters 'fowner_user', 'fowner_role' and 'fowner_type' are new
LSM conditions that allow to measure inodes whose opened file descriptor
has the label given as a value.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 Documentation/ABI/testing/ima_policy |    7 ++++-
 security/integrity/ima/ima.h         |    4 +-
 security/integrity/ima/ima_api.c     |    4 +-
 security/integrity/ima/ima_main.c    |    4 +-
 security/integrity/ima/ima_policy.c  |   45 +++++++++++++++++++++++++++++----
 5 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6cd6dae..ee49345 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -18,7 +18,8 @@ Description:
 		condition:= base | lsm
 			base:	[[func=] [mask=] [fsmagic=] [uid=]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
-				 [obj_user=] [obj_role=] [obj_type=]]
+				 [obj_user=] [obj_role=] [obj_type=]
+				 [fowner_user=] [fowner_role=] [fowner_type=]]
 
 		base: 	func:= [BPRM_CHECK][FILE_MMAP][FILE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
@@ -46,6 +47,10 @@ Description:
 		all files mmapped executable in file_mmap, and all files
 		open for read by root in do_filp_open.
 
+		LSM conditions starting with obj_ refer to security attributes
+		of inodes while those starting with fowner_ involve file
+		descriptors.
+
 		Examples of LSM specific definitions:
 
 		SELinux:
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 08408bd..3a05625 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -110,7 +110,7 @@ struct ima_iint_cache {
 };
 
 /* LIM API function definitions */
-int ima_must_measure(struct inode *inode, int mask, int function);
+int ima_must_measure(struct file *file, int mask, int function);
 int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file);
 void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
@@ -128,7 +128,7 @@ struct ima_iint_cache *ima_iint_find(struct inode *inode);
 /* IMA policy related functions */
 enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
 
-int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
+int ima_match_policy(struct file *file, enum ima_hooks func, int mask);
 void ima_init_policy(void);
 void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index da36d2c..d815392 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -108,11 +108,11 @@ err_out:
  * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
  * or other error, return an error code.
 */
-int ima_must_measure(struct inode *inode, int mask, int function)
+int ima_must_measure(struct file *file, int mask, int function)
 {
 	int must_measure;
 
-	must_measure = ima_match_policy(inode, function, mask);
+	must_measure = ima_match_policy(file, function, mask);
 	return must_measure ? 0 : -EACCES;
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 39d66dc..9eaca61 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -65,7 +65,7 @@ static void ima_rdwr_violation_check(struct file *file)
 		goto out;
 	}
 
-	rc = ima_must_measure(inode, MAY_READ, FILE_CHECK);
+	rc = ima_must_measure(file, MAY_READ, FILE_CHECK);
 	if (rc < 0)
 		goto out;
 
@@ -127,7 +127,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
 
-	rc = ima_must_measure(inode, mask, function);
+	rc = ima_must_measure(file, mask, function);
 	if (rc != 0)
 		return rc;
 retry:
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d661afb..115c2e7 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -27,9 +27,10 @@
 
 enum ima_action { UNKNOWN = -1, DONT_MEASURE = 0, MEASURE };
 
-#define MAX_LSM_RULES 6
+#define MAX_LSM_RULES 9
 enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
-	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
+	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE,
+	LSM_FOWNER_USER, LSM_FOWNER_ROLE, LSM_FOWNER_TYPE
 };
 
 struct ima_measure_rule_entry {
@@ -96,9 +97,10 @@ __setup("ima_tcb", default_policy_setup);
  * Returns true on rule match, false on failure.
  */
 static bool ima_match_rules(struct ima_measure_rule_entry *rule,
-			    struct inode *inode, enum ima_hooks func, int mask)
+			    struct file *file, enum ima_hooks func, int mask)
 {
 	struct task_struct *tsk = current;
+	struct inode *inode = file->f_dentry->d_inode;
 	int i;
 
 	if ((rule->flags & IMA_FUNC) && rule->func != func)
@@ -112,7 +114,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
-		u32 osid, sid;
+		u32 osid, sid, fsid;
 
 		if (!rule->lsm[i].rule)
 			continue;
@@ -137,6 +139,15 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 							Audit_equal,
 							rule->lsm[i].rule,
 							NULL);
+		case LSM_FOWNER_USER:
+		case LSM_FOWNER_ROLE:
+		case LSM_FOWNER_TYPE:
+			security_file_getsecid(file, &fsid);
+			rc = security_filter_rule_match(fsid,
+							rule->lsm[i].type,
+							Audit_equal,
+							rule->lsm[i].rule,
+							NULL);
 		default:
 			break;
 		}
@@ -159,14 +170,14 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
  * as elements in the list are never deleted, nor does the list
  * change.)
  */
-int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
+int ima_match_policy(struct file *file, enum ima_hooks func, int mask)
 {
 	struct ima_measure_rule_entry *entry;
 
 	list_for_each_entry(entry, ima_measure, list) {
 		bool rc;
 
-		rc = ima_match_rules(entry, inode, func, mask);
+		rc = ima_match_rules(entry, file, func, mask);
 		if (rc)
 			return entry->action;
 	}
@@ -222,6 +233,7 @@ enum {
 	Opt_measure = 1, Opt_dont_measure,
 	Opt_obj_user, Opt_obj_role, Opt_obj_type,
 	Opt_subj_user, Opt_subj_role, Opt_subj_type,
+	Opt_fowner_user, Opt_fowner_role, Opt_fowner_type,
 	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
 };
 
@@ -234,6 +246,9 @@ static match_table_t policy_tokens = {
 	{Opt_subj_user, "subj_user=%s"},
 	{Opt_subj_role, "subj_role=%s"},
 	{Opt_subj_type, "subj_type=%s"},
+	{Opt_fowner_user, "fowner_user=%s"},
+	{Opt_fowner_role, "fowner_role=%s"},
+	{Opt_fowner_type, "fowner_type=%s"},
 	{Opt_func, "func=%s"},
 	{Opt_mask, "mask=%s"},
 	{Opt_fsmagic, "fsmagic=%s"},
@@ -407,6 +422,24 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 						   LSM_SUBJ_TYPE,
 						   AUDIT_SUBJ_TYPE);
 			break;
+		case Opt_fowner_user:
+			ima_log_string(ab, "fowner_user", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_FOWNER_USER,
+						   AUDIT_SUBJ_USER);
+			break;
+		case Opt_fowner_role:
+			ima_log_string(ab, "fowner_role", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_FOWNER_ROLE,
+						   AUDIT_SUBJ_ROLE);
+			break;
+		case Opt_fowner_type:
+			ima_log_string(ab, "fowner_type", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_FOWNER_TYPE,
+						   AUDIT_SUBJ_TYPE);
+			break;
 		case Opt_err:
 			ima_log_string(ab, "UNKNOWN", p);
 			result = -EINVAL;
-- 
1.7.4.4


------7980DD12C8618D03EA5E05F812D0F250
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjcxMjM1MDlaMCMGCSqG
SIb3DQEJBDEWBBQcXQ8mWmKWyfylC+GwwM7fYHlFATB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDOBid4e6bc1/K++uRC0AiPGGNy
onpfmwfuAj7d70WPOPQNxO8vvKOf5ksgdiEAp1ojV6jEcVrHUzipp/5yoqVWKefT
RpWL5eu6tJpCtwvU9/CK52qqkL+p3Ph43VtLfBBk/BJdEEI1K+6vxZ8lBS/PS2nN
ACVzCHcfLWUjRtX40Nd6sFmG2lqOWt7tNjV5hQ/JtUPMKJDiPaiZ8DtVz/pAVC/N
UMbJSOP+QqZGsJLiFfpTZTD8Cr9hBLyHp+1C5kV2+ItEYQIxp+1scdR7FEoRM4t5
tS1fU8AoFU+70bn+ukaU0m5TMFwSFVgzQsu/Vc+qSvm3cyCc/pz9d311Tmjl

------7980DD12C8618D03EA5E05F812D0F250--


