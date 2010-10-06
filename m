Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab0JFQba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:31:30 -0400
Received: from new1.smtp.messagingengine.com ([66.111.4.221]:48353 "EHLO
	new1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759376Ab0JFQb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:31:28 -0400
X-Sasl-enc: tIuzM5stlrMFNSPLFSMgSD9KXWR867Pjx7JNoSVBVhYy 1286382686
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com, jmorris@namei.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 1/3] ecryptfs: release keys loaded in ecryptfs_keyring_auth_tok_for_sig()
Date: Wed, 6 Oct 2010 18:31:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-56.fc13.x86_64; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1714199.jOHCpxfSix";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010061831.06856.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1714199.jOHCpxfSix
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch allows keys requested in the function ecryptfs_keyring_auth_tok_=
for_sig()=20
to be released when they are no longer required. In particular keys are dir=
ectly released=20
in the same function if the obtained authentication token is not valid.
=46urther, a new function parameter 'auth_tok_key' has been added to=20
ecryptfs_find_auth_tok_for_sig() in order to provide callers the key pointe=
r to be passed=20
to key_put().


Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 fs/ecryptfs/keystore.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 73811cf..77580db 100644
=2D-- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -446,6 +446,7 @@ out:
  */
 static int
 ecryptfs_find_auth_tok_for_sig(
+	struct key **auth_tok_key,
 	struct ecryptfs_auth_tok **auth_tok,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 	char *sig)
@@ -453,12 +454,12 @@ ecryptfs_find_auth_tok_for_sig(
 	struct ecryptfs_global_auth_tok *global_auth_tok;
 	int rc =3D 0;
=20
+	(*auth_tok_key) =3D NULL;
 	(*auth_tok) =3D NULL;
 	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
 						  mount_crypt_stat, sig)) {
=2D		struct key *auth_tok_key;
=20
=2D		rc =3D ecryptfs_keyring_auth_tok_for_sig(&auth_tok_key, auth_tok,
+		rc =3D ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
 						       sig);
 	} else
 		(*auth_tok) =3D global_auth_tok->global_auth_tok;
@@ -509,6 +510,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remain=
ing_bytes,
 			     char *filename, size_t filename_size)
 {
 	struct ecryptfs_write_tag_70_packet_silly_stack *s;
+	struct key *auth_tok_key =3D NULL;
 	int rc =3D 0;
=20
 	s =3D kmalloc(sizeof(*s), GFP_KERNEL);
@@ -606,6 +608,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remain=
ing_bytes,
 	}
 	dest[s->i++] =3D s->cipher_code;
 	rc =3D ecryptfs_find_auth_tok_for_sig(
+		&auth_tok_key,
 		&s->auth_tok, mount_crypt_stat,
 		mount_crypt_stat->global_default_fnek_sig);
 	if (rc) {
@@ -753,6 +756,8 @@ out_free_unlock:
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
+	if (auth_tok_key)
+		key_put(auth_tok_key);
 	kfree(s);
 	return rc;
 }
@@ -798,6 +803,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *f=
ilename_size,
 			     char *data, size_t max_packet_size)
 {
 	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
+	struct key *auth_tok_key =3D NULL;
 	int rc =3D 0;
=20
 	(*packet_size) =3D 0;
@@ -910,7 +916,8 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *f=
ilename_size,
 	 * >=3D ECRYPTFS_MAX_IV_BYTES. */
 	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
 	s->desc.info =3D s->iv;
=2D	rc =3D ecryptfs_find_auth_tok_for_sig(&s->auth_tok, mount_crypt_stat,
+	rc =3D ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
+					    &s->auth_tok, mount_crypt_stat,
 					    s->fnek_sig_hex);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to find auth tok for "
@@ -986,6 +993,8 @@ out:
 		(*filename_size) =3D 0;
 		(*filename) =3D NULL;
 	}
+	if (auth_tok_key)
+		key_put(auth_tok_key);
 	kfree(s);
 	return rc;
 }
@@ -1557,14 +1566,19 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **=
auth_tok_key,
 		       ECRYPTFS_VERSION_MAJOR,
 		       ECRYPTFS_VERSION_MINOR);
 		rc =3D -EINVAL;
=2D		goto out;
+		goto out_release_key;
 	}
 	if ((*auth_tok)->token_type !=3D ECRYPTFS_PASSWORD
 	    && (*auth_tok)->token_type !=3D ECRYPTFS_PRIVATE_KEY) {
 		printk(KERN_ERR "Invalid auth_tok structure "
 		       "returned from key query\n");
 		rc =3D -EINVAL;
=2D		goto out;
+		goto out_release_key;
+	}
+out_release_key:
+	if (rc) {
+		key_put(*auth_tok_key);
+		(*auth_tok_key) =3D NULL;
 	}
 out:
 	return rc;
