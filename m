Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1DDMUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:20:43 -0400
Received: from ftp.sofha.de ([82.144.60.99]:47969 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1DDMUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:20:42 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 08:20:42 EDT
Message-ID: <4D99B60D.3030009@snafu.de>
Date: Mon, 04 Apr 2011 14:14:05 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>,
        libusb-devel@lists.sourceforge.net
Subject: Kernel bug message and missing data on libusb_interrupt_transfer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  We are experiencing sporadic kernel bug messages and total
kernel freezes on usb communication via libusb-1.0.6.

  We are currently under kernel 2.6.30.10 but have seen
it also under older and newer kernel (I think the newest was
a 2.6.36.x).

  The communication should work as follows:

   - Send a 2 byte sequence to endpoint #4
     selecting the register to which the command should be send

   - The device should answer with the same two byte sequence
     on Endpoint #8

   - Send a 2 byte command sequence to endpoint #4

   - The device should acknowledge the command by returning
     the same two bytes on endpoint #8

   - The device may also initiate inbound data transfer on endpoint #8
     to inform about status changes.

  We send the register selection and command data via

  libusb_bulk_transfer() with a time out of 10000 ms

  and read the reply via libusb_interrupt_transfer
  with a time out of 100  ms as specified for our device
  We also periodically read on endpoint #8 to get the
  status changes.

  Sometimes we run into the following situation.

  - We send the 2 byte register selection sequence via libusb_bulk_transfer
  - We try to read the response via libusb_interrupt_transfer but run into
    a time out.
  - If we look at the USB communication via USB analyzer we actually see 
the inbound
    transfer of two bytes and the acknowledge by the kernel, but this 
data never
    ends up as a valid result of libusb_interrupt_transfer.
  - Since we got a time out we retry the read up to 30 times. Within 
this polling
    we see the following kernel bug message in dmesg. Sometimes the 
kernel freezes completely

<snip>
    ------------[ cut here ]------------
kernel BUG at mm/slub.c:2808!
invalid opcode: 0000 [#1] SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3/bConfigurationValue
CPU 3
Modules linked in:
Pid: 4314, comm: rrdupdate Not tainted 2.6.30.10 #2 To Be Filled By O.E.M.
RIP: 0010:[<ffffffff8028d2f8>]  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
RSP: 0000:ffff880077de1d38  EFLAGS: 00010246
RAX: 4000000000000000 RBX: ffff88007a07a772 RCX: ffff88007acea7e0
RDX: ffffe20000000000 RSI: ffffe20001ab1ab0 RDI: ffff88007a07a772
RBP: ffff880077de1d58 R08: 0000000000000000 R09: 0000000000000008
R10: 00000000f7f5e000 R11: 00000000f7f5d5b8 R12: ffff88007c081c80
R13: ffffffff802c9cd8 R14: 00000000f7f5e000 R15: ffff880077de1f58
FS:  0000000000000000(0000) GS:ffff88000105b000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7f5d5b8 CR3: 0000000079940000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rrdupdate (pid: 4314, threadinfo ffff880077de0000, task 
ffff8800790d8b40)
Stack:
  00000000f7f5e000 0000000000000000 ffff88007c081c80 ffff880077d77800
  ffff880077de1e48 ffffffff802c9cd8 0000000000000080 ffff880077d77800
  0000000000000001 00000000f7f3d000 ffff880077df2000 ffff880077df2000
Call Trace:
  [<ffffffff802c9cd8>] load_elf_binary+0xfda/0x1862
  [<ffffffff802c0b6f>] ? compat_copy_strings+0x1b8/0x1ca
  [<ffffffff802958fe>] search_binary_handler+0xb0/0x23f
  [<ffffffff802c0dc7>] compat_do_execve+0x246/0x36f
  [<ffffffff8022593b>] sys32_execve+0x3e/0x5c
  [<ffffffff80225765>] ia32_ptregs_common+0x25/0x4c
Code: ba 00 00 00 00 00 e2 ff ff 48 c1 e8 0c 48 6b f0 38 48 01 d6 66 83 
3e 00 79 04 48 8b 76 10 48 8b 06 84 c0 78 14 66 a9 00 c0 75 04 <0f> 0b 
eb fe 48 89 f7 e8 35 13 fe ff eb 48 48 8b 4d 08 48 8b 7e
RIP  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
  RSP <ffff880077de1d38>
---[ end trace ba800619f794f281 ]---

</snip>


I've placed a pdf on

http://www.oncaphillis.net/usb.pdf

which represents the annotated USB log


Thank you

O.

