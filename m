Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1CQLtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:49:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50428 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab1CQLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:49:34 -0400
X-Sasl-enc: h4jqcZ/2xyiBsmc27nMwMSvoabjDK+2+WkYU5cF/P+iH 1300362573
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 4/5] eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
Date: Thu, 17 Mar 2011 12:48:53 +0100
Message-Id: <1300362538-11502-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----CA2C7867156BEA1DCB39980552E23B53"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------CA2C7867156BEA1DCB39980552E23B53

The ecryptfs_find_auth_tok_for_sig() call is moved before the
mutex_lock(s->tfm_mutex) instruction in order to avoid possible deadlocks
that may occur by holding the lock on the two semaphores 'key->sem' and
's->tfm_mutex' in reverse order.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/keystore.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index e35d745..d066217 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -538,6 +538,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 			     char *filename, size_t filename_size)
 {
 	struct ecryptfs_write_tag_70_packet_silly_stack *s;
+	struct ecryptfs_auth_tok *auth_tok;
 	struct key *auth_tok_key = NULL;
 	int rc = 0;
 
@@ -550,6 +551,16 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	(*packet_size) = 0;
+	rc = ecryptfs_find_auth_tok_for_sig(
+		&auth_tok_key,
+		&auth_tok, mount_crypt_stat,
+		mount_crypt_stat->global_default_fnek_sig);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to find auth tok for "
+		       "fnek sig [%s]; rc = [%d]\n", __func__,
+		       mount_crypt_stat->global_default_fnek_sig, rc);
+		goto out;
+	}
 	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(
 		&s->desc.tfm,
 		&s->tfm_mutex, mount_crypt_stat->global_default_fn_cipher_name);
@@ -635,16 +646,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		goto out_free_unlock;
 	}
 	dest[s->i++] = s->cipher_code;
-	rc = ecryptfs_find_auth_tok_for_sig(
-		&auth_tok_key,
-		&s->auth_tok, mount_crypt_stat,
-		mount_crypt_stat->global_default_fnek_sig);
-	if (rc) {
-		printk(KERN_ERR "%s: Error attempting to find auth tok for "
-		       "fnek sig [%s]; rc = [%d]\n", __func__,
-		       mount_crypt_stat->global_default_fnek_sig, rc);
-		goto out_free_unlock;
-	}
+	s->auth_tok = auth_tok;
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
 	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
@@ -831,6 +833,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 			     char *data, size_t max_packet_size)
 {
 	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
+	struct ecryptfs_auth_tok *auth_tok;
 	struct key *auth_tok_key = NULL;
 	int rc = 0;
 
@@ -898,6 +901,15 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		       __func__, s->cipher_code);
 		goto out;
 	}
+	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
+					    &auth_tok, mount_crypt_stat,
+					    s->fnek_sig_hex);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to find auth tok for "
+		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
+		       rc);
+		goto out;
+	}
 	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&s->desc.tfm,
 							&s->tfm_mutex,
 							s->cipher_string);
@@ -944,15 +956,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	 * >= ECRYPTFS_MAX_IV_BYTES. */
 	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
 	s->desc.info = s->iv;
-	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
-					    &s->auth_tok, mount_crypt_stat,
-					    s->fnek_sig_hex);
-	if (rc) {
-		printk(KERN_ERR "%s: Error attempting to find auth tok for "
-		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
-		       rc);
-		goto out_free_unlock;
-	}
+	s->auth_tok = auth_tok;
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
 	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
-- 
1.7.4


------CA2C7867156BEA1DCB39980552E23B53
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMTcxMTQ5MzBaMCMGCSqG
SIb3DQEJBDEWBBQzwvaiNKDaK2/C3kKkiilLJZZ/iDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQC1B3Dl0cy7lEs8AW9kjDrTzIWC
TFMOBy0weruA3pT2zhdjDikKOr7I3cLl/Zjs36oKf0H8e4rySIzf8tyWgZf+LolD
5rS9jPSW5sboA6Onnju3k7CrFKoNWrotgugRraOMqf6LCfPOVDkJn90wOYHzkvff
NZF0ur+XAtEpj5p+bCcASYeY6o1Z8EoqJn5YPpnHDV8aonsFRHPLh7g+dCFD7fVs
mXnSzVdUicEye9Qq7b8XtGvz+6nw9LX4LzWc36Y+CAJPZ5ZDVuOse+PbhVew2htU
rGgTHFrX/4KKIZDs/Lo6qCOfMKuOC8oCB/L+V7JwEkysvXeuzg3YavHpv1J5

------CA2C7867156BEA1DCB39980552E23B53--


