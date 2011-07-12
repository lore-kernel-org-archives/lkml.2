Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1GLLj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:39:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1GLLjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:39:55 -0400
From: Michal Marek <mmarek@suse.cz>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: Do not write to builddir in modules_install
Date: Tue, 12 Jul 2011 13:39:40 +0200
Message-Id: <1310470780-12330-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let depmod.sh create a temporary directory in /tmp instead of writing to
the build directory as root. The mktemp utility should be available on
any recent system (and there is already scripts/gen_initramfs_list.sh
relying on it).

Reported-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/depmod.sh |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index 3b029cb..a272356 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -21,13 +21,15 @@ fi
 # older versions of depmod require the version string to start with three
 # numbers, so we cheat with a symlink here
 depmod_hack_needed=true
-mkdir -p .tmp_depmod/lib/modules/$KERNELRELEASE
-if "$DEPMOD" -b .tmp_depmod $KERNELRELEASE 2>/dev/null; then
-	if test -e .tmp_depmod/lib/modules/$KERNELRELEASE/modules.dep -o \
-		-e .tmp_depmod/lib/modules/$KERNELRELEASE/modules.dep.bin; then
+tmp_dir=$(mktemp -d ${TMPDIR:-/tmp}/depmod.XXXXXX)
+mkdir -p "$tmp_dir/lib/modules/$KERNELRELEASE"
+if "$DEPMOD" -b "$tmp_dir" $KERNELRELEASE 2>/dev/null; then
+	if test -e "$tmp_dir/lib/modules/$KERNELRELEASE/modules.dep" -o \
+		-e "$tmp_dir/lib/modules/$KERNELRELEASE/modules.dep.bin"; then
 		depmod_hack_needed=false
 	fi
 fi
+rm -rf "$tmp_dir"
 if $depmod_hack_needed; then
 	symlink="$INSTALL_MOD_PATH/lib/modules/99.98.$KERNELRELEASE"
 	ln -s "$KERNELRELEASE" "$symlink"
-- 
1.7.5.4

