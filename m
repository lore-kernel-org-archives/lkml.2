Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0KPQ1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:27:04 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36627 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344Ab0KPQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:27:01 -0500
X-Sasl-enc: y43GbXupURLyJVYN2CDmZx/ityiyeK1Sv2PaeHjoPEFW 1289924820
To: linux-security-module@vger.kernel.org
Subject: [PATCH] selinux: introduced new mount parameter umountcontext
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
Date: Tue, 16 Nov 2010 17:24:35 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1370425.BGfgtQ3ukn";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201011161724.39617.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1370425.BGfgtQ3ukn
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sorry for resending. I'm including the linux-kernel mailing list in the CC =
list.


This parameter has been introduced in order to properly detect when a
filesystem is unmounted, by setting an appropriate label to the
mountpoint inode, that can be seen after the operation is done.
The label set is not stored persistently, so that the inode will get
the previous one after a system reboot.
One possible application of this new feature is that it will be possible
to deny accesses on the path where a filesystem is mounted on if the last
is unmounted for example by malicious or compromised software.
This will prevent applications referring to a given path to see files
belonging to a different filesystem.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 security/selinux/hooks.c            |   70 +++++++++++++++++++++++++++++++=
++-
 security/selinux/include/objsec.h   |    1 +
 security/selinux/include/security.h |    2 +
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5c9f25b..2cc3a8a 100644
=2D-- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -334,6 +334,7 @@ enum {
 	Opt_defcontext =3D 3,
 	Opt_rootcontext =3D 4,
 	Opt_labelsupport =3D 5,
+	Opt_umountcontext =3D 6,
 };
