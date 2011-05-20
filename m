Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935658Ab1ETLxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:53:15 -0400
Received: from static-78-8-249-61.ssp.dialog.net.pl ([78.8.249.61]:45649 "EHLO
	noisy.codepainters.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935640Ab1ETLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:53:13 -0400
Message-ID: <4DD653C4.8070703@codepainters.com>
Date: Fri, 20 May 2011 13:43:00 +0200
From: Przemyslaw Wegrzyn <pwegrzyn@codepainters.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Paging oops (x86) and CR2 value - debugging help needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to solve the occasional instabilities of my Dell E6400 laptop
(C2D P8600). Beside the (rare) userspace SIGSEGVs, I observe the
following oops at boot time (almost every time), with vanilla 2.6.38.6:

[    5.130822] BUG: unable to handle kernel paging request at f822a0dc
[    5.130936] IP: [<c126fbb8>] memset+0x18/0x28
[    5.131021] *pde = 35422067 *pte = 00000000
[    5.131122] Oops: 0002 [#1] SMP
[    5.131222] last sysfs file: /sys/bus/hid/drivers/generic-usb/uevent
[    5.134750] Modules linked in: usbhid(+) hid firewire_ohci sdhci_pci
firewire_core ahci crc_itu_t sdhci libahci e1000e
[    5.134750]
[    5.134750] Pid: 228, comm: modprobe Not tainted 2.6.38.6 #2 Dell
Inc. Latitude E6400                 
[  237.306809] ata5: SATA link down (SStatus 0 SControl 300)
[    5.134750] /0U692R
[    5.134750] EIP: 0060:[<c126fbb8>] EFLAGS: 00010292 CPU: 1
[    5.134750] EIP is at memset+0x18/0x28
[    5.134750] EAX: 00000000 EBX: f82020cc ECX: 00010000 EDX: 00000000
[    5.134750] ESI: 00000000 EDI: f820a0dc EBP: f12d7bf4 ESP: f12d7bec
[    5.134750]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    5.134750] Process modprobe (pid: 228, ti=f12d6000 task=f12f5860
task.ti=f12d6000)
[    5.134750] Stack:
[  237.307415]  f8202000 00000001 f12d7c18 f81287aa f121bc40 f5515000
f12d7c18 00010006
[  237.307415]  f121bc46 f121bc78 f8202000 f12d7c58 f8127eff 00000282
f110ac98 00000038
[  237.307415]  00000038 f12d7c58 c1397b28 fffffff4 00000038 00000000
060a0001 00000001
[  237.307415] Call Trace:
[  237.307415]  [<f81287aa>] hid_parser_main+0x5a/0x2c0 [hid]
[  237.307415]  [<f8127eff>] hid_parse_report+0xbf/0x2e0 [hid]
[  237.307415]  [<c1397b28>] ? usb_control_msg+0xd8/0x100
[  237.307415]  [<f82a3b77>] usbhid_parse+0x167/0x300 [usbhid]
[  237.307415]  [<f8128419>] hid_device_probe+0xb9/0xd0 [hid]
[  237.307415]  [<c132603f>] driver_probe_device+0x7f/0x190
[  237.307415]  [<c1326229>] __device_attach+0x49/0x60
[  237.307415]  [<c13261e0>] ? __device_attach+0x0/0x60
[  237.307415]  [<c1324fdf>] bus_for_each_drv+0x4f/0x70
[  237.307415]  [<c1325f1a>] device_attach+0x7a/0x90
[  237.307415]  [<c13261e0>] ? __device_attach+0x0/0x60
[  237.307415]  [<c1325825>] bus_probe_device+0x25/0x40
[  237.307415]  [<c1323a40>] device_add+0x510/0x5d0
[  237.307415]  [<f8126822>] hid_add_device+0x92/0x1c0 [hid]
[  237.307415]  [<f82a2ac8>] usbhid_probe+0x2a8/0x3e0 [usbhid]
[  237.307415]  [<c139abc9>] usb_probe_interface+0xd9/0x1b0
[  237.307415]  [<c117dbc7>] ? sysfs_create_link+0x17/0x20
[  237.307415]  [<c132603f>] driver_probe_device+0x7f/0x190
[  237.307415]  [<c13261d1>] __driver_attach+0x81/0x90
[  237.307415]  [<c1326150>] ? __driver_attach+0x0/0x90
[  237.307415]  [<c13252a8>] bus_for_each_dev+0x48/0x70
[  237.307415]  [<c1325d5e>] driver_attach+0x1e/0x20
[  237.307415]  [<c1326150>] ? __driver_attach+0x0/0x90
[  237.307415]  [<c1325978>] bus_add_driver+0xb8/0x250
  237.307415]  [<c1326416>] driver_register+0x66/0x110
[  237.307415]  [<c1399a11>] usb_register_driver+0x81/0x140
[  237.307415]  [<c132658b>] ? driver_create_file+0x1b/0x20
[  237.307415]  [<f8059045>] hid_init+0x45/0x1000 [usbhid]
[  237.307415]  [<c1001255>] do_one_initcall+0x35/0x170
[  237.307415]  [<f8059000>] ? hid_init+0x0/0x1000 [usbhid]
[  237.307415]  [<c1083a46>] sys_init_module+0x166/0x1ac0
[  237.307415]  [<c1002f9f>] sysenter_do_call+0x12/0x28
[  237.307415] Code: 00 00 00 8b 45 f0 8b 5d f4 8b 75 f8 8b 7d fc 89 ec
5d c3 55 89 e5 83 ec 08 89 1c 24 89 7c 24 04 3e 8d 74 26 00 89 c3 89 c7
89 d0 <f3> aa 89 d8 8b 7c 24 04 8
b 1c 24 89 ec 5d c3 90 bb 00 e0 ff ff
[  237.307415] EIP: [<c126fbb8>] memset+0x18/0x28 SS:ESP 0068:f12d7bec
[  237.307415] CR2: 00000000f822a0dc
[  237.307415] ---[ end trace f9f52a0e760b97df ]---

What I was able to check so far:

- the stability is perfect if I switch the CPU to single-core in BIOS

- the paging fault is caused by 'rep movsb' inside memset(), which is
supposed to fill 0x18010 bytes. It always fails after 0x8010 bytes
filled (see ECX = 0x10000 in oops, it's the same on every crash). More
interestingly, ES and EDI values are perfectly valid (EDI is always in
range of the vmalloc'ed area).

I do not understand one detail of the oops log, however: given that 'rep
movsb' caused the paging fault, I'd expect CR2 to contain the same
value, however, CR2 is higher by 0x20000. Said that, EDI value is within
range, while address in CR2 is indeed invalid.

[    5.134750] ESI: 00000000 EDI: f820a0dc EBP: f12d7bf4 ESP: f12d7bec
[  237.307415] CR2: 00000000f822a0dc

I've checked the GDT, and __USER_DS descriptor looks perfectly valid there.

Any idea where this offset comes from? Am I missing some important
architecture detail, or is it just a proof of a failing hardware? Any
further debugging hints welcome.

BR,
Przemyslaw