@@ -1688,6 +1702,7 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_s=
tat *crypt_stat,
 	struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
 	size_t tag_11_contents_size;
 	size_t tag_11_packet_size;
+	struct key *auth_tok_key;
 	int rc =3D 0;
=20
 	INIT_LIST_HEAD(&auth_tok_list);
@@ -1784,6 +1799,10 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_=
stat *crypt_stat,
 	 * just one will be sufficient to decrypt to get the FEK. */
 find_next_matching_auth_tok:
 	found_auth_tok =3D 0;
+	if (auth_tok_key) {
+		key_put(auth_tok_key);
+		auth_tok_key =3D NULL;
+	}
 	list_for_each_entry(auth_tok_list_item, &auth_tok_list, list) {
 		candidate_auth_tok =3D &auth_tok_list_item->auth_tok;
 		if (unlikely(ecryptfs_verbosity > 0)) {
@@ -1800,7 +1819,8 @@ find_next_matching_auth_tok:
 			rc =3D -EINVAL;
 			goto out_wipe_list;
 		}
=2D		ecryptfs_find_auth_tok_for_sig(&matching_auth_tok,
+		ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
+					       &matching_auth_tok,
 					       crypt_stat->mount_crypt_stat,
 					       candidate_auth_tok_sig);
 		if (matching_auth_tok) {
@@ -1866,6 +1886,8 @@ found_matching_auth_tok:
 out_wipe_list:
 	wipe_auth_tok_list(&auth_tok_list);
 out:
+	if (auth_tok_key)
+		key_put(auth_tok_key);
 	return rc;
 }
=20
=2D-=20
1.7.2.3

--nextPart1714199.jOHCpxfSix
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQCTCCBLMw
ggOboAMCAQICARQwDQYJKoZIhvcNAQEFBQAwQTEQMA4GA1UEChMHRXVyb1BLSTEtMCsGA1UEAxMk
RXVyb1BLSSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MTAyNDEzMzEzM1oXDTEw
MTIzMTEyNTk1OVowUTELMAkGA1UEBhMCSVQxEDAOBgNVBAoTB0V1cm9QS0kxMDAuBgNVBAMTJ0V1
cm9QS0kgSXRhbGlhbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAPbJ3y5bE0iL2iFW59R4KGHS3iTc22mq2GlDaOZLE3Xz1wTvB/yBl5e4ntMZ
eEeWTW9JInNRTtfC3mcLk0gnEdK1rQZbe4lQwBVHdkG8LvRQDWHIkZNuccoUpQXMv+JbZjI6m7rH
fU2CN/YCvFY9QL08xXsfDxvX2Ee4S7EwJiSEEJSiy+R00uTfvfn27d8a6LCqYLzlInRlz4C2CUbk
+U2UAwjYEPTP2ziqFxztysbxC3fjqH8e6P5wIPXOS5cSYnVaEyp21VXhAOamVJEGlQCdVoTHs+pP
BYqCBuNhBfienUPaEDHHUUYHZ2nS4eNzd9XOu+5hFi1/8hVZxN4sbdECAwEAAaOCAaQwggGgMEwG
CWCGSAGG+EIBDQQ/Fj1Jc3N1ZWQgdW5kZXIgcG9saWN5OgogaHR0cDovL3d3dy5ldXJvcGtpLm9y
Zy9jYS9yb290L2Nwcy8xLjEvMGUGCCsGAQUFBwEBBFkwVzAoBggrBgEFBQcwAYYcaHR0cDovL29j
c3AuZXVyb3BraS5vcmc6ODAyNjArBggrBgEFBQcwAoYfaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9j
YS9yb290LzA7BgNVHR8ENDAyMDCgLqAshipodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL3Jvb3Qv
Y3JsL2NybC5kZXIwDAYDVR0TBAUwAwEB/zBOBgNVHSAERzBFMEMGCisGAQQBqQcBAQEwNTAzBggr
BgEFBQcCARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMA4GA1UdDwEB
/wQEAwIB9jAdBgNVHQ4EFgQUjl4HtzG0Gbu5BJU0rMX9016KQsAwHwYDVR0jBBgwFoAUjNyLsaVK
kOdOiHMYPJ3VXn7kss0wDQYJKoZIhvcNAQEFBQADggEBAFjlAWMiL7uhEAVcrPeMXsbQU+bQNbP1
TBqyBoMCMJ4RakM7/67AsmqpKGIYwhjVkSNHhscRl5BuSiyviHOLbWUJ9tAAKt6hzMDr1J4OvWSH
Sn8y9fSlyQU8+fQE8FHxXT3Aa7aLYVqsqr0ppmxRDL/9b/mdUVcMXiKFAdopFzhXIigfZFh6MW/o
7/GEiDMGsovCiwKJ5ZL46zGRDaS+O0aRYQv2PHZaWrC8i0OPwghlTeB2DfUBzm0urPijBATdjzP8
yO3YGymFZOIG08Roe4bwzrANGzX5luBk3lNmtXTPHoUtRLn3ADa+IUGwK6VYWHYJe1+uUHRNziQu
/Zsb858wggU/MIIEJ6ADAgECAgIJzzANBgkqhkiG9w0BAQUFADBRMQswCQYDVQQGEwJJVDEQMA4G
A1UEChMHRXVyb1BLSTEwMC4GA1UEAxMnRXVyb1BLSSBJdGFsaWFuIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MB4XDTA2MTEwNjE3MTU1OVoXDTEwMTIzMTEyNTk1OVowZTELMAkGA1UEBhMCSVQxHjAc
BgNVBAoTFVBvbGl0ZWNuaWNvIGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9y
aW5vIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEA/s1vopfmSp2eqKG/jW4H5YyfrZc/jWEnctMMm7TlVT+ryxJ2ifYV/7VyuYVIGdnCBnmJiav6
uhePqpHyuejEZ+IdCchk04BSBbgzkSbWakw2ekv1SKm8WfvhxHbiSo/t//LQEANMJ+XeeqGl1TRR
8gdMC6erWFGdl5FcuOpMoaqW6DszVGlOAf7Uo/DExZ0/9cw77GTRoDTA3vi1QJEYGaAAvI2/flaU
8gn4QoktjowchDXBylVsyqs+ux3v7m3H0cgC3q62t2om2badk40F9XH1w2WPLQB6rSl+TPDxkl2k
kR4goQprXR0b0OujS5ADq5Ds2w7YPj5h4J6ebsbIUQIDAQABo4ICCzCCAgcwdQYJYIZIAYb4QgEN
BGgWZklzc3VlZCB1bmRlciBwb2xpY2llczoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9v
dC9jcHMvMS4xLwogaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzBcBggrBgEF
BQcBAQRQME4wKAYIKwYBBQUHMAGGHGh0dHA6Ly9vY3NwLmV1cm9wa2kub3JnOjgwMjYwIgYIKwYB
BQUHMAKGFmh0dHA6Ly93d3cuZXVyb3BraS5vcmcwPAYDVR0fBDUwMzAxoC+gLYYraHR0cDovL3d3
dy5ldXJvcGtpLm9yZy9jYS9pdDIvY3JsMDMvY3JsLmRlcjAPBgNVHRMBAf8EBTADAQH/MIGTBgNV
HSAEgYswgYgwQwYKKwYBBAGpBwEBATA1MDMGCCsGAQUFBwIBFidodHRwOi8vd3d3LmV1cm9wa2ku
b3JnL2NhL3Jvb3QvY3BzLzEuMS8wQQYKKwYBBAGpBwIBATAzMDEGCCsGAQUFBwIBFiVodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL2l0L2Nwcy8xLjEvMAsGA1UdDwQEAwIB9jAdBgNVHQ4EFgQUCf0l
GW/jaHyCazVzvCgAviw8OjgwHwYDVR0jBBgwFoAUjl4HtzG0Gbu5BJU0rMX9016KQsAwDQYJKoZI
hvcNAQEFBQADggEBANfGdD6B98NUwBOVYIiuo+SNfw8Afjr2oFHLYEHYhKdBED1WBckhK610v2zJ
ctramnrqdd+xfyzmkyNm48OtkiVetYzXbgYeyMGxhO8HrJ1Ztf1yEN0lL8HgdK3lmJeLYNYH/cwZ
5SlKwvTR/VENHLYlWsgWk47ut7W8+Zd/ESwzNdJUCBUMoQnGZ3giyhAXKAgIOckwL0g8KmnceY7J
Y4L1G++1OuOoUcgg2jRPxcVmHVEe/cM0WHfUcigDXSBTIxAiDwlQ7ni97yX1RqBV/6IVdRDYKyjg
YkdYcwU9ZuOKUP4Pl5KKCegLOHRoo5kX6V1o7b2IZGBFoVmkag4m4kkwggYLMIIE86ADAgECAgID
wTANBgkqhkiG9w0BAQUFADBlMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMTYwNAYDVQQDEy1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMDgxMjA1MTYwMDAwWhcNMTAxMjMwMTIwMDAwWjB5MQswCQYDVQQGEwJJVDEeMBwG
A1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTEwLwYDVQQLEyhEaXBhcnRpbWVudG8gZGkgQXV0
b21hdGljYSBlIEluZm9ybWF0aWNhMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAOS/leMNzG5v7FG73ythWtNPOdq8MEFpzg7mjy4M7UsS9+sc
b7QE8TOX365q/+mBwxZ7qW+OhNKfgv14A3y/quju5P7mjTmTNvKWDpsUBjC+tCs+WpWsgIPc2xxW
PrR7br04U/SYYNsxynh1TtO2gsQrHIj9S/wNiNRP8GGPCAiuYRlaL2CeSVn4JEKcT0zOeLIIqfDp
3Ad3YeBhj+cR3TrmO9TyGTPCAb1oyq9wuA1Tx044rqSQNbp0e0RvOrwAIpD/2mNPP3ReTeB53aSg
q0pCHoH1s2AcY/jWJ1joYFC9hh/2DqZRvMNIsM7Uce5Iiz2sgl1I61IUD4658HYzCmMCAwEAAaOC
Aq8wggKrMIGVBglghkgBhvhCAQ0EgYcWgYRJc3N1ZWQgdW5kZXIgcG9saWNpZXM6CiBodHRwOi8v
d3d3LmV1cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8KIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcv
Y2EvaXQvY3BzLzEuMS8KIGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wEQYJYIZIAYb4QgEB
BAQDAgCwMGMGCCsGAQUFBwEBBFcwVTAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AuZXVyb3BraS5v
cmc6ODAyNjApBggrBgEFBQcwAoYdaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC8wMgYDVR0f
BCswKTAnoCWgI4YhaHR0cDovL2NhLnBvbGl0by5pdC9jcmwwMy9jcmwuZGVyMAwGA1UdEwEB/wQC
MAAwOgYDVR0RBDMwMYEXcm9iZXJ0by5zYXNzdUBwb2xpdG8uaXSgFgYKKwYBBAGVYgIBAaAIFgYw
MjEzMDUwgc0GA1UdIASBxTCBwjBDBgorBgEEAakHAQEBMDUwMwYIKwYBBQUHAgEWJ2h0dHA6Ly93
d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLzBBBgorBgEEAakHAgEBMDMwMQYIKwYBBQUH
AgEWJWh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2EvaXQvY3BzLzEuMS8wOAYKKwYBBAGVYgECATAq
MCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjEvMAsGA1UdDwQEAwIE8DAd
BgNVHQ4EFgQUP+37DpRL6r5BNjgsgFjI8MHvGTcwHwYDVR0jBBgwFoAUCf0lGW/jaHyCazVzvCgA
viw8OjgwDQYJKoZIhvcNAQEFBQADggEBADRj0OWMglzLXTPuKND9gMTHd1iRPzRNI1TiYFN/WIyu
a3mNev65wKn35VxbbMV6k7zuxxdC7o+iYRLepVOnpw90Af/SiJRc9QI4rk8tzSr5xII7vI0fPvcl
rjSMymXCvwKrbYwrKe0FhBnSZ8AoewXoHDQ8f64heLIU8mLWuwo1+brq0pJUH5Q+69WAGD03ln+l
Fhk2KqvVv8yAD21PydrS7Uk2ZLE7l7/+BTQBY8ZjpNRZ44C6+o7lou2zN6lkWtVHBwUNVdfu3wkS
TdtCm/yxR8XUlFyZkLHfhY19VW4luxb7KZ4GiPKDERdQwBb0kja4eqSOBkAPWZ9Y8zpv4bAxggIc
MIICGAIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8x
NjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIC
A8EwCQYFKw4DAhoFAKCBhzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xMDEwMDYxNjMxMDZaMCMGCSqGSIb3DQEJBDEWBBTN7pW+YsjsTU5oZbayTpVcptqqJTAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQCM
McTU7t9fJeLa0CKudAJMUosnRYkCG8Hbn2qJjeJtwRItmcHdVeBqvVc29byxYOXYaHFDKXl8sUl6
1PICuLLHInmOOVkWy5gNty3YSv1mETH39pgMy+3jnX94hF4BDnIzWFEAjsKIU1JA3/lLBDRLN86P
ztaaVNLETjoS/O+PNVN3HSwCu71gqTQ6h4W/8+htT3FHphmZX/bMCvL6H3qxh1OLuqD4Ah0v3Lpz
ZNGLjpYzayLRSDfuAYa0WngUaX0BufqvrPZx9LMsqHEmP9V7ibC8q9ZPrsImIOBq4EvOZULDk7XV
D9JyOY+lNVakS3/EQbYBcCgeo4uexWwh7nx+AAAAAAAA

--nextPart1714199.jOHCpxfSix--
