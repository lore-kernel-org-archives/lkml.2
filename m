Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1CUPEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:04:37 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47335 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab1CUPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:04:30 -0400
X-Sasl-enc: fMjqlAAKVJw5+yPQQRJ8Uu1BYkmjC/wM71D+aHozptRH 1300719869
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 3/5] eCryptfs: verify authentication tokens before their use
Date: Mon, 21 Mar 2011 16:00:53 +0100
Message-Id: <1300719658-3184-4-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
References: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----F9D05A459EC4BE5E18D291C47A7ED88C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------F9D05A459EC4BE5E18D291C47A7ED88C

Authentication tokens content may change if another requestor calls the
update() method of the corresponding key. The new function
ecryptfs_verify_auth_tok_from_key() retrieves the authentication token from
the provided key and verifies if it is still valid before being used to
encrypt or decrypt an eCryptfs file.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/ecryptfs_kernel.h |    1 -
 fs/ecryptfs/keystore.c        |  220 ++++++++++++++++++++++++++---------------
 fs/ecryptfs/main.c            |    4 +-
 3 files changed, 144 insertions(+), 81 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index f39956a..43ab593 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -333,7 +333,6 @@ struct ecryptfs_global_auth_tok {
 	u32 flags;
 	struct list_head mount_crypt_stat_list;
 	struct key *global_auth_tok_key;
-	struct ecryptfs_auth_tok *global_auth_tok;
 	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index bd139df..ff92b3c 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -65,6 +65,26 @@ static int process_request_key_err(long err_code)
 	return rc;
 }
 
+static int process_find_global_auth_tok_for_sig_err(int err_code)
+{
+	int rc = err_code;
+
+	switch (err_code) {
+	case -ENOENT:
+		ecryptfs_printk(KERN_WARNING,
+				"Missing auth tok\n");
+		break;
+	case -EINVAL:
+		ecryptfs_printk(KERN_WARNING,
+				"Invalid auth tok\n");
+		break;
+	default:
+		rc = process_request_key_err(err_code);
+		break;
+	}
+	return rc;
+}
+
 /**
  * ecryptfs_parse_packet_length
  * @data: Pointer to memory containing length at offset
@@ -403,27 +423,122 @@ out:
 	return rc;
 }
 
+/**
+ * ecryptfs_verify_version
+ * @version: The version number to confirm
+ *
+ * Returns zero on good version; non-zero otherwise
+ */
+static int ecryptfs_verify_version(u16 version)
+{
+	int rc = 0;
+	unsigned char major;
+	unsigned char minor;
+
+	major = ((version >> 8) & 0xFF);
+	minor = (version & 0xFF);
+	if (major != ECRYPTFS_VERSION_MAJOR) {
+		ecryptfs_printk(KERN_ERR, "Major version number mismatch. "
+				"Expected [%d]; got [%d]\n",
+				ECRYPTFS_VERSION_MAJOR, major);
+		rc = -EINVAL;
+		goto out;
+	}
+	if (minor != ECRYPTFS_VERSION_MINOR) {
+		ecryptfs_printk(KERN_ERR, "Minor version number mismatch. "
+				"Expected [%d]; got [%d]\n",
+				ECRYPTFS_VERSION_MINOR, minor);
+		rc = -EINVAL;
+		goto out;
+	}
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_verify_auth_tok_from_key
+ * @auth_tok_key: key containing the authentication token
+ * @auth_tok: authentication token
+ *
+ * Returns zero on valid auth tok; -EINVAL otherwise
+ */
+static int
+ecryptfs_verify_auth_tok_from_key(struct key *auth_tok_key,
+				  struct ecryptfs_auth_tok **auth_tok)
+{
+	int rc = 0;
+
+	(*auth_tok) = ecryptfs_get_key_payload_data(auth_tok_key);
+	if (ecryptfs_verify_version((*auth_tok)->version)) {
+		printk(KERN_ERR
+		       "Data structure version mismatch. "
+		       "Userspace tools must match eCryptfs "
+		       "kernel module with major version [%d] "
+		       "and minor version [%d]\n",
+		       ECRYPTFS_VERSION_MAJOR,
+		       ECRYPTFS_VERSION_MINOR);
+		rc = -EINVAL;
+		goto out;
+	}
+	if ((*auth_tok)->token_type != ECRYPTFS_PASSWORD
+	    && (*auth_tok)->token_type != ECRYPTFS_PRIVATE_KEY) {
+		printk(KERN_ERR "Invalid auth_tok structure "
+		       "returned from key query\n");
+		rc = -EINVAL;
+		goto out;
+	}
+out:
+	return rc;
+}
+
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
-		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {
-			rc = key_validate(walker->global_auth_tok_key);
-			if (!rc)
-				(*global_auth_tok) = walker;
+		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX))
+			continue;
+
+		if (walker->flags & ECRYPTFS_AUTH_TOK_INVALID) {
+			rc = -EINVAL;
 			goto out;
 		}
+
+		rc = key_validate(walker->global_auth_tok_key);
+		if (rc) {
+			if (rc == -EKEYEXPIRED)
+				goto out;
+			else
+				goto out_invalid_auth_tok;
+		}
+
+		rc = ecryptfs_verify_auth_tok_from_key(
+				walker->global_auth_tok_key, auth_tok);
+		if (rc)
+			goto out_invalid_auth_tok;
+
+		(*auth_tok_key) = walker->global_auth_tok_key;
+		key_get(*auth_tok_key);
+		goto out;
 	}
