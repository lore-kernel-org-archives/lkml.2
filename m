Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1CQLtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:49:32 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36037 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab1CQLt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:49:28 -0400
X-Sasl-enc: mOHXm/AqL2wyx0p3xT2wrU1GFp/JUsqoeKyODThKOT7y 1300362567
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 3/5] eCryptfs: verify authentication tokens before their use
Date: Thu, 17 Mar 2011 12:48:52 +0100
Message-Id: <1300362538-11502-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----A3466D8A8A8FAC1B85ED62933AAFE650"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------A3466D8A8A8FAC1B85ED62933AAFE650

Authentication tokens content may change if another requestor calls the
update() method of the corresponding key. The new function
ecryptfs_verify_auth_tok_from_key() retrieves the authentication token from
the provided key and verifies if it is still valid before being used to
encrypt or decrypt an eCryptfs file.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/ecryptfs_kernel.h |    3 +-
 fs/ecryptfs/keystore.c        |  107 ++++++++++++++++++++++++++++-------------
 fs/ecryptfs/main.c            |    4 +-
 3 files changed, 77 insertions(+), 37 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 8282031..85728e9 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -333,7 +333,6 @@ struct ecryptfs_global_auth_tok {
 	u32 flags;
 	struct list_head mount_crypt_stat_list;
 	struct key *global_auth_tok_key;
-	struct ecryptfs_auth_tok *global_auth_tok;
 	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
@@ -726,6 +725,8 @@ int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig);
+int ecryptfs_verify_auth_tok_from_key(struct key *auth_tok_key,
+				      struct ecryptfs_auth_tok **auth_tok);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 36b68a6..e35d745 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -405,25 +405,47 @@ out:
 
 static int
 ecryptfs_find_global_auth_tok_for_sig(
-	struct ecryptfs_global_auth_tok **global_auth_tok,
+	struct key **auth_tok_key,
+	struct ecryptfs_auth_tok **auth_tok,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig)
 {
 	struct ecryptfs_global_auth_tok *walker;
 	int rc = 0;
 
-	(*global_auth_tok) = NULL;
+	(*auth_tok_key) = NULL;
+	(*auth_tok) = NULL;
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	list_for_each_entry(walker,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
 		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {
+			if (walker->flags & ECRYPTFS_AUTH_TOK_INVALID) {
+				rc = -EINVAL;
+				goto out;
+			}
+
 			rc = key_validate(walker->global_auth_tok_key);
-			if (!rc)
-				(*global_auth_tok) = walker;
+			if (rc)
+				goto out;
+
+			rc = ecryptfs_verify_auth_tok_from_key(
+					walker->global_auth_tok_key, auth_tok);
+			if (rc) {
+				printk(KERN_WARNING
+				      "Invalidating auth tok with sig = [%s]\n",
+				      sig);
+				walker->flags |= ECRYPTFS_AUTH_TOK_INVALID;
+				key_put(walker->global_auth_tok_key);
+				walker->global_auth_tok_key = NULL;
+				mount_crypt_stat->num_global_auth_toks--;
+				goto out;
+			}
+			(*auth_tok_key) = walker->global_auth_tok_key;
+			key_get(*auth_tok_key);
 			goto out;
 		}
 	}
-	rc = -EINVAL;
+	rc = -ENOENT;
 out:
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	return rc;
@@ -451,14 +473,11 @@ ecryptfs_find_auth_tok_for_sig(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 	char *sig)
 {
-	struct ecryptfs_global_auth_tok *global_auth_tok;
 	int rc = 0;
 
-	(*auth_tok_key) = NULL;
-	(*auth_tok) = NULL;
-	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
-						  mount_crypt_stat, sig)) {
-
+	rc = ecryptfs_find_global_auth_tok_for_sig(auth_tok_key, auth_tok,
+						   mount_crypt_stat, sig);
+	if (rc == -ENOENT) {
 		/* if the flag ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY is set in the
 		 * mount_crypt_stat structure, we prevent to use auth toks that
 		 * are not inserted through the ecryptfs_add_global_auth_tok
@@ -470,8 +489,8 @@ ecryptfs_find_auth_tok_for_sig(
 
 		rc = ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
 						       sig);
-	} else
-		(*auth_tok) = global_auth_tok->global_auth_tok;
+	}
+
 	return rc;
 }
 
@@ -1566,7 +1585,23 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		(*auth_tok_key) = NULL;
 		goto out;
 	}
-	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
+
+	rc = ecryptfs_verify_auth_tok_from_key(*auth_tok_key, auth_tok);
+	if (rc) {
+		key_put(*auth_tok_key);
+		(*auth_tok_key) = NULL;
+		goto out;
+	}
+out:
+	return rc;
+}
+
+int ecryptfs_verify_auth_tok_from_key(struct key *auth_tok_key,
+				      struct ecryptfs_auth_tok **auth_tok)
+{
+	int rc = 0;
+
+	(*auth_tok) = ecryptfs_get_key_payload_data(auth_tok_key);
 	if (ecryptfs_verify_version((*auth_tok)->version)) {
 		printk(KERN_ERR
 		       "Data structure version mismatch. "
@@ -1576,19 +1611,14 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		       ECRYPTFS_VERSION_MAJOR,
 		       ECRYPTFS_VERSION_MINOR);
 		rc = -EINVAL;
-		goto out_release_key;
+		goto out;
 	}
 	if ((*auth_tok)->token_type != ECRYPTFS_PASSWORD
 	    && (*auth_tok)->token_type != ECRYPTFS_PRIVATE_KEY) {
 		printk(KERN_ERR "Invalid auth_tok structure "
 		       "returned from key query\n");
 		rc = -EINVAL;
-		goto out_release_key;
-	}
-out_release_key:
-	if (rc) {
-		key_put(*auth_tok_key);
-		(*auth_tok_key) = NULL;
+		goto out;
 	}
 out:
 	return rc;
@@ -2325,13 +2355,14 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 				 size_t max)
 {
 	struct ecryptfs_auth_tok *auth_tok;
-	struct ecryptfs_global_auth_tok *global_auth_tok;
+	struct key *auth_tok_key = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	size_t written;
 	struct ecryptfs_key_record *key_rec;
 	struct ecryptfs_key_sig *key_sig;
+	int auth_tok_count = 0;
 	int rc = 0;
 
 	(*len) = 0;
@@ -2344,21 +2375,18 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 	list_for_each_entry(key_sig, &crypt_stat->keysig_list,
 			    crypt_stat_list) {
 		memset(key_rec, 0, sizeof(*key_rec));
-		rc = ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
+		rc = ecryptfs_find_global_auth_tok_for_sig(&auth_tok_key,
+							   &auth_tok,
 							   mount_crypt_stat,
 							   key_sig->keysig);
 		if (rc) {
-			printk(KERN_ERR "Error attempting to get the global "
-			       "auth_tok; rc = [%d]\n", rc);
-			goto out_free;
-		}
-		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID) {
 			printk(KERN_WARNING
 			       "Skipping invalid auth tok with sig = [%s]\n",
-			       global_auth_tok->sig);
+			       key_sig->keysig);
+			rc = 0;
 			continue;
 		}
-		auth_tok = global_auth_tok->global_auth_tok;
+		auth_tok_count++;
 		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
 			rc = write_tag_3_packet((dest_base + (*len)),
 						&max, auth_tok,
@@ -2367,7 +2395,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 3 packet\n");
-				goto out_free;
+				goto out_release_key;
 			}
 			(*len) += written;
 			/* Write auth tok signature packet */
@@ -2377,7 +2405,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			if (rc) {
 				ecryptfs_printk(KERN_ERR, "Error writing "
 						"auth tok signature packet\n");
-				goto out_free;
+				goto out_release_key;
 			}
 			(*len) += written;
 		} else if (auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
@@ -2387,15 +2415,23 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 1 packet\n");
-				goto out_free;
+				goto out_release_key;
 			}
 			(*len) += written;
 		} else {
 			ecryptfs_printk(KERN_WARNING, "Unsupported "
 					"authentication token type\n");
 			rc = -EINVAL;
-			goto out_free;
+			goto out_release_key;
 		}
