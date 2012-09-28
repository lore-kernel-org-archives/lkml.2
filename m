Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031563Ab2I1TnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:43:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238Ab2I1S7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 107/262] xen/boot: Disable BIOS SMP MP table search.
Date: Fri, 28 Sep 2012 11:50:36 -0700
Message-Id: <20120928183010.840372407@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit bd49940a35ec7d488ae63bd625639893b3385b97 upstream.

As the initial domain we are able to search/map certain regions
of memory to harvest configuration data. For all low-level we
use ACPI tables - for interrupts we use exclusively ACPI _PRT
(so DSDT) and MADT for INT_SRC_OVR.

The SMP MP table is not used at all. As a matter of fact we do
not even support machines that only have SMP MP but no ACPI tables.

Lets follow how Moorestown does it and just disable searching
for BIOS SMP tables.

This also fixes an issue on HP Proliant BL680c G5 and DL380 G6:

9f->100 for 1:1 PTE
Freeing 9f-100 pfn range: 97 pages freed
1-1 mapping on 9f->100
.. snip..
e820: BIOS-provided physical RAM map:
Xen: [mem 0x0000000000000000-0x000000000009efff] usable
Xen: [mem 0x000000000009f400-0x00000000000fffff] reserved
Xen: [mem 0x0000000000100000-0x00000000cfd1dfff] usable
.. snip..
Scan for SMP in [mem 0x00000000-0x000003ff]
Scan for SMP in [mem 0x0009fc00-0x0009ffff]
Scan for SMP in [mem 0x000f0000-0x000fffff]
found SMP MP-table at [mem 0x000f4fa0-0x000f4faf] mapped at [ffff8800000f4fa0]
(XEN) mm.c:908:d0 Error getting mfn 100 (pfn 5555555555555555) from L1 entry 0000000000100461 for l1e_owner=0, pg_owner=0
(XEN) mm.c:4995:d0 ptwr_emulate: could not get_page_from_l1e()
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81ac07e2>] xen_set_pte_init+0x66/0x71
. snip..
Pid: 0, comm: swapper Not tainted 3.6.0-rc6upstream-00188-gb6fb969-dirty #2 HP ProLiant BL680c G5
.. snip..
Call Trace:
 [<ffffffff81ad31c6>] __early_ioremap+0x18a/0x248
 [<ffffffff81624731>] ? printk+0x48/0x4a
 [<ffffffff81ad32ac>] early_ioremap+0x13/0x15
 [<ffffffff81acc140>] get_mpc_size+0x2f/0x67
 [<ffffffff81acc284>] smp_scan_config+0x10c/0x136
 [<ffffffff81acc2e4>] default_find_smp_config+0x36/0x5a
 [<ffffffff81ac3085>] setup_arch+0x5b3/0xb5b
 [<ffffffff81624731>] ? printk+0x48/0x4a
 [<ffffffff81abca7f>] start_kernel+0x90/0x390
 [<ffffffff81abc356>] x86_64_start_reservations+0x131/0x136
 [<ffffffff81abfa83>] xen_start_kernel+0x65f/0x661
(XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

which is that ioremap would end up mapping 0xff using _PAGE_IOMAP
(which is what early_ioremap sticks as a flag) - which meant
we would get MFN 0xFF (pte ff461, which is OK), and then it would
also map 0x100 (b/c ioremap tries to get page aligned request, and
it was trying to map 0xf4fa0 + PAGE_SIZE - so it mapped the next page)
as _PAGE_IOMAP. Since 0x100 is actually a RAM page, and the _PAGE_IOMAP
bypasses the P2M lookup we would happily set the PTE to 1000461.
Xen would deny the request since we do not have access to the
Machine Frame Number (MFN) of 0x100. The P2M[0x100] is for example
0x80140.

Fixes-Oracle-Bugzilla: https://bugzilla.oracle.com/bugzilla/show_bug.cgi?id=13665
Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1422,6 +1422,10 @@ asmlinkage void __init xen_start_kernel(
 		pci_request_acs();
 
 		xen_acpi_sleep_register();
+
+		/* Avoid searching for BIOS MP tables */
+		x86_init.mpparse.find_smp_config = x86_init_noop;
+		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 	}
 #ifdef CONFIG_PCI
 	/* PCI BIOS service won't work from a PV guest. */


