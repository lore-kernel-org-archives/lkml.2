Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1JQRCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:02:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab1JQQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:51 -0400
X-Authority-Analysis: v=1.1 cv=UpSRffbr9y8V5xg6O7MBcDNOk5f8u00m038obrfOR4U= c=1 sm=0 a=vhdKIqpQuCYA:10 a=--LIOv-RJUcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QlXiSC5AU3UIl9oztH4A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=cNJ0hGFZyKKXBWhUCE8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165950.152955930@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/17][RFC] ktest: Add option REBOOT_SUCCESS_LINE to stop waiting after a reboot
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0007-ktest-Add-option-REBOOT_SUCCESS_LINE-to-stop-waiting.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When ktest.pl reboots, it will usuall wait SLEEP_TIME seconds of idle
console before starting the next test. By setting the
REBOOT_SUCCESS_LINE, ktest will not wait SLEEP_TIME when it detects the
line while rebooting to a new kernel.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   33 +++++++++++++++++++++++++++------
 tools/testing/ktest/sample.conf |   10 ++++++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 74fb2ac..51ddaa5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -117,6 +117,7 @@ my $timeout;
 my $booted_timeout;
 my $detect_triplefault;
 my $console;
+my $reboot_success_line;
 my $success_line;
 my $stop_after_success;
 my $stop_after_failure;
@@ -612,6 +613,13 @@ sub wait_for_monitor;
 sub reboot {
     my ($time) =3D @_;
=20
+    if (defined($time)) {
+	start_monitor;
+	# flush out current monitor
+	# May contain the reboot success line
+	wait_for_monitor 1;
+    }
+
     # try to reboot normally
     if (run_command $reboot) {
 	if (defined($powercycle_after_reboot)) {
@@ -624,8 +632,7 @@ sub reboot {
     }
=20
     if (defined($time)) {
-	start_monitor;
-	wait_for_monitor $time;
+	wait_for_monitor($time, $reboot_success_line);
 	end_monitor;
     }
 }
@@ -706,16 +713,29 @@ sub end_monitor {
 }
=20
 sub wait_for_monitor {
-    my ($time) =3D @_;
+    my ($time, $stop) =3D @_;
+    my $full_line =3D "";
     my $line;
+    my $booted =3D 0;
=20
     doprint "** Wait for monitor to settle down **\n";
=20
     # read the monitor and wait for the system to calm down
-    do {
+    while (!$booted) {
 	$line =3D wait_for_input($monitor_fp, $time);
-	print "$line" if (defined($line));
-    } while (defined($line));
+	last if (!defined($line));
+	print "$line";
+	$full_line .=3D $line;
+
+	if (defined($stop) && $full_line =3D~ /$stop/) {
+	    doprint "wait for monitor detected $stop\n";
+	    $booted =3D 1;
+	}
+
+	if ($line =3D~ /\n/) {
+	    $full_line =3D "";
+	}
+    }
     print "** Monitor flushed **\n";
 }
=20
@@ -2836,6 +2856,7 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     $console =3D set_test_option("CONSOLE", $i);
     $detect_triplefault =3D set_test_option("DETECT_TRIPLE_FAULT", $i);
     $success_line =3D set_test_option("SUCCESS_LINE", $i);
+    $reboot_success_line =3D set_test_option("REBOOT_SUCCESS_LINE", $i);
     $stop_after_success =3D set_test_option("STOP_AFTER_SUCCESS", $i);
     $stop_after_failure =3D set_test_option("STOP_AFTER_FAILURE", $i);
     $stop_test_after =3D set_test_option("STOP_TEST_AFTER", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index b3e0dc1..67bc4e0 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -423,6 +423,14 @@
 # (default "login:")
 #SUCCESS_LINE =3D login:
=20
+# To speed up between reboots, defining a line that the
+# default kernel produces that represents that the default
+# kernel has successfully booted and can be used to pass
+# a new test kernel to it. Otherwise ktest.pl will wait till
+# SLEEP_TIME to continue.
+# (default undefined)
+#REBOOT_SUCCESS_LINE =3D login:
+
 # In case the console constantly fills the screen, having
 # a specified time to stop the test after success is recommended.
 # (in seconds)
@@ -488,6 +496,8 @@
 # another test. If a reboot to the reliable kernel happens,
 # we wait SLEEP_TIME for the console to stop producing output
 # before starting the next test.
+#
+# You can speed up reboot times even more by setting REBOOT_SUCCESS_LINE.
 # (default 60)
 #SLEEP_TIME =3D 60
=20
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8GAAoJEIy3vGnGbaoAj3wQAOP4iPVm8hJYgV0+s26UScy0
ze/0WNbRN7ThNhjgmhEXmf+dJrUCvddLrtjiqS0UODhHqOAgcvTJCkXG1IgkkuWw
s8GvsMqRN3YqHKNHQzRfMef40sO1O4MTiOGkzge0DmVeeqndJ8NMI+0ameQSDfMs
CkEesHkyBHyUsM0xhyU18NiniBa/E/0UFWb4+hK7GVugGjG9CcAKpBw2rh8D4rpu
GsB4G5kXQeCGOnyooZySwnI4yOkl/MT1+fMxltVjMvHNtzZMgtnWmmpcniXmzkWp
4S96LjnItAQCkt9ekf4gLPnZIIHkbusjWTuo2RtWh3woOsJPs9Nl8RFBAPonoCbe
YYgaJI1al8CPR4aVOFfq0NWbzdaM3a/gDourkcKAHE/UXHHpLtgUaVsVA9xE3LoY
qGPZkga/dSzW2AL0zoI+01+xADJHGP6JKNU7w+61y8xQoWs5XKXIxoQZCJ/6OWv7
O2RGBsyqSzzQWIb4tDc561NDrmQSwirZhZKUkhtVm/hLWwDFHDzTWI0Yh9drmpTr
POZAKb+gKORYhIaZboL/JIS+2jsbzZ18B0PBf7iZasyDAjoRX0fVqFHy3X0l/8xE
VgfTJ+kArenU47aJSevCqAEoctU8ea6IgH05yPGgO8RH5dec18aTnDdpmu2nd0A0
wi5jzHrCXtt6pf0QWnif
=56mS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
