Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1GAXbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:31:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab1GAXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:31:34 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [RFC 3/4] kconfig/streamline_config.pl: merge local{mod,yes}config
Date: Fri,  1 Jul 2011 19:31:15 -0400
Message-Id: <1309563076-5050-4-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two targets `localmodconfig' and `localyesconfig' only differs from the
sed(1) ran on the result of `streamline_config.pl' to convert symbols set to
`modules' to `yes'. This conversion can be made directly from the perl script,
and thus avoid duplicating the command to generate the configuration.

Cc: Steven Rostedt <srostedt@redhat.com>
---
 scripts/kconfig/Makefile             |   18 +-----------------
 scripts/kconfig/streamline_config.pl |   11 ++++++++++-
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index a718b3c..8a59adf 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -33,7 +33,7 @@ silentoldconfig: $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$< --$@ $(Kconfig)
 
-localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
+localyesconfig localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)if [ -f .config ]; then 					\
@@ -48,22 +48,6 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	fi
 	$(Q)rm -f .tmp.config
 
-localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
-	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
-	$(Q)sed -i s/=m/=y/ .tmp.config
-	$(Q)if [ -f .config ]; then					\
-			cmp -s .tmp.config .config ||			\
-			(mv -f .config .config.old.1;			\
-			 mv -f .tmp.config .config;			\
-			 $(obj)/conf --silentoldconfig $(Kconfig);	\
-			 mv -f .config.old.1 .config.old)		\
-	else								\
-			mv -f .tmp.config .config;			\
-			$(obj)/conf --silentoldconfig $(Kconfig);	\
-	fi
-	$(Q)rm -f .tmp.config
-
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
 # The symlink is used to repair a deficiency in arch/um
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index ae34d20..c762d9d 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -117,6 +117,11 @@ my $ksource = $ARGV[0];
 my $kconfig = $ARGV[1];
 my $lsmod_file = $ENV{'LSMOD'};
 
+my $localyesconfig = 0;
+if ($ENV{'MAKECMDGOALS'} =~ /.*localyesconfig.*/) {
+	$localyesconfig = 1;
+}
+
 my @makefiles = `find $ksource -name Makefile 2>/dev/null`;
 chomp @makefiles;
 
@@ -425,7 +430,11 @@ while(<CIN>) {
 
     if (/^(CONFIG.*)=(m|y)/) {
 	if (defined($configs{$1})) {
-	    $setconfigs{$1} = $2;
+	    if ($localyesconfig) {
+	        $setconfigs{$1} = 'y';
+	    } else {
+	        $setconfigs{$1} = $2;
+	    }
 	} elsif ($2 eq "m") {
 	    print "# $1 is not set\n";
 	    next;
-- 
1.7.3.4.574.g608b.dirty

