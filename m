Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2BWRlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:41:52 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:16914 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2BWRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:41:50 -0500
X-IronPort-AV: E=Sophos;i="4.73,470,1325462400"; 
   d="scan'208";a="10904372"
Date: Thu, 23 Feb 2012 17:47:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <kvm@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH-WIP 00/13] xen/arm: receive Xen events and initialize
 xenbus
Message-ID: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series is part of the work in progress support for Xen on
ARMv7 with virtualization extensions in Linux.

It is obviously NOT ready to be accepted upstream but implements
enough support to allow Linux Dom0 to receive event channel
notifications and initialize xenbus.
With this series applied and the corresponding Xen patch series
(http://marc.info/?l=xen-devel&m=133001696312879) is possible to boot
Linux as Dom0 on Xen on a Versatile Express Cortex A15 emulator and
issue basic xl commands, like "xl list" and "xl uptime".
"xl create" is still not working though but it is the next on the list
:)


Working on this series it became obvious that passing the hypercall
number as IMM parameter to HVC is not flexible enough because we don't
always know the hypercall number at compile time.
As a result I changed the hypercall.h header file to use r12 to pass the
hypercall number instead. r12 was chosen because it is defined as
"intra-procedure call scratch register" so it seems the most appropriate. 

I have CC'ed the KVM list on the first patch because following previous
discussions hypercall.h might become a common header file to issue
hypercalls on different hypervisors on ARM. I haven't disentangled the
Xen specific bits from the generic ones yet, however it should be
straightforward.

I am looking forward to hearing your opinions, especially on the
hypercall calling convention.


The patch series is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-1

It is based on the vexpress-dt branch of
git://xenbits.xen.org/people/dvrabel/linux.git, that we are currently
using as development tree for Linux on Xen on Cortex A15.  See
http://wiki.xen.org/wiki/Xen_ARMv7_with_Virtualization_Extensions.


The list of patches with diffstat follows:

Stefano Stabellini (13):
      xen/arm: use r12 to pass the hypercall number to the hypervisor
      xen/arm: introduce privcmp, physdev_op and memory_op hypercalls.
      xen/arm: mmu.h and page.h related definitions
      xen/arm: sync_bitops
      xen/arm: empty implementation of grant_table arch specific functions
      xen/arm: missing includes
      xen/arm: receive xen events on arm
      xen/arm: fix arm xen guest handle definitions
      xen/arm: shared_info and start_info
      xen/arm: empty implementation of xen_remap_domain_mfn_range
      xen/arm: Introduce xen_pfn_t for pfn and mfn types
      xen/arm: compile and run xenbus
      xen/arm: compile grant-table features events and xenbus, do not compile pci

 arch/arm/Kconfig                           |    4 +
 arch/arm/include/asm/sync_bitops.h         |   17 ++++
 arch/arm/include/asm/xen/events.h          |    9 ++
 arch/arm/include/asm/xen/grant_table.h     |    2 +
 arch/arm/include/asm/xen/hypercall.h       |  111 ++++++++++++++++++----------
 arch/arm/include/asm/xen/interface.h       |   12 +--
 arch/arm/include/asm/xen/mmu.h             |   61 +++++++++++++++
 arch/arm/include/asm/xen/page.h            |   14 +++-
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/enlighten.c                   |   71 ++++++++++++++++--
 arch/arm/xen/grant-table.c                 |   47 ++++++++++++
 arch/ia64/include/asm/xen/interface.h      |    3 +-
 arch/x86/include/asm/xen/interface.h       |    3 +
 drivers/xen/Makefile                       |    7 +-
 drivers/xen/events.c                       |   36 +++++++++-
 drivers/xen/grant-table.c                  |    2 +
 drivers/xen/xenbus/xenbus_client.c         |    1 +
 drivers/xen/xenbus/xenbus_comms.c          |    2 +-
 drivers/xen/xenbus/xenbus_probe.c          |   26 ++++---
 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 drivers/xen/xenbus/xenbus_xs.c             |    3 +-
 drivers/xen/xenfs/xenstored.c              |    1 +
 include/xen/interface/grant_table.h        |    4 +-
 include/xen/interface/memory.h             |    6 +-
 include/xen/interface/platform.h           |    4 +-
 include/xen/interface/xen.h                |    6 +-
 include/xen/privcmd.h                      |    3 +-
 include/xen/xen.h                          |    2 +-
 28 files changed, 371 insertions(+), 89 deletions(-)


Cheers,

Stefano
