Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1BITA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:00:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab1BITA5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:00:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110209092851.bba6c40c.randy.dunlap@oracle.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com> <20110209092851.bba6c40c.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Feb 2011 11:00:34 -0800
Message-ID: <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Joel Becker <jlbec@evilplan.org>,
        James Bottomley <James.Bottomley@suse.de>
Cc: scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 9:28 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> x86_64, nearly allmodconfig.  No target hardware.
>
>
> [  144.508473] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  144.509901] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
> [  144.512026] CPU 1
> [  144.512026]
> [  144.512026] Pid: 2597, comm: rmmod Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745
> [  144.512026] RIP: 0010:[<ffffffff810c3e5f>]  [<ffffffff810c3e5f>] __lock_acquire+0xd8/0x4e8
> [  144.512026] RSP: 0018:ffff88006df1bb78  EFLAGS: 00010006
> [  144.512026] RAX: 0000000000000002 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000

The code disassembles to

   0:	8d 01                	lea    (%rcx),%eax
   2:	e8 6c b1 fb ff       	callq  0xfffffffffffbb173
   7:	48 ff 05 8b 32 8d 01 	incq   0x18d328b(%rip)        # 0x18d3299
   e:	48 ff 05 8c 32 8d 01 	incq   0x18d328c(%rip)        # 0x18d32a1
  15:	48 ff 05 95 32 8d 01 	incq   0x18d3295(%rip)        # 0x18d32b1
  1c:	e9 e3 03 00 00       	jmpq   0x404
  21:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32a9
  28:*	48 81 3b 40 5f 26 82 	cmpq   $0xffffffff82265f40,(%rbx)     <--
trapping instruction
  2f:	75 07                	jne    0x38
  31:	48 ff 05 81 32 8d 01 	incq   0x18d3281(%rip)        # 0x18d32b9
  38:	83 fe 01             	cmp    $0x1,%esi

and %rbx (and %rdi) contains the poison pattern for free'd memory (0x6b6b6b..).

> [  144.512026] Process rmmod (pid: 2597, threadinfo ffff88006df1a000, task ffff88006dec3000)

.. and that's likely not a very commonly tested case.

> [  144.512026]  [<ffffffffa06ace26>] configfs_unregister_subsystem+0x105/0x194 [configfs]
> [  144.512026]  [<ffffffffa06baf55>] target_core_exit_configfs+0x185/0x1eb [target_core_mod]
> [  144.512026]  [<ffffffff810d46a8>] sys_delete_module+0x2d6/0x368

The target_core_exit_configfs() code looks _very_ broken. It looks
broken for two reasons:

 - it's very different from the cleanup code for the "failed to init"
case in target_core_init_configfs, which does a lot less (see the
"out:" code there)

 - it seems to do a lot of manual freeing of the
"su_group.default_groups" stuff etc, which is all internal configfs
stuff, and seems to be used by the register/unregister phases.

So somebody show knows configfs better should really check that
cleanup, but it looks like target-core is just totally broken for the
rmmod case.

Added more people to the cc. Nicholas, Joel and James. Guys: please
check the insmod/rmmod case with
 (a) spinlock debugging and lockdep enabled
 (b) SLUB poisoning enabled.
ie all of these should be on:

  CONFIG_SLUB_DEBUG_ON=y
  CONFIG_DEBUG_SPINLOCK=y
  CONFIG_DEBUG_MUTEXES=y
  CONFIG_DEBUG_LOCK_ALLOC=y
  CONFIG_PROVE_LOCKING=y
  CONFIG_LOCKDEP=y
  CONFIG_DEBUG_LOCKDEP=y
  CONFIG_TRACE_IRQFLAGS=y
  CONFIG_DEBUG_SPINLOCK_SLEEP=y
  CONFIG_STACKTRACE=y

and you might also want to add CONFIG_DEBUG_PAGEALLOC to the mix.

                        Linus
