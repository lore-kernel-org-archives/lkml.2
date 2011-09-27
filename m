Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1I0SDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:03:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:5281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1I0SDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:03:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="56443098"
Message-ID: <4E820FA8.8050604@linux.intel.com>
Date: Tue, 27 Sep 2011 11:02:16 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Denis Turischev <denis@compulab.co.il>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Serial issues with EG20T (Topcliff) PCH uarts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I provide a lot of details below, so here's a brief summary of what I'm running
into:

o Using a PCIe attached EG20T (Topcliff) uart at 0xb060, INT 18
o BIOS redirection to serial works
o Syslinux redirection to serial doesn't
o kernel messages only appear well into the boot process (after PCI init)
o getty doesn't present login over serial

OK, so what follows is are the details.

I'm working with a board with PCIe connected Topcliff PCH uarts. A serial
expansion board provides a serial->usb converter so that you plug in a microUSB
from your host to the board and you get a usb uart (ie /dev/ttyUSB0 on your
host, which communicates with /dev/ttyS1 on the board). This UART line
(basically 3 wire UART, not RS232) are connected to a TUSB3410RHB which exports
them over USB to the host. As far as the board is concerned, it is regular
serial ports.. well, a regular PCIe attached serial port.

Using the ti_usb_3410_5052 driver with modified vendor/product strings, I am
able to get ttyUSB0 on my host and open it in minicom:

$ sudo modprobe ti_usb_3410_5052 vendor_3410=0x0451 product_3410=0x5053
$ minicom -D /dev/ttyUSB0

I configure minicom for 115200,8,none,1,no,no

In the board's BIOS, I configure console redirection to go over COM2 (COM0 and
COM1 are marked as "Not Present", COM2 is PCI,Bus5,Dec10,Func2) and set its
baud,etc accordingly. After rebooting, I get POST and BIOS over serial. I can
enter the BIOS, move around, it just works. \o/

Next is syslinux, using "serial [0123] 115200" I simply cannot get anything from
syslinux across the wire. :(

The kernel eventually loads (console=ttyS1,115200), we miss all of the ACPI
table messages, MM init, CPU init, some PCI init, audio, even some USB, and
finally the serial driver finds the PCI serial ports, identifying ttyS1 with the
same PCI bus,dev,and func values from BIOS above and starts spewing kernel
messages to the console. :|

The getty is spawned from inittab:
S:2345:respawn:/sbin/getty 115200 ttyS1
but no output appears over serial. :(

At this point I have 2 bits that work over serial and two that don't.

If I disable the serial getty in inittab and reboot, I can start to use
setserial and minicom. I first take a look at dmesg:

root@board:~# dmesg | grep tty
Kernel command line: initrd=initrd LABEL=boot console=ttyS1,115200
console=tty0 root=/dev/ram0 BOOT_IMAGE=vmlinuz
console [tty0] enabled
console [ttyS1] enabled
0000:05:0a.1: ttyS0 at I/O 0xb070 (irq = 18) is a 16550A
0000:05:0a.2: ttyS1 at I/O 0xb060 (irq = 18) is a 16550A  <-- THIS ONE
0000:05:0a.3: ttyS2 at I/O 0xb050 (irq = 18) is a 16550A
0000:05:0a.4: ttyS3 at I/O 0xb040 (irq = 18) is a 16550A

Then at setserial:
root@board:~# setserial -g /dev/ttyS*
/dev/ttyS0, UART: 16550A, Port: 0xb070, IRQ: 18
/dev/ttyS1, UART: 16550A, Port: 0xb060, IRQ: 18 <-- THIS ONE
/dev/ttyS2, UART: 16550A, Port: 0xb050, IRQ: 18
/dev/ttyS3, UART: 16550A, Port: 0xb040, IRQ: 18

I tried using setserial autoconfig:
root@board:~# setserial /dev/ttyS1 irq 18 port 0xb060 autoconfig
root@board:~# setserial -g /dev/ttyS1
/dev/ttyS1, UART: 16550A, Port: 0xb060, IRQ: 18


Now lets watch /proc/interrupts and /proc/tty/driver/serial on the FRI2 while I
type on both sides of the connection with minicom. Both sides are configured the
same: 115200,8,n,1,no,no.

Every 2s: cat /proc/interrupts; cat /proc/tty/driver/serial
2011-09-24 04:43:04

           CPU0       CPU1
  0:     693420          0   IO-APIC-edge      timer
  9:          0          0   IO-APIC-fasteoi   acpi
 16:        188          0   IO-APIC-fasteoi   ahci, hda_intel
 17:          0          0   IO-APIC-fasteoi   pch-dma,
spi_topcliff_pch, i2c_eg20t, mmc0, mmc1

 18:        175          0   IO-APIC-fasteoi   pch-dma, ehci_hcd:usb1,
ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5, pch_udc, serial

 19:       7329          0   IO-APIC-fasteoi   ehci_hcd:usb2,
ohci_hcd:usb6, ohci_hcd:usb7, ohci_hcd:usb8, eth0
NMI:          0          0   Non-maskable interrupts
LOC:       2293     352542   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:       5316       5126   Rescheduling interrupts
CAL:          8          9   Function call interrupts
TLB:        642        304   TLB shootdowns
ERR:          0
MIS:          0
serinfo:1.0 driver revision:
0: uart:16550A port:0000B070 irq:18 tx:0 rx:0

1: uart:16550A port:0000B060 irq:18 tx:100 rx:134 fe:67 brk:67 RTS|DTR

2: uart:16550A port:0000B050 irq:18 tx:0 rx:0
3: uart:16550A port:0000B040 irq:18 tx:0 rx:0

INT18 goes up by one for every character I type on either side of the
connection. Starting on the board I see tx (for the /proc/tty/driver/serial line
1 near the bottom) go up by 1 for each character typed. So far so good - but the
characters don't appear on the receiving end.

When I type on the other side (my laptop) I see INT18 increment once per
character, but I see the lower rx go up by 6 for each char typed, and fe and brk
go up by 3 for each char typed. After a few characters, RTS|DTR appear. I'm not
sure what to make of this, but it doesn't sound good.

When running windows on the board, it is necessary to adjust the CLOCK from 48K
to 64K for the serial port driver. Is it possible that there is something I need
to do in order to account for that in Linux?  This is using the pch_uart driver
as far as I can tell, so perhaps something in pch_uart_port_init? There is
something board specific in there now:

	base_baud = 1843200; /* 1.8432MHz */

	/* quirk for CM-iTC board */
	board_name = dmi_get_system_info(DMI_BOARD_NAME);
	if (board_name && strstr(board_name, "CM-iTC"))
		base_baud = 192000000; /* 192.0MHz */


The fact that the kernel is able to display messages, suggests to me that the
driver is working properly and that the getty issue is with my configuration.
But the lack of output in minicom, and the odd rx increments sound a bit like a
BAUD/CLOCK mismatch. I'm just out of ideas of what to try.

As for syslinux, I'm concerned it may not be able to access a PCIe connected
serial port.

Can anyone offer up some ideas on what I might try to get:

1) the getty working
2) the earlier kernel messages to appear
3) syslinux working

over the serial port?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
