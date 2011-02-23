Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1BWUtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:49:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26777 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1BWUtX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 23 Feb 2011 15:49:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@Oracle.Com>
To: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@Oracle.Com>
Subject: [PATCH] radeon: DMA unmap dummy page during unload/unbind.
Date: Wed, 23 Feb 2011 15:48:55 -0500
Message-Id: <1298494135-16751-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298494135-16751-1-git-send-email-konrad.wilk@oracle.com>
References: <1298494135-16751-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D6572C7.001B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit 82568565683b4991964a5fc89a9ca0c7122818e8 adds a dummy page
so that if something goes wrong it will at least fetch/write data
_only_ to this location.

The radeon_gart_init sets it up.. but there is no corresponding
free-ing of this dummy page. There is one invocation to free-ing
the dummy page in r600.c but nothing in the radeon_gart_fini path.

This patch adds in the unloading/unbind path the free-ing of said
dummy page.

Without this patch and if we have CONFIG_DMA_API_DEBUG=y set we
get this:

[   22.113420] drm: unregistered panic notifier
[   22.126500] [drm] radeon: finishing device.
[   22.130868] [drm] radeon: cp finalized
[   22.135384] [TTM] Finalizing pool allocator.
[   22.139669] [TTM] Zone  kernel: Used memory at exit: 0 kiB.
[   22.145229] [drm] radeon: ttm finalized
[   22.149055] vga_switcheroo: disabled
[   22.153393] ------------[ cut here ]------------
[   22.158021] WARNING: at /home/konrad/ssd/linux/lib/dma-debug.c:689 dma_debug_device_change+0x12e/0x161()
[   22.167475] Hardware name: PowerEdge T105
[   22.171562] pci 0000:01:08.0: DMA-API: device driver has pending DMA allocations while released from device [count=1]

With this patch we don't see this anymore.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/radeon/radeon_gart.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 6501611..dc04c7b 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -269,4 +269,6 @@ void radeon_gart_fini(struct radeon_device *rdev)
 	kfree(rdev->gart.pages_addr);
 	rdev->gart.pages = NULL;
 	rdev->gart.pages_addr = NULL;
+
+	radeon_dummy_page_fini(rdev);
 }
-- 
1.7.1

