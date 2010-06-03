Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab0FCJ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:59:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0FCJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lh51XpnuF+F2Gc6AlVl74va/koTA00B6AmXdJ8KJekmxJ7pyGY9/dvYuPPo9ZywjL3
         TF0fwK7Nll+wnEmO9pJRfZF1m2qTXpqGRg0QLVJDJC4Z7JfDJNBcLgwGsWaikHTEZPVb
         8HqERV8RJVus5JK6Hblpom6UNlk6VV8xCoYto=
From: Roberto Sassu <roberto.sassu@polito.it>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [Linux-ima-user] [PATCH][1/1] fs: wrong type for 'magic' 
 =?utf-8?q?argument=09in?= 'simple_fill_super()', fs/libfs.c
Date: Thu, 3 Jun 2010 11:58:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.3; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-ima-user@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org
References: <201006011906.00880.roberto.sassu@polito.it> <1275504265.3091.5.camel@localhost.localdomain>
In-Reply-To: <1275504265.3091.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1628879.SxsvaoqpPi";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006031158.33629.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1628879.SxsvaoqpPi
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sorry for resending, the previous was rejected by some mailing list.


On Wednesday 02 June 2010 20:44:25 Mimi Zohar wrote:
> On Tue, 2010-06-01 at 19:05 +0200, Roberto Sassu wrote:=20
> > Description of the issue:
> >=20
> > The function 'simple_fill_super()' in the path 'fs/libfs.c' takes the '=
magic' argument as int.=20
> > In the include file 'include/linux/fs.h' the 's_magic' field of the 'su=
per_block' structure is
> > declared as unsigned long.
> > This causes a misbehaviour in the 'Integrity Measurement Architecture' =
security module,=20
> > since the 's_magic' field is used as criteria to determine if the inode=
 must be measured.
>=20
> There aren't any magic numbers today greater than 32 bits. Out of
> curiosity, which magic number on which platform are you having a
> problem?
>=20

I'm using a Fedora 12 64-bit KVM virtual machine. I do some tests on the 'i=
ma_must_measure()'
function and i noted that the result for inodes with superblock magic SELIN=
UX_MAGIC is to=20
measure, when the action specified in the default policy is don't measure. =
So i modified
the code to display the superblock's magic of measured inodes adding this l=
ine in the function=20
'process_measurement()' in 'security/integrity/ima/ima_main.c' after 'ima_m=
ust_measure()':

printk("file %s: magic: %lx\n", file->f_dentry->d_name.name, inode->i_sb->s=
_magic);


I obtained this result:

=2E..
file access: magic 0xfffffffff97cff8c
=2E..


The magic that i'm expecting is 0xf97cff8c. I think this is why the IMA pol=
icy is not applied=20
correctly.
I investigated further the selinux's code to understand how the super_block=
 structure is=20
instantiated in memory and i found this code in 'security/selinux/selinuxfs=
=2Ec' , line 1601:

        ret =3D simple_fill_super(sb, SELINUX_MAGIC, selinux_files);

In the prototype of the above function the type of the second argument is '=
int', when the=20
's_magic' type of the 'super_block' structure is 'unsigned long'.
In the patch i modified the type of the second argument of the function 'si=
mple_fill_super()'.=20
This solves my problem but, since this is used by other filesystems, i don'=
t known if this=20
solution is valid in general.

