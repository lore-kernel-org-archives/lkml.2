Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0JEPkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:40:04 -0400
Received: from new1.smtp.messagingengine.com ([66.111.4.221]:36401 "EHLO
	new1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457Ab0JEPkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:40:00 -0400
X-Sasl-enc: 5rNIp4+Z8zyTTU1bB0IufQSnwGNgErkR2FphfiKJtHHo 1286293198
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [patch 1/1] ecryptfs: call __vfs_setxattr_noperm() in ecryptfs_setxattr()
Date: Tue, 5 Oct 2010 17:39:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-56.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101005062353.GA24737@boomer>
In-Reply-To: <20101005062353.GA24737@boomer>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6635845.Oo9iz1YnZt";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201010051739.47423.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6635845.Oo9iz1YnZt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday, October 05, 2010 08:23:53 am Tyler Hicks wrote:
> On Fri Oct 01, 2010 at 02:14:00PM -0700, akpm@linux-foundation.org <akpm@=
linux-foundation.org> wrote:
> > From: Roberto Sassu <roberto.sassu@polito.it>
>=20
> Andrew - thanks for not letting this one slip through.
>=20
> >=20
> > Ecryptfs is a stackable filesystem which relies on lower filesystems the
> > ability of setting/getting extended attributes.
> >=20
> > If there is a security module enabled on the system it updates the
> > 'security' field of inodes according to the owned extended attribute set
> > with the function vfs_setxattr().  When this function is performed on a
> > ecryptfs filesystem the 'security' field is not updated for the lower
> > filesystem since the call security_inode_post_setxattr() is missing for
> > the lower inode.
> >=20
> > This patch makes the function __vfs_setxattr_noperm() available for
> > modules and replaces the call to the setxattr() method of the lower ino=
de
> > with the exported function.
> >=20
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> > Cc: Dustin Kirkland <kirkland@canonical.com>
> > Cc: James Morris <jmorris@namei.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >=20
> >  fs/ecryptfs/inode.c |    5 +++--
> >  fs/xattr.c          |    1 +
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff -puN fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ec=
ryptfs_setxattr fs/ecryptfs/inode.c
> > --- a/fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecrypt=
fs_setxattr
> > +++ a/fs/ecryptfs/inode.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/crypto.h>
> >  #include <linux/fs_stack.h>
> >  #include <linux/slab.h>
> > +#include <linux/xattr.h>
> >  #include <asm/unaligned.h>
> >  #include "ecryptfs_kernel.h"
> >=20
> > @@ -1109,8 +1110,8 @@ ecryptfs_setxattr(struct dentry *dentry,
> >  		goto out;
> >  	}
> >  	mutex_lock(&lower_dentry->d_inode->i_mutex);
> > -	rc =3D lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, valu=
e,
> > -						   size, flags);
> > +	rc =3D __vfs_setxattr_noperm(lower_dentry, name, value,
> > +				   size, flags);
>=20
> Hi Roberto - Thanks for the fix. However, it seems to me like we should
> call vfs_setxattr(). We can't guarantee consistency among the eCryptfs
> inode and the lower inode, so the extra call to xattr_permission()
> isn't a waste.
>=20

Hi Tyler

i look in deep at the code and i made the following considerations:
first, i think calling vfs_setxattr() instead of __vfs_setxattr is not nece=
ssary when ecryptfs is=20
mounted on the top of a directory in the lower filesystem: in this case the=
 only way
to modify the extended attributes of lower inodes is to call ecryptfs_setxa=
ttr().
Second, the use of vfs_setxattr() causes functions xattr_permission() and=20
security_inode_setxattr() to be called twice. While the former is not neede=
d the second time
because it calls ecryptfs_permission() which in turn invokes inode_permissi=
on()=20
on the lower inode, i noted the second is required at least for SELinux in =
this situation:
suppose that ecryptfs and the lower filesystem have different security cont=
exts for the=20
filesystem object; in this case if the security_inode_setxattr() is missing=
 for the lower inode,
the filesystem 'associate' permission is not checked (SELinux verifies if a=
n inode with a=20
given label can be stored on a filesystem bound to a specific security cont=
ext).
I will post a second version of the patch which has the function __vfs_setx=
attr() replaced with
vfs_setxattr().


> >  	mutex_unlock(&lower_dentry->d_inode->i_mutex);
> >  out:
> >  	return rc;
> > diff -puN fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_se=
txattr fs/xattr.c
> > --- a/fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxat=
tr
> > +++ a/fs/xattr.c
> > @@ -106,6 +106,7 @@ int __vfs_setxattr_noperm(struct dentry=20
> >=20
> >  	return error;
> >  }
> > +EXPORT_SYMBOL_GPL(__vfs_setxattr_noperm);
> >=20
> >=20
> >  int
> > _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-=
module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--nextPart6635845.Oo9iz1YnZt
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
Fw0xMDEwMDUxNTM5NDBaMCMGCSqGSIb3DQEJBDEWBBTXTiwzWRALC8mGDIeD5DQ0yMXwSzAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQBu
4iTrWc3UXqOtd9DWqiTjWr05O250BRtPpMF8zzQmELJt/VonqikXZ+kLLnLyNk4PLPqtBElUeChV
8LAJYAJnJmqDHWYDdPKE39IoD+Ee92kfytlr3okwq31patfFeuXj/zPCETrFazZuB5j8x4yfdSof
qiecHhA3s9NQqyE7C1Vrjl3KvLpjdJ/iz8ui61do/LIeQ03P+3h9tjW8KaNoejLkh6qzSOjAVrOe
4mJcPHoJnMsjFKzyGpPrzseBoQ2CC8brduZFQlNaZHmD5NmMaDOGa9UZaK1Qesein1DS+SDvjChn
Pn7UpjM+Y8uSMSf0nfeVjDAzAAiKiWXRrDJ7AAAAAAAA

--nextPart6635845.Oo9iz1YnZt--
