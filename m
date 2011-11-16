Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1KPKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:10:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63114 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1KPKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:10:47 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 1/2] ima: split ima_add_digest_entry() function
Date: Wed, 16 Nov 2011 11:10:25 +0100
Message-Id: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----919F2F262CA39AF46BD61BCAC9928689"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------919F2F262CA39AF46BD61BCAC9928689

The ima_add_digest_entry() function has been split in order to avoid
adding an entry in the measurements list for which the PCR extend
operation subsequently fails. Required memory is allocated earlier in the
new function ima_prepare_template_entry() and the template entry is added
after ima_pcr_extend().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_queue.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index 8e28f04..ddc7e18 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -59,30 +59,41 @@ static struct ima_queue_entry *ima_lookup_digest_entry(u8 *digest_value)
 	return ret;
 }
 
-/* ima_add_template_entry helper function:
- * - Add template entry to measurement list and hash table.
+/* ima_prepare_template_entry helper function:
+ * - prepare template entry before adding it to the measurement list.
  *
  * (Called with ima_extend_list_mutex held.)
  */
-static int ima_add_digest_entry(struct ima_template_entry *entry)
+static struct ima_queue_entry *ima_prepare_template_entry(
+					struct ima_template_entry *entry)
 {
 	struct ima_queue_entry *qe;
-	unsigned int key;
 
 	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
 	if (qe == NULL) {
 		pr_err("IMA: OUT OF MEMORY ERROR creating queue entry.\n");
-		return -ENOMEM;
+		goto out;
 	}
 	qe->entry = entry;
+out:
+	return qe;
+}
+
+/* ima_add_digest_entry helper function:
+ * - Add template entry to measurement list and hash table.
+ *
+ * (Called with ima_extend_list_mutex held.)
+ */
+static void ima_add_digest_entry(struct ima_queue_entry *qe)
+{
+	unsigned int key;
 
 	INIT_LIST_HEAD(&qe->later);
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
 	atomic_long_inc(&ima_htable.len);
-	key = ima_hash_key(entry->digest);
+	key = ima_hash_key(qe->entry->digest);
 	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
-	return 0;
 }
 
 static int ima_pcr_extend(const u8 *hash)
@@ -104,6 +115,7 @@ static int ima_pcr_extend(const u8 *hash)
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode)
 {
+	struct ima_queue_entry *qe;
 	u8 digest[IMA_DIGEST_SIZE];
 	const char *audit_cause = "hash_added";
 	int audit_info = 1;
@@ -118,10 +130,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 		}
 	}
 
-	result = ima_add_digest_entry(entry);
-	if (result < 0) {
+	qe = ima_prepare_template_entry(entry);
+	if (qe == NULL) {
 		audit_cause = "ENOMEM";
 		audit_info = 0;
+		result = -ENOMEM;
 		goto out;
 	}
 
@@ -132,7 +145,11 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 	if (result != 0) {
 		audit_cause = "TPM error";
 		audit_info = 0;
+		kfree(qe);
+		goto out;
 	}
+
+	ima_add_digest_entry(qe);
 out:
 	mutex_unlock(&ima_extend_list_mutex);
 	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
-- 
1.7.6.4


------919F2F262CA39AF46BD61BCAC9928689
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTExMTYxMDEwMjlaMCMGCSqG
SIb3DQEJBDEWBBSFAxqJqxNSpDy+RS0DtI2d/eI2dDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCKe6iOWtc3Rbe6NM2jaruAhEiT
u9iI8k25LOQnk1kTl6U4Uc2X2ZJh89ci7jYnGORiHkTMYtutI08J9/EdO4K1uj4s
X85Lk+NrNhSQerp5+tKae+gFfHurqLDeONdJF9S00kYtwQcPyKR1aOM157OJYRJD
yjQZ92FYD9xTiCWrQwS65Lx7NXDhd9ceTRwuSH1N00K7RwyYRMzpJaKvCj9/zlBJ
t1XVK6pnIPp+t4gnNg5Nknhn3JXb29ZUOEBatApVEJuQr7UNr+ay7UqDY908K8Zf
D2nbX3Gi+wQ6iq29e0mh0MeS2PEQqvo8GRj2wk03HcB4R8eyH21qyxUWOnkY

------919F2F262CA39AF46BD61BCAC9928689--


