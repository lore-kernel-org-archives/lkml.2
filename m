Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031628Ab2I1Tpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:45:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965190Ab2I1S7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andre Przywara <andre.przywara@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 108/262] xen/boot: Disable NUMA for PV guests.
Date: Fri, 28 Sep 2012 11:50:37 -0700
Message-Id: <20120928183010.961189317@linuxfoundation.org>
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

commit 8d54db795dfb1049d45dc34f0dddbc5347ec5642 upstream.

The hypervisor is in charge of allocating the proper "NUMA" memory
and dealing with the CPU scheduler to keep them bound to the proper
NUMA node. The PV guests (and PVHVM) have no inkling of where they
run and do not need to know that right now. In the future we will
need to inject NUMA configuration data (if a guest spans two or more
NUMA nodes) so that the kernel can make the right choices. But those
patches are not yet present.

In the meantime, disable the NUMA capability in the PV guest, which
also fixes a bootup issue. Andre says:

"we see Dom0 crashes due to the kernel detecting the NUMA topology not
by ACPI, but directly from the northbridge (CONFIG_AMD_NUMA).

This will detect the actual NUMA config of the physical machine, but
will crash about the mismatch with Dom0's virtual memory. Variation of
the theme: Dom0 sees what it's not supposed to see.

This happens with the said config option enabled and on a machine where
this scanning is still enabled (K8 and Fam10h, not Bulldozer class)

We have this dump then:
NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
Scanning NUMA topology in Northbridge 24
Number of physical nodes 4
Node 0 MemBase 0000000000000000 Limit 0000000040000000
Node 1 MemBase 0000000040000000 Limit 0000000138000000
Node 2 MemBase 0000000138000000 Limit 00000001f8000000
Node 3 MemBase 00000001f8000000 Limit 0000000238000000
Initmem setup node 0 0000000000000000-0000000040000000
  NODE_DATA [000000003ffd9000 - 000000003fffffff]
Initmem setup node 1 0000000040000000-0000000138000000
  NODE_DATA [0000000137fd9000 - 0000000137ffffff]
Initmem setup node 2 0000000138000000-00000001f8000000
  NODE_DATA [00000001f095e000 - 00000001f0984fff]
Initmem setup node 3 00000001f8000000-0000000238000000
Cannot find 159744 bytes in node 3
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81d220e6>] __alloc_bootmem_node+0x43/0x96
Pid: 0, comm: swapper Not tainted 3.3.6 #1 AMD Dinar/Dinar
RIP: e030:[<ffffffff81d220e6>]  [<ffffffff81d220e6>] __alloc_bootmem_node+0x43/0x96
.. snip..
  [<ffffffff81d23024>] sparse_early_usemaps_alloc_node+0x64/0x178
  [<ffffffff81d23348>] sparse_init+0xe4/0x25a
  [<ffffffff81d16840>] paging_init+0x13/0x22
  [<ffffffff81d07fbb>] setup_arch+0x9c6/0xa9b
  [<ffffffff81683954>] ? printk+0x3c/0x3e
  [<ffffffff81d01a38>] start_kernel+0xe5/0x468
  [<ffffffff81d012cf>] x86_64_start_reservations+0xba/0xc1
  [<ffffffff81007153>] ? xen_setup_runstate_info+0x2c/0x36
  [<ffffffff81d050ee>] xen_start_kernel+0x565/0x56c
"

so we just disable NUMA scanning by setting numa_off=1.

Reported-and-Tested-by: Andre Przywara <andre.przywara@amd.com>
Acked-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/setup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -17,6 +17,7 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/acpi.h>
+#include <asm/numa.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
@@ -549,4 +550,7 @@ void __init xen_arch_setup(void)
 	disable_cpufreq();
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
+#ifdef CONFIG_NUMA
+	numa_off = 1;
+#endif
 }


