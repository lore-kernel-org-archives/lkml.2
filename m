Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2FTCuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:50:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2FTCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:50:06 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=pGYlzOKfiEwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=qrFA_WvyAAAA:8 a=qJgER5RU2pfj1r0b-p4A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=bdmcM0_chmsA:10 a=jeBq3FmKZ4MA:10 a=QoWkRonxAqWaY8m1:21 a=fQ5rLMVGHjH3bZ7d:21 a=SCRDvdLp12zf8e06TzEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120620025004.888565203@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Jun 2012 22:06:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: John David Yost <johnyost@ptd.net>
Subject: [PATCH 3/4] localmodconfig: Check if configs are already set for selects
References: <20120620020608.911616775@goodmis.org>
Content-Disposition: inline; filename=0003-localmodconfig-Check-if-configs-are-already-set-for-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

There are some cases that a required module does not have a prompt
and needs to have another module enabled that selects it to be set.
As localmodconfig is conservative and tries to make the minimum config
without breaking the user's kernel, or keeping the user from using
devices that were loaded when the lsmod was done, all modules that
select this module will also be enabled.

If you needed module A, but module A did not have a prompt but needed
module B to be selected, localmodconfig would make sure B was still
enabled. If not only B selected A, but C, D, E, F, and G also
selected A, then all of those would also be included, as well as the
modules they depend on. This ballooned the number of configs that
localmodconfig would keep.

The fix here is to process the depends first, and then record those
configs that did not have a prompt and needed to be selected.
After the depends are done, check what configs are needed to select
the configs in the list, and if a config that selects it is already
set, then we don't need to do anything else.

If no config that selects the config is set, then just pick one and
try again.

This change brought down the number of selected modules from 290
to 67! Both before and after were run against a config that had 3095
modules enabled.

Tested-by: John David Yost <johnyost@ptd.net> # AlleyTrotter
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |  115 ++++++++++++++++++++++++++++++=
----
 1 file changed, 104 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streaml=
ine_config.pl
index ab4985f..fcfcb30 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -420,7 +420,7 @@ my $repeat =3D 1;
 # to keep on. If A was on in the original config, B would not have been
 # and B would not be turned on by this script.
 #
-sub parse_config_dep_select
+sub parse_config_depends
 {
     my ($p) =3D @_;
=20
@@ -448,26 +448,119 @@ sub parse_config_dep_select
     }
 }
