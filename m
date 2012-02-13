Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2BMOtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:49:15 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14767 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756685Ab2BMOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:49:14 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZC6HR-01-794-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, Ben Hutchings <ben@decadent.org.uk>,
        <debian-kernel@lists.debian.org>, <linux-kbuild@vger.kernel.org>
Subject: [PATCH v2] kbuild: Fix link to headers in 'make deb-pkg'
Date: Mon, 13 Feb 2012 15:48:57 +0100
Message-ID: <1329144538-21444-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Link to the kernel header files in the debian packages
point to the original build directory. This is a bad choice
if the packages were installed on a different machine. Fix
this in by manually re-creating the link in the builddeb
script.

Cc: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <max@stro.at>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: debian-kernel@lists.debian.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 scripts/package/builddeb |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index f6cbc3d..fc3f76a 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -97,6 +97,7 @@ mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
 mkdir -p "$libc_headers_dir/usr/share/doc/$libc_headers_packagename"
 mkdir -m 755 -p "$kernel_headers_dir/DEBIAN"
 mkdir -p "$kernel_headers_dir/usr/share/doc/$kernel_headers_packagename"
+mkdir -p "$kernel_headers_dir/lib/modules/$version/"
 if [ "$ARCH" = "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
 fi
@@ -121,6 +122,8 @@ fi
 
 if grep -q '^CONFIG_MODULES=y' .config ; then
 	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
+	rm -f "$tmpdir/lib/modules/$version/build"
+	rm -f "$tmpdir/lib/modules/$version/source"
 	if [ "$ARCH" = "um" ] ; then
 		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
 		rmdir "$tmpdir/lib/modules/$version"
@@ -245,6 +248,12 @@ destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
 (cd $srctree; tar -c -f - -T /tmp/files$$) | (cd $destdir; tar -xf -)
 (cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
+ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
+if [ "$ARCH" = "um" ] ; then
+	mkdir -p "$kernel_headers_dir/usr/lib/uml/modules/$version/"
+	mv "$kernel_headers_dir/lib/modules/$version"/* "$kernel_headers_dir/usr/lib/uml/modules/$version/"
+	rmdir "$kernel_headers_dir/lib/modules/$version"
+fi
 rm -f /tmp/files$$ /tmp/objfiles$$
 arch=$(dpkg --print-architecture)
 
-- 
1.7.5.4


