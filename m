Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0JGPiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:38:24 -0400
Received: from new1.smtp.messagingengine.com ([66.111.4.221]:35206 "EHLO
	new1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab0JGPiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:38:22 -0400
X-Sasl-enc: n94grkTg0ECO2A7CZRxiI1q/l4BlExKVBIFXPjtlFTSH 1286465901
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: tyhicks@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] ecryptfs: added ecryptfs_mount_auth_tok_only mount parameter
Date: Thu, 7 Oct 2010 17:37:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-56.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <201010061831.32663.roberto.sassu@polito.it>
In-Reply-To: <201010061831.32663.roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2853083.vdGaWHbfzp";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010071737.54251.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2853083.vdGaWHbfzp
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Sorry, i noted this patch is incomplete since the function ecryptfs_show_op=
tions()
does not display the string relative to the added mount option.
I will send the new patch after receiving comments and suggestions.
Thanks.

Roberto


On Wednesday, October 06, 2010 06:31:32 pm Roberto Sassu wrote:
> This patch adds a new mount parameter 'ecryptfs_mount_auth_tok_only' to f=
orce=20
> ecryptfs to use only authentication tokens which signature has been=20
> specified at mount time with parameters 'ecryptfs_sig' and 'ecryptfs_fnek=
_sig'.=20
> In this way, after disabling the passthrough and the encrypted view modes,
> it's possible to make available to users only files encrypted with the sp=
ecified
> authentication token.
>=20
>=20
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    1 +
>  fs/ecryptfs/keystore.c        |    7 +++++++
>  fs/ecryptfs/main.c            |    8 +++++++-
>  3 files changed, 15 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 0032a9f..59ab793 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -377,6 +377,7 @@ struct ecryptfs_mount_crypt_stat {
>  #define ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES      0x00000010
>  #define ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK   0x00000020
>  #define ECRYPTFS_GLOBAL_ENCFN_USE_FEK          0x00000040
> +#define ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY    0x00000080
>  	u32 flags;
>  	struct list_head global_auth_tok_list;
>  	struct mutex global_auth_tok_list_mutex;
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 643d011..93f7785 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -459,6 +459,13 @@ ecryptfs_find_auth_tok_for_sig(
>  	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
>  						  mount_crypt_stat, sig)) {
> =20
> +		/* if the flag ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY is set in the
> +		 * mount_crypt_stat structure, we prevent to use auth toks that are
> +		 * not inserted through the ecryptfs_add_global_auth_tok function.
> +		 */
> +		if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY)
> +			return -EINVAL;
> +
>  		rc =3D ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
>  						       sig);
>  	} else
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index cbd4e18..e372226 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -208,7 +208,8 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
>         ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
>         ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
>         ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
> -       ecryptfs_opt_unlink_sigs, ecryptfs_opt_err };
> +       ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
> +       ecryptfs_opt_err };
> =20
>  static const match_table_t tokens =3D {
>  	{ecryptfs_opt_sig, "sig=3D%s"},
> @@ -223,6 +224,7 @@ static const match_table_t tokens =3D {
>  	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=3D%s"},
>  	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=3D%u"},
>  	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
> +	{ecryptfs_opt_mount_auth_tok_only, "ecryptfs_mount_auth_tok_only"},
>  	{ecryptfs_opt_err, NULL}
>  };
> =20
> @@ -406,6 +408,10 @@ static int ecryptfs_parse_options(struct ecryptfs_sb=
_info *sbi, char *options)
>  		case ecryptfs_opt_unlink_sigs:
>  			mount_crypt_stat->flags |=3D ECRYPTFS_UNLINK_SIGS;
>  			break;
> +		case ecryptfs_opt_mount_auth_tok_only:
> +			mount_crypt_stat->flags |=3D=20
> +				ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY;
> +			break;
>  		case ecryptfs_opt_err:
>  		default:
>  			printk(KERN_WARNING
>=20

--nextPart2853083.vdGaWHbfzp
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
Fw0xMDEwMDcxNTM3NDZaMCMGCSqGSIb3DQEJBDEWBBT+kvJg8QNsV/lxiR1FhWz05hBWFzAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQAb
n8lNAEfLWqdY90pjX7kDi+uPE9DL++BwTcP66wYj6AD9erN8N7Fe6KadcG6TCuvpJrgdhrNIUvPK
CDHDsFalqYJLhRdESgpzQWXADvywI02VJA8nNLLdByMNqk03c5BFgdRWatzfPDV2AQ9v9ldcRYVp
K0kimAQ3x5XCgxLxqLW87DfbgN6Il/BcRMLqOqq8U8bMCNRJsbt0myDb6JR/bmHu51I4JO2OaYkc
ecfKBa/hJF2IP6k1E273QFlZxSPY+GX3ys4XRWqC+d/4jelpev+Ct+NUKfP3C4vOjc5zjGHdvLOf
7aB7dCJAgWSCWJ1CrAjgit7dEoYELKwk4iMqAAAAAAAA

--nextPart2853083.vdGaWHbfzp--
