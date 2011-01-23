Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1AWNhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:37:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1AWNhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:37:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=osXtei9AllTqNt9KB8C9l0gRzusccGkNqhOyGFsH/CLTvia6hw7ejHoQQq7S6U300J
         Qs98uunqZ7WWwbWs5OMw3RfYePT+MXxfXW88+FnnROqWgkOurafDdrJYmxELDykQnSOC
         +v7CBrWO+tkh0X1z4MP0/u86fTH7XoPjmd3AI=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, penberg@kernel.org, shaohui.zheng@intel.com,
        rientjes@google.com
Subject: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#5
Date: Sun, 23 Jan 2011 14:37:26 +0100
Message-Id: <1295789862-25482-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the fifth take of unify-x86_32-and-64-NUMA-init-paths
patchset.

It's rebased (again!) on top of v2.6.39-rc2.  There isn't any change
from the last take[L] other than what's necessary for the rebasing.

As commit 56d91f13 already introduced MAX_LOCAL_APIC but didn't
replace MAX_APICID, the second patch is updated to convert the users
of MAX_APICID and drop MAX_APICID.  0015 also received updates to
accomodate changes made by d906f0eb.  Other than the two mentioned
changes, all changes were trivial context updates.

This patchset contains the following sixteen patches.

 0001-x86-Kill-unused-static-boot_cpu_logical_apicid-in-sm.patch
 0002-x86-Drop-x86_32-MAX_APICID.patch
 0003-x86-Make-default_send_IPI_mask_sequence-allbutself_l.patch
 0004-x86-Replace-cpu_2_logical_apicid-with-early-percpu-v.patch
 0005-x86-Always-use-x86_cpu_to_logical_apicid-for-cpu-log.patch
 0006-x86-Kill-apic-cpu_to_logical_apicid.patch
 0007-x86-Add-apic-x86_32_early_logical_apicid.patch
 0008-x86-Implement-the-default-x86_32_early_logical_apici.patch
 0009-x86-Implement-x86_32_early_logical_apicid-for-bigsmp.patch
 0010-x86-Implement-x86_32_early_logical_apicid-for-summit.patch
 0011-x86-Implement-x86_32_early_logical_apicid-for-numaq_.patch
 0012-x86-Replace-apic-apicid_to_node-with-x86_32_numa_cpu.patch
 0013-x86-Unify-cpu-apicid-NUMA-node-mapping-between-32-an.patch
 0014-x86-Unify-CPU-NUMA-node-mapping-between-32-and-64bit.patch
 0015-x86-Unify-node_to_cpumask_map-handling-between-32-an.patch
 0016-x86-Unify-NUMA-initialization-between-32-and-64bit.patch

It's based on top of v2.6.38-rc2 (1bae4ce2) and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git unify-numa

Diffstat follows.

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/apic.h           |   36 +++--
 arch/x86/include/asm/ipi.h            |    8 -
 arch/x86/include/asm/mpspec.h         |    3 
 arch/x86/include/asm/numa.h           |   49 +++++++
 arch/x86/include/asm/numa_32.h        |    7 -
 arch/x86/include/asm/numa_64.h        |   16 --
 arch/x86/include/asm/smp.h            |    3 
 arch/x86/include/asm/topology.h       |   17 --
 arch/x86/kernel/acpi/boot.c           |    8 -
 arch/x86/kernel/apic/apic.c           |   39 +++++
 arch/x86/kernel/apic/apic_flat_64.c   |    4 
 arch/x86/kernel/apic/apic_noop.c      |   26 +--
 arch/x86/kernel/apic/bigsmp_32.c      |   34 ++---
 arch/x86/kernel/apic/es7000_32.c      |   35 ++---
 arch/x86/kernel/apic/ipi.c            |   12 -
 arch/x86/kernel/apic/numaq_32.c       |   21 +--
 arch/x86/kernel/apic/probe_32.c       |   10 +
 arch/x86/kernel/apic/summit_32.c      |   47 ++-----
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |    2 
 arch/x86/kernel/cpu/amd.c             |   51 ++++---
 arch/x86/kernel/cpu/common.c          |    2 
 arch/x86/kernel/cpu/intel.c           |    5 
 arch/x86/kernel/setup.c               |    2 
 arch/x86/kernel/setup_percpu.c        |   11 +
 arch/x86/kernel/smpboot.c             |   68 ----------
 arch/x86/mm/amdtopology_64.c          |    4 
 arch/x86/mm/numa.c                    |  208 ++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_32.c                 |    7 +
 arch/x86/mm/numa_64.c                 |  227 ++--------------------------------
 arch/x86/mm/srat_32.c                 |    6 
 arch/x86/mm/srat_64.c                 |   12 -
 34 files changed, 498 insertions(+), 488 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/1081733
