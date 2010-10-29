Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0J2Fo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:44:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0J2Fo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:26 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=Om30yJlIVGMA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=7gkXJVJtAAAA:8 a=meVymXHHAAAA:8 a=4e1kaW1goDNjlzB9y6UA:9 a=TKUsUahZHlEAVB9ByHG3nr12rBwA:4 a=hXFNqW0bEOwA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=JmBWkid0h3cA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054423.498608001@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle environment variables
References: <20101029054310.790179545@goodmis.org>
Content-Disposition: inline; filename=0001-kconfig-Make-localmodconfig-handle-environment-varia.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The commit 838a2e55e6a4e9e8a10451ed2ef0f7a08dabdb04
 kbuild: migrate all arch to the kconfig mainmenu upgrade

Broke make localmodconfig. The reason was that it added a
environment variable to the kconfig source, which the
streamline_config.pl could not handle.

This patch changes streamline_config.pl to handle kconfig sources
using environment variables in their names.

Cc: Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index c70a27d..cc10bcf 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -137,7 +137,17 @@ sub read_kconfig {
     my $config;
     my @kconfigs;
 
-    open(KIN, "$ksource/$kconfig") || die "Can't open $kconfig";
+    my $source = "$ksource/$kconfig";
+    my $last_source = "";
+
+    # Check for any environment variables used
+    while ($source =~ /\$(\w+)/ && $last_source ne $source) {
+	my $env = $1;
+	$last_source = $source;
+	$source =~ s/\$$env/$ENV{$env}/;
+    }
+
+    open(KIN, "$source") || die "Can't open $kconfig";
     while (<KIN>) {
 	chomp;
 
-- 
1.7.1


