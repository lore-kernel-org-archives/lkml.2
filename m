Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2BPS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:57:56 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:57512
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab2BPS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:57:53 -0500
X-SpamScore: -8
X-BigFish: VPS-8(zz444eM13e6Kzz1202hzz8275bh8275dhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZI20C-01-EH9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, Ben Hutchings <ben@decadent.org.uk>,
        <debian-kernel@lists.debian.org>, <linux-kbuild@vger.kernel.org>
Subject: [RFC PATCH] kbuild: Build linux-tools package with 'make deb-pkg'
Date: Thu, 16 Feb 2012 19:57:44 +0100
Message-ID: <1329418664-1750-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also build a linux-tools package for installation so that
common tools run without issues (e.g. perf).

[RFC note: This may break with x-compilation when the
           x-compilation environment is not set up to
	   compile user-space programs. Is that acceptable?
	   I also thought about a compile-time parameter
	   such as 'make TOOLS=1 deb-pkg' or a special
	   'make deb-tools-pkg' target.	Opinions? ]

Cc: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <max@stro.at>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: debian-kernel@lists.debian.org
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 scripts/package/builddeb |   55 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index eee5f8e..8466380 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -78,17 +78,19 @@ tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
 kernel_headers_dir="$objtree/debian/hdrtmp"
 libc_headers_dir="$objtree/debian/headertmp"
+tools_dir="$objtree/debian/toolstmp"
 packagename=linux-image-$version
 fwpackagename=linux-firmware-image
 kernel_headers_packagename=linux-headers-$version
 libc_headers_packagename=linux-libc-dev
+tools_packagename=linux-tools-$version
 
 if [ "$ARCH" = "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
 # Setup the directory structure
-rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
+rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$tools_dir"
 mkdir -m 755 -p "$tmpdir/DEBIAN"
 mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
 mkdir -m 755 -p "$fwdir/DEBIAN"
@@ -98,6 +100,9 @@ mkdir -p "$libc_headers_dir/usr/share/doc/$libc_headers_packagename"
 mkdir -m 755 -p "$kernel_headers_dir/DEBIAN"
 mkdir -p "$kernel_headers_dir/usr/share/doc/$kernel_headers_packagename"
 mkdir -p "$kernel_headers_dir/lib/modules/$version/"
+mkdir -m 755 -p "$tools_dir/DEBIAN"
+mkdir -p "$tools_dir/usr/share/doc/$tools_packagename"
+mkdir -p "$tools_dir/usr/bin/"
 if [ "$ARCH" = "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
 fi
@@ -120,6 +125,39 @@ else
 	fi
 fi
 
+# Build the tools
+num_tools="0"
+tools_flavour_abi=${version#*-}
+tools_flavour=${tools_flavour_abi#*-}
+tools_version=${version%-$tools_flavour}
+if grep -q '^CONFIG_PERF_EVENTS=y' .config ; then
+	# Build perf
+	(
+	 mkdir -p $objtree/tools/perf
+	 cd "$srctree/tools/perf"
+	 $MAKE LDFLAGS= O=$O/tools/perf
+	 cp $objtree/tools/perf/perf "$tools_dir/usr/bin/perf_$tools_version"
+	)
+	num_tools=$(($num_tools+1))
+fi
+
+if [[ "$ARCH" = "i386" || "$ARCH" = "x86_64" ]]; then
+	# Build turbostat
+	(
+	 cd "$srctree/tools/power/x86/turbostat/"
+	 $MAKE 
+	 cp turbostat "$tools_dir/usr/bin/turbostat_$tools_version"
+	)
+
+	# Build x86_energy_perf_policy
+	(
+	 cd "$srctree/tools/power/x86/x86_energy_perf_policy"
+	 $MAKE 
+	 cp x86_energy_perf_policy "$tools_dir/usr/bin/x86_energy_perf_policy_$tools_version"
+	)
+	num_tools=$(($num_tools+2))
+fi
+
 if grep -q '^CONFIG_MODULES=y' .config ; then
 	INSTALL_MOD_PATH="$tmpdir" $MAKE KBUILD_SRC= modules_install
 	rm -f "$tmpdir/lib/modules/$version/build"
@@ -291,9 +329,24 @@ Description: Linux support headers for userspace development
  are used by the installed headers for GNU glibc and other system libraries.
 EOF
 
+cat <<EOF >> debian/control
+
+Package: $tools_packagename
+Section: devel
+Architecture: $arch
+Depends: \${shlibs:Depends}, linux-tools-common
+Description: Linux kernel tools for version $version
+ This package provides the architecture dependant parts for kernel
+ version locked tools for version $version
+EOF
+
 if [ "$ARCH" != "um" ]; then
 	create_package "$kernel_headers_packagename" "$kernel_headers_dir"
 	create_package "$libc_headers_packagename" "$libc_headers_dir"
+	if [ "$num_tools" > "0" ]; then
+		dpkg-shlibdeps $tools_dir/usr/bin/*
+		create_package "$tools_packagename" "$tools_dir"
+	fi
 fi
 
 create_package "$packagename" "$tmpdir"
-- 
1.7.5.4


