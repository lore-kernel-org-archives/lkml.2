Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2FNUh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:37:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64079 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2FNUhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120614160129.GA3433@redhat.com>
References: <CANaxB-xyBw+O9h7OrFRNM93+Gp+GX63C-OgOZ2ZK2QbKMDBJ7g@mail.gmail.com>
	<20120614160129.GA3433@redhat.com>
Date: Fri, 15 Jun 2012 00:37:54 +0400
Message-ID: <CANaxB-z3Jho4vjRcG30mECYO+CdjwHXX7TmvxCy2A8rp2J7AOA@mail.gmail.com>
Subject: Re: general protection fault on finalizing task
From: Andrew Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, thank you for response. I'm going to test yours patches.

FYI: I bisected this problem.

# git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[3208450488ae724196f1efffc457e4265957c04e] pidns: use
task_active_pid_ns in do_notify_parent

commit 3208450488ae724196f1efffc457e4265957c04e
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu May 31 16:26:39 2012 -0700

    pidns: use task_active_pid_ns in do_notify_parent

    Using task_active_pid_ns is more robust because it works even after we
    have called exit_namespaces.  This change allows us to have parent
    processes that are zombies.  Normally a zombie parent processes is crazy
    and the last thing you would want to have but in the case of not letting
    the init process of a pid namespace be reaped until all of it's children
    are dead and reaped a zombie parent process is exactly what we want.

    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Pavel Emelyanov <xemul@parallels.com>
    Cc: Cyrill Gorcunov <gorcunov@openvz.org>
    Cc: Louis Rilling <louis.rilling@kerlabs.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



2012/6/14 Oleg Nesterov <oleg@redhat.com>:
> Hi Andrey,
>
> On 06/14, Andrey Vagin wrote:
>>
>> Hello,
>>
>> I'm developing CRIU (criu.org) and got this GP. I have seen it a few
>> time with the same stack trace.
>> It's not reproduced on 3.4.0-rc4+.
>>
>> general protection fault: 0000 [#1] SMP
>> CPU 0
>> Modules linked in: udp_diag bridge stp llc ipv6 ext4 jbd2 dm_mirror
>> dm_region_hash dm_log dm_mod pcspkr virtio_balloon 8139too 8139cp mii
>> i2c_piix4 i2c_core ext3 jbd mbcache virtio_blk virtio_pci virtio_ring
>> virtio pata_acpi ata_generic ata_piix floppy [last unloaded:
>> scsi_wait_scan]
>>
>> Pid: 1647, comm: crtools Not tainted 3.5.0-rc2+ #203 Red Hat KVM
>> RIP: 0010:[<ffffffff811b453a>]  [<ffffffff811b453a>] d_hash_and_lookup+0x2a/0x70
>
> Could you please re-test with these
>
>        http://marc.info/?l=linux-mm-commits&m=133962463616232
>        http://marc.info/?l=linux-mm-commits&m=133962463616231
>
> patches applied?
>
>
>> RSP: 0018:ffff88001651bd28  EFLAGS: 00010246
>> RAX: 0000000000003531 RBX: ffff88001651bd68 RCX: 0000000000000010
>> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000003531
>> RBP: ffff88001651bd38 R08: 000000000000fffa R09: 0000000000000002
>> R10: 0000000000000000 R11: 000000000000fffd R12: 6b6b6b6b6b6b6b6b
>> R13: ffff88001a3b3db0 R14: ffff88001651bd68 R15: 000000000000000f
>> FS:  00007ff80c4a2700(0000) GS:ffff88001f800000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007ff80c4ac000 CR3: 0000000001a0b000 CR4: 00000000000006f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process crtools (pid: 1647, threadinfo ffff88001651a000, task ffff880017154c40)
>> Stack:
>>  ffff88001651bd78 0000000000000001 ffff88001651bdc8 ffffffff812050c0
>>  ffff8800185b44b0 ffff88001721e4a0 ffff88001721e4a0 0000000f81057b6c
>>  0000000200003531 ffff88001651bd78 ffff880032003531 0000000000000246
>> Call Trace:
>>  [<ffffffff812050c0>] proc_flush_task+0xa0/0x1e0
>>  [<ffffffff81057c0e>] release_task+0xce/0x690
>>  [<ffffffff81057b6c>] ? release_task+0x2c/0x690
>>  [<ffffffff810622c2>] exit_ptrace+0x102/0x140
>>  [<ffffffff81059c64>] do_exit+0x214/0xa70
>>  [<ffffffff81553cbb>] ? _raw_read_unlock+0x2b/0x50
>>  [<ffffffff8105a51b>] do_group_exit+0x5b/0xd0
>>  [<ffffffff8105a5a7>] sys_exit_group+0x17/0x20
>>  [<ffffffff8155cee9>] system_call_fastpath+0x16/0x1b
>> Code: 00 55 48 89 e5 48 83 ec 10 48 89 1c 24 4c 89 64 24 08 66 66 66
>> 66 90 48 89 f3 49 89 fc 8b 76 04 48 8b 7b 08 e8 58 0c ff ff 89 03 <41>
>> f6 04 24 01 75 1f 48 89 de 4c 89 e7 e8 64 ff ff ff 48 8b 1c
>> RIP  [<ffffffff811b453a>] d_hash_and_lookup+0x2a/0x70
>>  RSP <ffff88001651bd28>
>> ---[ end trace 250bb1fa95f4b805 ]---
>> Fixing recursive fault but reboot is needed!
>>
>> Steps to reproduce:
>> * # git clone git://github.com/avagin/crtools.git -b gp-3.5
>> * # cd crtools
>> * # make && make -C test
>> * # while :; do bash test/zdtm.sh pidns/static/session00 || break; done
>> * Wait a few seconds
>>
>> session00 is a test case for checking, that session ids restored correctly.
>> it create about 10 processes in a separate pidns, some of them wait
>> children, other ones
>> wait on read from pipe. crtools freezes and dumps state of this
>> processes and kill processes.
>>
>> The bug is reproduced, when crtools try to kill tasks (in this moment
>> crtools attached to this tasks by ptrace).
>> The meta code looks like:
>> for_each_task(pid) {
>>   kill(pid, SIGKILL);
>>   ptrace(PTRACE_DETACH, pid, NULL, NULL);
>> }
>
