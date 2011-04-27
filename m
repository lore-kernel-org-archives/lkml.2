Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab1D0Mg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:36:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41434 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759156Ab1D0Mgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:36:54 -0400
X-Sasl-enc: n5mh5yqrCai4cYrjs4Y4sBrOJ3YOFun092R5OetyPRBn 1303907813
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 6/7] security: new LSM hook security_file_getsecid()
Date: Wed, 27 Apr 2011 14:34:14 +0200
Message-Id: <1303907657-18366-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----9E53A120786B392C6DD45B0D0888154C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------9E53A120786B392C6DD45B0D0888154C

The new LSM hook security_file_getsecid() and its implementation in the
capability module, SELinux and SMACK allows to obtain the security
identifier associated to a file descriptor.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 include/linux/security.h   |   12 ++++++++++++
 security/capability.c      |    6 ++++++
 security/security.c        |    6 ++++++
 security/selinux/hooks.c   |    7 +++++++
 security/smack/smack_lsm.c |   11 +++++++++++
 5 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ca02f17..6e73a1a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -630,6 +630,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	to receive an open file descriptor via socket IPC.
  *	@file contains the file structure being received.
  *	Return 0 if permission is granted.
+ * @file_getsecid:
+ *	Get the secid associated with the file descriptor.
+ *	@file contains a pointer to the file descriptor.
+ *	@secid contains a pointer to the location where result will be saved.
+ *	In case of failure, @secid will be set to zero.
  *
  * Security hook for dentry
  *
@@ -1492,6 +1497,7 @@ struct security_operations {
 	int (*file_send_sigiotask) (struct task_struct *tsk,
 				    struct fown_struct *fown, int sig);
 	int (*file_receive) (struct file *file);
+	void (*file_getsecid)(const struct file *file, u32 *secid);
 	int (*dentry_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
@@ -1751,6 +1757,7 @@ int security_file_set_fowner(struct file *file);
 int security_file_send_sigiotask(struct task_struct *tsk,
 				 struct fown_struct *fown, int sig);
 int security_file_receive(struct file *file);
+void security_file_getsecid(const struct file *file, u32 *secid);
 int security_dentry_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
@@ -2251,6 +2258,11 @@ static inline int security_file_receive(struct file *file)
 	return 0;
 }
 
+static inline void security_file_getsecid(const struct file *file, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_dentry_open(struct file *file,
 				       const struct cred *cred)
 {
diff --git a/security/capability.c b/security/capability.c
index 2984ea4..fcb569d 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -349,6 +349,11 @@ static int cap_file_receive(struct file *file)
 	return 0;
 }
 
+static void cap_file_getsecid(const struct file *file, u32 *secid)
+{
+	*secid = 0;
+}
+
 static int cap_dentry_open(struct file *file, const struct cred *cred)
 {
 	return 0;
@@ -953,6 +958,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_set_fowner);
 	set_to_cap_if_null(ops, file_send_sigiotask);
 	set_to_cap_if_null(ops, file_receive);
+	set_to_cap_if_null(ops, file_getsecid);
 	set_to_cap_if_null(ops, dentry_open);
 	set_to_cap_if_null(ops, task_create);
 	set_to_cap_if_null(ops, cred_alloc_blank);
diff --git a/security/security.c b/security/security.c
index 1011423..9973dab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -688,6 +688,12 @@ int security_file_receive(struct file *file)
 	return security_ops->file_receive(file);
 }
 
+void security_file_getsecid(const struct file *file, u32 *secid)
+{
+	security_ops->file_getsecid(file, secid);
+}
+EXPORT_SYMBOL(security_file_getsecid);
+
 int security_dentry_open(struct file *file, const struct cred *cred)
 {
 	int ret;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6772687..e1e787c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3179,6 +3179,12 @@ static int selinux_file_receive(struct file *file)
 	return file_has_perm(cred, file, file_to_av(file));
 }
 
+static void selinux_file_getsecid(const struct file *file, u32 *secid)
+{
+	struct file_security_struct *fsec = file->f_security;
+	*secid = fsec->sid;
+}
+
 static int selinux_dentry_open(struct file *file, const struct cred *cred)
 {
 	struct file_security_struct *fsec;
@@ -5498,6 +5504,7 @@ static struct security_operations selinux_ops = {
 	.file_set_fowner =		selinux_file_set_fowner,
 	.file_send_sigiotask =		selinux_file_send_sigiotask,
 	.file_receive =			selinux_file_receive,
+	.file_getsecid =		selinux_file_getsecid,
 
 	.dentry_open =			selinux_dentry_open,
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6612ba1..a583736 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1304,6 +1304,16 @@ static int smack_file_receive(struct file *file)
 	return smk_curacc(file->f_security, may, &ad);
 }
 
+/**
+ * smack_file_getsecid - Extract file descriptor's security id
+ * @file: file descriptor to extract the info from
+ * @secid: where result will be saved
+ */
+static void smack_file_getsecid(const struct file *file, u32 *secid)
+{
+	*secid = smack_to_secid(file->f_security);
+}
+
 /*
  * Task hooks
  */
@@ -3434,6 +3444,7 @@ struct security_operations smack_ops = {
 	.file_set_fowner = 		smack_file_set_fowner,
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
+	.file_getsecid =		smack_file_getsecid,
 
 	.cred_alloc_blank =		smack_cred_alloc_blank,
 	.cred_free =			smack_cred_free,
-- 
1.7.4.4


------9E53A120786B392C6DD45B0D0888154C
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjcxMjM1MDNaMCMGCSqG
SIb3DQEJBDEWBBQPpMrtSjx9vko4NtB+uLoinRgLGjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBuYPNpmxPHlKPkPHmmpQEXbgiO
o4BH9tI5gkTrawVvfZy5wsnHGS2ZD3OGUV8M1QdLiVfhqiiAiVmgnWaaprSdIiTg
ipOJ6KQqWzZ2yQazgByqvlbXSfatA4XAp0eEetjDZZLe0gDA/uYd0jREwH1S8edT
AoOJ4yMwmp3fBou72kxnAk3iykShGHod2nd0Lx6WbTxz1SMD+K2bco9PJHh0Q+nA
eonW/69YZJzV+CNyrsgJnPlyAn0iC2NYq1fmsFYMDr84tnpzslz1uuSf39lLdFjy
yWP086SIz1FUehSEdLWAhnKwrGBrrPmGuYIsKHFcNjUDEKjIy4P6wLd6Dksw

------9E53A120786B392C6DD45B0D0888154C--