=20
-while ($repeat) {
-    $repeat =3D 0;
+# Select is treated a bit differently than depends. We call this
+# when a config has no prompt and requires another config to be
+# selected. We use to just select all configs that selected this
+# config, but found that that can balloon into enabling hundreds
+# of configs that we do not care about.
+#
+# The idea is we look at all the configs that select it. If one
+# is already in our list of configs to enable, then there's nothing
+# else to do. If there isn't, we pick the first config that was
+# enabled in the orignal config and use that.
+sub parse_config_selects
+{
+    my ($config, $p) =3D @_;
=20
-    foreach my $config (keys %configs) {
-	$config =3D~ s/^CONFIG_//;
+    my $next_config;
+
+    while ($p =3D~ /[$valid]/) {
+
+	if ($p =3D~ /^[^$valid]*([$valid]+)/) {
+	    my $conf =3D "CONFIG_" . $1;
+
+	    $p =3D~ s/^[^$valid]*[$valid]+//;
=20
-	if (defined($depends{$config})) {
-	    # This config has dependencies. Make sure they are also included
-	    parse_config_dep_select $depends{$config};
+	    # Make sure that this config exists in the current .config file
+	    if (!defined($orig_configs{$conf})) {
+		next;
+	    }
+
+	    # Check if something other than a module selects this config
+	    if (defined($orig_configs{$conf}) && $orig_configs{$conf} ne "m") {
+		# we are good with this
+		return;
+	    }
+	    if (defined($configs{$conf})) {
+		# A set config selects this config, we are good
+		return;
+	    }
+	    # Set this config to be selected
+	    if (!defined($next_config)) {
+		$next_config =3D $conf;
+	    }
+	} else {
+	    die "this should never happen";
 	}
+    }
=20
-	if (defined($prompts{$config}) || !defined($selects{$config})) {
-	    next;
+    # If no possible config selected this, then something happened.
+    if (!defined($next_config)) {
+	print STDERR "WARNING: $config is required, but nothing in the\n";
+	print STDERR "  current config selects it.\n";
+	return;
+    }
+
+    # If we are here, then we found no config that is set and
+    # selects this config. Repeat.
+    $repeat =3D 1;
+    # Make this config need to be selected
+    $configs{$next_config} =3D 1;
+}
+
+my %process_selects;
+
+# loop through all configs, select their dependencies.
+sub loop_depend {
+    $repeat =3D 1;
+
+    while ($repeat) {
+	$repeat =3D 0;
+
+      forloop:
+	foreach my $config (keys %configs) {
+
+	    # If this config is not a module, we do not need to process it
+	    if (defined($orig_configs{$config}) && $orig_configs{$config} ne "m")=
 {
+		next forloop;
+	    }
+
+	    $config =3D~ s/^CONFIG_//;
+
+	    if (defined($depends{$config})) {
+		# This config has dependencies. Make sure they are also included
+		parse_config_depends $depends{$config};
+	    }
+
+	    # If the config has no prompt, then we need to check if a config
+	    # that is enabled selected it. Or if we need to enable one.
+	    if (!defined($prompts{$config}) && defined($selects{$config})) {
+		$process_selects{$config} =3D 1;
+	    }
 	}
+    }
+}
+
+sub loop_select {
+
+    foreach my $config (keys %process_selects) {
+	$config =3D~ s/^CONFIG_//;
=20
 	# config has no prompt and must be selected.
-	parse_config_dep_select $selects{$config};
+	parse_config_selects $config, $selects{$config};
     }
 }
=20
+while ($repeat) {
+    # Get the first set of configs and their dependencies.
+    loop_depend;
+
+    $repeat =3D 0;
+
+    # Now we need to see if we have to check selects;
+    loop_select;
+}=09=20=20=20=20
+
 my %setconfigs;
=20
 # Finally, read the .config file and turn off any module enabled that
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4TpcAAoJEIy3vGnGbaoAAMsQAKPLgFXHFRLiXQV8eYwIeB3A
g0UPp/HVijRdyOnUSHYqMBrGOLMS9hTwQOQ8uPj2jj7baJtN2p3KzkO6Az4d2sP3
s7FeyVbM8thUTx/IQ0DEm1wU0OmAv6DdpqJ2ohidGdxJGhQ1HfU4qqD4WYnwMHPy
E5sGovy6CZ2W5bZ3qxhFZrzH1Or60Xk0tQO9setXjmAtOlU3NXAZ7XIjUImjYswP
EazO+VX+2Gib1SQmZr2SQ8DRFerJ4Aq7Z8Y3Iy6DiydQAVjh+SKeqZkTRdjjJOsX
jhKXrVtmn7wRQU5SXZTaHFMhCmm4aXdBjS99MBZdbBJjf/ulk0lP4X4/ttrMg6Om
9J5HzE0UeLzbTpzTtiACwO8bl9m3JlYnFiL7fTL5QXJM7zHclt7vO2bmHRiP/cJd
qlbDC3+pa8mdLBfc7LRCVZfE4YDnEh77rDiqdvM71vG4vAkAOcaf5I5l0vRy58dp
lRnGmZ8yGiwoirO5HYVUS45a1tFj7SQAURyKEiC4JLR/3LVczXoRcqkvunKY1jjA
ev/gyq6zB/44smzrPj4TXs56QBlYX5wZzu4J95iFbT/Z6QUnZzydKWIm1bcH/eDd
ADJujFQCf3PsiQ/IYk4GtTuBmiC0v+UlLnUFfEfnKfSMLDAHzwffgkPBHx9MElnK
VKa38bimV0t2rr4UURtg
=g8s9
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
