Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab1D2Now (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:44:52 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41378 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758759Ab1D2Not (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:44:49 -0400
X-Sasl-enc: ++5QDBoLLPWoq1nMIoz34inZ6lar3qRJv1FHiqqIBLUq 1304084687
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 3/4] eCryptfs: override prepared credentials
Date: Fri, 29 Apr 2011 15:41:51 +0200
Message-Id: <1304084515-22132-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
References: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----2D811DDDECCF577102CE118E6ED6ECC7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------2D811DDDECCF577102CE118E6ED6ECC7

The new mount parameter 'ecryptfs_security_ctx' allows to override the
security label of the filesystem's credentials. This feature can be used to
identify or restrict actions performed by a specific eCryptfs filesystem.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/main.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d53f834..075634b 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -254,7 +254,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
        ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
-       ecryptfs_opt_err };
+       ecryptfs_opt_security_ctx, ecryptfs_opt_err };
 
 static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -270,6 +270,7 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
 	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
 	{ecryptfs_opt_mount_auth_tok_only, "ecryptfs_mount_auth_tok_only"},
+	{ecryptfs_opt_security_ctx, "ecryptfs_security_ctx=%s"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -365,6 +366,7 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	char *security_ctx = NULL;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -474,6 +476,9 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
 			mount_crypt_stat->flags |=
 				ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY;
 			break;
+		case ecryptfs_opt_security_ctx:
+			security_ctx = args[0].from;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
@@ -505,6 +510,15 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
 	    && !fn_cipher_key_bytes_set)
 		mount_crypt_stat->global_default_fn_cipher_key_bytes =
 			mount_crypt_stat->global_default_cipher_key_size;
+	if (security_ctx) {
+		rc = set_security_override_from_ctx(
+			mount_crypt_stat->subject_cred, security_ctx);
+		if (rc) {
+			printk(KERN_ERR "%s: set_security_override_from_ctx "
+					"failed: rc = [%d]\n", __func__, rc);
+			goto out;
+		}
+	}
 	mutex_lock(&key_tfm_list_mutex);
 	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
 				 NULL)) {
-- 
1.7.4.4


------2D811DDDECCF577102CE118E6ED6ECC7
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjkxMzQyMzJaMCMGCSqG
SIb3DQEJBDEWBBRqSgJmXM2k4nXQdduqBjPTDMvLqDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQA4vPc5Kuc2XasxDUlcteUkYbBi
Y2Ue0XuGQckoR8XqGSvgitmY7bfUlKOZh5wSHsBh6BgQbNPOcuU0o2su1RTBG+jJ
tfWMow8u21Z74nhNZcPRlbjhAEqrpyzy0eBiWPsI8E4Qcvf+tFnNFh8t2/CEXysn
8catX/mMweb2ZnypfvpeXl8nLHjkX699keVMVb6M3k7IH3InMS3c8SE3y8g4i4RQ
OSkeQIVVLT0Fa9a97H0GpwZjHD1geVJyku5BG1v30XDMfI41FEBR2rhhVeYFyJUD
JTwFcuTItFjkMbUpsDdtnmEjhhQ4S9kXpONQmasPbDpRUZ6xszNOYTnylYPq

------2D811DDDECCF577102CE118E6ED6ECC7--


