Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2GQR6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:58:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47406 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2GQR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:57:59 -0400
Message-ID: <1342547874.5129.2.camel@henna.lan>
Subject: [PATCH] scripts/package/builddeb: upgrade to current practices
From: =?ISO-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jul 2012 20:57:54 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sanitizes and updates the Debian package building script:

1) Updates $fwpackagename to 'firmware-linux' as used by Debian,
2) Removes trailing whitespace,
3) Updates Linus' copyright in the generated packaging files,
4) Updates URL of Linus' GIT tree in the generated packaging files,
5) Removes obsolete references to linux-2.6,
6) Adds installation of missing subarch components to header package,
7) Adds dependency relationships to the firmware package.

Signed-off-by: Martin-Éric Racine <martin-eric.racine@iki.fi>
---
 scripts/package/builddeb |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c95fdda..44ef3d1 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -79,9 +79,9 @@ fwdir="$objtree/debian/fwtmp"
 kernel_headers_dir="$objtree/debian/hdrtmp"
 libc_headers_dir="$objtree/debian/headertmp"
 packagename=linux-image-$version
-fwpackagename=linux-firmware-image
 kernel_headers_packagename=linux-headers-$version
 libc_headers_packagename=linux-libc-dev
+fwpackagename=firmware-linux
 
 if [ "$ARCH" = "um" ] ; then
 	packagename=user-mode-linux-$version
@@ -109,7 +109,7 @@ if [ "$ARCH" = "um" ] ; then
 	cp .config "$tmpdir/usr/share/doc/$packagename/config"
 	gzip "$tmpdir/usr/share/doc/$packagename/config"
 	cp $KBUILD_IMAGE "$tmpdir/usr/bin/linux-$version"
-else 
+else
 	cp System.map "$tmpdir/boot/System.map-$version"
 	cp .config "$tmpdir/boot/config-$version"
 	# Not all arches include the boot path in KBUILD_IMAGE
@@ -188,17 +188,17 @@ This is a packacked upstream version of the Linux kernel.
 The sources may be found at most Linux ftp sites, including:
 ftp://ftp.kernel.org/pub/linux/kernel
 
-Copyright: 1991 - 2009 Linus Torvalds and others.
+Copyright: 1991-2012 Linus Torvalds and others.
 
-The git repository for mainline kernel development is at:
-git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+The GIT repository for mainline kernel development is at:
+git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation; version 2 dated June, 1991.
 
 On Debian GNU/Linux systems, the complete text of the GNU General Public
-License version 2 can be found in \`/usr/share/common-licenses/GPL-2'.
+License version 2 can be found in /usr/share/common-licenses/GPL-2.
 EOF
 
 # Generate a control file
@@ -215,7 +215,7 @@ if [ "$ARCH" = "um" ]; then
 	cat <<EOF >> debian/control
 
 Package: $packagename
-Provides: linux-image, linux-image-2.6, linux-modules-$version
+Provides: linux-image, linux-modules-$version
 Architecture: any
 Description: User Mode Linux kernel, version $version
  User-mode Linux is a port of the Linux kernel to its own system call
@@ -232,7 +232,7 @@ else
 	cat <<EOF >> debian/control
 
 Package: $packagename
-Provides: linux-image, linux-image-2.6, linux-modules-$version
+Provides: linux-image, linux-modules-$version
 Suggests: $fwpackagename
 Architecture: any
 Description: Linux kernel, version $version
@@ -243,7 +243,7 @@ EOF
 fi
 
 # Build header package
-(cd $srctree; find . -name Makefile -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
+(cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
 (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
 (cd $objtree; find arch/$SRCARCH/include .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
@@ -257,12 +257,12 @@ arch=$(dpkg --print-architecture)
 cat <<EOF >> debian/control
 
 Package: $kernel_headers_packagename
-Provides: linux-headers, linux-headers-2.6
+Provides: linux-headers
 Architecture: $arch
 Description: Linux kernel headers for $KERNELRELEASE on $arch
  This package provides kernel header files for $KERNELRELEASE on $arch
  .
- This is useful for people who need to build external modules
+ This is useful for people who need to build external modules.
 EOF
 
 # Do we have firmware? Move it out of the way and build it into a package.
@@ -273,6 +273,9 @@ if [ -e "$tmpdir/lib/firmware" ]; then
 
 Package: $fwpackagename
 Architecture: all
+Conflicts: firmware-linux-free, firmware-linux-nonfree
+Provides: firmware-linux-free, firmware-linux-nonfree
+Replaces: firmware-linux-free, firmware-linux-nonfree
 Description: Linux kernel firmware, version $version
  This package contains firmware from the Linux kernel, version $version.
 EOF
-- 
1.7.10.4


