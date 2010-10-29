Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0J2FpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:45:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0J2FoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:25 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=yHcU_4g1GYsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BUQqRvzF8HAIV3N57woA:9 a=rfnkYTT9Wx1mkmA7JXo861euM9YA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054424.291908153@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 4/5] [PATCH 4/5] kconfig: Fix streamline_config to read multi line deps in Kconfig files
References: <20101029054310.790179545@goodmis.org>
Content-Disposition: inline; filename=0004-kconfig-Fix-streamline_config-to-read-multi-line-dep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I noticed that some Kconfig files have multi line dependencies
that continue with a backslash. Those dependencies on the next
line will be missed by streamline_config.

For example:

config CS89x0
	tristate "CS89x0 support"
	depends on NET_ETHERNET && (ISA || EISA || MACH_IXDP2351 \
		|| ARCH_IXDP2X01 || MACH_MX31ADS)

The "|| ARCH_IXDP2X01 || MACH_MX31ADS)" will not be processed.

This patch adds code to handle this case.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 883748c..ebba407 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -125,7 +125,6 @@ my %selects;
 my %prompts;
 my %objects;
 my $var;
-my $cont = 0;
 my $iflevel = 0;
 my @ifdeps;
 
@@ -139,6 +138,9 @@ sub read_kconfig {
     my $config;
     my @kconfigs;
 
+    my $cont = 0;
+    my $line;
+
     my $source = "$ksource/$kconfig";
     my $last_source = "";
 
@@ -153,6 +155,19 @@ sub read_kconfig {
     while (<KIN>) {
 	chomp;
 
+	# Make sure that lines ending with \ continue
+	if ($cont) {
+	    $_ = $line . " " . $_;
+	}
+
+	if (s/\\$//) {
+	    $cont = 1;
+	    $line = $_;
+	    next;
+	}
+
+	$cont = 0;
+
 	# collect any Kconfig sources
 	if (/^source\s*"(.*)"/) {
 	    $kconfigs[$#kconfigs+1] = $1;
@@ -230,6 +245,8 @@ if ($kconfig) {
 # Read all Makefiles to map the configs to the objects
 foreach my $makefile (@makefiles) {
 
+    my $cont = 0;
+
     open(MIN,$makefile) || die "Can't open $makefile";
     while (<MIN>) {
 	my $objs;
-- 
1.7.1


