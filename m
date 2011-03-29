Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1C2Kwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:52:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46331 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab1C2Kwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:52:30 -0400
X-Sasl-enc: VOqK8wP2EUJMP7ilh3EgcJILhNndL9biiRLaUMWjXavJ 1301395945
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v4 6/6] eCryptfs: added support for the encrypted key type
Date: Tue, 29 Mar 2011 12:47:35 +0200
Message-Id: <1301395658-28494-7-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301395658-28494-1-git-send-email-roberto.sassu@polito.it>
References: <1301395658-28494-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----B10D406C1950CBBA872A99A6B658329B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------B10D406C1950CBBA872A99A6B658329B

The function ecryptfs_keyring_auth_tok_for_sig() has been modified in order
to search keys of both 'user' and 'encrypted' types.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Acked-by: Gianluca Ramunno <ramunno@polito.it>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |   41 +++++++++++++++++++++++++++++++++++++++--
 fs/ecryptfs/keystore.c        |   13 ++++++++-----
 2 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 02e39c8..f7c32d7 100644
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
index 03e609c..1966d1b 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1639,11 +1639,14 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 
 	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
 	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
-		printk(KERN_ERR "Could not find key with description: [%s]\n",
-		       sig);
-		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
-		(*auth_tok_key) = NULL;
-		goto out;
+		(*auth_tok_key) = ecryptfs_get_encrypted_key(sig);
+		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
+			printk(KERN_ERR "Could not find key with description: [%s]\n",
+			      sig);
+			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
+			(*auth_tok_key) = NULL;
+			goto out;
+		}
 	}
 	down_write(&(*auth_tok_key)->sem);
 	rc = ecryptfs_verify_auth_tok_from_key(*auth_tok_key, auth_tok);
-- 
1.7.4


------B10D406C1950CBBA872A99A6B658329B
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjkxMDQ4MThaMCMGCSqG
SIb3DQEJBDEWBBS73snWUwCJecQNrOWJ8BiomczuEDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCYoUSRUeZ626mn6QSYmUyaiAXd
OBriNKVTLCA6VqCR5oicFWJ+6zuXHD/5Z80pcY3ihCdmEKhAUvoyNXdxkZCM4Rp8
QF0XaVlIp5h/EDtc+Gl/LPhKqqCuO6b7sQYzKQ8wULwYoqzD4GxZRoctmyG9zFkI
hhSfgu1lWNgS1Xs/0kZG4LON8s2UUAXk3WGFRNz79baBCRkhsFXojw9JaptR2Bxg
2lyXhviL7UBxgbk7I6xxr+uOiwj8jHniy38Kn1E1D41E0E/olqjQnoedXXwAPPIk
ed4b3jFnHzGnLkMHdJ2cro1tNSgPl7Km+yB5zut35mmQtSb5A50XQMuvQCwt

------B10D406C1950CBBA872A99A6B658329B--


