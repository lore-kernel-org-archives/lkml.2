Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2IPXNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:13:51 -0400
Received: from exprod7ob112.obsmtp.com ([64.18.2.176]:42255 "EHLO
	exprod7ob112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2IPXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:13:50 -0400
Message-ID: <50565D2B.5080900@genband.com>
Date: Sun, 16 Sep 2012 17:13:47 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Help!  How to get arguments to last function call of blocked task?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2012 23:13:48.0110 (UTC) FILETIME=[ED35A6E0:01CD9460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running an x86_64 kernel and I've got a task that is blocked on a mutex.  The stack trace shows:

[<ffffffff815ab5ae>] __mutex_lock_slowpath+0x7e/0xd0
[<ffffffff815ab3be>] mutex_lock+0xe/0x10
[<ffffffff81177d67>] nfsd_sync+0x47/0xd0
[<ffffffff81179800>] nfsd_commit+0x70/0xa0
[<ffffffff8117fd80>] nfsd3_proc_commit+0x80/0x100
[<ffffffff81173b1b>] nfsd_dispatch+0xbb/0x260
[<ffffffff81578f6e>] svc_process+0x48e/0x800
[<ffffffff81174299>] nfsd+0x199/0x2b0

I need to find out the argument of the call to __mutex_lock_slowpath() so that I can figure out which file it's trying to write to.  Based on disassembling the functions, I know that it is stored in r12 going into the call to schedule().

Rebooting is not possible, building kernel modules is.  Kprobes are enabled.  The stack for the task in question looks like this (printed out as 64-bit values):


stack pointer: ffff8807dfd8bc40

i: 0, addr: ffff8807dfd8bc48, val: 46
i: 1, addr: ffff8807dfd8bc50, val: 0
i: 2, addr: ffff8807dfd8bc58, val: ffff8807dfd8bcf4
i: 3, addr: ffff8807dfd8bc60, val: ffff8806f90ece40
i: 4, addr: ffff8807dfd8bc68, val: ff8806ee4a0260
i: 5, addr: ffff8807dfd8bc70, val: ffffffff818b5988
i: 6, addr: ffff8807dfd8bc78, val: ffffffff818b59a0
i: 7, addr: ffff8807dfd8bc80, val: ff8807dfd8bcb0
i: 8, addr: ffff8807dfd8bc88, val: ffffffff818b9d00
i: 9, addr: ffff8807dfd8bc90, val: ffff8807e91e6c80
i: 10, addr: ffff8807dfd8bc98, val: ffffffff8174e380
i: 11, addr: ffff8807dfd8bca0, val: ffff8807e91e6ff0
i: 12, addr: ffff8807dfd8bca8, val: dcd123c0
i: 13, addr: ffff8807dfd8bcb0, val: 1004826dc
i: 14, addr: ffff8807dfd8bcb8, val: ffff8807e91e70cc
i: 15, addr: ffff8807dfd8bcc0, val: ffff8807e91e6ff0
i: 16, addr: ffff8807dfd8bcc8, val: 818
i: 17, addr: ffff8807dfd8bcd0, val: fffffff7
i: 18, addr: ffff8807dfd8bcd8, val: 2
i: 19, addr: ffff8807dfd8bce0, val: 8001
i: 20, addr: ffff8807dfd8bce8, val: 0
i: 21, addr: ffff8807dfd8bcf0, val: 73dfd8bda0
i: 22, addr: ffff8807dfd8bcf8, val: 1
i: 23, addr: ffff8807dfd8bd00, val: 0
i: 24, addr: ffff8807dfd8bd08, val: ffff8807dcd1247c 
i: 25, addr: ffff8807dfd8bd10, val: ffff8807dcd12478 
i: 26, addr: ffff8807dfd8bd18, val: ffffffffffffffff 
i: 27, addr: ffff8807dfd8bd20, val: ffff8807e91e6c80 
i: 28, addr: ffff8807dfd8bd28, val: ffff8807dcd12480 
i: 29, addr: ffff8807dfd8bd30, val: ffff8807dfd8bd90 -- pointer to previous rbp?
i: 30, addr: ffff8807dfd8bd38, val: ffffffff815ab5ae -- return address (__mutex_lock_slowpath)
i: 31, addr: ffff8807dfd8bd40, val: ffff8807dcd12480
i: 32, addr: ffff8807dfd8bd48, val: ffff8807decdbd40
i: 33, addr: ffff8807dfd8bd50, val: ffff8807e91e6c80
i: 34, addr: ffff8807dfd8bd58, val: ffff8807f1c00000
i: 35, addr: ffff8807dfd8bd60, val: ffff8807f19e8808
i: 36, addr: ffff8807dfd8bd68, val: ffff8807dcd12478
i: 37, addr: ffff8807dfd8bd70, val: ffff8806f90ece40
i: 38, addr: ffff8807dfd8bd78, val: ffff8807f19e9000
i: 39, addr: ffff8807dfd8bd80, val: ffff8807f19e8800
i: 40, addr: ffff8807dfd8bd88, val: ffff8807dfc90000
i: 41, addr: ffff8807dfd8bd90, val: ffff8807dfd8bda0 -- pointer to previous rbp?
i: 42, addr: ffff8807dfd8bd98, val: ffffffff815ab3be -- return address (mutex_lock)


The __mutex_lock_slowpath() disassembly starts out like this:


Dump of assembler code for function __mutex_lock_slowpath:
   0xffffffff815ab530 <+0>:     push   %rbp
   0xffffffff815ab531 <+1>:     mov    %rsp,%rbp
   0xffffffff815ab534 <+4>:     push   %r15
   0xffffffff815ab536 <+6>:     push   %r14
   0xffffffff815ab538 <+8>:     push   %r13
   0xffffffff815ab53a <+10>:    push   %r12
   0xffffffff815ab53c <+12>:    mov    %rdi,%r12
   0xffffffff815ab53f <+15>:    push   %rbx
   0xffffffff815ab540 <+16>:    lea    0x8(%r12),%r15

so does that mean that address ffff8807dfd8bd28 stores r15, ffff8807dfd8bd20 stores r14, etc.?


The schedule() function starts out like this:
   0xffffffff815a9ea0 <+0>:     push   %rbp
   0xffffffff815a9ea1 <+1>:     mov    $0xffffffff818b59a0,%rdx
   0xffffffff815a9ea8 <+8>:     mov    %rsp,%rbp
   0xffffffff815a9eab <+11>:    mov    $0xffffffff818b5988,%rcx
   0xffffffff815a9eb2 <+18>:    push   %r15
   0xffffffff815a9eb4 <+20>:    push   %r14
   0xffffffff815a9eb6 <+22>:    push   %r13
   0xffffffff815a9eb8 <+24>:    push   %r12
   0xffffffff815a9eba <+26>:    mov    $0x0,%al
   0xffffffff815a9ebc <+28>:    push   %rbx


I'm interested in the r12 value going into schedule().  How do I identify it in my stack above?


Thanks,
Chris

-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com
