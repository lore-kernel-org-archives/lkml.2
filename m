Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab1GOIWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:22:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51019 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab1GOIWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:22:20 -0400
Subject: Dropped IRQ disables Radeon 3D
Date: Fri, 15 Jul 2011 08:20:02 -0000
From: Michael Witten <mfwitten@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnuschky <arnuschky@xylon.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-ID: <0fe54f4a77b64475b9e6041d9ef5772b-mfwitten@gmail.com>
In-Reply-To: <d74f405530c34a2f9fdae3d7cf37e0fcmfwitten@gmail.com>
References: <d74f405530c34a2f9fdae3d7cf37e0fcmfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is kind of a status update.

On Mon, 02 May 2011 20:19:35 +0000, Michael Witten wrote:

> I've been randomly getting the following backtrace in dmesg for a
> while now (I thought I built my kernel with debugging support and
> symbols, but I guess not, so sorry if it's not that helpful); at
> the time, I was running:
>
>   v2.6.39-rc4-183-g0f1d9f7 (0f1d9f78ce41a8874d30271ef8480e6f8f7f1fce)
>
> It only seems like my 3D acceleration is disabled as a result
> of disabling the IRQ (and the IRQ number is not always the
> same).
>
> I can fix my 3D acceleration by suspending to ram and then
> waking my system up again.
>
>   [357580.931252] irq 11: nobody cared (try booting with the "irqpoll" option)
>   [357580.931260] Pid: 0, comm: swapper Not tainted 2.6.39-rc4-0f1d9f78ce41a8874d30271ef8480e6f8f7f1fce-THOR-205+ #4
>   [357580.931264] Call Trace:
>   [357580.931276]  [<c1329df1>] ? __report_bad_irq.isra.6+0x37/0x83
>   [357580.931283]  [<c12900cb>] ? snd_intel8x0_interrupt+0x4e/0x1c0
>   [357580.931289]  [<c104d6a3>] ? note_interrupt+0x110/0x175
>   [357580.931296]  [<c121be98>] ? tg3_interrupt_tagged+0x29/0x70
>   [357580.931301]  [<c104c832>] ? handle_irq_event_percpu+0x105/0x117
>   [357580.931306]  [<c104da68>] ? unmask_irq+0x1a/0x1a
>   [357580.931310]  [<c104c85d>] ? handle_irq_event+0x19/0x24
>   [357580.931314]  [<c104daa8>] ? handle_level_irq+0x40/0x56
>   [357580.931318]  <IRQ>  [<c100358a>] ? do_IRQ+0x2e/0x81
>   [357580.931327]  [<c1024510>] ? irq_exit+0x44/0x67
>   [357580.931334]  [<c132e2a9>] ? common_interrupt+0x29/0x30
>   [357580.931339]  [<c1024345>] ? __do_softirq+0x30/0xe5
>   [357580.931343]  [<c1024315>] ? local_bh_enable+0x2/0x2
>   [357580.931346]  <IRQ>  [<c10244fd>] ? irq_exit+0x31/0x67
>   [357580.931353]  [<c10035ca>] ? do_IRQ+0x6e/0x81
>   [357580.931360]  [<c1147dd7>] ? acpi_hw_write_port+0x22/0x83
>   [357580.931365]  [<c132e2a9>] ? common_interrupt+0x29/0x30
>   [357580.931371]  [<c1154f11>] ? acpi_idle_enter_bm+0x1d5/0x20a
>   [357580.931378]  [<c1261150>] ? cpuidle_idle_call+0x65/0x95
>   [357580.931382]  [<c1001577>] ? cpu_idle+0x23/0x3d
>   [357580.931387]  [<c14dd60b>] ? start_kernel+0x263/0x268
>   [357580.931392]  [<c14dd151>] ? loglevel+0x14/0x14
>   [357580.931395] handlers:
>   [357580.931397] [<c11bdcb4>] (radeon_driver_irq_handler_kms+0x0/0x10)
>   [357580.931405] [<c122cca3>] (usb_hcd_irq+0x0/0x5e)
>   [357580.931411] [<c122cca3>] (usb_hcd_irq+0x0/0x5e)
>   [357580.931415] [<c121be6f>] (tg3_interrupt_tagged+0x0/0x70)
>   [357580.931420] [<c129007d>] (snd_intel8x0_interrupt+0x0/0x1c0)
>   [357580.931426] Disabling IRQ #11

Arnuschky wrote to me about this related Debian bug report:

  Fri, 2010-06-18 10:21:05 +0000
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586312

I popped over to #radeon on freenode where user agd5f told me to
try the following on the kernel command line:

  pci=nomsi

After reading about MSIs and the requisite CONFIG_* settings, I
realized that I didn't even have MSI support in the kernel anyway.
Then agd5f suggested the following patches by Benjamin Herrenschmidt
might be of help:

  http://lists.freedesktop.org/archives/dri-devel/2011-July/012980.html
  http://lists.freedesktop.org/archives/dri-devel/2011-July/012981.html

the latter of which fixes a syncronization bug on systems that use
non-MSI IRQs (presumably pin-based IRQs) for the radeon device/driver.

For my system, I decided to enable MSI/MSI-X support by building
Linux with the following configuration variables set:

  CONFIG_PCI=y
  CONFIG_X86_LOCAL_APIC=y
  CONFIG_X86_IO_APIC=y
  CONFIG_PCI_MSI=y

and making sure I get the following:

  $ dmesg | grep MSI | grep radeon 
  radeon 0000:01:00.0: irq 42 for MSI/MSI-X
  radeon 0000:01:00.0: radeon: using MSI.

I'm not sure if this will avoid the problem, but it sure seems like
a good bet.

Sincerely,
Michael Witten
