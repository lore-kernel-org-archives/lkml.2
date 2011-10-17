Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1JQQ77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1JQQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:55 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=G63vQC6HLSgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=eP9BnrXZSuA4vl4ctZUA:9 a=BxVY7RNYDVBY2LKuSxcA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=CeDq2egx64_vBY1nBrIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017165953.911347826@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:05:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/17][RFC] ktest: Sort make_min_config configs by dependecies
References: <20111017160455.498567257@goodmis.org>
Content-Disposition: inline; filename=0015-ktest-Sort-make_min_config-configs-by-dependecies.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The make_min_config test will turn off one config at a time and check
if the config boots or not, and if it does, it will remove that config
plus any config that depended on that config.

ktest already looks if a config has a dependency and will try the
dependency config first. But by sorting the configs and trying the
config with the most configs dependent on it, we can shrink the
minconfig faster.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   71 +++++++++++++++++++++++++++++---------=
----
 1 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 76a5964..2a9d042 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2372,12 +2372,31 @@ sub patchcheck {
 }
=20
 my %depends;
+my %depcount;
 my $iflevel =3D 0;
 my @ifdeps;
=20
 # prevent recursion
 my %read_kconfigs;
=20
+sub add_dep {
+    # $config depends on $dep
+    my ($config, $dep) =3D @_;
+
+    if (defined($depends{$config})) {
+	$depends{$config} .=3D " " . $dep;
+    } else {
+	$depends{$config} =3D $dep;
+    }
+
+    # record the number of configs depending on $dep
+    if (defined $depcount{$dep}) {
+	$depcount{$dep}++;
+    } else {
+	$depcount{$dep} =3D 1;
+    }=20
+}
+
 # taken from streamline_config.pl
 sub read_kconfig {
     my ($kconfig) =3D @_;
@@ -2424,30 +2443,19 @@ sub read_kconfig {
 	    $config =3D $2;
=20
 	    for (my $i =3D 0; $i < $iflevel; $i++) {
-		if ($i) {
-		    $depends{$config} .=3D " " . $ifdeps[$i];
-		} else {
-		    $depends{$config} =3D $ifdeps[$i];
-		}
-		$state =3D "DEP";
+		add_dep $config, $ifdeps[$i];
 	    }
=20
 	# collect the depends for the config
 	} elsif ($state eq "NEW" && /^\s*depends\s+on\s+(.*)$/) {
=20
-	    if (defined($depends{$1})) {
-		$depends{$config} .=3D " " . $1;
-	    } else {
-		$depends{$config} =3D $1;
-	    }
+	    add_dep $config, $1;
=20
 	# Get the configs that select this config
-	} elsif ($state ne "NONE" && /^\s*select\s+(\S+)/) {
-	    if (defined($depends{$1})) {
-		$depends{$1} .=3D " " . $config;
-	    } else {
-		$depends{$1} =3D $config;
-	    }
+	} elsif ($state eq "NEW" && /^\s*select\s+(\S+)/) {
+
+	    # selected by depends on config
+	    add_dep $1, $config;
=20
 	# Check for if statements
 	} elsif (/^if\s+(.*\S)\s*$/) {
@@ -2559,11 +2567,18 @@ sub make_new_config {
     close OUT;
 }
=20
+sub chomp_config {
+    my ($config) =3D @_;
+
+    $config =3D~ s/CONFIG_//;
+
+    return $config;
+}
+
 sub get_depends {
     my ($dep) =3D @_;
=20
-    my $kconfig =3D $dep;
-    $kconfig =3D~ s/CONFIG_//;
+    my $kconfig =3D chomp_config $dep;
=20
     $dep =3D $depends{"$kconfig"};
=20
@@ -2613,8 +2628,7 @@ sub test_this_config {
 	return undef;
     }
=20
-    my $kconfig =3D $config;
-    $kconfig =3D~ s/CONFIG_//;
+    my $kconfig =3D chomp_config $config;
=20
     # Test dependencies first
     if (defined($depends{"$kconfig"})) {
@@ -2704,6 +2718,14 @@ sub make_min_config {
=20
     my @config_keys =3D keys %min_configs;
=20
+    # All configs need a depcount
+    foreach my $config (@config_keys) {
+	my $kconfig =3D chomp_config $config;
+	if (!defined $depcount{$kconfig}) {
+		$depcount{$kconfig} =3D 0;
+	}
+    }
+
     # Remove anything that was set by the make allnoconfig
     # we shouldn't need them as they get set for us anyway.
     foreach my $config (@config_keys) {
@@ -2742,8 +2764,13 @@ sub make_min_config {
 	# Now disable each config one by one and do a make oldconfig
 	# till we find a config that changes our list.
=20
-	# Put configs that did not modify the config at the end.
 	my @test_configs =3D keys %min_configs;
+
+	# Sort keys by who is most dependent on
+	@test_configs =3D sort  { $depcount{chomp_config($b)} <=3D> $depcount{cho=
mp_config($a)} }
+			  @test_configs ;
+
+	# Put configs that did not modify the config at the end.
 	my $reset =3D 1;
 	for (my $i =3D 0; $i < $#test_configs; $i++) {
 	    if (!defined($nochange_config{$test_configs[0]})) {
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF8KAAoJEIy3vGnGbaoAO50P/2MfFdD3Nlk57HrrAY8wWb4J
mRpz5tRyMX8IC4M5IecbrXCqYcSlK5J68412+3TSaIAlE2vbwFSgwIX3VbI42b8F
q+T5RBIP2eCf1eDhj0bnISM7m/FazLLcpW4dPJihJlGWd4CaO4s2IggbKMhOXrTH
Bob5i5hoJNSPk1GeEszztIhn0Jzl5L31ohJj9cNSIc46fUv1E4T9bD605Q42eCLp
jt1uhwDOqJJLaUF5PxtAyOqq4BU3xjvIXCKXGBH/7fdPkPe8fUTF8M5KQRX+RZMo
OnryEV+4NeD3NjrWNIsaKv9//CQt4miArPZc+VR9Zx9WehgBgPO+fNQaFMa0ofDz
MXKXGxgAVYQvetrLsFr+6eyO362W8yIncrIMl2aPMsYR3oh4+3gdL4RtxN25jBv5
YrDwZDdlLx09/gIRq8lT7k2TUeOEQv5S30UKGviQCh8MS63ZA+OgO+PFgZagH0xb
4w1gYokWyy9BY10dlSd107zhIKdHSmfDaveVLeDsJPrO85RHiLJIXc4oVkFjlkBE
v8N2bjHQ44Z7HMBWLdDFXDCvcedW//XvQWFKlAuhycvsgsvNCibYleVlEEiKNLCC
GZKAWKxGQueuq4QYTXxjynwRf0VAcDRHNITHAuWYzYNLO2lQ6behMLa3P9AZTX0X
5KGJ8ipjeeGG2Sec4G87
=YkD7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
