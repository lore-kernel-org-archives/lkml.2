Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab2ISTZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:25:06 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35755 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2ISTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:25:03 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 15:25:03 EDT
From: Nix <nix@esperi.org.uk>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
Emacs: if SIGINT doesn't work, try a tranquilizer.
Date: Wed, 19 Sep 2012 19:52:34 +0100
Message-ID: <87mx0lsv4d.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
Areca 1210 hardware RAID-5 controller driven by libata which has been
humming along happily for years -- but suddenly, today, the entire
machine froze for a couple of minutes (or at least fs access froze),
followed by this in the logs:

Sep 19 16:55:47 spindle notice: [3447524.381843] arcmsr0: abort device command of scsi id = 0 lun = 1 
[... repeated a few times at intervals over the next five minutes,
 followed by a mass of them at 16:59:29, and...]
Sep 19 16:59:25 spindle err: [3447657.821450] arcmsr: executing bus reset eh.....num_resets = 0, num_aborts = 33 
Sep 19 16:59:25 spindle notice: [3447697.878386] arcmsr0: wait 'abort all outstanding command' timeout 
Sep 19 16:59:25 spindle notice: [3447697.878628] arcmsr0: executing hw bus reset .....
Sep 19 16:59:25 spindle err: [3447698.287054] irq 16: nobody cared (try booting with the "irqpoll" option)
Sep 19 16:59:25 spindle warning: [3447698.287291] Pid: 0, comm: swapper/4 Not tainted 3.5.1-dirty #1
Sep 19 16:59:25 spindle warning: [3447698.287522] Call Trace:
Sep 19 16:59:25 spindle warning: [3447698.287754]  <IRQ>  [<ffffffff810af5ba>] __report_bad_irq+0x31/0xc2
Sep 19 16:59:25 spindle warning: [3447698.288031]  [<ffffffff810af84e>] note_interrupt+0x16a/0x1e8
Sep 19 16:59:25 spindle warning: [3447698.288263]  [<ffffffff810ad9d5>] handle_irq_event_percpu+0x163/0x1a5
Sep 19 16:59:25 spindle warning: [3447698.288497]  [<ffffffff810ada4f>] handle_irq_event+0x38/0x55
Sep 19 16:59:25 spindle warning: [3447698.288727]  [<ffffffff810b01a0>] handle_fasteoi_irq+0x78/0xab
Sep 19 16:59:25 spindle warning: [3447698.288960]  [<ffffffff8103631c>] handle_irq+0x24/0x2a
Sep 19 16:59:25 spindle warning: [3447698.289189]  [<ffffffff81036229>] do_IRQ+0x4d/0xb4
Sep 19 16:59:25 spindle warning: [3447698.289419]  [<ffffffff815070e7>] common_interrupt+0x67/0x67
Sep 19 16:59:25 spindle warning: [3447698.289648]  <EOI>  [<ffffffff812ab174>] ? acpi_idle_enter_c1+0xcb/0xf2
Sep 19 16:59:25 spindle warning: [3447698.289919]  [<ffffffff812ab152>] ? acpi_idle_enter_c1+0xa9/0xf2
Sep 19 16:59:25 spindle warning: [3447698.290152]  [<ffffffff813c1446>] cpuidle_enter+0x12/0x14
Sep 19 16:59:25 spindle warning: [3447698.290382]  [<ffffffff813c1902>] cpuidle_idle_call+0xc5/0x175
Sep 19 16:59:25 spindle warning: [3447698.290614]  [<ffffffff8103c2da>] cpu_idle+0x5b/0xa5
Sep 19 16:59:25 spindle warning: [3447698.290844]  [<ffffffff81ad4fcb>] start_secondary+0x1a2/0x1a6
Sep 19 16:59:25 spindle err: [3447698.291074] handlers:
Sep 19 16:59:25 spindle err: [3447698.291294] [<ffffffff8133b9a3>] usb_hcd_irq
Sep 19 16:59:25 spindle emerg: [3447698.291553] Disabling IRQ #16
Sep 19 16:59:25 spindle err: [3447710.888187] arcmsr0: waiting for hw bus reset return, retry=0
Sep 19 16:59:25 spindle err: [3447720.882155] arcmsr0: waiting for hw bus reset return, retry=1
Sep 19 16:59:25 spindle notice: [3447730.896410] Areca RAID Controller0: F/W V1.46 2009-01-06 & Model ARC-1210
Sep 19 16:59:25 spindle err: [3447730.916348] arcmsr: scsi  bus reset eh returns with success

This is the first SCSI (that is, um, ATA) bus reset I have *ever* had on
this machine, hence my concern. (The IRQ disable we can ignore: it was
just bad luck that an interrupt destined for the Areca hit after the
controller had briefly vanished from the PCI bus as part of resetting.)

Now just last week another (surge-protected) machine on the same power
main as it died without warning with a fried power supply which
apparently roasted the BIOS and/or other motherboard components before
it died (the ACPI DSDT was filled with rubbish, and other things must
have been fried because even with ACPI off Linux wouldn't boot more than
one time out of a hundred (freezing solid at different places in the
boot each time). So my worry level when this SCSI bus reset turned up
today is quite high. It's higher given that the controller logs
(accessed via the Areca binary-only utility for this purpose) show no
sign of any problem at all.

EDAC shows no PCI bus problems and no memory problems, so this probably
*is* the controller.

So... is this a serious problem? Does anyone know if I'm about to lose
this controller, or indeed machine as well? (I really, really hope not.)

I'd write this off as a spurious problem and not report it at all, but
I'm jittery as heck after the catastrophic hardware failure last week,
and when this happens in close proximity, I worry.