+		key_put(auth_tok_key);
+	}
+	if (!auth_tok_count) {
+		printk(KERN_WARNING
+			"Unable to create a new file without a valid "
+			"authentication token\n");
+		rc = -EINVAL;
+		goto out_free;
 	}
 	if (likely(max > 0)) {
 		dest_base[(*len)] = 0x00;
@@ -2403,6 +2439,9 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 		ecryptfs_printk(KERN_ERR, "Error writing boundary byte\n");
 		rc = -EIO;
 	}
+out_release_key:
+	if (rc)
+		key_put(auth_tok_key);
 out_free:
 	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
 out:
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 758323a..f079473 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -241,14 +241,14 @@ static int ecryptfs_init_global_auth_toks(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
 	struct ecryptfs_global_auth_tok *global_auth_tok;
+	struct ecryptfs_auth_tok *auth_tok;
 	int rc = 0;
 
 	list_for_each_entry(global_auth_tok,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
 		rc = ecryptfs_keyring_auth_tok_for_sig(
-			&global_auth_tok->global_auth_tok_key,
-			&global_auth_tok->global_auth_tok,
+			&global_auth_tok->global_auth_tok_key, &auth_tok,
 			global_auth_tok->sig);
 		if (rc) {
 			printk(KERN_ERR "Could not find valid key in user "
-- 
1.7.4


------A3466D8A8A8FAC1B85ED62933AAFE650
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMTcxMTQ5MjVaMCMGCSqG
SIb3DQEJBDEWBBSlep1xL+BSmtmI59G4xwBz54L2BDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBqDmfqpgbYMcSB5nO5Tjl80p44
7UTkojYkhhOk2Mco9djadvIIoGmV4NmS8LLymQDyg4QhnuJRd/PfwuTzoCPSUNZi
Hv2skAgZu8aeIMVL10Cf9dUm9J7XztKb1W4DJpHYt54v/KiHvF/mi8zN/+xUNL+O
oIZuR6O4uKaWthWS6iYF6MHfhNlX/UedS/I43254Cy4dpLGod8YFQmAEKnBirwEU
6cFscU3VvBpbXrm0BMPM9+hGJvtnGOnZMFPQwKXpBkGDy8vrDGLU/qx1fTjoJ7Ux
lnVLAgUiRufXZQl5pjP6TUS74VOdXRj8I1gANBZDUoWNnd72Hv0kbNZs+FcU

------A3466D8A8A8FAC1B85ED62933AAFE650--


