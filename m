Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1EYDAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:00:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1EYDAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:00:09 -0400
Date: Wed, 25 May 2011 13:00:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the dwmw2-iommu tree with Linus' tree
Message-Id: <20110525130004.150c054f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the dwmw2-iommu tree got a conflict in
arch/x86/kernel/apic/apic.c between commit 31dce14a3269 ("x86, ioapic:
Use ioapic_saved_data while enabling intr-remapping") from Linus' tree and
commit 6a87c5ec6463 ("intel-iommu: enable x2apic opt out") from the
dwmw2-iommu tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/apic/apic.c
index b961af8,fb1c36c..0000000
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@@ -1461,16 -1450,24 +1461,17 @@@ int __init enable_IR(void
  void __init enable_IR_x2apic(void)
  {
  	unsigned long flags;
- 	int ret, x2apic_enabled = 0;
 -	struct IO_APIC_route_entry **ioapic_entries;
+ 	int ret = 0, x2apic_enabled = 0;
  	int dmar_table_init_ret;
  
  	dmar_table_init_ret = dmar_table_init();
- 	if (dmar_table_init_ret && !x2apic_supported())
+ 	if (dmar_table_init_ret && !cpu_has_x2apic)
  		return;
  
 -	ioapic_entries = alloc_ioapic_entries();
 -	if (!ioapic_entries) {
 -		pr_err("Allocate ioapic_entries failed\n");
 -		goto out;
 -	}
 -
 -	ret = save_IO_APIC_setup(ioapic_entries);
 +	ret = save_ioapic_entries();
  	if (ret) {
  		pr_info("Saving IO-APIC state failed: %d\n", ret);
+ 		ret = 0;
  		goto out;
  	}
  
