Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2IHWWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:22:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2IHWWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:22:48 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=7sy-z-_qPgAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=4xKBBUcpWnwA:10 a=n6BDpCYhE_xn3VB1LTUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1347142965.4746.11.camel@gandalf.local.home>
Subject: [BUG][3.4.10] Conflicts between initializing my USB devices and my
 IDE devices
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        stable <stable@vger.kernel.org>
Date: Sat, 08 Sep 2012 18:22:45 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded my workstation to 3.4.10 from something like 3.2 or so, thus
I don't know when this started causing issues. But after I did, my 2TB
WD external USB hard drive stopped showing up.

I looked at my dmesg and saw this:

[    1.372997] /home/rostedt/work/git/nobackup/linux-build.git/drivers/usb/core/inode.c: creating file '002'
[    1.373024] hub 3-0:1.0: state 7 ports 3 chg 000c evt 000c
[    1.373032] ohci_hcd 0000:07:01.0: GetStatus roothub.portstatus [1] = 0x00010100 CSC PPS
[    1.373045] hub 3-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[    1.465871] ------------[ cut here ]------------
[    1.466177] WARNING: at /home/rostedt/work/git/nobackup/linux-build.git/kernel/irq/manage.c:433 __enable_irq+0x60/0x120()
[    1.466782] Hardware name: System Product Name
[    1.467056] Unbalanced enable for IRQ 16
[    1.467304] Modules linked in: ata_generic(+) ohci_hcd xhci_hcd ata_piix r8169 mii libata via82cxxx(+) ehci_hcd scsi_mod ide_pci_generic ide_core usbcore usb_common
[    1.468790] Pid: 146, comm: modprobe Not tainted 3.4.10-custom+ #25
[    1.469153] Call Trace:
[    1.469332]  [<ffffffff810382ef>] warn_slowpath_common+0x7f/0xc0
[    1.469684]  [<ffffffff810383e6>] warn_slowpath_fmt+0x46/0x50
[    1.470042]  [<ffffffff810ba0a0>] __enable_irq+0x60/0x120
[    1.470375]  [<ffffffff810ba1bd>] enable_irq+0x5d/0xa0
[    1.470670] usb 1-1: link qh256-0001/ffff88022f9798c0 start 1 [1/0 us]
[    1.470706]  [<ffffffffa0046639>] ide_probe_port+0x1a9/0x6d0 [ide_core]
[    1.471090]  [<ffffffff81330a6b>] ? dmi_check_system+0x2b/0x60
[    1.471433]  [<ffffffffa0046ee9>] ide_host_register+0x2d9/0x730 [ide_core]
[    1.471828]  [<ffffffffa004cada>] ide_pci_init_two+0x4ba/0x7c0 [ide_core]
[    1.472220]  [<ffffffff8144a5d8>] ? _raw_spin_unlock_irqrestore+0x18/0x40
[    1.472610]  [<ffffffff810390c5>] ? console_unlock+0x1f5/0x270
[    1.472955]  [<ffffffffa004cdf6>] ide_pci_init_one+0x16/0x20 [ide_core]
[    1.473337]  [<ffffffffa003191e>] via_init_one+0x237/0x25c [via82cxxx]
[    1.473715]  [<ffffffff8106ebc1>] ? get_parent_ip+0x11/0x50
[    1.474044]  [<ffffffffa00310a0>] ? via82cxxx_cable_detect+0xa0/0xa0 [via82cxxx]
[    1.474475]  [<ffffffff8126850c>] local_pci_probe+0x5c/0xd0
[    1.474806]  [<ffffffff81269e61>] pci_device_probe+0x101/0x120
[    1.475150]  [<ffffffff8130259e>] driver_probe_device+0x7e/0x220
[    1.475501]  [<ffffffff813027eb>] __driver_attach+0xab/0xb0
[    1.475832]  [<ffffffff81302740>] ? driver_probe_device+0x220/0x220
[    1.476195]  [<ffffffff81300a06>] bus_for_each_dev+0x56/0x90
[    1.476529]  [<ffffffff813020be>] driver_attach+0x1e/0x20
[    1.476850]  [<ffffffff81301c80>] bus_add_driver+0x1a0/0x260
[    1.477184]  [<ffffffffa0036000>] ? 0xffffffffa0035fff
[    1.477492]  [<ffffffff81302d36>] driver_register+0x76/0x130
[    1.477826]  [<ffffffff8144db9d>] ? notifier_call_chain.isra.0+0x4d/0x70
[    1.478210]  [<ffffffffa0036000>] ? 0xffffffffa0035fff
[    1.478518]  [<ffffffff81269b25>] __pci_register_driver+0x55/0xd0
[    1.478873]  [<ffffffff8102d7e3>] ? set_memory_nx+0x43/0x50
[    1.479203]  [<ffffffffa003601e>] via_ide_init+0x1e/0x1000 [via82cxxx]
[    1.479580]  [<ffffffff810001cf>] do_one_initcall+0x3f/0x170
[    1.479914]  [<ffffffff8109affe>] sys_init_module+0xbe/0x230
[    1.480249]  [<ffffffff81451812>] system_call_fastpath+0x16/0x1b
[    1.480599] ---[ end trace 99f8fad80eedfdb7 ]---
[    1.480909] Probing IDE interface ide1...

