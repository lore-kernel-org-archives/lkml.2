Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1AOBo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 20:44:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50627 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab1AOBoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 20:44:55 -0500
Date: Sat, 15 Jan 2011 12:44:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the cleancache tree with Linus' tree
Message-Id: <20110115124451.19c32122.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Today's linux-next merge of the cleancache tree got a conflict in
mm/Kconfig between various transparent huge page commits from Linus' tree
and commit 83137a5649ec8a0bb769c68024b0532733087482 ("mm: cleancache core
ops functions and config") from the cleancache tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/Kconfig
index 3ad483b,9ee0751..0000000
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@@ -302,48 -302,24 +302,70 @@@ config NOMMU_INITIAL_TRIM_EXCES
  
  	  See Documentation/nommu-mmap.txt for more information.
  
 +config TRANSPARENT_HUGEPAGE
 +	bool "Transparent Hugepage Support"
 +	depends on X86 && MMU
 +	select COMPACTION
 +	help
 +	  Transparent Hugepages allows the kernel to use huge pages and
 +	  huge tlb transparently to the applications whenever possible.
 +	  This feature can improve computing performance to certain
 +	  applications by speeding up page faults during memory
 +	  allocation, by reducing the number of tlb misses and by speeding
 +	  up the pagetable walking.
 +
 +	  If memory constrained on embedded, you may want to say N.
 +
 +choice
 +	prompt "Transparent Hugepage Support sysfs defaults"
 +	depends on TRANSPARENT_HUGEPAGE
 +	default TRANSPARENT_HUGEPAGE_ALWAYS
 +	help
 +	  Selects the sysfs defaults for Transparent Hugepage Support.
 +
 +	config TRANSPARENT_HUGEPAGE_ALWAYS
 +		bool "always"
 +	help
 +	  Enabling Transparent Hugepage always, can increase the
 +	  memory footprint of applications without a guaranteed
 +	  benefit but it will work automatically for all applications.
 +
 +	config TRANSPARENT_HUGEPAGE_MADVISE
 +		bool "madvise"
 +	help
 +	  Enabling Transparent Hugepage madvise, will only provide a
 +	  performance improvement benefit to the applications using
 +	  madvise(MADV_HUGEPAGE) but it won't risk to increase the
 +	  memory footprint of applications without a guaranteed
 +	  benefit.
 +endchoice
 +
 +#
 +# UP and nommu archs use km based percpu allocator
 +#
 +config NEED_PER_CPU_KM
 +	depends on !SMP
 +	bool
 +	default y
++
+ config CLEANCACHE
+ 	bool "Enable cleancache pseudo-RAM driver to cache clean pages"
+ 	default y
+ 	help
+ 	  Cleancache can be thought of as a page-granularity victim cache
+ 	  for clean pages that the kernel's pageframe replacement algorithm
+ 	  (PFRA) would like to keep around, but can't since there isn't enough
+ 	  memory.  So when the PFRA "evicts" a page, it first attempts to put
+ 	  it into a synchronous concurrency-safe page-oriented pseudo-RAM
+ 	  device (such as Xen's Transcendent Memory, aka "tmem") which is not
+ 	  directly accessible or addressable by the kernel and is of unknown
+ 	  (and possibly time-varying) size.  And when a cleancache-enabled
+ 	  filesystem wishes to access a page in a file on disk, it first
+ 	  checks cleancache to see if it already contains it; if it does,
+ 	  the page is copied into the kernel and a disk access is avoided.
+ 	  When a pseudo-RAM device is available, a significant I/O reduction
+ 	  may be achieved.  When none is available, all cleancache calls
+ 	  are reduced to a single pointer-compare-against-NULL resulting
+ 	  in a negligible performance hit.
+ 
+ 	  If unsure, say Y to enable cleancache
