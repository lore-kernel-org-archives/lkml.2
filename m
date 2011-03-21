Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1CUPE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:04:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46552 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab1CUPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:04:34 -0400
X-Sasl-enc: aWqPasSIZK8V0/ZrR1Qcp/d7FBroZChLg+eIb5AFXMeU 1300719873
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 4/5] eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
Date: Mon, 21 Mar 2011 16:00:54 +0100
Message-Id: <1300719658-3184-5-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
References: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----C724FA2456A26163B4C29F5BDDDE35A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------C724FA2456A26163B4C29F5BDDDE35A1

The ecryptfs_find_auth_tok_for_sig() call is moved before the
mutex_lock(s->tfm_mutex) instruction in order to avoid possible deadlocks
that may occur by holding the lock on the two semaphores 'key->sem' and
's->tfm_mutex' in reverse order.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/keystore.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index ff92b3c..09b3afe 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -643,6 +643,16 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	}
 	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	(*packet_size) = 0;
+	rc = ecryptfs_find_auth_tok_for_sig(
+		&auth_tok_key,
+		&s->auth_tok, mount_crypt_stat,
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
@@ -728,16 +738,6 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
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
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
 	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
@@ -991,6 +991,15 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		       __func__, s->cipher_code);
 		goto out;
 	}
+	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
+					    &s->auth_tok, mount_crypt_stat,
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
@@ -1037,15 +1046,6 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
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
 	/* TODO: Support other key modules than passphrase for
 	 * filename encryption */
 	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
-- 
1.7.4


------C724FA2456A26163B4C29F5BDDDE35A1
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjExNTAxMjNaMCMGCSqG
SIb3DQEJBDEWBBRbPXWDneiNbVIQ+C2XvpslRSZtdTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDI4vWTUoJl89E3rc5Goi8Osdt5
M1pZ07kpmhbas8WuSbJUKZichrKP50SQJAQPv3grWA+z5v3qSODDhzyjCpco7Bz4
khDiW2P8dLM1DSyIyOTQZFj/VW/C8mVPrFyiEVsEYZIM/2kakLQD/9ZYo2X1iT5w
CW+a4lJ5/acUKHDnEX7cOQxqIas4HT2VCvZ/4FDaKO4SyHydNEGa4V2CbIg739Ok
5szPMxyakJuyXPJETPXdD2VFmkNQjmKxIjCbMTKhMSuph/M6dOKlUawFxpOcfPBQ
sRMSz23Nk9hlIC82an8CBPjVGJo6tOSF37SCpRAVf7L9Oj3BePNw0Plnh60N

------C724FA2456A26163B4C29F5BDDDE35A1--


