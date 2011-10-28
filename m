Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1J1LUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1J1LUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:12 -0400
X-Authority-Analysis: v=1.1 cv=QqHiGEe6yGvmA2Hj/+B5Qdh2oWFRI3gWtdRZxD5t9t4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=sJ7mlw4ZgFUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=LhNPSl8vHYZcF8Syk74A:9 a=Vdf6MleSGQnVMSxM4RoA:7 a=QEXdDO2ut3YA:10 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Gav36qMsiirTAy4XNfgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028112009.453946163@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:16:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH 04/21] ktest: Include monitor in reboot code
References: <20111028111558.173726794@goodmis.org>
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

iQIcBAABAgAGBQJOqo/pAAoJEIy3vGnGbaoAbxMQAIeJOYxAhoTL/GD6mhlnE5xs
h4WSphkD3e9uOSQmfm++k/AdSQQol2r+MLkP9ze7dllA0kLu4UjVryLSNAwIoGwK
T+8fJ6Us/4auJc0nmzwUu5PFqPB8medhqkU0Hgo5GFcsOVQiffmeZ12c7so3yrES
urZxNMGZaeDPlbSVUEQMx/qsE886Aql7B5+YZ7fOGoV4tO88GfZUz3FYymBt5Kws
V6Zb2W5r2Beot6Ta53qg5ktoo1FzotGlEr0uAVg2gawTb2xQi/JM+fhEmqXbUVM0
TBsqR2DkDzfPbKvcUznu/gL1N42OxtsAIG22BE9iSZfYh0QojuYSG40H3wEJqBSv
5EiF3mMufJGeCs/hSuQWbqJmawUrbo1EhKAe0v0m9LnoS8E4y4cFObd9qVfFaGON
enXjcJF9GAbwxFZURdkmSqarVtxAwZz0RuFh4gpNyAIbqjAhlWzcBobxVFkQ7aGg
9ZopyRbBUtIt7Li9bF5qcPKjzRLoTpeSOs+BAJMRs6PJGrZVJms9s8JChIp7lwPK
D7YKhH6n+saUPs/U8XY8cCHRVe7hNjPY4ERT5GJuNYqnPi8VcdCQRXjjS7VjsUhQ
hXOqLsQFpU+kNyflMwNZBUizWBOjiRtS+ihkNJ8c2JwmOE4EWctrpo/NmPhK9vt9
nEx7YF+39aqzaHAtJH2a
=kLq5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
