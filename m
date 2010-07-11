Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0GKSza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 14:55:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43771 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0GKSz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 14:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DqetQZw8tF6b6d1VzOwX7rFMH+jGn3qCbvYmN+9ph0dwo49zEOCz+cQQHjZW0wdSRK
         D731AyjpKSbLZa6hVPaRcep2SSqOBSDMpA99JJzpyvvgFPKHPwOo+EdH07l32rfG6ftk
         1Qjgc6TyhAZfQJG37f0xztLIf2185Db2gNlJg=
MIME-Version: 1.0
Date: Sun, 11 Jul 2010 20:55:26 +0200
Message-ID: <AANLkTimVSZ584-dTIJFalTStvT1kPBQmnDdgUTsoSFQT@mail.gmail.com>
Subject: Regression 2.6.33->2.6.34: OOPS at boot, kmalloc corruption?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to upgrade my system from 2.6.33 to 2.6.34, I can't get it to boot.

All tries used CONFIG_SLUB=y

The gentoo version of 2.6.34 generated an OOPS during network
initialization and then came to a stop. (It seemed that all processes
got stuck waiting on some locks.)
As in this instance the system was able to start the syslog, I was
able to capture the complete OOPS:
Jul  3 05:51:43 ariolc kernel: [   32.674367] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000003
Jul  3 05:51:43 ariolc kernel: [   32.675674] IP: [<ffffffff810aab89>]
__kmalloc_track_caller+0x69/0x110
Jul  3 05:51:43 ariolc kernel: [   32.676951] PGD 11e7e5067 PUD 11fd3d067 PMD 0
Jul  3 05:51:43 ariolc kernel: [   32.678224] Oops: 0000 [#1] SMP
Jul  3 05:51:43 ariolc kernel: [   32.679477] last sysfs file:
/sys/devices/virtual/block/md0/md/metadata_version
Jul  3 05:51:43 ariolc kernel: [   32.680745] CPU 1
Jul  3 05:51:43 ariolc kernel: [   32.680761] Modules linked in:
aes_x86_64(+) aes_generic sg
Jul  3 05:51:43 ariolc kernel: [   32.682764]
Jul  3 05:51:43 ariolc kernel: [   32.682764] Pid: 4652, comm:
modprobe Not tainted 2.6.34-gentoo-r1 #1 MS-7368/MS-7368
Jul  3 05:51:43 ariolc kernel: [   32.682764] RIP:
0010:[<ffffffff810aab89>]  [<ffffffff810aab89>]
__kmalloc_track_caller+0x69/0x110
Jul  3 05:51:43 ariolc kernel: [   32.682764] RSP:
0018:ffff88011e75fe08  EFLAGS: 00010006
Jul  3 05:51:43 ariolc kernel: [   32.687268] RAX: ffff880001b0f088
RBX: ffffffff8170d4d0 RCX: ffff88011e574b80
Jul  3 05:51:43 ariolc kernel: [   32.688564] RDX: 0000000000000000
RSI: 00000000000000d0 RDI: 00000000000002d0
Jul  3 05:51:43 ariolc kernel: [   32.688564] RBP: 0000000000000296
R08: 0000000000000014 R09: ffff88011e574800
Jul  3 05:51:43 ariolc kernel: [   32.691414] R10: 0000000000000001
R11: ffff880001a12008 R12: 00000000000000d0
Jul  3 05:51:43 ariolc kernel: [   32.691414] R13: 0000000000000003
R14: ffffffff81064abb R15: ffffc90010729d68
Jul  3 05:51:43 ariolc kernel: [   32.691414] FS:
00007f0a9acb8700(0000) GS:ffff880001b00000(0000)
knlGS:0000000000000000
Jul  3 05:51:43 ariolc kernel: [   32.691414] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul  3 05:51:43 ariolc kernel: [   32.697212] CR2: 0000000000000003
CR3: 000000011d03e000 CR4: 00000000000006e0
Jul  3 05:51:43 ariolc kernel: [   32.698792] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jul  3 05:51:43 ariolc kernel: [   32.698792] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  3 05:51:43 ariolc kernel: [   32.698792] Process modprobe (pid:
4652, threadinfo ffff88011e75e000, task ffff88011d114150)
Jul  3 05:51:43 ariolc kernel: [   32.698792] Stack:
Jul  3 05:51:43 ariolc kernel: [   32.698792]  0000000000000000
ffffc90010729c97 0000000000000008 ffff88011e574800
Jul  3 05:51:43 ariolc kernel: [   32.698792] <0> ffff88011e574aa0
ffffffff8108c27b ffffffffa0018920 ffffc900000000d0
Jul  3 05:51:43 ariolc kernel: [   32.698792] <0> ffffffffa0018920
ffffc90010728000 ffffc90010729d68 ffffffff81064abb
Jul  3 05:51:43 ariolc kernel: [   32.708636] Call Trace:
Jul  3 05:51:43 ariolc kernel: [   32.708636]  [<ffffffff8108c27b>] ?
kstrdup+0x3b/0x70
Jul  3 05:51:43 ariolc kernel: [   32.711488]  [<ffffffff81064abb>] ?
load_module+0x13eb/0x1730
Jul  3 05:51:43 ariolc kernel: [   32.711488]  [<ffffffff81064e7b>] ?
sys_init_module+0x7b/0x260
Jul  3 05:51:43 ariolc kernel: [   32.711488]  [<ffffffff810024ab>] ?
system_call_fastpath+0x16/0x1b
Jul  3 05:51:43 ariolc kernel: [   32.716465] Code: 23 25 dc 47 6f 00
41 f6 c4 10 75 66 9c 5d fa 65 48 8b 14 25 a8 d1 00 00 48 8b 03 48 8d
04 02 4c 8b 28 4d 85 ed 74 55 48 63 53 18 <49> 8b 54 15 00 48 89 10 55
9d 4d 85 ed 74 06 66 45 85 e4 78 22
Jul  3 05:51:43 ariolc kernel: [   32.718865] RIP
[<ffffffff810aab89>] __kmalloc_track_caller+0x69/0x110
Jul  3 05:51:43 ariolc kernel: [   32.718865]  RSP <ffff88011e75fe08>
Jul  3 05:51:43 ariolc kernel: [   32.718865] CR2: 0000000000000003
Jul  3 05:51:43 ariolc kernel: [   32.718865] ---[ end trace
692101747f991cfb ]---

Two other OOPSen in __kmalloc() followed this one.

I tried to switch from CONFIG_NO_BOOTMEM=y to unsetting this option.
This kernel froze before the userspace was started, I did not see any
OOPS output.

Today I tried the vanilla 2.6.34.1 (again with CONFIG_NO_BOOTMEM=y).
The vanilla kernel also crashed before userspace, again in
__kmalloc(), but with a visible OOPS.
I wrote the following informations down:
OPPS was: BUG: unable to handle kernel NULL pointer dereference at
0000000000000003
Callchain started with:
ffffffff810aab39 : __kmalloc_track_caller+0x69/0x110
ffffffff8108c23b : kstrdup+0x3b/0x70
called from sysfs_new_dirent
there where no modules loaded at this time, the faulting process was
Pid: 1, comm: swapper

>From System.map:
ffffffff810aa910 t get_slab
ffffffff810aa980 T __kmalloc_node_track_caller
ffffffff810aaad0 T __kmalloc_track_caller
ffffffff810aabe0 T __kmalloc
Dump of assembler code from 0xffffffff810aaad0 to 0xffffffff810aabe0:
0xffffffff810aaad0:     sub    $0x28,%rsp
0xffffffff810aaad4:     cmp    $0x2000,%rdi
0xffffffff810aaadb:     mov    %r12,0x10(%rsp)
0xffffffff810aaae0:     mov    %r14,0x20(%rsp)
0xffffffff810aaae5:     mov    %esi,%r12d
0xffffffff810aaae8:     mov    %rbx,(%rsp)
0xffffffff810aaaec:     mov    %rbp,0x8(%rsp)
0xffffffff810aaaf1:     mov    %rdx,%r14
0xffffffff810aaaf4:     mov    %r13,0x18(%rsp)
0xffffffff810aaaf9:     ja     0xffffffff810aaba3
0xffffffff810aaaff:     callq  0xffffffff810aa910
0xffffffff810aab04:     cmp    $0x10,%rax
0xffffffff810aab08:     mov    %rax,%rbx
0xffffffff810aab0b:     jbe    0xffffffff810aab51
0xffffffff810aab0d:     and    0x6f48ac(%rip),%r12d        # 0xffffffff8179f3c0
0xffffffff810aab14:     test   $0x10,%r12b
0xffffffff810aab18:     jne    0xffffffff810aab80
0xffffffff810aab1a:     pushfq
0xffffffff810aab1b:     pop    %rbp
0xffffffff810aab1c:     cli
0xffffffff810aab1d:     mov    %gs:0xd1a8,%rdx
0xffffffff810aab26:     mov    (%rbx),%rax
0xffffffff810aab29:     lea    (%rdx,%rax,1),%rax
0xffffffff810aab2d:     mov    (%rax),%r13
0xffffffff810aab30:     test   %r13,%r13
0xffffffff810aab33:     je     0xffffffff810aab8a
0xffffffff810aab35:     movslq 0x18(%rbx),%rdx
0xffffffff810aab39:     mov    0x0(%r13,%rdx,1),%rdx
0xffffffff810aab3e:     mov    %rdx,(%rax)
0xffffffff810aab41:     push   %rbp
0xffffffff810aab42:     popfq
0xffffffff810aab43:     test   %r13,%r13
0xffffffff810aab46:     je     0xffffffff810aab4e
0xffffffff810aab48:     test   %r12w,%r12w
0xffffffff810aab4c:     js     0xffffffff810aab70
0xffffffff810aab4e:     mov    %r13,%rax
0xffffffff810aab51:     mov    (%rsp),%rbx
0xffffffff810aab55:     mov    0x8(%rsp),%rbp
0xffffffff810aab5a:     mov    0x10(%rsp),%r12
0xffffffff810aab5f:     mov    0x18(%rsp),%r13
0xffffffff810aab64:     mov    0x20(%rsp),%r14
0xffffffff810aab69:     add    $0x28,%rsp
0xffffffff810aab6d:     retq
0xffffffff810aab6e:     xchg   %ax,%ax
0xffffffff810aab70:     movslq 0x14(%rbx),%rdx
0xffffffff810aab74:     xor    %esi,%esi
0xffffffff810aab76:     mov    %r13,%rdi
0xffffffff810aab79:     callq  0xffffffff811f51e0
0xffffffff810aab7e:     jmp    0xffffffff810aab4e
0xffffffff810aab80:     callq  0xffffffff814cd640
0xffffffff810aab85:     nopl   (%rax)
0xffffffff810aab88:     jmp    0xffffffff810aab1a
0xffffffff810aab8a:     mov    %rax,%r8
0xffffffff810aab8d:     mov    %r14,%rcx
0xffffffff810aab90:     or     $0xffffffffffffffff,%edx
0xffffffff810aab93:     mov    %r12d,%esi
0xffffffff810aab96:     mov    %rbx,%rdi
0xffffffff810aab99:     callq  0xffffffff810a9ae0
0xffffffff810aab9e:     mov    %rax,%r13
0xffffffff810aaba1:     jmp    0xffffffff810aab41
0xffffffff810aaba3:     dec    %rdi
0xffffffff810aaba6:     or     $0xffffffffffffffff,%esi
0xffffffff810aaba9:     shr    $0xb,%rdi
0xffffffff810aabad:     inc    %esi
0xffffffff810aabaf:     shr    %rdi
0xffffffff810aabb2:     jne    0xffffffff810aabad
0xffffffff810aabb4:     mov    %r12d,%edi
0xffffffff810aabb7:     mov    (%rsp),%rbx
0xffffffff810aabbb:     mov    0x8(%rsp),%rbp
0xffffffff810aabc0:     mov    0x10(%rsp),%r12
0xffffffff810aabc5:     mov    0x18(%rsp),%r13
0xffffffff810aabca:     or     $0x4000,%edi
0xffffffff810aabd0:     mov    0x20(%rsp),%r14
0xffffffff810aabd5:     add    $0x28,%rsp
0xffffffff810aabd9:     jmpq   0xffffffff81080920
0xffffffff810aabde:     xchg   %ax,%ax

>From this assembly, I would guess its this line in slub.c / slab_alloc():
c->freelist = get_freepointer(s, object);

A short test with 2.6.35-rc4 suggest that this problem has been fixed
on master, although 2.6.35-rc4 only boots with radeon.modset=0. With
KMS enabled the display turns off and the system does not even respond
to SysRq+B.
(I will report this KMS issue in another mail.)

The system is an AMD RS690 with an Athlon X2 BE-2400.
Under 2.6.33 the system is perfectly stable, KMS is working and enabled.

Any guesses what this might cause?

Thanks for looking that this,
                                            Torsten
