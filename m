Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0L1Ks4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:48:56 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46308 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab0L1Ksw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:48:52 -0500
X-Sasl-enc: gqr7MwNO5EZdQxzivwFzSwaIiIn3fpp1M8QKefmpe2fi 1293533331
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, jmorris@namei.org, safford@watson.ibm.com,
        ramunno@polito.it, tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH v2 2/6] encrypted-keys: added additional debug messages
Date: Tue, 28 Dec 2010 11:48:12 +0100
Message-Id: <1293533302-22868-3-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293533302-22868-1-git-send-email-roberto.sassu@polito.it>
References: <1293533302-22868-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----5A975E96756A7F79DA8A40F5CF096F6A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an S/MIME signed message

------5A975E96756A7F79DA8A40F5CF096F6A
Content-Type: text/plain

Some debug messages have been added in the function datablob_parse() in
order to better identify errors returned when dealing with 'encrypted'
keys.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/keys/encrypted_defined.c |   44 +++++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
index c1c5e27..0f3c159 100644
--- a/security/keys/encrypted_defined.c
+++ b/security/keys/encrypted_defined.c
@@ -133,46 +133,68 @@ static int datablob_parse(char *datablob, char **master_desc,
 	substring_t args[MAX_OPT_ARGS];
 	int ret = -EINVAL;
 	int key_cmd;
-	char *p;
+	char *keyword;
 
-	p = strsep(&datablob, " \t");
-	if (!p)
+	keyword = strsep(&datablob, " \t");
+	if (!keyword) {
+		pr_err("encrypted_key: insufficient parameters specified\n");
 		return ret;
-	key_cmd = match_token(p, key_tokens, args);
+	}
+	key_cmd = match_token(keyword, key_tokens, args);
 
 	*master_desc = strsep(&datablob, " \t");
-	if (!*master_desc)
+	if (!*master_desc) {
+		pr_err("encrypted_key: master key parameter is missing\n");
 		goto out;
+	}
 
-	if (valid_master_desc(*master_desc, NULL) < 0)
+	if (valid_master_desc(*master_desc, NULL) < 0) {
+		pr_err("encrypted_key: master key parameter \'%s\' "
+		       "is invalid\n", *master_desc);
 		goto out;
+	}
 
 	if (decrypted_datalen) {
 		*decrypted_datalen = strsep(&datablob, " \t");
-		if (!*decrypted_datalen)
+		if (!*decrypted_datalen) {
+			pr_err("encrypted_key: keylen parameter is missing\n");
 			goto out;
+		}
 	}
 
 	switch (key_cmd) {
 	case Opt_new:
-		if (!decrypted_datalen)
+		if (!decrypted_datalen) {
+			pr_err("encrypted_key: keyword \'%s\' not allowed when "
+			       "updating an existent key\n", keyword);
 			break;
+		}
 		ret = 0;
 		break;
 	case Opt_load:
-		if (!decrypted_datalen)
+		if (!decrypted_datalen) {
+			pr_err("encrypted_key: keyword \'%s\' not allowed when "
+			       "updating an existent key\n", keyword);
 			break;
+		}
 		*hex_encoded_iv = strsep(&datablob, " \t");
-		if (!*hex_encoded_iv)
+		if (!*hex_encoded_iv) {
+			pr_err("encrypted_key: hex blob is missing\n");
 			break;
+		}
 		ret = 0;
 		break;
 	case Opt_update:
-		if (decrypted_datalen)
+		if (decrypted_datalen) {
+			pr_err("encrypted_key: keyword \'%s\' not allowed when "
+			       "instantiating a new key\n", keyword);
 			break;
+		}
 		ret = 0;
 		break;
 	case Opt_err:
+		pr_err("encrypted_key: keyword \'%s\' not recognized\n",
+		       keyword);
 		break;
 	}
 out:
-- 
1.7.2.3


------5A975E96756A7F79DA8A40F5CF096F6A
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDEyMjgxMDQ4NDdaMCMGCSqG
SIb3DQEJBDEWBBRAMv2bV3asA+GTcm55DBmaSRq/RzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQDRI9+B/B19lT0lZrNy+OvBgnzV
ihCBHaFc3XtPBOtdXP6zDx9MiWWnAi8+Rx+p0vVwgPMfNtymVWyHL18FIaIfmpvX
97d7jXXAnqr57i9CzHpOCZz7NHs/K0mz2+BC4kUj5wJz5ZTQzRvyClsh1BBg2Ziy
LDir3wUeRJRx5J7W1pNTWIqFi57B0RQf4fad0YWU8vNNCga8/Pfc7ctLRC44VNHp
kyxLxtQAOyfx4qQ3TQ7wTJXkF4D7f9I1UhIDFeMr6OCzkzZkcAXKv/f/M2ph1YFN
SRIoxwOUbIWjG/hjp8rcJ0DddL4aTWal7VtAgj/gnce0+RKnmoQuUkrA4dDf

------5A975E96756A7F79DA8A40F5CF096F6A--

