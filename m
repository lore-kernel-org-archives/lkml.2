Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2HSDBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911328"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org
Subject: RFC: Link Time Optimization support for the kernel
Date: Sat, 18 Aug 2012 19:55:56 -0700
Message-Id: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rather large patchkit enables gcc Link Time Optimization (LTO) 
support for the kernel. 

With LTO gcc will do whole program optimizations for
the whole kernel and each module. This increases compile time,
but can generate faster code.
    
LTO allows gcc to inline functions between different files and
do various other optimization across the whole binary.
    
It might also trigger bugs due to more aggressive optimization.
It allows gcc to drop unused code. It also allows it to check
types over the whole program.

The build slow down is currently between 2-4x (with larger binaries
taking longer). Typical configs with reasonably sized vmlinux
compile with less than 4GB memory, but very large setups (like 
allyes) need upto 9GB.

You probably wouldn't use it for development, but it may become
a useful option in the future for release builds.

We see speedups in various benchmarks, but also still a few minor
regressions. There's still some outstanding tuning, both in compile
time and allow gcc even better optimization. Also the kernel currently
triggers some slow behaviour in gcc, which will hopefully improve
in future gcc versions, allowing faster LTO builds.

The kit contains workarounds for various toolchain problems with gcc 4.7.
Part of those will be hopefully removed with some upcoming changes.

Currently a special tool chain setup is needed for LTO, with
gcc 4.7 and HJ Lu's Linux binutils. Please see Documentation/lto-build 
for more details on how to install the right versions with the right setup.
The LTO code disables itself if it doesn't find the right toolchain
(however it may not be able to detect all misconfigurations)

This is in the RFC stage at this point. I only tested it on 32bit
and 64bit x86. Other architectures will undoubtedly need more
changes. I would be interested in any testing and benchmarking and
review.

Some options are currently disabled with LTO. MODVERSIONS I plan
to fix. Some others like the FUNCTION_TRACER (who rely on 
different options for specific files) may need compiler changes.

This patchkit relies on the separately posted const-sections patchkit
With LTO gcc insists on correct section attributes.

Available from

git://github.com/andikleen/linux-misc lto-3.6   (or -3.5 and -3.7 in the future)

Note the tree is frequently rebased.

Thanks to HJ Lu, Joe Mario, Honza Hubicka, Richard Guenther,
Don Zickus, Changlong Xie who helped with this project
(and probably some more who I forgot, sorry)

-Andi

