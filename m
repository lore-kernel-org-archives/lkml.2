Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2HSDD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:03:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:36894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab2HSC5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422082"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 68/74] Kbuild, lto: Add LTO build Documentation
Date: Sat, 18 Aug 2012 19:57:04 -0700
Message-Id: <1345345030-22211-69-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add build documentation for LTO.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/lto-build |  115 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/lto-build

diff --git a/Documentation/lto-build b/Documentation/lto-build
new file mode 100644
index 0000000..5da427a
--- /dev/null
+++ b/Documentation/lto-build
@@ -0,0 +1,115 @@
+Link time optimization (LTO) for the Linux kernel
+
+This is an experimental feature which still has various problems.
+
+Link Time Optimization allows the compiler to optimize the complete program
+instead of just each file.  Link Time Optimization was a new feature in gcc 4.6,
+but only really works with gcc 4.7. The kernel LTO build also requires
+the Linux binutils (the normal FSF releases do not work at the moment)
+
+The compiler can inline functions between files and do some other global
+optimizations.  It will also drop unused functions which can make the kernel
+image smaller in some circumstances.  The binary gets somewhat larger.
+In return the resulting kernels (usually) have better performance.
+
+Build time and memory consumption at build time will increase.
+The build time penalty depends on the size of the vmlinux. Reasonable 
+sized vmlinux build about twice as long, much larger monolithic kernels 
+like allyesconfig ~4x as long. Modular kernels are less affected.
+
+Normal "reasonable" builds work with less than 4GB of RAM, but very large
+configurations like allyesconfig can need upto 9GB. 
+
+Issues:
+- Various workarounds in kernel needed for toolchain problem.
+- A few kernel features are currently incompatible with LTO, in particular
+function tracing, because they require special compiler flags for
+specific files, which is not supported in LTO right now.
+- The build is faster with LTO_SLIM enabled, but this still triggers
+problems in some circumstances (currently disabled)
+- Jobserver control for -j does not work correctly for the final
+LTO phase. The makefiles hardcodes -j<number of online cpus>
+
+Configuration:
+- Enable CONFIG_LTO_MENU and then disable CONFIG_LTO_DISABLE.
+This is mainly to not have allyesconfig default to LTO.
+- FUNCTION_TRACER, STACK_TRACER, FUNCTION_GRAPH_TRACER have to disabled
+because they are currently incompatible with LTO.
+- MODVERSIONS have to be disabled because they are not fixed for LTO
+yet.
+
+Requirements:
+- Enough memory: 4GB for a standard build, ~8GB for allyesconfig
+If you are tight on memory and use tmpfs as /tmp define TMPDIR and 
+point it to a directory on disk.  The peak memory usage
+happens single threaded (when lto-wpa merges types), so dialing
+back -j options will not help much.
+
+A 32bit compiler is unlikely to work due to the memory requirements.
+You can however build a kernel targetted at 32bit on a 64bit host.
+
+- Get the Linux binutils from
+http://www.kernel.org/pub/linux/devel/binutils/
+Sorry standard binutils releases don't work
+The kernel build has to use this linker, so if it is installed 
+in a non standard location use LD=... on the make line.
+
+- gcc 4.7 built with plugin ld (--with-plugin-ld) also pointing to the 
+linker from the Linux binutils and LTO 
+
+Example build procedure for the tool chain and kernel. This does not 
+overwrite the standard compiler toolchain on the system. If you already
+have a suitable gcc 4.7+ compiler and linker the toolchain build can
+be skipped (note that a distribution gcc 4.7 is not necessarily
+correctly configured for LTO)
+
+Get the Linux binutils from http://www.kernel.org/pub/linux/devel/binutils/
+The standard binutils do not work at this point!
+
+Unpack binutils
+
+cd binutils-VERSION  (or plain binutils in some versions)
+./configure --prefix=/opt/binutils-VERSION --enable-plugins
+nice -n20 make -j$(getconf _NPROCESSORS_ONLN)
+sudo make install
+sudo ln -sf /opt/binutils-VERSION/bin/ld /usr/local/bin/ld-plugin
+
+Unpack gcc-4.7
+
+mkdir obj-gcc
+# please don't skip this cd. the build will not work correctly in the 
+# source dir, you have to use the separate object dir
+cd obj-gcc
+# make sure to install gmp-devel and mpfr-devel
+# and the 32bit glibc package if you have a multilib system
+# if mpc-devel is not there get it from
+# http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz
+# and install in gcc-4.7*/mpc
+../gcc-4.7*/configure --prefix=/opt/gcc-4.7 --enable-lto \
+--with-plugin-ld=/usr/local/bin/ld-plugin  \
+--disable-nls --enable-languages=c,c++ \
+--disable-libstdcxx-pch
+nice -n20 make -j$(getconf _NPROCESSORS_ONLN) 
+sudo make install-no-fixedincludes
+sudo ln -sf /opt/gcc-4.7/bin/gcc /usr/local/bin/gcc47
+sudo ln -sf /opt/gcc-4.7/bin/gcc-ar /usr/local/bin/gcc-ar47
+
+# get lto tree in linux-lto
+
+mkdir obj-lto
+cd obj-lto
+# copy a suitable kernel config file into .config
+make -C ../linux-lto O=$(pwd)  oldconfig
+./source/scripts/config --disable function_tracer --disable function_graph_tracer \
+			 --disable stack_tracer --enable lto_menu \
+                         --disable lto_disable --disable lto_debug --disable lto_slim
+export TMPDIR=$(pwd) 
+# this lowers memory usage with /tmp=tmpfs
+# note the special ar is only needed if CONFIG_LTO_SLIM is enabled
+# The PATH is that gcc-ar finds a plugin aware ar, if your standard
+# binutils doesn't support that. If the standard ar supports --plugin
+# it is not needed
+PATH=/opt/binutils-VERSION:$PATH nice -n20 make CC=gcc47 LD=ld-plugin AR=gcc-ar47 \
+-j $(getconf _NPROCESSORS_ONLN)
+
+Andi Kleen
-- 
1.7.7.6

