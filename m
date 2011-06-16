Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1FPTti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:49:38 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:56167 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1FPTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:49:36 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DFA5E41.5090803@ise.pw.edu.pl>
Date: Thu, 16 Jun 2011 21:49:21 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: maciej.rutecki@gmail.com
Subject: Probably solved or worked around: 2.6.37 says WARNING: at arch/x86/kernel/apic/apic.c:1287
 setup_local_APIC+0x18f/0x263()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had similar problems as reported in 
https://bugzilla.kernel.org/show_bug.cgi?id=27642

I was using buildroot buildroot-2011.02 with kernel 2.6.37.2 on virtual 
machine inside of QEMU
The warning shown in the subject further lead to incorrect routing of 
IRQs from PCI devices
connected withg QEMU's option "-device DEVICE_NAME".

The warning was reported as:
------------[ cut here ]------------
WARNING: at arch/x86/kernel/apic/apic.c:1287 setup_local_APIC+0x22a/0x34d()
Hardware name: Bochs
Modules linked in:
Pid: 0, comm: kworker/0:0 Tainted: G        W   2.6.37 #3
Call Trace:
  [<c102f318>] ? warn_slowpath_common+0x78/0xb0
  [<c12ebde5>] ? setup_local_APIC+0x22a/0x34d
  [<c12ebde5>] ? setup_local_APIC+0x22a/0x34d
  [<c102f36b>] ? warn_slowpath_null+0x1b/0x20
  [<c12ebde5>] ? setup_local_APIC+0x22a/0x34d
  [<c12eb0d8>] ? start_secondary+0xd3/0x1c1
---[ end trace 4eaa2a86a8e2da23 ]---

And IRQs were routed as follows:

wzab_enc1 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 35
  mmio_start=f2060000, mmio_end=f2060fff, mmio_len=1000, irq=35

IRQ35 was not available in the emulated system so driver was not able to 
request it.

The problem disappeared, after I have switched on the following options 
in kernel configuration:
CONFIG_PM=y
CONFIG_ACPI=y

I have verified, that this resulted in automatic selection of option
CONFIG_PCI_IOAPIC=y

After recompilation of kernel, I don't get the mentioned warning during 
the boot
and IRQs are routed correctly:
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
wzab_enc1 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, high) 
-> IRQ 11
  mmio_start=f2060000, mmio_end=f2060fff, mmio_len=1000, irq=11

-- 
HTH & Regards,
Wojtek





