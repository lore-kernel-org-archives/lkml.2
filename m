Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2HUUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:36:18 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48117 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2HUUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:13 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113783"
From: Attilio Rao <attilio.rao@citrix.com>
To: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <Stefano.Stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>
CC: Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start and x86_init.paging.pagetable_setup_done setup functions and document its semantic
Date: Tue, 21 Aug 2012 21:22:36 +0100
Message-ID: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the definition of x86_init.paging.pagetable_setup_start and
x86_init.paging.pagetable_setup_done is twisted and not really well
defined (in terms of prototypes desired). More specifically:
pagetable_setup_start:
 * cleans up the boot time page table in the x86_32 case
 * it is a nop for the XEN case
 * it is a nop on x86_64

pagetable_setup_done:
 * it is a nop on x86_32
 * sets up accessor functions for pagetable manipulation, for the
   XEN case
 * it is a nop on x86_64

Most of this logic can be skipped by creating a new setup function that can
handle pagetable setup and pre/post operations on it. This means the above
mentioned functions will be removed and only one will be used for the whole
operation.
The new function must be called only once, during boot-time setup and
after the direct mapping for physical memory is available.

Differences with v1:
- The patch serie is re-arranged in a way that it helps reviews, following
  a plan by Thomas Gleixner
- The PVOPS nomenclature is not used as it is not correct
- The front-end message is adjusted with feedback by Thomas Gleixner,
  Stefano Stabellini and Konrad Rzeszutek Wilk 


Attilio Rao (5):
  X86/XEN: Remove the base argument from
    x86_init.paging.pagetable_setup_start
  X86/XEN: Rename pagetable_setup_start() setup functions into
    pagetable_init()
  X86/XEN: Allow setup function x86_init.paging.pagetable_init to setup
    kernel pagetables
  X86/XEN: Move content of xen_pagetable_setup_done() into
    xen_pagetable_init() and retire now unused
    x86_init.paging.pagetable_setup_done
  X86/XEN: Add few lines explaining simple semantic for
    x86_init.paging.pagetable_init setup function

 arch/x86/include/asm/pgtable_types.h |    6 ++----
 arch/x86/include/asm/x86_init.h      |   11 +++++++----
 arch/x86/kernel/setup.c              |    4 +---
 arch/x86/kernel/x86_init.c           |    4 +---
 arch/x86/mm/init_32.c                |   11 ++++-------
 arch/x86/xen/mmu.c                   |   18 +++++++-----------
 6 files changed, 22 insertions(+), 32 deletions(-)

-- 
1.7.2.5