-	rc = -EINVAL;
+	rc = -ENOENT;
+	goto out;
+
+out_invalid_auth_tok:
+	printk(KERN_WARNING "Invalidating auth tok with sig = [%s]\n", sig);
+	walker->flags |= ECRYPTFS_AUTH_TOK_INVALID;
+	key_put(walker->global_auth_tok_key);
+	walker->global_auth_tok_key = NULL;
 out:
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	return rc;
@@ -451,14 +566,11 @@ ecryptfs_find_auth_tok_for_sig(
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
@@ -470,8 +582,8 @@ ecryptfs_find_auth_tok_for_sig(
 
 		rc = ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
 						       sig);
-	} else
-		(*auth_tok) = global_auth_tok->global_auth_tok;
+	}
+
 	return rc;
 }
 
@@ -1520,38 +1632,6 @@ out:
 	return rc;
 }
 
-/**
- * ecryptfs_verify_version
- * @version: The version number to confirm
- *
- * Returns zero on good version; non-zero otherwise
- */
-static int ecryptfs_verify_version(u16 version)
-{
-	int rc = 0;
-	unsigned char major;
-	unsigned char minor;
-
-	major = ((version >> 8) & 0xFF);
-	minor = (version & 0xFF);
-	if (major != ECRYPTFS_VERSION_MAJOR) {
-		ecryptfs_printk(KERN_ERR, "Major version number mismatch. "
-				"Expected [%d]; got [%d]\n",
-				ECRYPTFS_VERSION_MAJOR, major);
-		rc = -EINVAL;
-		goto out;
-	}
-	if (minor != ECRYPTFS_VERSION_MINOR) {
-		ecryptfs_printk(KERN_ERR, "Minor version number mismatch. "
-				"Expected [%d]; got [%d]\n",
-				ECRYPTFS_VERSION_MINOR, minor);
-		rc = -EINVAL;
-		goto out;
-	}
-out:
-	return rc;
-}
-
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig)
@@ -1566,29 +1646,12 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		(*auth_tok_key) = NULL;
 		goto out;
 	}
-	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
-	if (ecryptfs_verify_version((*auth_tok)->version)) {
-		printk(KERN_ERR
-		       "Data structure version mismatch. "
-		       "Userspace tools must match eCryptfs "
-		       "kernel module with major version [%d] "
-		       "and minor version [%d]\n",
-		       ECRYPTFS_VERSION_MAJOR,
-		       ECRYPTFS_VERSION_MINOR);
-		rc = -EINVAL;
-		goto out_release_key;
-	}
-	if ((*auth_tok)->token_type != ECRYPTFS_PASSWORD
-	    && (*auth_tok)->token_type != ECRYPTFS_PRIVATE_KEY) {
-		printk(KERN_ERR "Invalid auth_tok structure "
-		       "returned from key query\n");
-		rc = -EINVAL;
-		goto out_release_key;
-	}
-out_release_key:
+
+	rc = ecryptfs_verify_auth_tok_from_key(*auth_tok_key, auth_tok);
 	if (rc) {
 		key_put(*auth_tok_key);
 		(*auth_tok_key) = NULL;
+		goto out;
 	}
 out:
 	return rc;
@@ -2325,7 +2388,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 				 size_t max)
 {
 	struct ecryptfs_auth_tok *auth_tok;
-	struct ecryptfs_global_auth_tok *global_auth_tok;
+	struct key *auth_tok_key = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
@@ -2344,21 +2407,17 @@ ecryptfs_generate_key_packet_set(char *dest_base,
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
-			       "Skipping invalid auth tok with sig = [%s]\n",
-			       global_auth_tok->sig);
-			continue;
+			       "Unable to retrieve auth tok with sig = [%s]\n",
+			       key_sig->keysig);
+			rc = process_find_global_auth_tok_for_sig_err(rc);
+			goto out_free;
 		}
-		auth_tok = global_auth_tok->global_auth_tok;
 		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
 			rc = write_tag_3_packet((dest_base + (*len)),
 						&max, auth_tok,
@@ -2396,6 +2455,8 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			rc = -EINVAL;
 			goto out_free;
 		}
+		key_put(auth_tok_key);
+		auth_tok_key = NULL;
 	}
 	if (likely(max > 0)) {
 		dest_base[(*len)] = 0x00;
@@ -2408,6 +2469,9 @@ out_free:
 out:
 	if (rc)
 		(*len) = 0;
+	if (auth_tok_key)
+		key_put(auth_tok_key);
+
 	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	return rc;
 }
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


------F9D05A459EC4BE5E18D291C47A7ED88C
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjExNTAxMTlaMCMGCSqG
SIb3DQEJBDEWBBT+lwp/9SHs4wWp4r9VbGDsuKEHhDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQB6w09QL/RcvR1nIP/45sAWVq4w
E1MyxiBm/TkxZQWq7qcxbsoqgP8kx9KITHUqaAFKkOLs/R6VIWZt8Z9FjeN84XOP
L3IAfP13P+GI9qr21VwX6QMNJ8QgWqpxg5GoKFPjMnDbU6Tzmjay6DTM4prnaxMc
21OGFtU00K/8zOoV80Do6EFTgW38SyXpyVcXaGl6FVSXmp1gog3wv9PIEjHywAGy
QySzFoGWiV7u1D8UmmGGHMvwYD+NG2fg7qQ7mUYsTc18DUwh33sUoIdreDdM3KQk
6iQ4eueQ15Rawx2e438eIqeIInIiL19fR1dWVd0guU5rkFhZqzTfue0/98F5

------F9D05A459EC4BE5E18D291C47A7ED88C--


