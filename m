Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab1D2P2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:28:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab1D2P2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=ZDty4d/Wj2zUG8MAlEnesDkO07BdwTLDR+k5Fm58hRJ+Eama7XHseBKTCb9fnifDMv
         /ynD0yQ9xT12PmRZ9bRel8RcxRBeUloU0Fk9DFL6bHJ+1+yGxvJCqm5gz2Kv+ZK3me3h
         c7wLtFiQyG3lH51vHNbInAM4jQJ1mWtUQtJog=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET tip] x86, NUMA: Unify 32 and 64bit NUMA initialization
Date: Fri, 29 Apr 2011 17:28:19 +0200
Message-Id: <1304090924-8197-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset, finally, unifies 32 and 64bit NUMA initialization.  It
gradually moves 64bit stuff to common code and replaces 32bit code
with it.  Once the unification is complete, amdtopology and emulation
are enabled for 32bit too (there's no reason not to).

This patchset contains the following 25 patches.

 0001-x86-64-NUMA-Simplify-hotadd-memory-handling.patch
 0002-x86-64-NUMA-trivial-cleanups-for-setup_node_bootmem.patch
 0003-x86-64-NUMA-simplify-nodedata-allocation.patch
 0004-x86-32-NUMA-Automatically-set-apicid-node-in-setup_l.patch
 0005-x86-NUMA-Unify-32-64bit-numa_cpu_node-implementation.patch
 0006-x86-32-NUMA-Make-apic-x86_32_numa_cpu_node-optional.patch
 0007-x86-32-NUMA-use-sparse_memory_present_with_active_re.patch
 0008-x86-NUMA-trivial-cleanups.patch

 0009-x86-NUMA-rename-srat_64.c-to-srat.c.patch
 0010-x86-NUMA-make-srat.c-32bit-safe.patch
 0011-x86-32-NUMA-Move-get_memcfg_numa-into-numa_32.c.patch
 0012-x86-NUMA-Move-numa_nodes_parsed-to-numa.-hc.patch
 0013-x86-32-NUMA-implement-temporary-NUMA-init-shims.patch
 0014-x86-32-NUMA-Replace-srat_32.c-with-srat.c.patch

 0015-x86-32-NUMA-Update-numaq-to-use-new-NUMA-init-protoc.patch

 0016-x86-NUMA-Move-NUMA-init-logic-from-numa_64.c-to-numa.patch
 0017-x86-NUMA-Enable-build-of-generic-NUMA-init-code-on-3.patch
 0018-x86-NUMA-Remove-long-64bit-assumption-from-numa.c.patch
 0019-x86-32-NUMA-Add-start-and-end-to-init_alloc_remap.patch
 0020-x86-NUMA-Initialize-and-use-remap-allocator-from-set.patch
 0021-x86-NUMA-Make-32bit-use-common-NUMA-init-path.patch
 0022-x86-NUMA-Make-numa_init_array-static.patch

 0023-x86-NUMA-Rename-amdtopology_64.c-to-amdtopology.c.patch
 0024-x86-NUMA-Enable-CONFIG_AMD_NUMA-on-32bit-too.patch
 0025-x86-NUMA-Enable-emulation-on-32bit-too.patch

Patches can be grouped as follows.

0001-0008 are preparation patches.  Please note that 0001 was posted
before.

0009-0014 rename srat_64.c to srat.c and replace srat_32.c with it.

0015 converts NUMAQ to follow the new init protocol.

0016-0022 move 64bit NUMA init code from numa_64.c to numa.c and
replace 32bit init code in numa_32.c with it.

0023-0025 enable amdtoplogy and emulation for 32bit too.

I've tested ACPI and amdtopology with and without emulation on 32 and
64bit with several different configurations.  It all looks dandy but
wider scope testing is definitely required.  Also, I couldn't test
NUMAQ at all.

Due to dependencies, the base commit this patchset is based on is a
bit complex.  This patchset is based on,

 tip:x86/mm	c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
 + tip:x86/numa	993ba1585cbb03fab012e41d1a5d24330a283b31
 + Cherry pick of 765af22da8 (x86-32, NUMA: Fix ACPI NUMA init broken
   by recent x86-64 change)

The tip:x86/numa requirement is because of the "x86-32, NUMA: Clean up
alloc_remap" patchset[2] which got committed there.  I think it would
have been better if they got routed together through x86/mm.  Well,
anyways, we can sort it out.

So, for review, please use the following git branch as base.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-numa-base

The whole patchset on top of the above base is available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-numa

diffstat follows.  610 lines removed and 32bit NUMA got much better! :)

 arch/x86/Kconfig                 |    4 
 arch/x86/include/asm/acpi.h      |    2 
 arch/x86/include/asm/amd_nb.h    |    1 
 arch/x86/include/asm/apic.h      |    9 
 arch/x86/include/asm/dma.h       |   12 
 arch/x86/include/asm/mmzone_32.h |   20 -
 arch/x86/include/asm/numa.h      |   32 ++
 arch/x86/include/asm/numa_32.h   |   10 
 arch/x86/include/asm/numa_64.h   |   36 --
 arch/x86/include/asm/numaq.h     |    7 
 arch/x86/include/asm/srat.h      |   39 --
 arch/x86/include/asm/topology.h  |    7 
 arch/x86/kernel/apic/apic.c      |   26 -
 arch/x86/kernel/apic/apic_noop.c |    9 
 arch/x86/kernel/apic/bigsmp_32.c |    1 
 arch/x86/kernel/apic/es7000_32.c |    7 
 arch/x86/kernel/apic/numaq_32.c  |   30 --
 arch/x86/kernel/apic/probe_32.c  |    1 
 arch/x86/kernel/apic/summit_32.c |    1 
 arch/x86/mm/Makefile             |    4 
 arch/x86/mm/amdtopology.c        |  197 ++++++++++++++
 arch/x86/mm/amdtopology_64.c     |  196 --------------
 arch/x86/mm/init_32.c            |    1 
 arch/x86/mm/init_64.c            |    8 
 arch/x86/mm/numa.c               |  545 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_32.c            |  165 -----------
 arch/x86/mm/numa_64.c            |  519 -------------------------------------
 arch/x86/mm/numa_emulation.c     |   16 -
 arch/x86/mm/numa_internal.h      |    8 
 arch/x86/mm/srat.c               |  184 +++++++++++++
 arch/x86/mm/srat_32.c            |  287 --------------------
 arch/x86/mm/srat_64.c            |  260 ------------------
 32 files changed, 1017 insertions(+), 1627 deletions(-)

--
tejun
