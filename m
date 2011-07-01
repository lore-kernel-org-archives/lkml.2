Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1GAXcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:32:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50397 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab1GAXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:31:36 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [RFC 4/4] kconfig/streamline_config.pl: move config generation to script
Date: Fri,  1 Jul 2011 19:31:16 -0400
Message-Id: <1309563076-5050-5-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoid having to deals with multiline shell command in the Makefile and
increase readability.

Cc: Steven Rostedt <srostedt@redhat.com>
---
 scripts/kconfig/Makefile       |   14 +-------------
 scripts/kconfig/localconfig.sh |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 13 deletions(-)
 create mode 100755 scripts/kconfig/localconfig.sh

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 8a59adf..d48ddc9 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -34,19 +34,7 @@ silentoldconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 localyesconfig localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
-	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
-	$(Q)if [ -f .config ]; then 					\
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
+	$(Q)$(src)/localconfig.sh
 
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
diff --git a/scripts/kconfig/localconfig.sh b/scripts/kconfig/localconfig.sh
new file mode 100755
index 0000000..64dd295
--- /dev/null
+++ b/scripts/kconfig/localconfig.sh
@@ -0,0 +1,20 @@
+#!/bin/sh
+#
+
+mkdir -p include/generated
+
+perl "${srctree}/scripts/kconfig/streamline_config.pl" ${srctree}/ ${Kconfig} $1 > .tmp.config
+
+if [ -f .config ]; then
+	if ! cmp -s .tmp.config .config; then
+		mv -f .config .config.old.1
+		mv -f .tmp.config .config
+		${obj}/conf --silentoldconfig ${Kconfig}
+		mv -f .config.old.1 .config.old
+	fi
+else
+	mv -f .tmp.config .config
+	${obj}/conf --silentoldconfig ${Kconfig}
+fi
+
+rm -f .tmp.config
-- 
1.7.3.4.574.g608b.dirty

