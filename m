Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1A1KmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:42:23 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42954 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371Ab1A1KmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:42:20 -0500
X-Sasl-enc: EodqBwGONl2uVr5EBgqaUg3ZgPr14/RPZo6/hoFZoBM8 1296211339
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 2/2] eCryptfs: lock requested keys for writing
Date: Fri, 28 Jan 2011 11:42:04 +0100
Message-Id: <1296211326-2437-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296211326-2437-1-git-send-email-roberto.sassu@polito.it>
References: <1296211326-2437-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----AB9557213D23EFDE5E043A8AE373D3AA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------AB9557213D23EFDE5E043A8AE373D3AA

Keys requested by eCryptfs are exclusively locked in order to prevent
modifications by other subjects. In particular those which description is
specified at mount time are locked until the filesystem is unmounted, these
required to decrypt a single file are unlocked immediately after the open.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Reported-by: David Howells <dhowells@redhat.com>
---
 fs/ecryptfs/crypto.c   |    4 +++-
 fs/ecryptfs/keystore.c |   15 ++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index bfd8b68..6b32776 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -268,8 +268,10 @@ void ecryptfs_destroy_mount_crypt_stat(
 		list_del(&auth_tok->mount_crypt_stat_list);
 		mount_crypt_stat->num_global_auth_toks--;
 		if (auth_tok->global_auth_tok_key
-		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID))
+		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID)) {
+			up_write(&(auth_tok->global_auth_tok_key->sem));
 			key_put(auth_tok->global_auth_tok_key);
+		}
 		kmem_cache_free(ecryptfs_global_auth_tok_cache, auth_tok);
 	}
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 4feb78c..c90456a 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -765,8 +765,10 @@ out_free_unlock:
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
-	if (auth_tok_key)
+	if (auth_tok_key) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
+	}
 	kfree(s);
 	return rc;
 }
@@ -1002,8 +1004,10 @@ out:
 		(*filename_size) = 0;
 		(*filename) = NULL;
 	}
-	if (auth_tok_key)
+	if (auth_tok_key) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
+	}
 	kfree(s);
 	return rc;
 }
@@ -1566,6 +1570,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		(*auth_tok_key) = NULL;
 		goto out;
 	}
+	down_write(&((*auth_tok_key)->sem));
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
 	if (ecryptfs_verify_version((*auth_tok)->version)) {
 		printk(KERN_ERR
@@ -1587,6 +1592,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 	}
 out_release_key:
 	if (rc) {
+		up_write(&((*auth_tok_key)->sem));
 		key_put(*auth_tok_key);
 		(*auth_tok_key) = NULL;
 	}
@@ -1810,6 +1816,7 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 find_next_matching_auth_tok:
 	found_auth_tok = 0;
 	if (auth_tok_key) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
 		auth_tok_key = NULL;
 	}
@@ -1896,8 +1903,10 @@ found_matching_auth_tok:
 out_wipe_list:
 	wipe_auth_tok_list(&auth_tok_list);
 out:
-	if (auth_tok_key)
+	if (auth_tok_key) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
+	}
 	return rc;
 }
 
-- 
1.7.3.4


------AB9557213D23EFDE5E043A8AE373D3AA
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAxMjgxMDQyMTdaMCMGCSqG
SIb3DQEJBDEWBBQD+KDzoCFjTLyPV3hw7xO6Pwj6MjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAbEzo6NdUG516jYGAHQWY1NTXf
NuDbsnoNoXTni80EcOUxHkkl2+3H44FIPVXUMEiqA7QzGsuU4HEbRIj9lNBbDvDF
pgnZz9bE/QT8obb2w5Nxw+fzmRsRagZ3NdZWDXkfVZl6jowElTtZhErOMHD5aTqT
vo0JArWq4ZVqYNpYAOV6acf6UAJqXKgDyKRMfMhNfiUQ3JW/6NVknHYo/6aYStid
IQ390zZqdb1LLhRD8QOJG1EcQlzUSTcEvyqAdZDoqo4H8y+og7ebUoopvjrf/Wf2
Z8LycWImTW19OanTNeZqiaivPh0UvGMBuxBN2dqXoBVu5NBOmAcl+lMWrksw

------AB9557213D23EFDE5E043A8AE373D3AA--


