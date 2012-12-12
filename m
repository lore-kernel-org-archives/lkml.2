Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2LLWPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:15:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2LLWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:46 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-jvMD2h2GRkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0tz3qSQ_tzAA:10 a=20KFwNOVAAAA:8 a=N2_t3ZGiY-TM7tp_vEsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=pVb_JX6BmIwSOlTcbXEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221544.525456597@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] ktest: Test if target machine is up before install
References: <20121212221437.245229327@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Test-if-target-machine-is-up-before-install.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Sometimes a test kernel will crash or hang on reboot (this is even more
apparent when testing a config without CGROUPS on a box running
systemd). When this happens, on the next iteration of installing a
kernel, ktest will fail when it tries to install.

Have ktest do a check to see if the target can be connected to via ssh
before it tries to install. If it can't connect, then reboot again.
This time the reboot will fail because it can't connect and will force a
power cycle.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6b1e0c5..35fc584 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1807,6 +1807,14 @@ sub do_post_install {
 	dodie "Failed to run post install";
 }
=20
+# Sometimes the reboot fails, and will hang. We try to ssh to the box
+# and if we fail, we force another reboot, that should powercycle it.
+sub test_booted {
+    if (!run_ssh "echo testing connection") {
+	reboot $sleep_time;
+    }
+}
+
 sub install {
=20
     return if ($no_install);
@@ -1819,6 +1827,8 @@ sub install {
=20
     my $cp_target =3D eval_kernel_version $target_image;
=20
+    test_booted;
+
     run_scp_install "$outputdir/$build_target", "$cp_target" or
 	dodie "failed to copy image";
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQyQIQAAoJEOdOSU1xswtMutoIAKYF696zIT0ASQHdY7jsbXXN
K3AHBPbMtwVUM10JDRnuKDjCpaAnTiS7NbDbxyUml0sxHfruVT0763Gwb8eYbi2z
9rozOvy3aNRNBLYT0a5TVVGE55UQslMIBijr+WBFpRce8FsaE1/NoK457ktKCcrh
ee4Vab1PuYWTGt5LF+kaWadmf/gFF72Do58LcvzaL3K17gGiAxeKsnPezaU0LVou
Kj0QgCzF5He42r0IxhjSmPBqJP2qi/C5ADbeEIoKTMp0Fy7cnwk5kT3uC59O3drx
sjw3tQ1/e0Lb8L12Wnj+E3jQZs2nrizx7Gk9oW0iZh/OCTK4qXgdSjmAQVEOtcc=
=od5b
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
