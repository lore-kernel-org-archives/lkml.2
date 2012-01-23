Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2AWLkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:40:52 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11182 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2AWLku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:40:50 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY91RV-01-25A-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Michal Marek <mmarek@suse.cz>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kbuild: Fix link to headers in 'make deb-pkg'
Date: Mon, 23 Jan 2012 12:40:28 +0100
Message-ID: <1327318828-12984-1-git-send-email-joerg.roedel@amd.com>
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
With this patch applied the lib/modules/$version dir always
exists, so move the "$ARCH = um" check out of the modules
check too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 scripts/package/builddeb |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index f6cbc3d..46f63dc 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -91,6 +91,7 @@ fi
 rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
 mkdir -m 755 -p "$tmpdir/DEBIAN"
 mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
+mkdir -p  "$tmpdir/lib/modules/$version"
 mkdir -m 755 -p "$fwdir/DEBIAN"
 mkdir -p "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
 mkdir -m 755 -p "$libc_headers_dir/DEBIAN"
@@ -121,10 +122,14 @@ fi
 
 if grep -q '^CONFIG_MODULES=y' .config ; then
 	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
-	if [ "$ARCH" = "um" ] ; then
-		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
-		rmdir "$tmpdir/lib/modules/$version"
-	fi
+fi
+
+# Make sure link to the headers is correct
+ln -snf "/usr/src/$kernel_headers_packagename" "$tmpdir/lib/modules/$version/build"
+
+if [ "$ARCH" = "um" ] ; then
+	mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
+	rmdir "$tmpdir/lib/modules/$version"
 fi
 
 make headers_check
-- 
1.7.5.4


