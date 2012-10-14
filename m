Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2JNPfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:35:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44786 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2JNPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:35:31 -0400
Message-ID: <507ADBBB.9090209@gmail.com>
Date: Sun, 14 Oct 2012 17:35:23 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [git pull] signals pile 3
References: <20121013005334.GM2616@ZenIV.linux.org.uk>
In-Reply-To: <20121013005334.GM2616@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/mixed;
 boundary="------------020202000702040007020602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020202000702040007020602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Al,

On 13.10.2012 02:53, Al Viro wrote:
> The last bits of infrastructure for kernel_thread() et.al., with alpha/arm/x86
> use of those.  Plus sanitizing the asm glue and do_notify_resume() on alpha,
> fixing the "disabled irq while running task_work stuff" breakage there.
> 
> At that point the rest of kernel_thread/kernel_execve/sys_execve work can
> be done independently for different architectures.  The only pending bits
> that do depend on having all architectures converted are restrictred to
> fs/* and kernel/* - that'll obviously have to wait for the next cycle.
> I thought we'd have to wait for all of them done before we start eliminating
> the longjump-style insanity in kernel_execve(), but it turned out there's
> a very simple way to do that without flagday-style changes.
> 
> Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
> 
> Shortlog:
> Al Viro (12):

[...]

>       arm: switch to saner kernel_execve() semantics

[...]

> Diffstat:

[...]

>  arch/arm/include/asm/unistd.h              |    1 -
>  arch/arm/kernel/entry-common.S             |   29 +--------
>  arch/arm/kernel/process.c                  |    5 +-

I rebased my ARM development branch and figured that your patch 9fff2fa
("arm: switch to saner kernel_execve() semantics") breaks the boot on my
board right after init is invoked via NFS:

[    4.682072] VFS: Mounted root (nfs filesystem) on device 0:12.
[    4.690744] devtmpfs: mounted
[    4.694395] Freeing init memory: 172K
[    5.291417] Internal error: Oops - undefined instruction: 0 [#1] SMP
THUMB2
[    5.298734] Modules linked in:
[    5.301952] CPU: 0    Not tainted  (3.6.0-11053-g56c8535 #128)
[    5.308071] PC is at cpsw_probe+0x422/0x9ac
[    5.312459] LR is at trace_hardirqs_on_caller+0x8f/0xfc
[    5.317934] pc : [<c03493de>]    lr : [<c005e81f>]    psr: 60000113
[    5.317934] sp : cf055fb0  ip : 00000000  fp : 00000000
[    5.329944] r10: 00000000  r9 : 00000000  r8 : 00000000
[    5.335413] r7 : 00000000  r6 : 00000000  r5 : c034458d  r4 : 00000000
[    5.342244] r3 : cf057a40  r2 : 00000000  r1 : 00000001  r0 : 00000000
[    5.349078] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[    5.356546] Control: 50c5387d  Table: 8f434019  DAC: 00000015
[    5.362562] Process init (pid: 1, stack limit = 0xcf054240)
[    5.368395] Stack: (0xcf055fb0 to 0xcf056000)
[    5.372961] 5fa0:                                     00000001
00000000 00000000 00000000
[    5.381525] 5fc0: cf055fb0 c000d1a8 00000000 00000000 00000000
00000000 00000000 00000000
[    5.390091] 5fe0: 00000000 bee83f10 00000000 b6fdedd0 00000010
00000000 aaaabfaf a8babbaa
[    5.398664] Code: 2206a010 718ef508 0184f8da f8b1f65d (3070f8d8)
[    5.405049] ---[ end trace f92e44d0ab15d037 ]---
[    5.410424] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b


Looking at the patch, I see it does two things:

 a) kill the special treatment formerly done by ret_from_kernel_thread
 b) switch over to generic execve for ARM

I know too little about the internals here, but reverting the latter
part fixes the boot for me. Find attached the patch I used locally for
that, on top of Linus' current merge tree (4d7127d).

FWIW, the config I'm using is here: http://pastebin.com/JPwAYmrD

I can test patches if you have any for me.


Thanks,
Daniel


--------------020202000702040007020602
Content-Type: text/x-patch;
 name="arm-execve-revert.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="arm-execve-revert.diff"

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 261fdd0..1bc092e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -12,7 +12,6 @@ config ARM
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_KERNEL_THREAD
-	select GENERIC_KERNEL_EXECVE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 8f60b6e..202bc3a 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -42,6 +42,7 @@
 #define __ARCH_WANT_SYS_SOCKETCALL
 #endif
 #define __ARCH_WANT_SYS_EXECVE
+#define __ARCH_WANT_KERNEL_EXECVE
 
 /*
  * "Conditional" syscalls
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 417bac1..c05bd28 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -94,6 +94,18 @@ ENTRY(ret_from_fork)
 	b	ret_slow_syscall
 ENDPROC(ret_from_fork)
 
+/*
+ * turn a kernel thread into userland process
+ * use: ret_from_kernel_execve(struct pt_regs *normal)
+ */
+ENTRY(ret_from_kernel_execve)
+	mov     why, #0                 @ not a syscall
+	str     why, [r0, #S_R0]        @ ... and we want 0 in ->ARM_r0 as well
+	get_thread_info tsk             @ thread structure
+	mov     sp, r0                  @ stack pointer just under pt_regs
+	b       ret_slow_syscall
+ENDPROC(ret_from_kernel_execve)
+
 	.equ NR_syscalls,0
 #define CALL(x) .equ NR_syscalls,NR_syscalls+1
 #include "calls.S"

--------------020202000702040007020602--
