Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1GAXbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:31:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab1GAXbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:31:33 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [RFC 2/4] kconfig/streamline_config.pl: directly access LSMOD
Date: Fri,  1 Jul 2011 19:31:14 -0400
Message-Id: <1309563076-5050-3-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Rostedt <srostedt@redhat.com>
---
 scripts/kconfig/Makefile             |   12 ++----------
 scripts/kconfig/streamline_config.pl |    8 ++++++--
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 84abb2f..a718b3c 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -33,17 +33,9 @@ silentoldconfig: $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$< --$@ $(Kconfig)
 
-# if no path is given, then use src directory to find file
-ifdef LSMOD
-LSMOD_F := $(LSMOD)
-ifeq ($(findstring /,$(LSMOD)),)
-  LSMOD_F := $(objtree)/$(LSMOD)
-endif
-endif
-
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)if [ -f .config ]; then 					\
 			cmp -s .tmp.config .config ||			\
 			(mv -f .config .config.old.1;			\
@@ -58,7 +50,7 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 
 localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
 	$(Q)if [ -f .config ]; then					\
 			cmp -s .tmp.config .config ||			\
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index a4fe923..ae34d20 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -115,7 +115,7 @@ find_config;
 # Get the build source and top level Kconfig file (passed in)
 my $ksource = $ARGV[0];
 my $kconfig = $ARGV[1];
-my $lsmod_file = $ARGV[2];
+my $lsmod_file = $ENV{'LSMOD'};
 
 my @makefiles = `find $ksource -name Makefile 2>/dev/null`;
 chomp @makefiles;
@@ -296,7 +296,11 @@ my %modules;
 
 if (defined($lsmod_file)) {
     if ( ! -f $lsmod_file) {
-	die "$lsmod_file not found";
+	if ( -f $ENV{'objtree'}."/".$lsmod_file) {
+	    $lsmod_file = $ENV{'objtree'}."/".$lsmod_file;
+	} else {
+		die "$lsmod_file not found";
+	}
     }
     if ( -x $lsmod_file) {
 	# the file is executable, run it
-- 
1.7.3.4.574.g608b.dirty

