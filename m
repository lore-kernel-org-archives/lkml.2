Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0H3LTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:19:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:32241 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0H3LTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:19:38 -0400
X-IronPort-AV: E=Sophos;i="4.56,292,1280707200"; 
   d="scan'208";a="1602621"
Date: Mon, 30 Aug 2010 12:20:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/7] PV on HVM: receive interrupts as xen events
Message-ID: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces some performance improvements for xen PV on
HVM guests: interacting with the emulated APIC is slow because it causes
traps in the hypervisor while receiving xen events using the vector callback
mechanism allow us to skip all that. For this reason we remap interrupts
and MSIs into xen pirqs so that from that point on we can receive them
as xen events instead.
This series is based on Konrad's pcifront series (not upstream yet):

http://lkml.org/lkml/2010/8/4/374

and requires a patch to xen and a patch to qemu-xen (just sent to
xen-devel).


The list of patches with diffstat follows:

Jeremy Fitzhardinge (2):
 xen: add xen hvm acpi_register_gsi variant
 acpi: use indirect call to register gsi in different modes

Stefano Stabellini (5):
 xen: xen: map MSIs into pirqs
 xen: support GSI -> pirq remapping in PV on HVM guests
 xen: implement xen_hvm_register_pirq
 xen: get the maximum number of pirqs from xen
 xen: support pirq != irq


 arch/x86/include/asm/acpi.h      |    3 +
 arch/x86/include/asm/xen/pci.h   |   10 +++
 arch/x86/kernel/acpi/boot.c      |   60 ++++++++++++++------
 arch/x86/pci/xen.c               |  114 ++++++++++++++++++++++++++++++++++++++
 drivers/pci/xen-pcifront.c       |    2 +-
 drivers/xen/events.c             |  106 +++++++++++++++++++++++++++++++----
 include/xen/events.h             |    3 +
 include/xen/interface/features.h |    3 +
 include/xen/interface/physdev.h  |   36 ++++++++++++
 9 files changed, 308 insertions(+), 29 deletions(-)


A git tree with this series and Konrad's pcifront series on top of Linux
2.6.36-rc1 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc1-pvhvm-pirq-v3

Cheers,

Stefano Stabellini
