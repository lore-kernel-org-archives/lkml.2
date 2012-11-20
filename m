Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2KTGdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:33:42 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48734 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2KTGdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:33:39 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru devices
 assigned to KVM guests
Thread-Topic: [PATCH 0/4] AER-KVM: Error containment of PCI pass-thru
 devices assigned to KVM guests
Thread-Index: AQHNxui4h6c7cMTORE+3hu06XL5uJg==
Date: Tue, 20 Nov 2012 06:31:48 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146F4DA@G4W3208.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for error containment when a PCI pass-thru device assigned to a KVM
guest encounters an error. This is for PCIe devices/drivers that support AER
functionality. When the OS is notified of an error in a device either
through the firmware first approach or through an interrupt handled by the AER
root port driver, concerned subsystems are notified by invoking callbacks
registered by these subsystems. The device is also marked as tainted till the
corresponding driver recovery routines are successful. 

KVM module registers for a notification of such errors. In the KVM callback
routine, a global counter is incremented to keep track of the error
notification. Before each CPU enters guest mode to execute guest code,
appropriate checks are done to see if the impacted device belongs to the guest
or not. If the device belongs to the guest, qemu hypervisor for the guest is
informed and the guest is immediately brought down, thus preventing or
minimizing chances of any bad data being written out by the guest driver
after the device has encountered an error.

Note that the changes here are specific to  PCI pass-thru devices and is
confined to error containment. Error recovery is not included in these set
of changes. A future set of patches is planned to address SR-IOV devices and
VFIO devices assigned to guests as well as recovery without bringing down
the guest.

---
Vijay Mohan Pandarathil(4):

 AER-PCI: Add infrastructure for notification of errors to other subsystems
 AER-GHES: Add support for error notification in firmware first approach of AER
 AER-KVM: Integration of KVM with AER for PCI pass-thru devices
 AER-QEMU: Bring down the guest when KVM detects a PCI device error

 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 | 44 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/apei/ghes.c           | 41 +++++++++++++++++++++++++++++++++++
 drivers/pci/pcie/aer/aerdrv.c      | 20 +++++++++++++++++
 drivers/pci/pcie/aer/aerdrv_core.c |  9 +++++++-
 include/linux/aer.h                |  4 ++++
 include/linux/kvm_host.h           |  4 ++++
 include/linux/pci.h                |  2 ++
 include/uapi/linux/kvm.h           |  1 +
 virt/kvm/assigned-dev.c            | 34 +++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                | 34 +++++++++++++++++++++++++++++
 11 files changed, 193 insertions(+), 1 deletion(-)

 
Qemu files changed

 kvm-all.c                 |    6 ++++++
 linux-headers/linux/kvm.h |    1 +
 2 files changed, 7 insertions(+)
