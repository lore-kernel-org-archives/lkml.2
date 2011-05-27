Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab1E0JSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:18:42 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:56608 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab1E0JSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:18:41 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 05:18:41 EDT
From: Marin Mitov <mitov@issp.bas.bg>
To: linux-kernel@vger.kernel.org
Subject: [regression] matrox drm/mga driver do not use interrupts
Date: Fri, 27 May 2011 12:04:38 +0300
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Cc: David Airlie <airlied@linux.ie>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271204.38705.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I observed that matrox drm/mga driver do not use interrupts in 2.6.39,
while it uses it in 2.6.32.41 (different kernels, same userland, all 32 bits,
IRQ assigned to VGA in BIOS).

One finds in Xorg.0.log:

(II) MGA(0): [drm] failure adding irq handler, there is a device already using that irq

which is misleading, because no other device is using it. A small kernel module
that simply request_irq()/free_irq() is getting the same IRQ without a problem.

Debugging the drm/mga couple traced the problem to this operator:
(in drivers/gpu/drm/drm_irq.c, drm_control() function)

		if (dev->if_version < DRM_IF_VERSION(1, 2) &&
		    ctl->irq != drm_dev_to_irq(dev))
			return -EINVAL;

where:

ctl->irq = -22, drm_dev_to_irq(dev) = 16 (the correct value), and
return -EINVAL; is executed.

If I change ctl->irq = 16, just before the if operator, all is working OK.

Just for info, almost the same hardware/chipsets/VGA(matrox) is
working OK in  2.6.39/64 bits, but userland (64 bits too) is a newer version).

I am ready for testing patches, I use 3 Matrox g450 AGP adapters on 2 - 32 bits
systems and 1 - 64 bits system.

Please, help in solving the problem.

Marin Mitov

P.S. Here is some logs:

2.6.39
==========================
dmesg
[drm] Initialized drm 1.1.0 20060810
matrox_w1 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized mga 3.2.1 20051102 for 0000:01:00.0 on minor 0
agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
agpgart-amd64 0000:00:00.0: bridge is in legacy mode, falling back to 2.x
agpgart-amd64 0000:00:00.0: putting AGP V2 device into 4x mode
matrox_w1 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Initialized card for AGP DMA.

cat /proc/interrupts
 12:          2       3495   IO-APIC-edge      i8042
 14:          1       4429   IO-APIC-edge      ide0
 15:          1        584   IO-APIC-edge      ide1
 17:          3       2422   IO-APIC-fasteoi   skge@pci:0000:00:0a.0
 18:          0         30   IO-APIC-fasteoi   sata_promise
 20:          6      18571   IO-APIC-fasteoi   sata_via

grep MGA /var/log/Xorg.0.log
(II) MGA(0): [DRI] installation complete
(II) MGA(0): [drm] Mapped 128 DMA buffers
(II) MGA(0): [drm] failure adding irq handler, there is a device already using that irq
(II) MGA(0): Direct rendering enabled

2.6.32.41
=============================
dmesg
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized mga 3.2.1 20051102 for 0000:01:00.0 on minor 0
agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
agpgart-amd64 0000:00:00.0: bridge is in legacy mode, falling back to 2.x
agpgart-amd64 0000:00:00.0: putting AGP V2 device into 4x mode
matrox_w1 0000:01:00.0: putting AGP V2 device into 4x mode
[drm] Initialized card for AGP DMA.
platform mga_warp.0: firmware: using built-in firmware matrox/g400_warp.fw

cat /proc/interrupts
 12:         26      24183   IO-APIC-edge      i8042
 14:          4       4452   IO-APIC-edge      ide0
 15:          2       7128   IO-APIC-edge      ide1
 16:          0          0   IO-APIC-fasteoi   mga@pci:0000:01:00.0
 17:         43      56704   IO-APIC-fasteoi   skge@pci:0000:00:0a.0
 18:          0        207   IO-APIC-fasteoi   sata_promise
 20:         18      20682   IO-APIC-fasteoi   sata_via

grep MGA /var/log/Xorg.0.log
(II) MGA(0): [DRI] installation complete
(II) MGA(0): [drm] Mapped 128 DMA buffers
(II) MGA(0): [drm] dma control initialized, using IRQ 16
(II) MGA(0): Direct rendering enabled
