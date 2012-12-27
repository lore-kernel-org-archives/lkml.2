Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2L0CpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:45:24 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:37610 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2L0CpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:45:23 -0500
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 21:45:22 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, maxim.uvarov@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
Date: Thu, 27 Dec 2012 03:18:49 +0100
Message-Id: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
X-Bogosity: No, spamicity=0.482930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This set of patches contains initial kexec/kdump implementation for Xen v3.
Currently only dom0 is supported, however, almost all infrustructure
required for domU support is ready.

Jan Beulich suggested to merge Xen x86 assembler code with baremetal x86 code.
This could simplify and reduce a bit size of kernel code. However, this solution
requires some changes in baremetal x86 code. First of all code which establishes
transition page table should be moved back from machine_kexec_$(BITS).c to
relocate_kernel_$(BITS).S. Another important thing which should be changed in that
case is format of page_list array. Xen kexec hypercall requires to alternate physical
addresses with virtual ones. These and other required stuff have not been done in that
version because I am not sure that solution will be accepted by kexec/kdump maintainers.
I hope that this email spark discussion about that topic.

Daniel

 arch/x86/Kconfig                     |    3 +
 arch/x86/include/asm/kexec.h         |   10 +-
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/include/asm/xen/kexec.h     |   79 ++++
 arch/x86/kernel/machine_kexec_64.c   |   12 +-
 arch/x86/kernel/vmlinux.lds.S        |    7 +-
 arch/x86/xen/Kconfig                 |    1 +
 arch/x86/xen/Makefile                |    3 +
 arch/x86/xen/enlighten.c             |   11 +
 arch/x86/xen/kexec.c                 |  150 +++++++
 arch/x86/xen/machine_kexec_32.c      |  226 +++++++++++
 arch/x86/xen/machine_kexec_64.c      |  318 +++++++++++++++
 arch/x86/xen/relocate_kernel_32.S    |  323 +++++++++++++++
 arch/x86/xen/relocate_kernel_64.S    |  309 ++++++++++++++
 drivers/xen/sys-hypervisor.c         |   42 ++-
 include/linux/kexec.h                |   26 ++-
 include/xen/interface/xen.h          |   33 ++
 kernel/Makefile                      |    1 +
 kernel/kexec-firmware.c              |  743 ++++++++++++++++++++++++++++++++++
 kernel/kexec.c                       |   46 ++-
 20 files changed, 2331 insertions(+), 18 deletions(-)

Daniel Kiper (11):
      kexec: introduce kexec firmware support
      x86/kexec: Add extra pointers to transition page table PGD, PUD, PMD and PTE
      xen: Introduce architecture independent data for kexec/kdump
      x86/xen: Introduce architecture dependent data for kexec/kdump
      x86/xen: Register resources required by kexec-tools
      x86/xen: Add i386 kexec/kdump implementation
      x86/xen: Add x86_64 kexec/kdump implementation
      x86/xen: Add kexec/kdump Kconfig and makefile rules
      x86/xen/enlighten: Add init and crash kexec/kdump hooks
      drivers/xen: Export vmcoreinfo through sysfs
      x86: Add Xen kexec control code size check to linker script
