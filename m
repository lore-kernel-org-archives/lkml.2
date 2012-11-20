Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2KTPRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:17:17 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2KTPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:12 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: [PATCH v2 00/11] xen: Initial kexec/kdump implementation
Date: Tue, 20 Nov 2012 16:04:42 +0100
Message-Id: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
X-Bogosity: No, spamicity=0.475885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This set of patches contains initial kexec/kdump implementation for Xen v2
(previous version were posted to few people by mistake; sorry for that).
Currently only dom0 is supported, however, almost all infrustructure
required for domU support is ready.

Jan Beulich suggested to merge Xen x86 assembler code with baremetal x86 code.
This could simplify and reduce a bit size of kernel code. However, this solution
requires some changes in baremetal x86 code. The most important thing which should
be changed in that case is format of page_list array. Xen kexec hypercall requires
to alternate physical addresses with virtual ones. This and other required things
have not done in that version because I am not sure that solution will be accepted
by kexec/kdump maintainers. I hope that this email spark discussion about that topic.

Daniel

 arch/x86/include/asm/kexec.h         |   10 +-
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/include/asm/xen/kexec.h     |   83 +++++++++
 arch/x86/kernel/machine_kexec_64.c   |   12 +-
 arch/x86/kernel/vmlinux.lds.S        |    7 +-
 arch/x86/xen/Makefile                |    3 +
 arch/x86/xen/enlighten.c             |   12 ++
 arch/x86/xen/kexec.c                 |  150 ++++++++++++++++
 arch/x86/xen/machine_kexec_32.c      |  245 ++++++++++++++++++++++++++
 arch/x86/xen/machine_kexec_64.c      |  301 +++++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_32.S    |  323 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_64.S    |  309 ++++++++++++++++++++++++++++++++
 drivers/xen/sys-hypervisor.c         |   42 +++++-
 include/linux/kexec.h                |   18 ++
 include/xen/interface/xen.h          |   33 ++++
 kernel/kexec.c                       |  125 ++++++++++----
 16 files changed, 1636 insertions(+), 43 deletions(-)

Daniel Kiper (11):
      kexec: introduce kexec_ops struct
      x86/kexec: Add extra pointers to transition page table PGD, PUD, PMD and PTE
      xen: Introduce architecture independent data for kexec/kdump
      x86/xen: Introduce architecture dependent data for kexec/kdump
      x86/xen: Register resources required by kexec-tools
      x86/xen: Add i386 kexec/kdump implementation
      x86/xen: Add x86_64 kexec/kdump implementation
      x86/xen: Add kexec/kdump makefile rules
      x86/xen/enlighten: Add init and crash kexec/kdump hooks
      drivers/xen: Export vmcoreinfo through sysfs
      x86: Add Xen kexec control code size check to linker script
