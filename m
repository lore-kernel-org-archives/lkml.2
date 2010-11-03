Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0KCKNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:13:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52947 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab0KCKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:12:58 -0400
X-Sasl-enc: aD0emg2KFsIZR/digeERBWjxEjYPk7+YRYQypJq2cenO 1288779177
To: tyhicks@linux.vnet.ibm.com
Subject: [PATCH 5/5] ecryptfs: open lower files with kthread credentials
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
Date: Wed, 3 Nov 2010 11:11:40 +0100
MIME-Version: 1.0
Cc: kirkland@canonical.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: multipart/signed;
  boundary="nextPart1648538.6WOaLfkx6U";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201011031111.41084.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1648538.6WOaLfkx6U
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ecryptfs allows concurrent accesses to an encrypted file by opening the
relative lower inode only once and making the returned file descriptor
available until the ecryptfs inode is destroyed.
The file descriptor is obtained by calling the function dentry_open() for
the lower inode with flag O_RDWR  and the credentials of the process that
issued the open request.
During this procedure two issues may be encountered when using ecryptfs in
conjunction with SELinux: first, a process needs read/write permission
for opening a file even with flag O_RDONLY; second a process needs the
'use' permission in the 'fd' class if the lower file was opened by another
process with different credentials.
This patch replaces the 'cred' structure of the current process, passed to
the function dentry_open(), with the one associated with the 'kthread'
kernel service.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 fs/ecryptfs/ecryptfs_kernel.h |    3 +--
 fs/ecryptfs/kthread.c         |   17 +++++++++++++----
 fs/ecryptfs/main.c            |    3 +--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 452be3c..14d167f 100644
=2D-- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -759,8 +759,7 @@ int ecryptfs_init_kthread(void);
 void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
=2D			     struct vfsmount *lower_mnt,
=2D			     const struct cred *cred);
+			     struct vfsmount *lower_mnt);
 int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
 int
 ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index d8c3a37..5094601 100644
=2D-- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -38,6 +38,7 @@ static struct ecryptfs_kthread_ctl {
 } ecryptfs_kthread_ctl;
=20
 static struct task_struct *ecryptfs_kthread;
+static struct cred *ecryptfs_kthread_cred;
=20
 /**
  * ecryptfs_threadfn
@@ -74,7 +75,7 @@ static int ecryptfs_threadfn(void *ignored)
 				mntget(req->lower_mnt);
 				(*req->lower_file) =3D dentry_open(
 					req->lower_dentry, req->lower_mnt,
=2D					(O_RDWR | O_LARGEFILE), current_cred());
+					(O_RDWR | O_LARGEFILE), ecryptfs_kthread_cred);
 				req->flags |=3D ECRYPTFS_REQ_PROCESSED;
 			}
 			wake_up(&req->wait);
@@ -99,7 +100,15 @@ int ecryptfs_init_kthread(void)
 		rc =3D PTR_ERR(ecryptfs_kthread);
 		printk(KERN_ERR "%s: Failed to create kernel thread; rc =3D [%d]"
 		       "\n", __func__, rc);
+		goto out;
+	}
+	ecryptfs_kthread_cred =3D prepare_kernel_cred(ecryptfs_kthread);
+	if (IS_ERR(ecryptfs_kthread_cred)) {
+		rc =3D PTR_ERR(ecryptfs_kthread_cred);
+		printk(KERN_ERR "%s: Failed to obtain the credential struct; "
+				"rc =3D [%d]\n", __func__, rc);
 	}
+out:
 	return rc;
 }
=20
@@ -119,6 +128,7 @@ void ecryptfs_destroy_kthread(void)
 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
 	kthread_stop(ecryptfs_kthread);
 	wake_up(&ecryptfs_kthread_ctl.wait);
+	put_cred(ecryptfs_kthread_cred);
 }
=20
 /**
@@ -133,8 +143,7 @@ void ecryptfs_destroy_kthread(void)
  */
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
=2D			     struct vfsmount *lower_mnt,
=2D			     const struct cred *cred)
+			     struct vfsmount *lower_mnt)
 {
 	struct ecryptfs_open_req *req;
 	int flags =3D O_LARGEFILE;
@@ -146,7 +155,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	dget(lower_dentry);
 	mntget(lower_mnt);
 	flags |=3D IS_RDONLY(lower_dentry->d_inode) ? O_RDONLY : O_RDWR;
=2D	(*lower_file) =3D dentry_open(lower_dentry, lower_mnt, flags, cred);
+	(*lower_file) =3D dentry_open(lower_dentry, lower_mnt, flags, ecryptfs_kt=
hread_cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
 	if (flags & O_RDONLY) {
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 81821d7..c07bb9a 100644
=2D-- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -117,7 +117,6 @@ void __ecryptfs_printk(const char *fmt, ...)
  */
 int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
=2D	const struct cred *cred =3D current_cred();
 	struct ecryptfs_inode_info *inode_info =3D
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
 	int rc =3D 0;
@@ -130,7 +129,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecrypt=
fs_dentry)
=20
 		lower_dentry =3D ecryptfs_dentry_to_lower(ecryptfs_dentry);
 		rc =3D ecryptfs_privileged_open(&inode_info->lower_file,
=2D					      lower_dentry, lower_mnt, cred);
+					      lower_dentry, lower_mnt);
 		if (rc) {
 			printk(KERN_ERR "Error opening lower persistent file "
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
=2D-=20
1.7.2.3


--nextPart1648538.6WOaLfkx6U
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
Fw0xMDExMDMxMDExNDFaMCMGCSqGSIb3DQEJBDEWBBSq/X8SIIN2sTvxrIzCeakRwXIZGzAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQBc
kEoQ0j/cbtPUI52FNMr3I0c/Vx15SOygm5bC25UNo/6aqBR7mK2FTVZU+0T+V+5jNSWcycriYBWx
1MgzZC3KV+79iUWtG0TRlep9XzF0LUyf1xO8B+BSEr1ceuUctLg/vlMjWiMDwAjwdI14EDL7DvLr
xUnzGdh3tfwaMnSWGT5ythdV97Nkc4Zj6AEjVlhJ7RU6Z2fFnFsHEcycU7Wkf4yBqKTQByyFUdmG
XMyQHf3zS4rP2B/A+inPhTVvdnfanCIi0f2p6jX/G/dnP/iqCK6Xk1azyEfH4gbdsBMyE7b3ZvPW
Slrog3wlitoiHBaaGNdgHLoJhmb1mTSKds+AAAAAAAAA

--nextPart1648538.6WOaLfkx6U--
