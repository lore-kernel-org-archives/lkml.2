Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1EFBNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:13:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40510 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1EFBNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:13:51 -0400
Message-ID: <4DC34B21.9040203@oracle.com>
Date: Thu, 05 May 2011 18:13:05 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci, dmar: flush IOTLB before exit domain
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DC34B2C.000C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


during one hotplug testing on system that support iommu/dmar.
got memory corruption.

[  578.279327] pci 0000:c4:00.0: no hotplug settings from platform
[  578.299240] scsi11 : Fusion MPT SAS Host
[  578.301033] mpt2sas2: mpt2sas_base_attach
[  578.302643] mpt2sas2: mpt2sas_base_map_resources
[  578.302797] BUG: Bad page state in process udevd  pfn:dffe23e
[  578.302801] page:ffffea030ff97d90 count:0 mapcount:-27 mapping:          (null) index:0xffff88dffe23eec0
[  578.302803] page flags: 0x1a00000000000000()
[  578.302807] Pid: 18215, comm: udevd Not tainted 2.6.39-rc5-tip-yh-03961-gced6a85-dirty #898
[  578.302809] Call Trace:
[  578.302825]  [<ffffffff81101528>] ? dump_page+0xbb/0xc0
[  578.302831]  [<ffffffff8110160a>] bad_page+0xdd/0xf2
[  578.302838]  [<ffffffff811023e6>] prep_new_page+0x70/0x141
[  578.302844]  [<ffffffff811028da>] get_page_from_freelist+0x423/0x59f
[  578.302851]  [<ffffffff81102c0a>] __alloc_pages_nodemask+0x1b4/0x7fe
[  578.302864]  [<ffffffff810a276a>] ? local_clock+0x2b/0x3c
[  578.302879]  [<ffffffff8111929e>] ? __pud_alloc+0x73/0x84
[  578.302885]  [<ffffffff810a276a>] ? local_clock+0x2b/0x3c
[  578.302896]  [<ffffffff8112d5a1>] alloc_pages_current+0xba/0xdd
[  578.302903]  [<ffffffff810ff774>] __get_free_pages+0xe/0x4b
[  578.302909]  [<ffffffff810ff7c7>] get_zeroed_page+0x16/0x18
[  578.302915]  [<ffffffff811192d1>] __pmd_alloc+0x22/0x85
[  578.302922]  [<ffffffff8111a6ad>] copy_page_range+0x238/0x3d8
[  578.302938]  [<ffffffff8107dd1b>] dup_mmap+0x2b9/0x375
[  578.302944]  [<ffffffff8107e3c5>] dup_mm+0xab/0x171
[  578.302951]  [<ffffffff8107eb99>] copy_process+0x6ea/0xd8e
[  578.302959]  [<ffffffff810b1a87>] ? __lock_release+0x166/0x16f
[  578.302965]  [<ffffffff8107f396>] do_fork+0x130/0x2dd
[  578.302976]  [<ffffffff811541c2>] ? mntput_no_expire+0x27/0xc8
[  578.302982]  [<ffffffff81154289>] ? mntput+0x26/0x28
[  578.302994]  [<ffffffff8113c429>] ? __fput+0x1b9/0x1c8
[  578.303004]  [<ffffffff81c2f69c>] ? sysret_check+0x27/0x62
[  578.303015]  [<ffffffff81040f41>] sys_clone+0x28/0x2a
[  578.303021]  [<ffffffff81c2f953>] stub_clone+0x13/0x20
[  578.303027]  [<ffffffff81c2f66b>] ? system_call_fastpath+0x16/0x1b

the bug is uncoverred by

| commit a97590e56d0d58e1dd262353f7cbd84e81d8e600
| Author: Alex Williamson <alex.williamson@redhat.com>
| Date:   Fri Mar 4 14:52:16 2011 -0700
|
|    intel-iommu: Unlink domain from iommu
|    
|    When we remove a device, we unlink the iommu from the domain, but
|    we never do the reverse unlinking of the domain from the iommu.
|    This means that we never clear iommu->domain_ids, eventually leading
|    to resource exhaustion if we repeatedly bind and unbind a device
|    to a driver.  Also free empty domains to avoid a resource leak.

that will remove domain really...
It exposes the problem that defer flushing is not handled properly during hot removing.

Try to flush unmaps before exit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intel-iommu.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -3252,6 +3252,9 @@ static int device_notifier(struct notifi
 		return 0;
 
 	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
+		/* before we remove dev with domain, flush IOTLB */
+		flush_unmaps();
+
 		domain_remove_one_dev_info(domain, pdev);
 
 		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
