Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0JLQeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:34:23 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29151 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab0JLQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:34:22 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283731200"; 
   d="scan'208";a="2306841"
Date: Tue, 12 Oct 2010 17:34:19 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH v4 0/7] PV on HVM: receive interrupts as xen events
Message-ID: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
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
This series is based on Konrad's pcifront series:

http://lkml.org/lkml/2010/10/12/207

and requires a patch to xen and a patch to qemu-xen (both sent to the
list).


New changes in v4:
- xen_hvm_register_pirq has been made static;

- the functions in arch/x86/pci/xen.c that depends on CONFIG_ACPI have
been ifdef'ed.


The list of patches with diffstat follows:

Jeremy Fitzhardinge (2):
      acpi: use indirect call to register gsi in different modes
      xen: add xen hvm acpi_register_gsi variant

Stefano Stabellini (5):
      xen: support pirq != irq
      xen: get the maximum number of pirqs from xen
      xen: implement xen_hvm_register_pirq
      xen: support GSI -> pirq remapping in PV on HVM guests
      xen: map MSIs into pirqs

 arch/x86/include/asm/acpi.h      |    3 +
 arch/x86/include/asm/xen/pci.h   |    5 ++
 arch/x86/kernel/acpi/boot.c      |   60 ++++++++++++++-----
 arch/x86/pci/xen.c               |  117 +++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c             |  120 ++++++++++++++++++++++++++++++++------
 include/xen/events.h             |    3 +
 include/xen/interface/features.h |    3 +
 include/xen/interface/physdev.h  |   36 +++++++++++
 8 files changed, 311 insertions(+), 36 deletions(-)



A git tree with this series and Konrad's pcifront series on top of Linux
2.6.36-rc6 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc6-pvhvm-pirq-v4

Cheers,

Stefano Stabellini
