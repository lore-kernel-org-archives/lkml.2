Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2GPM3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:29:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:14762 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2GPM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177983566"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        mika.westerberg@linux.intel.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: irq domain desing for some devices
Date: Mon, 16 Jul 2012 15:28:55 +0300
Message-Id: <1342441735-21134-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's guess the following scenario. The gpio driver is compiled in and provides
several lines as the non-PIC interrupts. The DMA controller is a fake PCI
device and compiled as a module.

What does it mean? The process of an assigning the interrupt lines roughly
looks like following:
 - kernel loads the drivers accordingly to SFI (on Medfield devices we have no
   DT, nor ACPI 5, but SFI) which doesn't have any information about fake PCI
   devices
 - current gpio driver allocates the first free irq numbers x1, x2, ..., xN as
   asked by linear scheme
 - userspace tries to load the DMA controller driver
 - DMA controller driver tries to reserve irq line with a specific number and
   fails, because that number is already assigned to previosly loaded gpio
   driver

Corresponding traceback.

Entering kdb (current=0xf5a23480, pid 813) on processor 1 Oops: (null)
due to oops @ 0xc1016a08
Pid: 813, comm: modprobe Not tainted 3.5.0-rc7-next-20120716-00050-g98f58a2 #401
EIP: 0060:[<c1016a08>] EFLAGS: 00010206 CPU: 1
EIP is at __add_pin_to_irq_node+0x10/0x74
EAX: 312e3230 EBX: f6d45a88 ECX: 00000000 EDX: ffffffff
ESI: 00000000 EDI: ffffffff EBP: f5515d0c ESP: f5515d00
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 312e3230 CR3: 354aa000 CR4: 000007f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process modprobe (pid: 813, ti=f5514000 task=f5a23480 task.ti=f5514000)
Stack:
 f5515d74 f5a064d4 ffffffff f5515d40 c101743a 0000001e c10609e4 00000246
 c16ed694 0000001e c1060a7f f5515d3c c1494a4b c17706a4 0000001e 00000000
 f5515d54 c1017ca6 0000001e f5515d74 00000168 f5515d64 c1017d06 f6d822c0
Call Trace:
 [<c101743a>] io_apic_setup_irq_pin+0x26a/0x281
 [<c10609e4>] ? trace_hardirqs_on_caller+0x105/0x195
 [<c1060a7f>] ? trace_hardirqs_on+0xb/0xd
 [<c1494a4b>] ? _raw_spin_unlock_irqrestore+0x4b/0x58
 [<c1017ca6>] io_apic_setup_irq_pin_once+0x21/0x33
...

In current design of the linear scheme of the irq domains the workaround is to
use strict mapping for the gpio interrupt lines (see attached patch). However,
this is not a solution. Another way is to return back to the legacy scheme, but
it requires the irq descriptors to be allocated beforehand. That's not a
comprehensive solution too.

There are two ideas around. One is to create namespaces inside plain area of
the linux irq lines. The other one is to hide irq number in the API (struct
device, request_irq, ...), but keep reference between driver
and PIC via some object [1].

Third opinion is to forget about the issue and hope the new coming devices will
support either DT, or ACPI 5.

[1] https://lkml.org/lkml/2012/7/5/155

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index a1c8754..ca9024b 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -177,7 +177,7 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
 static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	return irq_create_mapping(lnw->domain, offset);
+	return irq_create_strict_mappings(lnw->domain, 0x100 + offset, offset, 1);
 }
 
 static int lnw_irq_type(struct irq_data *d, unsigned type)
-- 
1.7.10.4

