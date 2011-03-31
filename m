Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab1CaP2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:28:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42715 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1CaP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=HAbbxUs4ZaEMvVBUPRHEifv8WRUeZYM8shsANCSnZturu1efjnROUwwpVUFXr7SHKw
         DAzqJL7dH1ukhb5DI0WjVxjPJWa5WWnaRjnDH1cxYi6HO18GbuxzDCm9NcNB1vn5Gqb/
         LOD0h6v2/Bud2GNYb92yMfdUR1F0W4qZyCMYo=
MIME-Version: 1.0
Date: Thu, 31 Mar 2011 17:28:03 +0200
Message-ID: <AANLkTimPAX+BnXhtV0R=he80DBrQFMLgjobUwKfnWJuZ@mail.gmail.com>
Subject: gcc 4.6.0 breaks User Mode Linux
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, jdike@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The um kernel (Linus's tree as of today) crashes very early during boot-up.

---cut---
$ ./linux
Locating the bottom of the address space ... 0x10000
Locating the top of the address space ... 0xc0000000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm...nothing mounted on /dev/shm
Checking PROT_EXEC mmap in /tmp/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Aborted
---cut---

Here the gdb backtrace:
---cut---
Program received signal SIGILL, Illegal instruction.
kmem_cache_create (name=0x81efe77 "pid", size=44, align=4,
flags=270336, ctor=0) at mm/slab.c:2181
2181                    BUG();
(gdb) bt
#0  kmem_cache_create (name=0x81efe77 "pid", size=44, align=4,
flags=270336, ctor=0) at mm/slab.c:2181
#1  0x0804c902 in pidmap_init () at kernel/pid.c:565
#2  0x080494e9 in start_kernel () at init/main.c:591
#3  0x0804a539 in start_kernel_proc (unused=0x0) at
arch/um/kernel/skas/process.c:46
#4  0x08063ec2 in run_kernel_thread (fn=0x804a50f <start_kernel_proc>,
arg=0x0, jmp_ptr=0x823e7dc)
    at arch/um/os-Linux/process.c:267
#5  0x08057717 in new_thread_handler () at arch/um/kernel/process.c:153
#6  0x00000000 in ?? ()
---cut---

BUG() was trigged by in_interrupt() at mm/slab.c:2181.
in_interrupt() returns misleadingly a non-zero value.
My first idea was that in_interrupt() returns always a non-zero value,
but this is not the case.
preempt_count() seems broken in some way.

I can reproduce this issue using gcc 4.6.0 on x86 and x86_64 hosts.
Now I'm wondering whether this is a gcc or a uml bug.

Any ideas where to start?

-- 
Thanks,
//richard
