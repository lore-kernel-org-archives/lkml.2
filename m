Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2GLH01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:26:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47800 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752760Ab2GLH00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:26:26 -0400
X-Authenticated: #118086913
X-Provags-ID: V01U2FsdGVkX187FG4Cyq07NMDkaFURX81CIQFcKXFt4npTsVZQSZ
	LZ8mwQA6/F8l0Q
Message-ID: <4FFE7C1F.7080702@gmx.net>
Date: Thu, 12 Jul 2012 09:26:23 +0200
From: Andreas Schallenberg <embedded@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: UIO: missing resource mapping
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm doing experiments with the Userspace IO driver (UIO_PCI_GENERIC) and 
a set of PCIe cards. The kernel version is 3.4.4, CPU is a Marvell 
MV78200 (ARMv5te). Example with an Intel ethernet card:

This makes /dev/uio0 appear
echo -n "8086 10d3" >/sys/bus/pci/drivers/uio_pci_generic/new_id

# lspci -v -k -s 0000:00:01.0
00:01.0 Ethernet controller: Intel Corporation 82574L Gigabit Network 
Connection
         Subsystem: Intel Corporation Gigabit CT Desktop Adapter
         Flags: bus master, fast devsel, latency 0, IRQ 36
         Memory at c00c0000 (32-bit, non-prefetchable) [size=128K]
         Memory at c0000000 (32-bit, non-prefetchable) [size=512K]
         I/O ports at f0800000 [size=32]
         Memory at c00e0000 (32-bit, non-prefetchable) [size=16K]
         [virtual] Expansion ROM at c0080000 [disabled] [size=256K]
         Capabilities: [c8] Power Management version 2
         Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [e0] Express Endpoint, MSI 00
         Capabilities: [a0] MSI-X: Enable- Count=5 Masked-
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number 00-1b-21-ff-ff-c4-f7-2f
         Kernel driver in use: uio_pci_generic

Suprisingly, there is no "maps" directory in /sys/class/uio/uio0 now. I 
made a small change to the UIO code:

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a783d53..b639654 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -274,8 +274,10 @@ static int uio_dev_add_attributes(struct uio_device 
*idev)

         for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
                 mem = &idev->info->mem[mi];
-               if (mem->size == 0)
-                       break;
+               if (mem->size == 0) {
+                       dev_err(idev->dev, "map %d has zero size\n", mi);
+                       continue; // was: break
+               }
                 if (!map_found) {
                         map_found = 1;
                         idev->map_dir = kobject_create_and_add("maps",

If I have this in the kernel and give the "echo" command as shown above 
I get:
[   43.761723] uio uio0: map 0 has zero size
[   43.765760] uio uio0: map 1 has zero size
[   43.769787] uio uio0: map 2 has zero size
[   43.774298] uio uio0: map 3 has zero size
[   43.778333] uio uio0: map 4 has zero size

On the other hand, I can see the resources:
# cat /sys/class/uio/uio0/device/resource
0x00000000c00c0000 0x00000000c00dffff 0x0000000000040200
0x00000000c0000000 0x00000000c007ffff 0x0000000000040200
0x00000000f0800000 0x00000000f080001f 0x0000000000040101
0x00000000c00e0000 0x00000000c00e3fff 0x0000000000040200
...more...

Looking further at the code, I cannot see where the mem fields are being 
filled at all.
Which code is supposed to write the struct uio_mem?

Best,
Andreas



