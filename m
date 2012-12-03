Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2LCOyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:54:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43621 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab2LCOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:54 -0500
Message-Id: <20121203143159.454613580@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:10 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jianguo Wu <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 84/89] mm/vmemmap: fix wrong use of virt_to_page
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit ae64ffcac35de0db628ba9631edf8ff34c5cd7ac upstream.

I enable CONFIG_DEBUG_VIRTUAL and CONFIG_SPARSEMEM_VMEMMAP, when doing
memory hotremove, there is a kernel BUG at arch/x86/mm/physaddr.c:20.

It is caused by free_section_usemap()->virt_to_page(), virt_to_page() is
only used for kernel direct mapping address, but sparse-vmemmap uses
vmemmap address, so it is going wrong here.

  ------------[ cut here ]------------
  kernel BUG at arch/x86/mm/physaddr.c:20!
  invalid opcode: 0000 [#1] SMP
  Modules linked in: acpihp_drv acpihp_slot edd cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse vfat fat loop dm_mod coretemp kvm crc32c_intel ipv6 ixgbe igb iTCO_wdt i7core_edac edac_core pcspkr iTCO_vendor_support ioatdma microcode joydev sr_mod i2c_i801 dca lpc_ich mfd_core mdio tpm_tis i2c_core hid_generic tpm cdrom sg tpm_bios rtc_cmos button ext3 jbd mbcache usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif processor thermal_sys hwmon scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh_emc scsi_dh ata_generic ata_piix libata megaraid_sas scsi_mod
  CPU 39
  Pid: 6454, comm: sh Not tainted 3.7.0-rc1-acpihp-final+ #45 QCI QSSC-S4R/QSSC-S4R
  RIP: 0010:[<ffffffff8103c908>]  [<ffffffff8103c908>] __phys_addr+0x88/0x90
  RSP: 0018:ffff8804440d7c08  EFLAGS: 00010006
  RAX: 0000000000000006 RBX: ffffea0012000000 RCX: 000000000000002c
  ...

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reviewd-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/sparse.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index fac95f2..a83de2f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -617,7 +617,7 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 {
 	return; /* XXX: Not implemented yet */
 }
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 }
 #else
@@ -658,10 +658,11 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 			   get_order(sizeof(struct page) * nr_pages));
 }
 
-static void free_map_bootmem(struct page *page, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
 	unsigned long magic;
+	struct page *page = virt_to_page(memmap);
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
@@ -710,13 +711,10 @@ static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 	 */
 
 	if (memmap) {
-		struct page *memmap_page;
-		memmap_page = virt_to_page(memmap);
-
 		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
 			>> PAGE_SHIFT;
 
-		free_map_bootmem(memmap_page, nr_pages);
+		free_map_bootmem(memmap, nr_pages);
 	}
 }
 