=20
 static const match_table_t tokens =3D {
@@ -342,6 +343,7 @@ static const match_table_t tokens =3D {
 	{Opt_defcontext, DEFCONTEXT_STR "%s"},
 	{Opt_rootcontext, ROOTCONTEXT_STR "%s"},
 	{Opt_labelsupport, LABELSUPP_STR},
+	{Opt_umountcontext, UMOUNTCONTEXT_STR "%s"},
 	{Opt_error, NULL},
 };
=20
@@ -496,6 +498,10 @@ static int selinux_get_mnt_opts(const struct super_blo=
ck *sb,
 	if (sbsec->flags & SE_SBLABELSUPP)
 		opts->num_mnt_opts++;
=20
+	/* Check if the umountcontext flag is set */
+	if (sbsec->flags & UMOUNTCONTEXT_MNT)
+		opts->num_mnt_opts++;
+
 	opts->mnt_opts =3D kcalloc(opts->num_mnt_opts, sizeof(char *), GFP_ATOMIC=
);
 	if (!opts->mnt_opts) {
 		rc =3D -ENOMEM;
@@ -544,6 +550,13 @@ static int selinux_get_mnt_opts(const struct super_blo=
ck *sb,
 		opts->mnt_opts[i] =3D NULL;
 		opts->mnt_opts_flags[i++] =3D SE_SBLABELSUPP;
 	}
+	if (sbsec->flags & UMOUNTCONTEXT_MNT) {
+		rc =3D security_sid_to_context(sbsec->umount_sid, &context, &len);
+		if (rc)
+			goto out_free;
+		opts->mnt_opts[i] =3D context;
+		opts->mnt_opts_flags[i++] =3D UMOUNTCONTEXT_MNT;
+	}
=20
 	BUG_ON(i !=3D opts->num_mnt_opts);
=20
@@ -588,7 +601,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	struct inode *inode =3D sbsec->sb->s_root->d_inode;
 	struct inode_security_struct *root_isec =3D inode->i_security;
 	u32 fscontext_sid =3D 0, context_sid =3D 0, rootcontext_sid =3D 0;
=2D	u32 defcontext_sid =3D 0;
+	u32 defcontext_sid =3D 0, umountcontext_sid =3D 0;
 	char **mount_options =3D opts->mnt_opts;
 	int *flags =3D opts->mnt_opts_flags;
 	int num_opts =3D opts->num_mnt_opts;
@@ -680,6 +693,16 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 			sbsec->flags |=3D DEFCONTEXT_MNT;
=20
 			break;
+		case UMOUNTCONTEXT_MNT:
+			umountcontext_sid =3D sid;
+
+			if (bad_option(sbsec, UMOUNTCONTEXT_MNT,
+					sbsec->umount_sid, umountcontext_sid))
+				goto out_double_mount;
+
+			sbsec->flags |=3D UMOUNTCONTEXT_MNT;
+
+			break;
 		default:
 			rc =3D -EINVAL;
 			goto out;
@@ -767,6 +790,15 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		sbsec->def_sid =3D defcontext_sid;
 	}
=20
+	if (umountcontext_sid) {
+		rc =3D may_context_mount_sb_relabel(umountcontext_sid,
+						  sbsec, cred);
+		if (rc)
+			goto out;
+
+		sbsec->umount_sid =3D umountcontext_sid;
+	}
+
 	rc =3D sb_finish_set_opts(sb);
 out:
 	mutex_unlock(&sbsec->lock);
@@ -809,6 +841,7 @@ static void selinux_sb_clone_mnt_opts(const struct supe=
r_block *oldsb,
 	newsbsec->sid =3D oldsbsec->sid;
 	newsbsec->def_sid =3D oldsbsec->def_sid;
 	newsbsec->behavior =3D oldsbsec->behavior;
+	newsbsec->umount_sid =3D oldsbsec->umount_sid;
=20
 	if (set_context) {
 		u32 sid =3D oldsbsec->mntpoint_sid;
@@ -841,6 +874,7 @@ static int selinux_parse_opts_str(char *options,
 	char *p;
 	char *context =3D NULL, *defcontext =3D NULL;
 	char *fscontext =3D NULL, *rootcontext =3D NULL;
+	char *umountcontext =3D NULL;
 	int rc, num_mnt_opts =3D 0;
=20
 	opts->num_mnt_opts =3D 0;
@@ -909,6 +943,13 @@ static int selinux_parse_opts_str(char *options,
 			break;
 		case Opt_labelsupport:
 			break;
+		case Opt_umountcontext:
+			umountcontext =3D match_strdup(&args[0]);
+			if (!umountcontext) {
+				rc =3D -ENOMEM;
+				goto out_err;
+			}
+			break;
 		default:
 			rc =3D -EINVAL;
 			printk(KERN_WARNING "SELinux:  unknown mount option\n");
@@ -945,6 +986,12 @@ static int selinux_parse_opts_str(char *options,
 		opts->mnt_opts_flags[num_mnt_opts++] =3D DEFCONTEXT_MNT;
 	}
=20
+	if (umountcontext) {
+		opts->mnt_opts[num_mnt_opts] =3D umountcontext;
+		opts->mnt_opts_flags[num_mnt_opts++] =3D UMOUNTCONTEXT_MNT;
+	}
+
+
 	opts->num_mnt_opts =3D num_mnt_opts;
 	return 0;
=20
@@ -953,6 +1000,7 @@ out_err:
 	kfree(defcontext);
 	kfree(fscontext);
 	kfree(rootcontext);
+	kfree(umountcontext);
 	return rc;
 }
 /*
@@ -1010,6 +1058,9 @@ static void selinux_write_opts(struct seq_file *m,
 		case DEFCONTEXT_MNT:
 			prefix =3D DEFCONTEXT_STR;
 			break;
+		case UMOUNTCONTEXT_MNT:
+			prefix =3D UMOUNTCONTEXT_STR;
+			break;
 		case SE_SBLABELSUPP:
 			seq_putc(m, ',');
 			seq_puts(m, LABELSUPP_STR);
@@ -2413,7 +2464,8 @@ static inline int selinux_option(char *option, int le=
n)
 		match_prefix(FSCONTEXT_STR, sizeof(FSCONTEXT_STR)-1, option, len) ||
 		match_prefix(DEFCONTEXT_STR, sizeof(DEFCONTEXT_STR)-1, option, len) ||
 		match_prefix(ROOTCONTEXT_STR, sizeof(ROOTCONTEXT_STR)-1, option, len) ||
=2D		match_prefix(LABELSUPP_STR, sizeof(LABELSUPP_STR)-1, option, len));
+		match_prefix(LABELSUPP_STR, sizeof(LABELSUPP_STR)-1, option, len) ||
+		match_prefix(UMOUNTCONTEXT_STR, sizeof(UMOUNTCONTEXT_STR)-1, option, len=
));
 }
=20
 static inline void take_option(char **to, char *from, int *first, int len)
@@ -2538,9 +2590,21 @@ static int selinux_mount(char *dev_name,
 static int selinux_umount(struct vfsmount *mnt, int flags)
 {
 	const struct cred *cred =3D current_cred();
+	struct inode_security_struct *isec =3D mnt->mnt_mountpoint->d_inode->i_se=
curity;
+	struct superblock_security_struct *sbsec =3D mnt->mnt_sb->s_security;
+	int rc;
=20
=2D	return superblock_has_perm(cred, mnt->mnt_sb,
+	rc =3D superblock_has_perm(cred, mnt->mnt_sb,
 				   FILESYSTEM__UNMOUNT, NULL);
+
+	if (!rc) {
+		mutex_lock(&isec->lock);
+		if (sbsec->flags & UMOUNTCONTEXT_MNT)
+			isec->sid =3D sbsec->umount_sid;
+		mutex_unlock(&isec->lock);
+	}
+
+	return rc;
 }
=20
 /* inode security operations */
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/o=
bjsec.h
index 26c7eee..4b51ead 100644
=2D-- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -58,6 +58,7 @@ struct superblock_security_struct {
 	u32 sid;			/* SID of file system superblock */
 	u32 def_sid;			/* default SID for labeling */
 	u32 mntpoint_sid;		/* SECURITY_FS_USE_MNTPOINT context for files */
+	u32 umount_sid;			/* SID assigned to the mountpoint inode */
 	unsigned int behavior;		/* labeling behavior */
 	unsigned char flags;		/* which mount options were specified */
 	struct mutex lock;
diff --git a/security/selinux/include/security.h b/security/selinux/include=
/security.h
index 1f7c249..f7768cf 100644
=2D-- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -47,12 +47,14 @@
 #define SE_SBINITIALIZED	0x10
 #define SE_SBPROC		0x20
 #define SE_SBLABELSUPP	0x40
+#define UMOUNTCONTEXT_MNT	0x80
=20
 #define CONTEXT_STR	"context=3D"
 #define FSCONTEXT_STR	"fscontext=3D"
 #define ROOTCONTEXT_STR	"rootcontext=3D"
 #define DEFCONTEXT_STR	"defcontext=3D"
 #define LABELSUPP_STR "seclabel"
+#define UMOUNTCONTEXT_STR "umountcontext=3D"
=20
 struct netlbl_lsm_secattr;
=20
=2D-=20
1.7.2.3


--nextPart1370425.BGfgtQ3ukn
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
Fw0xMDExMTYxNjI0MzZaMCMGCSqGSIb3DQEJBDEWBBQ4HSmiu6KqvitcLvYgGFKNfXmjWTAoBgkq
hkiG9w0BCQ8xGzAZMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQCZ
2JofAKzcn9ybioIrWr33BWtK2I5YONbBEmhPMA1nCgXZjDz8ADDDtwdFXfO0TTkVAbNZc5t5skwi
4NdznQWJ+77JiRw0PKNpnoz2QHScGdKGVmmVvl4Ay3X5024UhnD16rpzZuO/pa/ptlE1OfdR//DY
PUfBbFmbdNKDvRpQvU8/FqUfGI5XY2hS9FMgC2NS/+ifhmL5RdZy3pbrVoJFShimbtZBG1nWDl4p
WsGrJCHuMAAzZOK8o1jo4s20Xst8m8ZrH7mM0SbUryZom18otSyuRPCKZyGdXAVFXdQ2TWW5V9Fg
mOBCs/CtdB/ir0b4XjWz8p9i0+eXivpSWouwAAAAAAAA

--nextPart1370425.BGfgtQ3ukn--