> > This patch applies to the mainline kernel repository.
> >=20
> >=20
> > >From a9f6d9bc7b2259ac025977f4b28a8b90784caf62 Mon Sep 17 00:00:00 2001
> > From: Roberto Sassu <roberto.sassu@polito.it>
> > Date: Tue, 1 Jun 2010 18:28:13 +0200
> > Subject: [PATCH] BUG: wrong type for magic argument in simple_fill_supe=
r(), fs/libfs.c
> >=20
> >=20
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
>=20
> Reviewed-by: Mimi Zohar <zohar@us.ibm.com>
>=20
> > ---
> >  fs/libfs.c         |    2 +-
> >  include/linux/fs.h |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index 09e1016..7d966e8 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> > @@ -489,7 +489,7 @@ int simple_write_end(struct file *file, struct addr=
ess_space *mapping,
> >   * unique inode values later for this filesystem, then you must take c=
are
> >   * to pass it an appropriate max_reserved value to avoid collisions.
> >   */
> > -int simple_fill_super(struct super_block *s, int magic, struct tree_de=
scr *files)
> > +int simple_fill_super(struct super_block *s, unsigned long magic, stru=
ct tree_descr *files)
> >  {
> >   	struct inode *inode;
> >         struct dentry *root;
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 3428393..471e1ff 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2388,7 +2388,7 @@ extern const struct file_operations simple_dir_op=
erations;
> >  extern const struct inode_operations simple_dir_inode_operations;
> >  struct tree_descr { char *name; const struct file_operations *ops; int=
 mode; };
> >  struct dentry *d_alloc_name(struct dentry *, const char *);
> > -extern int simple_fill_super(struct super_block *, int, struct tree_de=
scr *);
> > +extern int simple_fill_super(struct super_block *, unsigned long, stru=
ct tree_descr *);
> >  extern int simple_pin_fs(struct file_system_type *, struct vfsmount **=
mount, int *count);
> >  extern void simple_release_fs(struct vfsmount **mount, int *count);
> >=20
>=20
>=20
>=20

--nextPart1628879.SxsvaoqpPi
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGDzCCBgsw
ggTzoAMCAQICAgPBMA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xp
dGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eTAeFw0wODEyMDUxNjAwMDBaFw0xMDEyMzAxMjAwMDBaMHkxCzAJBgNV
BAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xMTAvBgNVBAsTKERpcGFydGlt
ZW50byBkaSBBdXRvbWF0aWNhIGUgSW5mb3JtYXRpY2ExFzAVBgNVBAMTDlJvYmVydG8gIFNhc3N1
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5L+V4w3Mbm/sUbvfK2Fa00852rwwQWnO
DuaPLgztSxL36xxvtATxM5ffrmr/6YHDFnupb46E0p+C/XgDfL+q6O7k/uaNOZM28pYOmxQGML60
Kz5alayAg9zbHFY+tHtuvThT9Jhg2zHKeHVO07aCxCsciP1L/A2I1E/wYY8ICK5hGVovYJ5JWfgk
QpxPTM54sgip8OncB3dh4GGP5xHdOuY71PIZM8IBvWjKr3C4DVPHTjiupJA1unR7RG86vAAikP/a
Y08/dF5N4HndpKCrSkIegfWzYBxj+NYnWOhgUL2GH/YOplG8w0iwztRx7kiLPayCXUjrUhQPjrnw
djMKYwIDAQABo4ICrzCCAqswgZUGCWCGSAGG+EIBDQSBhxaBhElzc3VlZCB1bmRlciBwb2xpY2ll
czoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLwogaHR0cDovL3d3dy5l
dXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLwogaHR0cDovL2NhLnBvbGl0by5pdC9jcHMvMi4xLzAR
BglghkgBhvhCAQEEBAMCALAwYwYIKwYBBQUHAQEEVzBVMCgGCCsGAQUFBzABhhxodHRwOi8vb2Nz
cC5ldXJvcGtpLm9yZzo4MDI2MCkGCCsGAQUFBzAChh1odHRwOi8vd3d3LmV1cm9wa2kub3JnL2Nh
L2l0LzAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8vY2EucG9saXRvLml0L2NybDAzL2NybC5kZXIw
DAYDVR0TAQH/BAIwADA6BgNVHREEMzAxgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdKAWBgorBgEE
AZViAgEBoAgWBjAyMTMwNTCBzQYDVR0gBIHFMIHCMEMGCisGAQQBqQcBAQEwNTAzBggrBgEFBQcC
ARYnaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMEEGCisGAQQBqQcCAQEw
MzAxBggrBgEFBQcCARYlaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzA4Bgor
BgEEAZViAQIBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wCwYD
VR0PBAQDAgTwMB0GA1UdDgQWBBQ/7fsOlEvqvkE2OCyAWMjwwe8ZNzAfBgNVHSMEGDAWgBQJ/SUZ
b+NofIJrNXO8KAC+LDw6ODANBgkqhkiG9w0BAQUFAAOCAQEANGPQ5YyCXMtdM+4o0P2AxMd3WJE/
NE0jVOJgU39YjK5reY16/rnAqfflXFtsxXqTvO7HF0Luj6JhEt6lU6enD3QB/9KIlFz1AjiuTy3N
KvnEgju8jR8+9yWuNIzKZcK/AqttjCsp7QWEGdJnwCh7BegcNDx/riF4shTyYta7CjX5uurSklQf
lD7r1YAYPTeWf6UWGTYqq9W/zIAPbU/J2tLtSTZksTuXv/4FNAFjxmOk1FnjgLr6juWi7bM3qWRa
1UcHBQ1V1+7fCRJN20Kb/LFHxdSUXJmQsd+FjX1VbiW7FvspngaI8oMRF1DAFvSSNrh6pI4GQA9Z
n1jzOm/hsDGCAhwwggIYAgEBMGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNv
IGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24g
QXV0aG9yaXR5AgIDwTAJBgUrDgMCGgUAoIGHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEwMDYwMzA5NTgyOFowIwYJKoZIhvcNAQkEMRYEFHoXKFE2koMnUaF143MC
SgBIHDHeMCgGCSqGSIb3DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA0GCSqGSIb3
DQEBAQUABIIBALQOyvI9158A8Z8inq0PBK0AK3WyfEh/Pd5rnsQra+e7mi9g8vm1pRaVVzEerYyQ
fSXCOGfbIyFX+HNoR0UmabX17rlklm/sJv8PNRbuoXF7vHhIXaz6yojMf9SFekPeXN9dft5lm8xg
a7do0b0Qh7l46aVkbXdbLlfQe1J0Trk6ILKPAcjRChD8IQQ7gTxLLt6NFeHYlu1hGKEMzNj0jaSj
LWhQAoaqykzHrBc89yiKmeI5SS/gtOOofD/ZDJl4JFDy/0Vh5+6eauRhOrVcxOon1+x4gmqCOTBr
IUTBIfGPtSxiPpEe6IwK5yVGD45PKhUCyrWqKWtwFisBUNU1kA0AAAAAAAA=

--nextPart1628879.SxsvaoqpPi--
