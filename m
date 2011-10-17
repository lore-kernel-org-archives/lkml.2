Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1JQRDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:03:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45329 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1JQQ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:50 -0400
X-Authority-Analysis: v=1.1 cv=G2mrdTwFgeQf4gnIVCGl5REDSA/JVLCrZmxI9r5hHjY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=7C5jyeMLIsgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=LhNPSl8vHYZcF8Syk74A:9 a=Vdf6MleSGQnVMSxM4RoA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Ffi7gn7hV_0EkP3OpA4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165948.719640621@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:04:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 04/17][RFC] ktest: Include monitor in reboot code
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Include-monitor-in-reboot-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Andrew Jones <drjones@redhat.com>

Several places that call reboot do the same thing with respect to the
monitor. By adding this code into the reboot code, redundant code is
removed and it paves the way for the the reset time patch.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Link: http://lkml.kernel.org/r/1313155932-20092-4-git-send-email-drjones@re=
dhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 20b0e73..debc689 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -603,8 +603,13 @@ sub doprint {
 }
=20
 sub run_command;
+sub start_monitor;
+sub end_monitor;
+sub wait_for_monitor;
=20
 sub reboot {
+    my ($time) =3D @_;
+
     # try to reboot normally
     if (run_command $reboot) {
 	if (defined($powercycle_after_reboot)) {
@@ -615,6 +620,12 @@ sub reboot {
 	# nope? power cycle it.
 	run_command "$power_cycle";
     }
+
+    if (defined($time)) {
+	start_monitor;
+	wait_for_monitor $time;
+	end_monitor;
+    }
 }
=20
 sub do_not_reboot {
@@ -719,10 +730,7 @@ sub fail {
 	# no need to reboot for just building.
 	if (!do_not_reboot) {
 	    doprint "REBOOTING\n";
-	    reboot;
-	    start_monitor;
-	    wait_for_monitor $sleep_time;
-	    end_monitor;
+	    reboot $sleep_time;
 	}
=20
 	my $name =3D "";
@@ -1356,10 +1364,7 @@ sub success {
=20
     if ($i !=3D $opt{"NUM_TESTS"} && !do_not_reboot) {
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot;
-	start_monitor;
-	wait_for_monitor $sleep_time;
-	end_monitor;
+	reboot $sleep_time;
     }
 }
=20
@@ -1500,10 +1505,7 @@ sub run_git_bisect {
=20
 sub bisect_reboot {
     doprint "Reboot and sleep $bisect_sleep_time seconds\n";
-    reboot;
-    start_monitor;
-    wait_for_monitor $bisect_sleep_time;
-    end_monitor;
+    reboot $bisect_sleep_time;
 }
=20
 # returns 1 on success, 0 on failure, -1 on skip
@@ -2066,10 +2068,7 @@ sub config_bisect {
=20
 sub patchcheck_reboot {
     doprint "Reboot and sleep $patchcheck_sleep_time seconds\n";
-    reboot;
-    start_monitor;
-    wait_for_monitor $patchcheck_sleep_time;
-    end_monitor;
+    reboot $patchcheck_sleep_time;
 }
=20
 sub patchcheck {
@@ -2659,10 +2658,7 @@ sub make_min_config {
 	}
=20
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot;
-	start_monitor;
-	wait_for_monitor $sleep_time;
-	end_monitor;
+	reboot $sleep_time;
     }
=20
     success $i;
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8EAAoJEIy3vGnGbaoAXZEP/jzcNbmF+N7gKRvegLxDGXIa
h5Uatx+35jdWWHd7mJWbx+/z+lBoZNGMvqWX9le462ItCyjRRy9sbF7KgPNTikSu
SQN1r2SwhgASaOcJN9pWiZ8E5U72OMirLD1ByyD5AuVyp3WKBXXah7gz0LOoZOmo
WL8IVtEs3aq4z8O+XsQPRtBmq6OwGHmOc4A2z5m2obtZM8bvud9/R3uaOpTcSjeG
n5eU6hwgH4042z1ao/MWuoTqu5nHvHjCZcm0d0zwLHV5+o1zojnf3+Cu0kK0n8pP
gcNFL+g3eR8r5MmGpY3scG4Xs/hBb9zBCMfXUhCDyLkvKMEGBVVf8KClH4KNz58l
WetEQKgTimIhFyn0xhSzObsZ9guzcY1A6i0wxH/Vhj9SyEkaPCrDoNJBZDEi3nkx
G61WqJIEDugwt4JFHL0xMP3PpU55HKzIKQvMrLdScG1wdc9YSSoidDxSOpeDa1vx
JQOWldwUuS8OhwR/m4PPJUwqDM4uM9YyhPGr0Y6F1msFuISbjj2a2d4k5suobm9W
eb2qM8Qk8Gz4DC98bcz8iv/wGZExJ2d/5uRh1+8QXBh/1KMOjIZpEPzt5/3dhXVQ
GmCW8VwWSsbA25BIAyLoAaG7AbMEQNnmCICUA3zKeQDAsUyFaqujpTL0ksJczZm9
xD9Yy08oVdadSHYUeA4w
=oyRd
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
