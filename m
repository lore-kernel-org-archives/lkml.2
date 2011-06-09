Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1FIO6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:58:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:46963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab1FIO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:57:39 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] kbuild: Move depmod call to a separate script
Date: Thu,  9 Jun 2011 16:57:26 +0200
Message-Id: <1307631448-29848-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
References: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not bloat the Makefile with multiline shell statements. No
user-visible change intended.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile          |   12 +-----------
 scripts/depmod.sh |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 11 deletions(-)
 create mode 100755 scripts/depmod.sh

diff --git a/Makefile b/Makefile
index 60d4a67..4350937 100644
--- a/Makefile
+++ b/Makefile
@@ -1110,11 +1110,6 @@ modules_install: _modinst_ _modinst_post
 
 PHONY += _modinst_
 _modinst_:
-	@if [ -z "`$(DEPMOD) -V 2>/dev/null | grep module-init-tools`" ]; then \
-		echo "Warning: you may need to install module-init-tools"; \
-		echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt";\
-		sleep 1; \
-	fi
 	@rm -rf $(MODLIB)/kernel
 	@rm -f $(MODLIB)/source
 	@mkdir -p $(MODLIB)/kernel
@@ -1531,12 +1526,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = \
-	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
-		$(DEPMOD) -ae -F System.map                                     \
-		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) )     \
-		$(KERNELRELEASE);                                               \
-	fi
+      cmd_depmod = $(srctree)/scripts/depmod.sh $(DEPMOD) $(KERNELRELEASE)
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
diff --git a/scripts/depmod.sh b/scripts/depmod.sh
new file mode 100755
index 0000000..9f205da
--- /dev/null
+++ b/scripts/depmod.sh
@@ -0,0 +1,25 @@
+#!/bin/sh
+#
+# A depmod wrapper used by the toplevel Makefile
+
+if test $# -ne 2; then
+	echo "Usage: $0 /sbin/depmod <kernelrelease>" >&2
+	exit 1
+fi
+DEPMOD=$1
+KERNELRELEASE=$2
+
+if ! "$DEPMOD" -V 2>/dev/null | grep -q module-init-tools; then
+	echo "Warning: you may need to install module-init-tools" >&2
+	echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt" >&2
+	sleep 1
+fi
+
+if ! test -r System.map -a -x "$DEPMOD"; then
+	exit 0
+fi
+set -- -ae -F System.map
+if test -n "$INSTALL_MOD_PATH"; then
+	set -- "$@" -b "$INSTALL_MOD_PATH"
+fi
+exec "$DEPMOD" "$@" "$KERNELRELEASE"
-- 
1.7.4.2

