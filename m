Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab0EADZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 23:25:34 -0400
Received: from vana.uk.cvut.cz ([147.32.245.124]:59576 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab0EADZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 23:25:31 -0400
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 23:25:31 EDT
Date: Sat, 1 May 2010 04:54:23 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes in PCIe space
Message-ID: <20100501025423.GA10671@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  openSUSE11.3 32bit kernels hang when installed to the VMware's VMs because Moorestown
fixed capabilities detection code enters endless loop on Intel's AGP bridges (with
device ID=7191).  See https://bugzilla.kernel.org/show_bug.cgi?id=15888 for additional
details.  arch/x86/pci/mrst.c was introduced after 2.6.33, so only 2.6.34-rcX are
affected.
				Thanks,
					Petr Vandrovec


commit 11a35e56ad8275cbf62882d9c0dc2f17c2b5628b
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Fri Apr 30 19:17:43 2010 -0700

    Do not expect PCI devices to return zeroes in PCIe space

    There is no reason why old pre-PCIe/PCI-X devices should return zeroes when
    configuration space above 0x100 is accessed.  If these devices decode just
    low 8 bits of register number, conventional space repeats 15 times in
    PCIe config space.  And Moorestown parser for fixed bars then can enter
    endless loop when finding Intel AGP bridge device 0x7191 with secondary
    latency timer programmed to 0x40 - when such device is encountered, code
    will enter endless loop of reading registers 0x718 (reading 0x40010100)
    and 0x400 (reading 0x71918086).

    This change adds additional condition to the test: if device id/vendor
    match first PCIe capability, then device is not really PCIe.  It should
    not cause any problems: fixed_bar_cap is invoked only on Intel's devices,
    so only time there is possibilty to have false match would be if first
    PCIe capability would have ID 0x8086, and even then that address of
    next capability pointer and capability version will match device ID seems
    highly unlikely.

    This fix unbreaks 32bit 2.6.33+ kernels configured with Moorestown
    support to boot on AMD rev 10h+ processors under VMware in VMs which
    lack PCIe support.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..cd6c277 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -55,12 +55,16 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 {
 	int pos;
 	u32 pcie_cap = 0, cap_data;
+	u32 devid;
 
 	pos = PCIE_CAP_OFFSET;
 
 	if (!raw_pci_ext_ops)
 		return 0;
 
+	if (raw_pci_ops->read(pci_domain_nr(bus), bus->number, devfn, 0, 4, &devid))
+		return 0;
+
 	while (pos) {
 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
 					  devfn, pos, 4, &pcie_cap))
@@ -69,6 +73,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 		if (pcie_cap == 0xffffffff)
 			return 0;
 
+		if (pcie_cap == devid && pos == PCIE_CAP_OFFSET)
+			return 0;
+
 		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
 			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
 					      devfn, pos + 4, 4, &cap_data);

