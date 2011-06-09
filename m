Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1FIO5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:57:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1FIO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:57:39 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] kbuild: Hack for depmod not handling X.Y versions
Date: Thu,  9 Jun 2011 16:57:27 +0200
Message-Id: <1307631448-29848-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
References: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

depmod from module-init-tools < 3.13 and the busybox depmod check if the
kernel release starts with <num>.<num>.<num>. To support these versions,
we create a symlink with two numbers prepended.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/depmod.sh |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index 9f205da..3b029cb 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -18,8 +18,31 @@ fi
 if ! test -r System.map -a -x "$DEPMOD"; then
 	exit 0
 fi
+# older versions of depmod require the version string to start with three
+# numbers, so we cheat with a symlink here
+depmod_hack_needed=true
+mkdir -p .tmp_depmod/lib/modules/$KERNELRELEASE
+if "$DEPMOD" -b .tmp_depmod $KERNELRELEASE 2>/dev/null; then
+	if test -e .tmp_depmod/lib/modules/$KERNELRELEASE/modules.dep -o \
+		-e .tmp_depmod/lib/modules/$KERNELRELEASE/modules.dep.bin; then
+		depmod_hack_needed=false
+	fi
+fi
+if $depmod_hack_needed; then
+	symlink="$INSTALL_MOD_PATH/lib/modules/99.98.$KERNELRELEASE"
+	ln -s "$KERNELRELEASE" "$symlink"
+	KERNELRELEASE=99.98.$KERNELRELEASE
+fi
+
 set -- -ae -F System.map
 if test -n "$INSTALL_MOD_PATH"; then
 	set -- "$@" -b "$INSTALL_MOD_PATH"
 fi
-exec "$DEPMOD" "$@" "$KERNELRELEASE"
+"$DEPMOD" "$@" "$KERNELRELEASE"
+ret=$?
+
+if $depmod_hack_needed; then
+	rm -f "$symlink"
+fi
+
+exit $ret
-- 
1.7.4.2

