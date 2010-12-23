Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0LWRgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:36:33 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39735 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551Ab0LWRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:36:30 -0500
X-Sasl-enc: 8/oRafkgNPX4lr3tTunHX48ZmPeSNiEWLUgBD28KMJYL 1293125790
To: linux-security-module@vger.kernel.org
Subject: [RFC][PATCH 6/6] ecryptfs: added support for the encrypted key type
From: Roberto Sassu <roberto.sassu@polito.it>
Date: Thu, 23 Dec 2010 18:36:27 +0100
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6279426.GHUzhdsX6Q";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012231836.28220.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6279426.GHUzhdsX6Q
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The function ecryptfs_keyring_auth_tok_for_sig() has been modified in order
to search keys of both 'user' and 'encrypted' types.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 fs/ecryptfs/ecryptfs_kernel.h |   11 +++++++++--
 fs/ecryptfs/keystore.c        |   15 +++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index a27cad4..068eade 100644
=2D-- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -29,6 +29,7 @@
 #define ECRYPTFS_KERNEL_H
=20
 #include <keys/user-type.h>
+#include <keys/encrypted-type.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 #include <linux/namei.h>
@@ -81,8 +82,14 @@ struct ecryptfs_page_crypt_context {
 static inline struct ecryptfs_auth_tok *
 ecryptfs_get_key_payload_data(struct key *key)
 {
=2D	return (struct ecryptfs_auth_tok *)
=2D		(((struct user_key_payload*)key->payload.data)->data);
+#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
+	if (key->type =3D=3D &key_type_encrypted)
+		return (struct ecryptfs_auth_tok *)
+			(&((struct encrypted_key_payload *)key->payload.data)->payload_data);
+	else
+#endif
+		return (struct ecryptfs_auth_tok *)
+			(((struct user_key_payload *)key->payload.data)->data);
 }
=20
 #define ECRYPTFS_SUPER_MAGIC 0xf15f
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 73811cf..8d72635 100644
=2D-- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1542,10 +1542,17 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **=
auth_tok_key,
=20
 	(*auth_tok_key) =3D request_key(&key_type_user, sig, NULL);
 	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
=2D		printk(KERN_ERR "Could not find key with description: [%s]\n",
=2D		       sig);
=2D		rc =3D process_request_key_err(PTR_ERR(*auth_tok_key));
=2D		goto out;
+#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
+		(*auth_tok_key) =3D request_key(&key_type_encrypted, sig, NULL);
+		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
+#endif
+			printk(KERN_ERR "Could not find key with description: [%s]\n",
+			      sig);
+			rc =3D process_request_key_err(PTR_ERR(*auth_tok_key));
+			goto out;
+#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
+		}
+#endif
 	}
 	(*auth_tok) =3D ecryptfs_get_key_payload_data(*auth_tok_key);
 	if (ecryptfs_verify_version((*auth_tok)->version)) {
=2D-=20
1.7.2.3


--nextPart6279426.GHUzhdsX6Q
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
IwQYMBaAFNB15T/ryrprllF8IKWYvfNn07RKMIGRBgNVHSAEgYkwgYYwPgYKKwYBBAGpBwEBAjAw
MC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL2Nwcy8xLjIvMEQGCisGAQQB
qQcCAQIwNjA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5pdGFseS5ldXJvcGtpLm9yZy9jYS9jcHMv
MS4yLzB+BggrBgEFBQcBAQRyMHAwKQYIKwYBBQUHMAGGHWh0dHA6Ly9vY3NwLml0YWx5LmV1cm9w
a2kub3JnMEMGCCsGAQUFBzAChjdodHRwOi8vd3d3Lml0YWx5LmV1cm9wa2kub3JnL2NhL2NlcnRz
L2V1cm9wa2lfaXRhbHkuY2VyMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly93d3cuaXRhbHkuZXVy
b3BraS5vcmcvY2EvY3JsL2l0YWx5X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBAFNUlYhQGVuP
EVBOSNEuC80+3TebY0iGAK35IggW4LiuEHXRWoeKwBbryFfEcR8VnTovF4wufegac+uJZB2k+QLs
wC3zuJLIgbo593W83ShSG5aCJioMoQ5X9Zfd+j1BfIV/zARyhorEvgC7doGfBVxG3qAmQEYbonot
hz4UJWld3Gd3zmwpqpNMLG2JO3BJWOrAun9SWPVRLOE/92Pq/jTMB6Lkse0KNJTBbNHPUzydOzPU
tPA7JvMDnzb6L98hVVqKoxmJw3C2sV/NOl/tuTfS6dnZypZstRaOV0JSWgP4PAqcPte0N40h8q4D
/Rdg5P7EcUklgZqL57cyUCCQro8wggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQsw
CQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQDEy1Qb2xp
dGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAxMjIwMTExOTU0
WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7Y
tRnhhQJANfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOcTIkc
C1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3QXZy0w/hxGL9Ht9ve
lqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+da39nJqmo6AZ/y3Zg+r91BgNcfsH
VqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakDyQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16F
YEq7AgMBAAGjggIeMIICGjAOBgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsG
AQUFBwMDBggrBgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSMEGDAWgBTNm1tb
nup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQBqQcBAQIwMDAuBggrBgEFBQcC
ARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9jcHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYI
KwYBBQUHAgEWKGh0dHA6Ly93d3cuaXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYB
BAGVYgECAjAqMCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsG
AQUFBwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsGAQUFBzAC
hidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIwNwYDVR0fBDAwLjAsoCqg
KIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRvX2NybC5jcmwwDQYJKoZIhvcNAQEFBQAD
ggEBADMe0aHcBJXV6pMJPVVSt1Vazd8YLuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WE
A1PWb66xC4QXaJnlGZTXS3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM42
8YhZK8ZjoN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4JsOd
atFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBKYlqPpFTtU9czuoEP
12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggIcMIICGAIBATBrMGUxCzAJBgNVBAYT
AklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNv
IGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCBhzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDEyMjMxNzM2MjhaMCMGCSqG
SIb3DQEJBDEWBBS+nuRMG3kcSRGmEn+KvVnwQtQMMjAoBgkqhkiG9w0BCQ8xGzAZMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQA0Ni/a2MsGOAqB0/oiwv2dZl6yqrOz
9pwOzAejBcbsuEgehbKrsrRoS7YIqHT3KpG7fVYvFgaNqf0+7U7QNQ7rj8nJOhDINJIJUYuEMBt/
BitgMGGH32T8x41tqOyPI0IyoZDHSufZ069UcTlprid8iqeW3mr+SxdpPaQ6iF7TItJEFRLeZgT3
n1Q9Ts2j7H0BIaIwoxYl27Es/1oeXqjpjX+rMeaUmF6jo/vkleqeWRlaVvSMvpojU5x/Kpgf0GzI
QHMeODorFv6EjgJH13m8A3xb7oDmjuH7B+4zEUyoCR+iSohld/u4EvpemnCDMpVACNJrj/syLRLB
E8af5zlcAAAAAAAA

--nextPart6279426.GHUzhdsX6Q--
