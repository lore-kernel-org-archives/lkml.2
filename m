Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1BLRLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:11:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1BLRLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=mUdJ3+FGf1FfMBZwkYMtEOsqGmE+c9xedW4LYtOtVppDLOlVi8QuCd4bcWAr60DTbv
         B/el6jl1oGP0+5CEtHeNLdVIU5JA5/Xsa3jKawrHzOw5nI+ZVik4VBbcAG+ge3k1Cisp
         lXRTNEwYnVtb1IIgWqqyzuei7Ghf8Gsee35xM=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Subject: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA configuration
Date: Sat, 12 Feb 2011 18:10:37 +0100
Message-Id: <1297530663-26234-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently, x86-64 NUMA configuration is unnecessarily complicated with
srat_64, amdtopology_64, dummy and emulation all doing about the same
things in slightly different ways.  This makes the code difficult to
comprehend, maintain and extend.

The worst offender is the NUMA emulation which maps and reverse maps
things in quite chaotic ways.  For example, CPU node remapping is done
by finding out the node the CPU is mapped to, taking the start address
and looking up the containing physical node, and then again looking
for emulated nodes which fall in the physical node.  Another
interesting example is node distance remapping whem the system is
using amdtopology - it generates pseudo ACPI PXM mapping.

This is the first of two patchset series.  This one cleans up x86-64
NUMA configuration so that specific implementations - srat,
amdtopology and dummy - only have to supply the information about the
actul configuration.  All the mangling and massaging are done inside
numa_64.c proper using the provided information.

This patchset implements all the infrastructure to make NUMA emulation
sane but doesn't actually update NUMA emulation.  It will be done by
the next patchset.  As it still retains old code and glues to keep
them working, LOC is increased by 60 lines.  After the second
patchset, the net LOC change will be -123 lines.

Once the x86-64 update is settled, x86-32 will be moved over to share
the new infrastructure.

This patchset is on top of the current tip/x86/numa[1] and contains
the following 26 patches.

Tested on an opteron NUMA machine which can do both ACPI and AMD
configs.  All NUMA configs, emulation, !NUMA and UP work as expected.

 0001-x86-64-NUMA-Make-dummy-node-initialization-path-simi.patch
 0002-x86-64-NUMA-Simplify-hotplug-node-handling-in-acpi_n.patch
 0003-x86-64-NUMA-Drop-start-last_pfn-from-initmem_init.patch
 0004-x86-64-NUMA-Unify-acpi-amd-_-numa_init-scan_nodes-ar.patch
 0005-x86-64-NUMA-Wrap-acpi_numa_init-so-that-failure-can-.patch
 0006-x86-64-NUMA-Move-_numa_init-invocations-into-initmem.patch
 0007-x86-64-NUMA-Restructure-initmem_init.patch
 0008-x86-64-NUMA-Use-common-cpu-mem-_nodes_parsed.patch
 0009-x86-64-NUMA-Remove-local-variable-found-from-amd_num.patch
 0010-x86-64-NUMA-Move-apicid-to-numa-mapping-initializati.patch
 0011-x86-64-NUMA-Use-common-numa_nodes.patch
 0012-x86-64-NUMA-Kill-acpi-amd-_get_nodes.patch
 0013-x86-64-NUMA-Factor-out-memblk-handling-into-numa_-ad.patch
 0014-x86-64-NUMA-Unify-use-of-memblk-in-all-init-methods.patch
 0015-x86-64-NUMA-Unify-the-rest-of-memblk-registration.patch
 0016-x86-64-NUMA-Kill-acpi-amd-dummy-_scan_nodes.patch
 0017-x86-64-NUMA-Remove-NULL-nodeids-handling-from-comput.patch
 0018-x86-64-NUMA-Introduce-struct-numa_meminfo.patch
 0019-x86-64-NUMA-Separate-out-numa_cleanup_meminfo.patch
 0020-x86-64-NUMA-make-numa_cleanup_meminfo-prettier.patch
 0021-x86-64-NUMA-consolidate-and-improve-memblk-sanity-ch.patch
 0022-x86-64-NUMA-Add-common-find_node_by_addr.patch
 0023-x86-64-NUMA-kill-numa_nodes.patch
 0024-x86-64-NUMA-Rename-cpu_nodes_parsed-to-numa_nodes_pa.patch
 0025-x86-64-NUMA-Kill-mem_nodes_parsed.patch
 0026-x86-64-NUMA-Implement-generic-node-distance-handling.patch

The patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-unify

Diffstat follows.

 arch/x86/include/asm/acpi.h       |    6 
 arch/x86/include/asm/amd_nb.h     |    4 
 arch/x86/include/asm/numa_64.h    |   11 
 arch/x86/include/asm/page_types.h |    3 
 arch/x86/include/asm/topology.h   |    2 
 arch/x86/kernel/setup.c           |   16 -
 arch/x86/mm/amdtopology_64.c      |  117 ++------
 arch/x86/mm/init_64.c             |    5 
 arch/x86/mm/numa_64.c             |  507 ++++++++++++++++++++++++++++++++------
 arch/x86/mm/srat_64.c             |  290 +--------------------
 drivers/acpi/numa.c               |    9 
 11 files changed, 515 insertions(+), 455 deletions(-)

Thanks.

--
tejun

[1] eff9073790e1286aa12bf1c65814d3e0132b12e1 (x86: Rename incorrectly
    named parameter of numa_cpu_node())
