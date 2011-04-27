Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1D0MgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:36:24 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44801 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754765Ab1D0MgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:36:22 -0400
X-Sasl-enc: uvaSZuZItgbmifGbdR2GC1mOLv2d0QiEoCY2MRKC4Gsh 1303907781
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 1/7] fs: initialize file->f_cred with credentials provided
Date: Wed, 27 Apr 2011 14:34:09 +0200
Message-Id: <1303907657-18366-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----224F974968F4756AC202C194A81B7B40"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------224F974968F4756AC202C194A81B7B40

The 'f_cred' field of a file descriptor is initialized with the credentials
of the 'current' process except in the case they are provided to the
function dentry_open(). The get_empty_filp() function's definition has been
modified to take these credentials set as argument.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/file_table.c |    5 ++---
 fs/internal.h   |    2 +-
 fs/namei.c      |    2 +-
 fs/open.c       |    2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 01e4c1e..c33018c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -102,9 +102,8 @@ int proc_nr_files(ctl_table *table, int write,
  * done, you will imbalance int the mount's writer count
  * and a warning at __fput() time.
  */
-struct file *get_empty_filp(void)
+struct file *get_empty_filp(const struct cred *cred)
 {
-	const struct cred *cred = current_cred();
 	static long old_max;
 	struct file * f;
 
@@ -171,7 +170,7 @@ struct file *alloc_file(struct path *path, fmode_t mode,
 {
 	struct file *file;
 
-	file = get_empty_filp();
+	file = get_empty_filp(current_cred());
 	if (!file)
 		return NULL;
 
diff --git a/fs/internal.h b/fs/internal.h
index b29c46e..c81fc62 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -91,7 +91,7 @@ extern void chroot_fs_refs(struct path *, struct path *);
 extern void file_sb_list_add(struct file *f, struct super_block *sb);
 extern void file_sb_list_del(struct file *f);
 extern void mark_files_ro(struct super_block *);
-extern struct file *get_empty_filp(void);
+extern struct file *get_empty_filp(const struct cred *cred);
 
 /*
  * super.c
diff --git a/fs/namei.c b/fs/namei.c
index 54fc993..88ac2e5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2321,7 +2321,7 @@ static struct file *path_openat(int dfd, const char *pathname,
 	struct path path;
 	int error;
 
-	filp = get_empty_filp();
+	filp = get_empty_filp(current_cred());
 	if (!filp)
 		return ERR_PTR(-ENFILE);
 
diff --git a/fs/open.c b/fs/open.c
index b52cf01..6b033e6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -839,7 +839,7 @@ struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 	BUG_ON(!mnt);
 
 	error = -ENFILE;
-	f = get_empty_filp();
+	f = get_empty_filp(cred);
 	if (f == NULL) {
 		dput(dentry);
 		mntput(mnt);
-- 
1.7.4.4


------224F974968F4756AC202C194A81B7B40
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjcxMjM0MzBaMCMGCSqG
SIb3DQEJBDEWBBQEH0JjN+72IP64HuOMLEZgQoVDujB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQACOlak+CkiQx8Qk/QQ6fryWBKP
9gPYxPUOEzGJBuHpQDupWM9dAAvQDKOPY8F98FU0N9USrqAQWjZ/bgIEHjVbD6TU
RBmQR9HvQOjqrzP3LzoSoESGs34y8/rMwzVjWuIeRHhnXRwDvssFiBBnSD+NM9Kc
95mS4ZDsQZGaUlUPyhhVu1L4gHFyLcosuZgaxRmGjQyQ5BFopbYOIJ0S9VMSbvRF
6CYjXbvDvJJ1XzkIUs3LXMGzY7I9e/T5+qFkls57ssguWL7gCShalEminc5PlKPK
0JxXKLDueQLe235YotlOg19FTNIM5z4eykF5afBPqfgRn+czR7YIDRe8fYYK

------224F974968F4756AC202C194A81B7B40--


