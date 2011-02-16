Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab1BPMVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab1BPMVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=uvo3+iOcC/gCpZ5RQPSn1YczZetaQT2M7XV5cmubZmlEdEFCAYpfu+/0+N085LkT1R
         a2ujP37k43O+cUrsE61PXCEuvVl76592EO/57agKWoecxvRQeuLuvtd8KdG3NngK4Wok
         yPm9C9VQ03zr1BcUy4upAKQtPBD4tXWgOEjC8=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Subject: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA config/emulation
Date: Wed, 16 Feb 2011 13:20:34 +0100
Message-Id: <1297858867-25981-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is combination of bring-sanity-to-NUMA-configuration[1]
and bring-sanity-to-NUMA-emulation[2] patchsets.  The patchsets have
been rebased on the current tip/x86/mm[3].

Most conflicts are from the addition of init_memory_mapping_high() by
commit 1411e0ec31 (x86-64, numa: Put pgtable to local node memory).
The patches in this series have been updated to carry the calls around
but the changes are all straight forward.

This patchset contains the following 33 patches

 0001-x86-64-NUMA-Make-dummy-node-initialization-path-simi.patch
 0002-x86-64-NUMA-Simplify-hotplug-node-handling-in-acpi_n.patch
 0003-x86-NUMA-Drop-start-last_pfn-from-initmem_init.patch
 0004-x86-64-NUMA-Unify-acpi-amd-_-numa_init-scan_nodes-ar.patch
 0005-x86-64-NUMA-Wrap-acpi_numa_init-so-that-failure-can-.patch
 0006-x86-NUMA-Move-_numa_init-invocations-into-initmem_in.patch
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
 0023-x86-64-NUMA-Kill-numa_nodes.patch
 0024-x86-64-NUMA-Rename-cpu_nodes_parsed-to-numa_nodes_pa.patch
 0025-x86-64-NUMA-Kill-mem_nodes_parsed.patch
 0026-x86-64-NUMA-Implement-generic-node-distance-handling.patch
 0027-x86-64-NUMA-Trivial-changes-to-prepare-for-emulation.patch
 0028-x86-64-NUMA-Build-and-use-direct-emulated-nid-phys-n.patch
 0029-x86-64-NUMA-Make-emulation-code-build-numa_meminfo-a.patch
 0030-x86-64-NUMA-Wrap-node-ID-during-emulation.patch
 0031-x86-64-NUMA-Emulate-directly-from-numa_meminfo.patch
 0032-x86-64-NUMA-Unify-emulated-apicid-node-mapping-trans.patch
 0033-x86-64-NUMA-Unify-emulated-distance-mapping.patch

and is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify

Upto patch 26, which excludes all emulation related changes, is
available in the branch x86_64-numa-unify.  Diffstat follows.

 arch/x86/include/asm/acpi.h       |   10 
 arch/x86/include/asm/amd_nb.h     |    8 
 arch/x86/include/asm/numa_64.h    |   10 
 arch/x86/include/asm/page_types.h |    3 
 arch/x86/include/asm/topology.h   |    2 
 arch/x86/kernel/setup.c           |   16 
 arch/x86/mm/amdtopology_64.c      |  142 ------
 arch/x86/mm/init_32.c             |    3 
 arch/x86/mm/init_64.c             |    5 
 arch/x86/mm/numa_32.c             |    3 
 arch/x86/mm/numa_64.c             |  816 ++++++++++++++++++++++++++------------
 arch/x86/mm/srat_64.c             |  365 ----------------
 drivers/acpi/numa.c               |    9 
 13 files changed, 632 insertions(+), 760 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1099256/
[2] http://thread.gmane.org/gmane.linux.kernel/1099981
[3] 275a88d3cf0e: Merge branch 'x86/amd-nb' into x86/mm
