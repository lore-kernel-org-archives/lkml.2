Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1KPKKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:10:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63114 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1KPKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:10:52 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 2/2] ima: free memory of unused template entries
Date: Wed, 16 Nov 2011 11:10:26 +0100
Message-Id: <1321438229-18925-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----734AC66C24557D7B299A49D71E104C29"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------734AC66C24557D7B299A49D71E104C29

This patch solves the following issues:
- free the memory allocated for template entries that are already present
  in the measurements list;
- since template entries are added to the measurements list after the
  PCR extend operation (with the previous patch), they can be now safely
  removed if the latter fails.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_api.c   |    4 ++--
 security/integrity/ima/ima_queue.c |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 0d50df0..88a2788 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -178,8 +178,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
 
 	result = ima_store_template(entry, violation, inode);
-	if (!result)
+	if (!result || result == -EEXIST)
 		iint->flags |= IMA_MEASURED;
-	else
+	if (result < 0)
 		kfree(entry);
 }
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index ddc7e18..7ae1e9a 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -105,7 +105,8 @@ static int ima_pcr_extend(const u8 *hash)
 
 	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
 	if (result != 0)
-		pr_err("IMA: Error Communicating to TPM chip\n");
+		pr_err("IMA: Error Communicating to TPM chip, result: %d\n",
+		       result);
 	return result;
 }
 
@@ -126,6 +127,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 		memcpy(digest, entry->digest, sizeof digest);
 		if (ima_lookup_digest_entry(digest)) {
 			audit_cause = "hash_exists";
+			result = -EEXIST;
 			goto out;
 		}
 	}
@@ -145,6 +147,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	if (result != 0) {
 		audit_cause = "TPM error";
 		audit_info = 0;
+		result = -ECOMM;
 		kfree(qe);
 		goto out;
 	}
-- 
1.7.6.4


------734AC66C24557D7B299A49D71E104C29
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTExMTYxMDEwNDhaMCMGCSqG
SIb3DQEJBDEWBBT+TOtnvRcA66GojXak0GcAUYVVmTB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAwMusKTG+LktYrZxMdBm9vjavp
t+szl6PSUaWxqmIHkKrZAn7l27nsWcdIgi038rrcxNQx1EP0hZc8n88JTgQ2HTYY
E1KF/5sleP8kMu8IGCUce1Znxe46JrjGN0EFPzoI7kMhadMYIBhftfeZFtcszH5Y
j++F8pQevZLorDe+6Pym1kHYrXMHaWxp7fADXIhYtT7wMPz5qgtnrTqpxoGssKEw
MEydlp3R0quBxeorXdXj3MQPxn475O3CPYOAPnSNQcaBZ0uwu7p/xo4tTRWV3XLi
K9z/eNWuIjZiwqJAK1LywxXZ83PkYbPtE8NBlnM8P0K7pBKGKXVbF9mqM3T+

------734AC66C24557D7B299A49D71E104C29--


