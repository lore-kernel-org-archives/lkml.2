Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2BWLR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:17:26 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:55036
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755175Ab2BWLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:17:23 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz444eM1432N98dK13e6Kzz1202hzz15d4R8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZUFCQ-01-5AJ-02
X-M-MSG: 
Date: Thu, 23 Feb 2012 12:17:12 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, <debian-kernel@lists.debian.org>,
        <linux-kbuild@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>
Subject: Re: [RFC PATCH] kbuild: Build linux-tools package with 'make deb-pkg'
Message-ID: <20120223111712.GA2454@amd.com>
References: <1329418664-1750-1-git-send-email-joerg.roedel@amd.com>
 <1329448597.3258.28.camel@deadeye>
 <1329450390.3258.36.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329450390.3258.36.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 03:46:30AM +0000, Ben Hutchings wrote:
> > The advice I got from one of the perf developers - possibly Peter
> > Zijlstra - was that changes to the perf kernel interface are backward-
> > compatible but newer versions of the perf tool may depend on newer
> > kernel features.  New features involve a bump to the 2nd (at the time,
> > it was the 3rd) version component unless you're building from a perf
> > development branch.
> > 
> > So to avoid package proliferation the package name should be
> > linux-tools-$VERSION.$PATCHLEVEL and the executable filenames should be
> > something like perf_$VERSION.$PATCHLEVEL-$subcommand.
> [...]
> 
> Sorry, the executable filename is just perf_$VERSION.$PATCHLEVEL.  Only
> the manual pages for sub-commands are actually separate files.

Okay, here is a new version. It fits the needs for Debian and Ubuntu
now. I tested the patch on both distributions and with in-tree and
out-of-tree build. The installed packages work fine.

>From f17987587e188b34be57b7b20aee851de70a80d1 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 16 Feb 2012 19:48:24 +0100
Subject: [PATCH] RFC: kbuild: Build linux-tools package with 'make deb-pkg'

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
 scripts/package/builddeb |   93 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index eee5f8e..d474736 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -78,17 +78,20 @@ tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
 kernel_headers_dir="$objtree/debian/hdrtmp"
 libc_headers_dir="$objtree/debian/headertmp"
+tools_dir="$objtree/debian/toolstmp"
+tmp_build_dir="$objtree/debian/toolsbuild"
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
+rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$tools_dir" "$tmp_build_dir"
 mkdir -m 755 -p "$tmpdir/DEBIAN"
 mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
 mkdir -m 755 -p "$fwdir/DEBIAN"
@@ -98,6 +101,10 @@ mkdir -p "$libc_headers_dir/usr/share/doc/$libc_headers_packagename"
 mkdir -m 755 -p "$kernel_headers_dir/DEBIAN"
 mkdir -p "$kernel_headers_dir/usr/share/doc/$kernel_headers_packagename"
 mkdir -p "$kernel_headers_dir/lib/modules/$version/"