Thinking, OK this is probably related. I than started debugging and
added a bunch of trace_printks around the enable/disable_irq() routines,
and monitoring the desc->depth. This is what I found:

[edited for just the relevant content]

           <...>-146   [002] ....     0.898096: ide_probe_port:  disable irq 16
           <...>-146   [002] d..1     0.898097: __disable_irq_nosync: disable_irq 16 desc=ffff8802349bb880
           <...>-146   [002] d..1     0.898098: __disable_irq: inc desc 16 ffff8802349bb880 (1)
           <...>-198   [001] ....     0.920680: __setup_irq: setup irq 16 decs ffff8802349bb880
           <...>-198   [001] d..1     0.920680: irq_startup: reset desc ffff8802349bb880
           <...>-198   [001] d..1     0.920686: <stack trace>
 => irq_startup
 => __setup_irq
 => request_threaded_irq
 => usb_add_hcd
 => usb_hcd_pci_probe
 => local_pci_probe
 => pci_device_probe
 => driver_probe_device
 => __driver_attach
 => bus_for_each_dev
 => driver_attach
 => bus_add_driver
 => driver_register
 => __pci_register_driver
 => acpi_lid_send_state
 => do_one_initcall
 => sys_init_module
 => system_call_fastpath
           <...>-146   [002] ....     1.465868: ide_probe_port: enable irq 16
           <...>-146   [002] d..1     1.465869: enable_irq: enable_irq 16 desc=ffff8802349bb880
           <...>-146   [002] d..1     1.465870: __enable_irq: desc depth 16 ffff8802349bb880 (0)


Seems there's a nasty race/conflict between threads 146 and 198. Thread
146 is probing the ide devices and has code that looks like this:

        irqd = hwif->irq;
        if (irqd)
                disable_irq(hwif->irq);

        if (ide_port_wait_ready(hwif) == -EBUSY)
                printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);

        /*
         * Second drive should only exist if first drive was found,
         * but a lot of cdrom drives are configured as single slaves.
         */
        ide_port_for_each_dev(i, drive, hwif) {
                (void) probe_for_drive(drive);
                if (drive->dev_flags & IDE_DFLAG_PRESENT)
                        rc = 0;
        }

        /*
         * Use cached IRQ number. It might be (and is...) changed by probe
         * code above
         */
        if (irqd)
                enable_irq(irqd);


Where it disables the irq while its doing the probe, and in the mean
time, the shared usb device is doing its setup of the threaded irq
handler, and resetting the desc->depth in kernel/irq/chip.c:irq_setup().

When the ide finishes its probe it re-enables the irq, but because the
desc->depth was modified by the USB setup, it fails.

Note, according to /proc/interrupts, irq 16 is:

 16:         25          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb3, ide0, ide1

Not sure how this should be fixed. I haven't tried 3.5 or 3.6-rc, but I
can do that if necessary (on Monday).

-- Steve


