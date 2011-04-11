Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1DKIfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:35:48 -0400
Received: from ftp.sofha.de ([82.144.60.99]:42830 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1DKIfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:35:46 -0400
Message-ID: <4DA2BD60.5050706@snafu.de>
Date: Mon, 11 Apr 2011 10:35:44 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: oncaphillis@snafu.de
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel BUG in 2.6.38.2 slub.c when communicating via usb
References: <4D9F7D90.4040302@snafu.de>
In-Reply-To: <4D9F7D90.4040302@snafu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I've goggled some more and it seems to be the same behaviour as described
in

http://kerneltrap.org/mailarchive/linux-usb/2010/12/14/6267887

O.

On 04/08/2011 11:26 PM, Oncaphillis wrote:
>  We are experiencing sporadic kernel bug messages and total
> kernel freezes during usb communication via libusb-1.0.8
>
> The communication should work as follows:
>
>   - Send a 2 byte sequence to endpoint #4
>     selecting the register to which the command should be send
>
>   - The device should answer with the same two byte sequence
>     on Endpoint #8
>
>   - Send a 2 byte command sequence to endpoint #4
>
>   - The device should acknowledge the command by returning
>     the same two bytes on endpoint #8
>
>   - The device may also initiate inbound data transfer on endpoint #8
>     to inform about status changes.
>
> We send the register selection and command data via
>
>  libusb_bulk_transfer() with a time out of 10000 ms
>
>  and read the reply via libusb_interrupt_transfer
>  with a time out of 100  ms as specified for our device
>  We also periodically read on endpoint #8 to get the
>  status changes.
>  Sometimes we run into the following situation.
>
>  - We send the 2 byte register selection sequence via
>    libusb_bulk_transfer
>  - We try to read the response via libusb_interrupt_transfer but run
>    into a time out or read junk (seems to be zero)
>  - If we look at the USB communication via USB analyser we actually
>    see the inbound transfer of the correct two bytes and the ACK by the
>    kernel, but this data never ends up as a valid result of
>    libusb_interrupt_transfer. Sometimes we get a timeout, sometimes we
>    read junk.
>  - Since we got a time out or junk data we retry the read up to 30
>    times. Within  this polling we see the following kernel bug
>    message in dmesg. Sometimes the kernel freezes completely
>
> This BUG message is actually from a 2.6.30.10 kernel, but the
> message is almost the same referring to a different line in slug.c
> wher e it seems to complain that someone tries to free  memory
> that has never been allocated.
> The stack trace varies even for the same kernel versions.
>
> The whole issue seems to vanish if the libusb has been compiled
> with --enable-timerfd
>
> The chipset on the host side is an Intel 82801I. The device Is A Sparta
> Xilinx FPGA which seems to talk nicely to windows
>
> A detailed screen shot of a USB analyzation can be found under
>
>  http://www.oncaphillis.net/usb.pdf
>
>
> <snip>
>    ------------[ cut here ]------------
> kernel BUG at mm/slub.c:2808!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: 
> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3/bConfigurationValue
> CPU 3
> Modules linked in:
> Pid: 4314, comm: rrdupdate Not tainted 2.6.30.10 #2 To Be Filled By 
> O.E.M.
> RIP: 0010:[<ffffffff8028d2f8>]  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
> RSP: 0000:ffff880077de1d38  EFLAGS: 00010246
> RAX: 4000000000000000 RBX: ffff88007a07a772 RCX: ffff88007acea7e0
> RDX: ffffe20000000000 RSI: ffffe20001ab1ab0 RDI: ffff88007a07a772
> RBP: ffff880077de1d58 R08: 0000000000000000 R09: 0000000000000008
> R10: 00000000f7f5e000 R11: 00000000f7f5d5b8 R12: ffff88007c081c80
> R13: ffffffff802c9cd8 R14: 00000000f7f5e000 R15: ffff880077de1f58
> FS:  0000000000000000(0000) GS:ffff88000105b000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f7f5d5b8 CR3: 0000000079940000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rrdupdate (pid: 4314, threadinfo ffff880077de0000, task 
> ffff8800790d8b40)
> Stack:
>  00000000f7f5e000 0000000000000000 ffff88007c081c80 ffff880077d77800
>  ffff880077de1e48 ffffffff802c9cd8 0000000000000080 ffff880077d77800
>  0000000000000001 00000000f7f3d000 ffff880077df2000 ffff880077df2000
> Call Trace:
>  [<ffffffff802c9cd8>] load_elf_binary+0xfda/0x1862
>  [<ffffffff802c0b6f>] ? compat_copy_strings+0x1b8/0x1ca
>  [<ffffffff802958fe>] search_binary_handler+0xb0/0x23f
>  [<ffffffff802c0dc7>] compat_do_execve+0x246/0x36f
>  [<ffffffff8022593b>] sys32_execve+0x3e/0x5c
>  [<ffffffff80225765>] ia32_ptregs_common+0x25/0x4c
> Code: ba 00 00 00 00 00 e2 ff ff 48 c1 e8 0c 48 6b f0 38 48 01 d6 66 
> 83 3e 00 79 04 48 8b 76 10 48 8b 06 84 c0 78 14 66 a9 00 c0 75 04 <0f> 
> 0b eb fe 48 89 f7 e8 35 13 fe ff eb 48 48 8b 4d 08 48 8b 7e
> RIP  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
>  RSP <ffff880077de1d38>
> ---[ end trace ba800619f794f281 ]---
>
> </snip>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