+mkdir -m 755 -p "$tools_dir/DEBIAN"
+mkdir -p "$tools_dir/usr/share/doc/$tools_packagename"
+mkdir -p "$tools_dir/usr/bin/"
+mkdir -p "$tmp_build_dir"
 if [ "$ARCH" = "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
 fi
@@ -120,6 +127,75 @@ else
 	fi
 fi
 
+# Build the tools
+num_tools="0"
+tools_flavour_abi=${version#*-}
+tools_flavour=${tools_flavour_abi#*-}
+tools_version=${version%-$tools_flavour}
+debian_tools_version="${version%%-*}"
+debian_tools_version="${version%.*}"
+if grep -q '^CONFIG_PERF_EVENTS=y' .config ; then
+	# Build and install perf
+	(
+	 unset MAKEFLAGS
+	 unset MFLAGS
+	 unset MAKEOVERRIDES
+
+	 mkdir -p $objtree/tools/perf
+	 cd "$srctree/tools/perf"
+	 $MAKE DESTDIR="$tools_dir/usr/" LDFLAGS= O=$objtree/tools/perf/ install
+	 mv "$tools_dir/usr/bin/perf" "$tools_dir/usr/bin/perf_$debian_tools_version"
+	 ln -s "/usr/bin/perf_$debian_tools_version" "$tools_dir/usr/bin/perf_$tools_version"
+	 mv "$tools_dir/usr/libexec/perf-core" "$tools_dir/usr/share/perf_$debian_tools_version-core"
+	 rmdir "$tools_dir/usr/libexec"
+	 
+	 # Documentation can't be built out-of-tree so copy source
+	 # over to objtree and build man pages there
+	 mkdir -p $tmp_build_dir/perf
+	 cp -a "$srctree/tools/perf/Documentation" "$tmp_build_dir/perf/"
+	 cd "$tmp_build_dir/perf/Documentation"
+	 $MAKE man
+	 $MAKE DESTDIR="$tools_dir/usr/" install
+	 for manpage in `find $tools_dir/usr/share/man/ -type f`; do
+	 	mv $manpage ${manpage/perf/perf_$debian_tools_version}
+		gzip -9 ${manpage/perf/perf_$debian_tools_version}
+	 done
+	)
+	num_tools=$(($num_tools+1))
+fi
+
+if [[ "$ARCH" = "i386" || "$ARCH" = "x86_64" ]]; then
+	# Build turbostat
+	(
+	 cp -a $srctree/tools/power/x86/turbostat "$tmp_build_dir"
+	 cd "$tmp_build_dir/turbostat/"
+	 unset MAKEFLAGS
+	 unset MFLAGS
+	 unset MAKEOVERRIDES
+	 $MAKE LDFLAGS=
+	 cp turbostat "$tools_dir/usr/bin/turbostat_$debian_tools_version"
+	 ln -s "/usr/bin/turbostat_$debian_tools_version" "$tools_dir/usr/bin/turbostat_$tools_version"
+	 mkdir -p "$tools_dir/usr/share/man/man8"
+	 cp turbostat.8 "$tools_dir/usr/share/man/man8/turbotstat_${debian_tools_version}.8"
+	 gzip -9 "$tools_dir/usr/share/man/man8/turbotstat_${debian_tools_version}.8"
+	)
+
+	# Build x86_energy_perf_policy
+	(
+	 cp -a $srctree/tools/power/x86/x86_energy_perf_policy "$tmp_build_dir"
+	 cd "$tmp_build_dir/x86_energy_perf_policy"
+	 unset MAKEFLAGS
+	 unset MFLAGS
+	 unset MAKEOVERRIDES
+	 $MAKE LDFLAGS=
+	 cp x86_energy_perf_policy "$tools_dir/usr/bin/x86_energy_perf_policy_$debian_tools_version"
+	 ln -s "/usr/bin/x86_energy_perf_policy_$debian_tools_version" "$tools_dir/usr/bin/x86_energy_perf_policy_$tools_version"
+	 cp x86_energy_perf_policy.8 "$tools_dir/usr/share/man/man8/x86_energy_perf_policy_${debian_tools_version}.8"
+	 gzip -9 "$tools_dir/usr/share/man/man8/x86_energy_perf_policy_${debian_tools_version}.8"
+	)
+	num_tools=$(($num_tools+2))
+fi
+
 if grep -q '^CONFIG_MODULES=y' .config ; then
 	INSTALL_MOD_PATH="$tmpdir" $MAKE KBUILD_SRC= modules_install
 	rm -f "$tmpdir/lib/modules/$version/build"
@@ -291,9 +367,24 @@ Description: Linux support headers for userspace development
  are used by the installed headers for GNU glibc and other system libraries.
 EOF
 
+cat <<EOF >> debian/control
+
+Package: $tools_packagename
+Section: devel
+Architecture: $arch
+Depends: \${shlibs:Depends}
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




-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

