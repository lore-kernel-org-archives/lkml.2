Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1EQRhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:37:52 -0400
Received: from outmail009.snc4.facebook.com ([66.220.144.141]:40924 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755908Ab1EQRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:37:49 -0400
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 1/6] kbuild: Integrate with new-kernel-pkg
Date: Tue, 17 May 2011 10:36:14 -0700
Message-Id: <1305653779-3445-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handles mkinitrd, updating the bootloader among other things.

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 scripts/package/mkspec |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ed8b6a8..b820677 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -94,6 +94,19 @@ echo 'mv vmlinux.bz2 $RPM_BUILD_ROOT'"/boot/vmlinux-$KERNELRELEASE.bz2"
 echo 'mv vmlinux.orig vmlinux'
 echo "%endif"
 
+echo 'rm -rf $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
+echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
+echo "rsync -avz --exclude '.git/' --exclude '*vmlinux*' --exclude '.*' --exclude '*.o' --exclude '*.so' --exclude '*.ko' . "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE/"
+echo 'pushd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"' && ln -s build source && ln -s '"/usr/src/kernels/$KERNELRELEASE"' build && popd'
+
+echo ""
+echo "%preun"
+echo '/sbin/new-kernel-pkg --rminitrd --rmmoddep --remove '"$KERNELRELEASE"' || exit $?'
+
+echo ""
+echo "%post"
+echo '/sbin/new-kernel-pkg --mkinitrd --depmod --install --make-default '"$KERNELRELEASE"' || exit $?'
+
 echo ""
 echo "%clean"
 echo 'rm -rf $RPM_BUILD_ROOT'
-- 
1.7.4

