Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1BWUt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:49:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26848 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932614Ab1BWUtY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 23 Feb 2011 15:49:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bug fix for radeon driver in 2.6.38-rc6 w/ATI ES1000
Date: Wed, 23 Feb 2011 15:48:54 -0500
Message-Id: <1298494135-16751-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D6572C4.01E3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this when I was doing a bit of testing of my TTM patches. The issue is
that during unload/unbind:

echo 0000:01:05.0 > /sys/bus/pci/drivers/radeon/unbind

the radeon driver would unload, but if compiled with the CONFIG_DMA_API_DEBUG=y
it would throw out this warning:

[   22.113420] drm: unregistered panic notifier^M
[   22.126500] [drm] radeon: finishing device.^M
[   22.130868] [drm] radeon: cp finalized^M
[   22.135384] [TTM] Finalizing pool allocator.^M
[   22.139669] [TTM] Zone  kernel: Used memory at exit: 0 kiB.^M
[   22.145229] [drm] radeon: ttm finalized^M
[   22.149055] vga_switcheroo: disabled^M
[   22.153393] ------------[ cut here ]------------^M
[   22.158021] WARNING: at /home/konrad/ssd/linux/lib/dma-debug.c:689 dma_debug_device_change+0x12e/0x161()^M
[   22.167475] Hardware name: PowerEdge T105 ^M
[   22.171562] pci 0000:01:08.0: DMA-API: device driver has pending DMA allocations while released from device [count=1]^M
[   22.182139] Modules linked in: nouveau video sr_mod sg sd_mod cdrom ata_generic qla2xxx radeon sata_nv scsi_transport_fc scsi_tgt libata fbcon tileblit font bitblit softcursor ttm e1000e drm_kms_helper scsi_mod^M
[   22.201101] Pid: 2550, comm: primary_fb Not tainted 2.6.38-rc6-linux-next #1^M 
[   22.208129] Call Trace:^M
[   22.210575]  [<ffffffff81049580>] ? warn_slowpath_common+0x80/0x98^M
[   22.216737]  [<ffffffff8104962c>] ? warn_slowpath_fmt+0x41/0x43^M
[   22.222643]  [<ffffffff81208fe8>] ? dma_debug_device_change+0x12e/0x161^M
[   22.229240]  [<ffffffff8144e467>] ? notifier_call_chain+0x32/0x5e^M
[   22.235319]  [<ffffffff81067d5f>] ? __blocking_notifier_call_chain+0x4b/0x62^M
[   22.242350]  [<ffffffff81067d85>] ? blocking_notifier_call_chain+0xf/0x11^M
[   22.249121]  [<ffffffff812b54fd>] ? __device_release_driver+0xab/0xb0^M
[   22.255543]  [<ffffffff812b55d0>] ? device_release_driver+0x1e/0x2b^M
[   22.261794]  [<ffffffff812b4c86>] ? driver_unbind+0x57/0x8c^M
[   22.267352]  [<ffffffff812b440d>] ? drv_attr_store+0x27/0x29^M
[   22.272998]  [<ffffffff8114a64d>] ? sysfs_write_file+0xff/0x13b^M
[   22.278903]  [<ffffffff810f5b88>] ? vfs_write+0xa9/0x105^M
[   22.284202]  [<ffffffff810f5c9d>] ? sys_write+0x45/0x6c^M
[   22.289415]  [<ffffffff8100a992>] ? system_call_fastpath+0x16/0x1b^M
[   22.295578] ---[ end trace f6e27fa61e0cc3ec ]---^M
ERROR: Module radeon is in use^M

The radeon_gart_fini was missing an pci_unmap for the dummy page. Interestingly enough
the r600.c has a call to radeon_dummy_page_fini() in its unwind path so there
are definitly some chipsets on which this is done without any hinderance.

This above test is easily manifested with a stock 2.6.38-rc6 on a machine with a
ATI ES1000 chipset (Dell T105, IBM x366, SuperMicro X7DB8).
