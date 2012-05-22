Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2EVMGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:06:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2EVMGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:31 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=pfqmd9XoVUcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=wWU3qhqnOSgc2wo17lcA:9 a=aWRuADsPgT1MXMToN8AA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=upfMwAWJQWFWvjUzpC4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120629.880061783@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/8] ktest: Fix kernelrevision with POST_BUILD
References: <20120522120531.460108326@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Fix-kernelrevision-with-POST_BUILD.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The PRE_BUILD and POST_BUILD options of ktest are added to allow the
user to add temporary patch to the system and remove it on builds. This
is sometimes use to take a change from another git branch and add it to
a series without the fix so that this series can be tested, when an
unrelated bug exists in the series.

The problem comes when a tagged commit is being used. For example, if
v3.2 is being tested, and we add a patch to it, the kernelrelease for
that commit will be 3.2.0+, but without the patch the version will be
3.2.0. This can cause problems when the kernelrelease is determined for
creating the /lib/modules directory. The kernel booting has the '+' but
the module directory will not, and the modules will be missing for that
boot, and may not allow the kernel to succeed.

The fix is to put the creation of the kernelrelease in the POST_BUILD
logic, before it applies the POST_BUILD operation. The POST_BUILD is
where the patch may be removed, removing the '+' from the kernelrelease.

The calculation of the kernelrelease will also stay in its current
location but will be ignored if it was already calculated previously.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 4915408..50b6726 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -66,6 +66,7 @@ my %default =3D (
=20
 my $ktest_config;
 my $version;
+my $have_version =3D 0;
 my $machine;
 my $ssh_user;
 my $tmpdir;
@@ -1702,10 +1703,12 @@ sub install {
=20
 sub get_version {
     # get the release name
+    return if ($have_version);
     doprint "$make kernelrelease ... ";
     $version =3D `$make kernelrelease | tail -1`;
     chomp($version);
     doprint "$version\n";
+    $have_version =3D 1;
 }
=20
 sub start_monitor_and_boot {
@@ -1828,6 +1831,9 @@ sub build {
     my $save_no_reboot =3D $no_reboot;
     $no_reboot =3D 1;
=20
+    # Calculate a new version from here.
+    $have_version =3D 0;
+
     if (defined($pre_build)) {
 	my $ret =3D run_command $pre_build;
 	if (!$ret && defined($pre_build_die) &&
@@ -1887,6 +1893,9 @@ sub build {
     undef $redirect;
=20
     if (defined($post_build)) {
+	# Because a post build may change the kernel version
+	# do it now.
+	get_version;
 	my $ret =3D run_command $post_build;
 	if (!$ret && defined($post_build_die) &&
 	    $post_build_die) {
@@ -3474,6 +3483,8 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $no_reboot =3D 1;
     $reboot_success =3D 0;
=20
+    $have_version =3D 0;
+
     $iteration =3D $i;
=20
     my $makecmd =3D set_test_option("MAKE_CMD", $i);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FFAAoJEIy3vGnGbaoAyz4P/Ag8joWX9m8m0RyofmZ1QeCb
T+mJzIsSTAvokCYrqimy3JXJ4OBu69qYhZH3rxd0KaWNcFO4wZB9gJcMH47O63xu
XzAW45X2wQCFCV1jY6bFKqJXF0ze1vDHFeN2Dsf4Ereb5jhRU25m1b/52R9qqtea
lTWo8sSUkDiVc86gR7lGIYjfldLV/k2W3Xg7t6sFaIpLj6Bn/ayn9l+yqTJ3FxWk
KiP/8ZnQBm3EVkcwM5/8Egovwvpd3KghImQeatpwruS3rl+JH7mTf+iVGMzRaI6B
6H7/a69XBlvhvdNj+h81pd3qLsgZH+GEgI8wcVH7T6c8ENA0KS2tD6w/ucFAAQJ3
NMR2a65HPyB9nx9Swii1DjoCem+MmU3z6xoHGaTH5pGhD5a5EOg6HGeXi8s8nzYP
wKSVDGUq32y1zcX5umTDV9jodYIusKq9bdMJlR6pARL+G/p08G0q69287pkD6eqH
bBwKJEPpjFJwTVMI+NzN+qzroCkTL6nHWqU0oTkEPl/7s2mXQTa/autqVUkzO2S8
TYbRm/nnnzSc2wCXu7niaWxi9d98Uv14U/FB3As9ao6Afs4g9FqmCSZdHyIxFaY1
R933Rs455rElnyKgS3uwrbZCZ3xgwuujZGs+V+AnHqN3RNQpbTKLLIYt+De5vN8v
RTgwIqDsDGaJn3sjrSL5
=Vbym
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
