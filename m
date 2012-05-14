Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2ENNsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:48:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2ENNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:48:54 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v2 0/7] dmaengine: enhance dmaengine to support DMA device hotplug
Date: Mon, 14 May 2012 21:47:02 +0800
Message-Id: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

From: Jiang Liu <liuj97@gmail.com>

This patch set enhances the dmaengine core and its clients to support
hot-removal of DMA devices at runtime, especially for IOAT devices.

Intel IOAT (Crystal Beach) devices are often built into PCIe root complex.
When hot-plugging a PCI root complex (IOH) on Intel Nehalem/Westmere
platforms, all IOAT devices built in the IOH must be handled first.
For future Intel processors with Integrated IOH (IIO), IOAT device will
get involved even when hot-plugging physical processors.

The dmaengine core already supports hot-add of IOAT devices, but hot-removal
of IOAT devices is still unsupported due to a design limiation in the
dmaengine core.

Currently dmaengine has an assumption that DMA devices could only be
deregistered when there's no any clients making use of DMA devices.
So dma_async_device_unregister() is designed to be called by DMA device
driver's module_exit routines only. But the ioatdma driver doesn't
conform to that rule, it calls dma_async_device_unregister() from its
driver detaching routine instead of module_exit routine.

This patch set enhances the dmaengine core to support DMA device hotplug,
so that dma_async_device_unregister() could be called by DMA driver's
detach routines to hot-remove DMA devices at runtime. It also tries
to optimize DMA channel allocation policy according to NUMA affinity.

v2: use percpu counter for channel reference count to avoid polluting
    global shared cachelines

echo 0000:80:16.7 > /sys/bus/pci/drivers/ioatdma/unbind
ioatdma 0000:80:16.7: Removing dma and dca services
------------[ cut here ]------------
WARNING: at drivers/dma/dmaengine.c:831 dma_async_device_unregister+0xd5/0xf0() (Tainted: G           ---------------- T)
Hardware name: System x3850 X5 -[7143O3G]-
dma_async_device_unregister called while 17 clients hold a reference
Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun kvm_intel kvm uinput microcode sg serio_raw cdc_ether usbnet mii be2net i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support shpchp i7core_edac edac_core ioatdma igb dca e1000e bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif qla2xxx pmcraid pata_acpi ata_generic ata_piix bfa(T) scsi_transport_fc scsi_tgt megaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Pid: 5143, comm: bash Tainted: G           ---------------- T 2.6.32-220.el6.x86_64 #1
Call Trace:
 [<ffffffff81069b77>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81069c66>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff813fe465>] ? dma_async_device_unregister+0xd5/0xf0
 [<ffffffffa00ec5e9>] ? ioat_dma_remove+0x28/0x4a [ioatdma]
 [<ffffffffa00ec5b9>] ? ioat_remove+0x82/0x8a [ioatdma]
 [<ffffffff8128ab37>] ? pci_device_remove+0x37/0x70
 [<ffffffff8134623f>] ? __device_release_driver+0x6f/0xe0
 [<ffffffff813463ad>] ? device_release_driver+0x2d/0x40
 [<ffffffff81345711>] ? driver_unbind+0xa1/0xc0
 [<ffffffff81344b7c>] ? drv_attr_store+0x2c/0x30
 [<ffffffff811eb445>] ? sysfs_write_file+0xe5/0x170
 [<ffffffff811765d8>] ? vfs_write+0xb8/0x1a0
 [<ffffffff810d46e2>] ? audit_syscall_entry+0x272/0x2a0
 [<ffffffff81176fe1>] ? sys_write+0x51/0x90
 [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b
---[ end trace 436e184dbc830d94 ]---
ioatdma 0000:80:16.7: dma_pool_destroy dma_desc_pool, ffff881073536000 busy
ioatdma 0000:80:16.7: dma_pool_destroy dma_desc_pool, ffff881073533000 busy
ioatdma 0000:80:16.7: dma_pool_destroy dma_desc_pool, ffff88107352f000 busy
ioatdma 0000:80:16.7: dma_pool_destroy dma_desc_pool, ffff88107352c000 busy
ioatdma 0000:80:16.7: dma_pool_destroy dma_desc_pool, ffff881073529000 busy
ioatdma 0000:80:16.7: dma_pool_destroy completion_pool, ffff881073527000 busy

Jiang Liu (7):
  dmaengine: enhance DMA channel reference count management
  dmaengine: rebalance DMA channels when CPU hotplug happens
  dmaengine: enhance dmaengine to support DMA device hotplug
  dmaengine: enhance network subsystem to support DMA device hotplug
  dmaengine: enhance ASYNC_TX subsystem to support DMA device hotplug
  dmaengine: introduce CONFIG_DMA_ENGINE_HOTPLUG for DMA device hotplug
  dmaengine: assign DMA channel to CPU according to NUMA affinity

 crypto/async_tx/async_memcpy.c      |    2 +
 crypto/async_tx/async_memset.c      |    2 +
 crypto/async_tx/async_pq.c          |   10 +-
 crypto/async_tx/async_raid6_recov.c |    8 +-
 crypto/async_tx/async_tx.c          |    6 +-
 crypto/async_tx/async_xor.c         |   13 +-
 drivers/dma/Kconfig                 |    6 +
 drivers/dma/dmaengine.c             |  360 ++++++++++++++++++++++-------------
 include/linux/async_tx.h            |   13 ++
 include/linux/dmaengine.h           |   43 ++++-
 include/net/netdma.h                |   26 +++
 net/ipv4/tcp.c                      |   10 +-
 net/ipv4/tcp_input.c                |    5 +-
 net/ipv4/tcp_ipv4.c                 |    4 +-
 net/ipv6/tcp_ipv6.c                 |    4 +-
 15 files changed, 350 insertions(+), 162 deletions(-)

-- 
1.7.9.5

