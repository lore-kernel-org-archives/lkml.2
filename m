Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2G2W2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 18:28:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60910 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2G2W2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 18:28:05 -0400
Message-ID: <5015B913.5050309@gmail.com>
Date: Mon, 30 Jul 2012 00:28:35 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, arnd@arndb.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: /dev/kmem BUG on mmap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was poking around /dev/kmem related code, and noticed the following in mmap_kmem():

        /* Turn a kernel-virtual address into a physical page frame */
        pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;

Which looked odd since vm_pgoff is the offset into the mapping, so I'd assume that PAGE_OFFSET should be added to it as well, otherwise we get an invalid address.

I tested it by writing something like this:

	int main(void)
	{
	        int fd;
	        void *addr;
	
	        fd = open("/dev/kmem", O_RDONLY);
	        addr = mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, fd, 4096);
	
	        return 0;
	}

Which indeed triggered a VM_BUG:

[   32.285431] kernel BUG at arch/x86/mm/physaddr.c:18!
[   32.285431] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   32.285431] CPU 0
[   32.285431] Pid: 5643, comm: a.out Tainted: G        W    3.5.0-next-20120727-sasha #504
[   32.285431] RIP: 0010:[<ffffffff810acd97>]  [<ffffffff810acd97>] __phys_addr+0x57/0xa0
[   32.285431] RSP: 0018:ffff88000be67d68  EFLAGS: 00010213
[   32.285431] RAX: ffff87ffffffffff RBX: ffff88000d67cb00 RCX: 00000000000080d0
[   32.285431] RDX: 0000000000000071 RSI: ffff88000bfc8dc8 RDI: 0000000000001000
[   32.285431] RBP: ffff88000be67d68 R08: 0000000000000001 R09: ffff88000bfc8dc8
[   32.285431] R10: ffff88000bfc81f8 R11: 0000000000000002 R12: ffff88000bfc8dc8
[   32.285431] R13: 00007f26f80e6000 R14: ffff88000bf81000 R15: ffff88000bfc8dc8
[   32.285431] FS:  00007f26f80e8700(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[   32.285431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.285431] CR2: 00007f26f7c07d50 CR3: 000000000bfb8000 CR4: 00000000000406f0
[   32.285431] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.285431] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   32.285431] Process a.out (pid: 5643, threadinfo ffff88000be66000, task ffff88000bf2b000)
[   32.285431] Stack:
[   32.285431]  ffff88000be67d88 ffffffff81bb0737 ffff88000bfc95e0 ffff88000bfc95f0
[   32.285431]  ffff88000be67e48 ffffffff812163ae ffff88000d67cb00 0000000000000001
[   32.285431]  0000000000000000 0000000000000000 ffff88000be67dd8 ffff88000bfc81f8
[   32.285431] Call Trace:
[   32.285431]  [<ffffffff81bb0737>] mmap_kmem+0x27/0x90
[   32.285431]  [<ffffffff812163ae>] mmap_region+0x35e/0x5f0
[   32.285431]  [<ffffffff812168f9>] do_mmap_pgoff+0x2b9/0x350
[   32.285431]  [<ffffffff8120120c>] ? vm_mmap_pgoff+0x6c/0xb0
[   32.285431]  [<ffffffff81201224>] vm_mmap_pgoff+0x84/0xb0
[   32.285431]  [<ffffffff8124f280>] ? fget_raw+0x260/0x260
[   32.285431]  [<ffffffff81213d9e>] sys_mmap_pgoff+0x15e/0x190
[   32.285431]  [<ffffffff8198ab2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   32.285431]  [<ffffffff8106e4ed>] sys_mmap+0x1d/0x20
[   32.285431]  [<ffffffff8361f6f9>] system_call_fastpath+0x16/0x1b
[   32.285431] Code: 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 03 05 91 02 78 03 eb 57 0f 1f 80 00 00 00 00 48 b8 ff ff ff ff ff 87 ff ff 48 39 c7 77 11 <0f> 0b 0f 1f 80 00 00 00 00 eb fe 66 0f 1f 44 00 00 48 b8 00 00
[   32.285431] RIP  [<ffffffff810acd97>] __phys_addr+0x57/0xa0
[   32.285431]  RSP <ffff88000be67d68>

I could send a patch to do what I think it's supposed to be doing, but I find it odd since apparently /dev/kmem has been broken for a while now - which doesn't make sense.

What am I missing?
