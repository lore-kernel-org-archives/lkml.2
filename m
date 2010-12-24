Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0LYDCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 22:02:03 -0500
Received: from thunk.org ([69.25.196.29]:57313 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0LYDCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 22:02:00 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] kbuild: create linux-headers package in deb-pkg
Date: Fri, 24 Dec 2010 09:42:10 -0500
Message-Id: <1293201730-1583-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a linux-headers-$KVER.deb package which can be used to build
external modules without having the source tree around.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 scripts/package/builddeb |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 49b74e1..cb5b29d 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -40,15 +40,17 @@ else
 fi
 tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
+hdrdir="$objtree/debian/hdrtmp"
 packagename=linux-image-$version
 fwpackagename=linux-firmware-image
+hdrpackagename=linux-headers-$version
 
 if [ "$ARCH" = "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
 # Setup the directory structure
-rm -rf "$tmpdir" "$fwdir"
+rm -rf "$tmpdir" "$fwdir" "$hdrdir"
 mkdir -p "$tmpdir/DEBIAN" "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
 mkdir -p "$fwdir/DEBIAN" "$fwdir/lib" "$fwdir/usr/share/doc/$fwpackagename"
 if [ "$ARCH" = "um" ] ; then
@@ -188,6 +190,30 @@ EOF
 
 fi
 
+# Build header package
+find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$
+find arch/x86/include include scripts -type f >> /tmp/files$$
+(cd $objtree; find .config Module.symvers include scripts -type f >> /tmp/objfiles$$)
+destdir=$hdrdir/usr/src/linux-headers-$version
+mkdir -p "$destdir" "$hdrdir/DEBIAN" "$hdrdir/usr/share/doc/$hdrpackagename"
+tar -c -f - -T /tmp/files$$ | (cd $destdir; tar -xf -)
+(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
+rm -f /tmp/files$$ /tmp/objfiles$$
+arch=$(dpkg --print-architecture)
+
+cat <<EOF >> debian/control
+
+Package: $hdrpackagename
+Provides: linux-headers, linux-headers-2.6
+Architecture: $arch
+Description: Linux kernel headers for $KERNELRELEASE on $arch
+ This package provides kernel header files for $KERNELRELEASE on $arch
+ .
+ This is useful for people who need to build external modules
+EOF
+
+create_package "$hdrpackagename" "$hdrdir"
+
 # Do we have firmware? Move it out of the way and build it into a package.
 if [ -e "$tmpdir/lib/firmware" ]; then
 	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
-- 
1.7.3.1

