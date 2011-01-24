Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1AXQpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:45:50 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47942 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531Ab1AXQpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:45:47 -0500
X-Sasl-enc: M1lVwJ08r9fxDkIuSr3//Yaq8+mPU2w+Hn6ChxxbOcdc 1295887545
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH v3 6/6] eCryptfs: added support for the encrypted key type
Date: Mon, 24 Jan 2011 17:44:54 +0100
Message-Id: <1295887497-20198-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----887019E560014346B813CE0172AA2F9B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------887019E560014346B813CE0172AA2F9B

The function ecryptfs_keyring_auth_tok_for_sig() has been modified in order
to search keys of both 'user' and 'encrypted' types.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Acked-by: Gianluca Ramunno <ramunno@polito.it>
---
 fs/ecryptfs/ecryptfs_kernel.h |   41 +++++++++++++++++++++++++++++++++++++++--
 fs/ecryptfs/keystore.c        |   11 +++++++----
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 2e2242f..2b50397 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -29,6 +29,7 @@
 #define ECRYPTFS_KERNEL_H
 
 #include <keys/user-type.h>
+#include <keys/encrypted-type.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 #include <linux/namei.h>
@@ -78,11 +79,47 @@ struct ecryptfs_page_crypt_context {
 	} param;
 };
 
+#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
+static inline struct ecryptfs_auth_tok *
+ecryptfs_get_encrypted_key_payload_data(struct key *key)
+{
+	if (key->type == &key_type_encrypted)
+		return (struct ecryptfs_auth_tok *)
+			(&((struct encrypted_key_payload *)key->payload.data)->payload_data);
+	else
+		return NULL;
+}
+
+static inline struct key *ecryptfs_get_encrypted_key(char *sig)
+{
+	return request_key(&key_type_encrypted, sig, NULL);
+}
+
+#else
+static inline struct ecryptfs_auth_tok *
+ecryptfs_get_encrypted_key_payload_data(struct key *key)
+{
+	return NULL;
+}
+
+static inline struct key *ecryptfs_get_encrypted_key(char *sig)
+{
+	return ERR_PTR(-ENOKEY);
+}
+
+#endif /* CONFIG_ENCRYPTED_KEYS */
+
 static inline struct ecryptfs_auth_tok *
 ecryptfs_get_key_payload_data(struct key *key)
 {
-	return (struct ecryptfs_auth_tok *)
-		(((struct user_key_payload*)key->payload.data)->data);
+	struct ecryptfs_auth_tok *auth_tok;
+
+	auth_tok = ecryptfs_get_encrypted_key_payload_data(key);
+	if (!auth_tok)
+		return (struct ecryptfs_auth_tok *)
+			(((struct user_key_payload *)key->payload.data)->data);
+	else
+		return auth_tok;
 }
 
 #define ECRYPTFS_MAX_KEYSET_SIZE 1024
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index c1436cf..17194b8 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1560,10 +1560,13 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 
 	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
 	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
-		printk(KERN_ERR "Could not find key with description: [%s]\n",
-		       sig);
-		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
-		goto out;
+		(*auth_tok_key) = ecryptfs_get_encrypted_key(sig);
+		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
+			printk(KERN_ERR "Could not find key with description: [%s]\n",
+			      sig);
+			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+			goto out;
+		}
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
 	if (ecryptfs_verify_version((*auth_tok)->version)) {
-- 
1.7.3.4


------887019E560014346B813CE0172AA2F9B
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAxMjQxNjQ1NDNaMCMGCSqG
SIb3DQEJBDEWBBRIr/iquEhhGzs984mMrcN4QFSaGTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAqBwsvUeYl+ZSttqzr3zvDEPG+
rgaGsGiameiZOutkkikBmXTFgnypCMzykvFrfO8r/VLajQHtHW/wW4tTOOtaUOqv
lZ78mL+F72re2grBtgOIjwM0YsLNdux4C7c3ACr23sPdjdtZoAcr3wY9RJjSz1Qv
espkbmRdvqX5X7CdlkylO7x7peacUa8xVVNsUvRy3TeOff/QaLEA6pATJCP3OlNp
8USbn2nK9OgqGpy6jGcgJUvRlKUI+v1kvhWho6b9la05ZoWVVb4qiDd8myNkGwbh
/y5FHkhtQjhZRBG+S2Q1VMX29BCDvFKbSsj9ZridXKNcsuB5oEu6uOPvLIrA

------887019E560014346B813CE0172AA2F9B--


