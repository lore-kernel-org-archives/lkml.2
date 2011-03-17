Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1CQLty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:49:54 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38945 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218Ab1CQLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:49:39 -0400
X-Sasl-enc: UDcI+6B/tUsLhVX9vWOo9YhGLergi0X9wuBCzWrRe423 1300362578
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 5/5] eCryptfs: write lock requested keys
Date: Thu, 17 Mar 2011 12:48:54 +0100
Message-Id: <1300362538-11502-6-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----471AFFEEC2D498EF26DA2D8C4A4E8024"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------471AFFEEC2D498EF26DA2D8C4A4E8024

A requested key is write locked in order to prevent modifications on the
authentication token while it is being used.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/keystore.c |   23 ++++++++++++++++++-----
 fs/ecryptfs/main.c     |    4 +++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index d066217..3eac4ba 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -428,6 +428,7 @@ ecryptfs_find_global_auth_tok_for_sig(
 			if (rc)
 				goto out;
 
+			down_write(&(walker->global_auth_tok_key->sem));
 			rc = ecryptfs_verify_auth_tok_from_key(
 					walker->global_auth_tok_key, auth_tok);
 			if (rc) {
@@ -435,6 +436,7 @@ ecryptfs_find_global_auth_tok_for_sig(
 				      "Invalidating auth tok with sig = [%s]\n",
 				      sig);
 				walker->flags |= ECRYPTFS_AUTH_TOK_INVALID;
+				up_write(&(walker->global_auth_tok_key->sem));
 				key_put(walker->global_auth_tok_key);
 				walker->global_auth_tok_key = NULL;
 				mount_crypt_stat->num_global_auth_toks--;
@@ -786,8 +788,10 @@ out_free_unlock:
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
@@ -1025,8 +1029,10 @@ out:
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
@@ -1589,9 +1595,10 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 		(*auth_tok_key) = NULL;
 		goto out;
 	}
-
+	down_write(&(*auth_tok_key)->sem);
 	rc = ecryptfs_verify_auth_tok_from_key(*auth_tok_key, auth_tok);
 	if (rc) {
+		up_write(&(*auth_tok_key)->sem);
 		key_put(*auth_tok_key);
 		(*auth_tok_key) = NULL;
 		goto out;
@@ -1844,6 +1851,7 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 find_next_matching_auth_tok:
 	found_auth_tok = 0;
 	if (auth_tok_key) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
 		auth_tok_key = NULL;
 	}
@@ -1930,8 +1938,10 @@ found_matching_auth_tok:
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
 
@@ -2428,6 +2438,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 			rc = -EINVAL;
 			goto out_release_key;
 		}
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
 	}
 	if (!auth_tok_count) {
@@ -2444,8 +2455,10 @@ ecryptfs_generate_key_packet_set(char *dest_base,
 		rc = -EIO;
 	}
 out_release_key:
-	if (rc)
+	if (rc) {
+		up_write(&(auth_tok_key->sem));
 		key_put(auth_tok_key);
+	}
 out_free:
 	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
 out:
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index f079473..ada50a3 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -256,8 +256,10 @@ static int ecryptfs_init_global_auth_toks(
 			       "option: [%s]\n", global_auth_tok->sig);
 			global_auth_tok->flags |= ECRYPTFS_AUTH_TOK_INVALID;
 			goto out;
-		} else
+		} else {
 			global_auth_tok->flags &= ~ECRYPTFS_AUTH_TOK_INVALID;
+			up_write(&(global_auth_tok->global_auth_tok_key)->sem);
+		}
 	}
 out:
 	return rc;
-- 
1.7.4


------471AFFEEC2D498EF26DA2D8C4A4E8024
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMTcxMTQ5MzZaMCMGCSqG
SIb3DQEJBDEWBBSeaXKGXIRl2uZpmHrwGHbxvDmO0TB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBK+pBbxPo2/jR3wKVjLUk6yFLQ
8wL6dB4CLHCEBSbGg1sqO3fBgXwFwkGfoIIcWx9xMU0y8wVPwkdEf7HkIjuQtx4d
yDl6F5AaVMw6C/7AafiUqSWV0d5H80ujhDykSWV8OP0Z+3D8un8UD5eRbGRINj/x
igb9Gn6BtssaDuAYEB7LFEH6yGuMqnPbr2Tp6xA2+DAUfGt4Sd6Q9U+2clAqpOeo
ABqxaBf8MUEFGPUSpanHqBnGZsLsGMOhpxC2OKyUuoa2HFspEgKBVEfW8V9543X0
z1K2F9mR82cjh2b78kwed8jggfHIwApT58Eo0Kvl9fWCuZamTRtB8Fm9AtDr

------471AFFEEC2D498EF26DA2D8C4A4E8024--


