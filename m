Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab1ESQfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:35:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42505 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933494Ab1ESQfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:35:01 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18hjLAMbpghVE620bSHtEqDxLcrtxmOXB4K2ZBUSK
	ejy1eQ7JVKlnFg
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Thu, 19 May 2011 18:34:55 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
References: <201105191526.31904.toralf.foerster@gmx.de>
In-Reply-To: <201105191526.31904.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105191834.56577.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW I got :

* Starting local
Kernel panic - not syncing: Segfault with no mm
08335ed4:  [<082b0b3b>] dump_stack+0x22/0x24
08335eec:  [<082b0ba0>] panic+0x63/0x167
08335f14:  [<080614af>] segv+0x27f/0x2f0
08335fcc:  [<08061561>] segv_handler+0x41/0x60
08335fec:  [<08071da4>] sig_handler_common+0x44/0xb0


EIP: 0000:[<00000000>] CPU: 0 Not tainted EFLAGS: 00000000
    Not tainted
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: 00000000 DS: 0000 ES: 0000
08335e88:  [<0807935d>] show_regs+0xed/0x120
08335ea4:  [<0806179c>] panic_exit+0x2c/0x50
08335eb4:  [<080a2b9c>] notifier_call_chain+0x4c/0x70
08335edc:  [<080a2c13>] atomic_notifier_call_chain+0x23/0x30
08335eec:  [<082b0bc8>] panic+0x8b/0x167
08335f14:  [<080614af>] segv+0x27f/0x2f0
08335fcc:  [<08061561>] segv_handler+0x41/0x60
08335fec:  [<08071da4>] sig_handler_common+0x44/0xb0


and gdb gives in another session to reproduce the bug this:

(gdb) c
Continuing.

Program received signal SIGSEGV, Segmentation fault.
rwsem_down_failed_common (sem=0x84f4000, flags=<value optimized out>, 
adjustment=<value optimized out>)
    at lib/rwsem.c:189
189                     adjustment += RWSEM_WAITING_BIAS;
(gdb) bt
#0  rwsem_down_failed_common (sem=0x84f4000, flags=<value optimized out>, 
adjustment=<value optimized out>)
    at lib/rwsem.c:189
#1  0x082b28f5 in rwsem_down_write_failed (sem=0x84f4000) at lib/rwsem.c:236
#2  0x082b0ba2 in call_rwsem_down_write_failed () at arch/um/sys-
i386/../../x86/lib/semaphore_32.S:92
#3  0x082b20e7 in __down_write_nested (sem=0x18916274)
    at /home/tfoerste/devel/linux-2.6/arch/x86/include/asm/rwsem.h:105
#4  __down_write (sem=0x18916274) at 
/home/tfoerste/devel/linux-2.6/arch/x86/include/asm/rwsem.h:121
#5  down_write (sem=0x18916274) at kernel/rwsem.c:51
#6  0x080d78e5 in sys_brk (brk=139411456) at mm/mmap.c:254
#7  0x08061dc6 in handle_syscall (r=0x19634d50) at 
arch/um/kernel/skas/syscall.c:35
#8  0x08075ed1 in handle_trap (regs=0x19634d50) at arch/um/os-
Linux/skas/process.c:201
#9  userspace (regs=0x19634d50) at arch/um/os-Linux/skas/process.c:417
#10 0x0805ef34 in fork_handler () at arch/um/kernel/process.c:181
#11 0x00000000 in ?? ()
(gdb) bt full
#0  rwsem_down_failed_common (sem=0x84f4000, flags=<value optimized out>, 
adjustment=<value optimized out>)
    at lib/rwsem.c:189
        waiter = {list = {next = 0x84cf27c, prev = 0x6}, task = 0x19634b80, 
flags = 2}
        tsk = 0x19634b80
        count = <value optimized out>
#1  0x082b28f5 in rwsem_down_write_failed (sem=0x84f4000) at lib/rwsem.c:236
No locals.
#2  0x082b0ba2 in call_rwsem_down_write_failed () at arch/um/sys-
i386/../../x86/lib/semaphore_32.S:92
No locals.
#3  0x082b20e7 in __down_write_nested (sem=0x18916274)
    at /home/tfoerste/devel/linux-2.6/arch/x86/include/asm/rwsem.h:105
        tmp = 411836076
#4  __down_write (sem=0x18916274) at 
/home/tfoerste/devel/linux-2.6/arch/x86/include/asm/rwsem.h:121
No locals.
#5  down_write (sem=0x18916274) at kernel/rwsem.c:51
No locals.
#6  0x080d78e5 in sys_brk (brk=139411456) at mm/mmap.c:254
        rlim = <value optimized out>
        newbrk = <value optimized out>
        oldbrk = 0
        mm = 0x18916240
#7  0x08061dc6 in handle_syscall (r=0x19634d50) at 
arch/um/kernel/skas/syscall.c:35
        syscall = <value optimized out>
#8  0x08075ed1 in handle_trap (regs=0x19634d50) at arch/um/os-
Linux/skas/process.c:201
        err = <value optimized out>
        status = 0
#9  userspace (regs=0x19634d50) at arch/um/os-Linux/skas/process.c:417
        sig = <value optimized out>
        timer = {it_interval = {tv_sec = 0, tv_usec = 0}, it_value = {tv_sec = 
0, tv_usec = 3999}}
        nsecs = <value optimized out>
        err = <value optimized out>
        status = 34175
        op = 31
        pid = 11337
        local_using_sysemu = 2
#10 0x0805ef34 in fork_handler () at arch/um/kernel/process.c:181
No locals.
#11 0x00000000 in ?? ()
No symbol table info available.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
