Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab2EAM2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:28:45 -0400
Received: from websrv.saout.de ([78.46.99.52]:56231 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab2EAM2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:28:43 -0400
Message-ID: <1335875321.26671.15.camel@localhost>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: Jana Saout <jana@saout.de>
To: Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 14:28:41 +0200
In-Reply-To: <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1335788867.29087.19.camel@localhost>
	 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

> > I've been trying out the latest kernel and ran into an occasional oops
> > on a machine with OCFS2 and another machine with autofs. (on x86_64)
> > 
> > I've attached one of those as full log excerpt at the end of the mail
> > for completeness.
> > 
> > What the crashes have in common is that they always occur in fs/namei.c
> > hash_name (inlined into link_path_walk):
> > 
> >        [...]
> > 
> >                 hash = (hash + a) * 9;
> >                 len += sizeof(unsigned long);
> >  here --->      a = *(unsigned long *)(name+len);
> >                 /* Do we have any NUL or '/' bytes in this word? */
> >                 mask = has_zero(a) | has_zero(a ^ REPEAT_BYTE('/'));
> >        [...]
> > 
> > The line got compiled into "mov 0(%rbp,%rcx,1),%rax" with rbp being
> > "name" and "rcx" being len.
> > 
> > Now, it seems ocfs2 and autofs both manage to call into link_path_walk
> > with "name" not being word-aligned.
> > 
> > In the first example oops rbp ends with 0x...ff9, which is not
> > word-aligned, and in this particular case, the read goes one byte over
> > the end of the page, hence the rare, but occasional oops. (similar issue
> > for the autofs oops)
> 
> 	ocfs2 copyies a fast symlink into a len+1 buffer, allocated with
> kzalloc.  I'm not sure kzalloc is required to provide word-aligned
> allocs, but I think it does.

I thought so too... maybe the backtrace is slightly misleading, they
sometimes are. I'm not too clean on what the exact callchain is here. Do
you want me to investigate some more?

> > Force-disabling CONFIG_DCACHE_WORD_ACCESS make the oopses go away on
> > those machines.
> > 
> > Now, I guess, since the check is for dcache, and the name being passed
> > in is from filesystem code and not dcache, that there is something weird
> > going on here, or a case that has been missed, or something is happening
> > that is not supposed to happen in OCFS2 or autofs.
> > 
> > For the OCFS2 case I have a couple of oopses, always with almost
> > identical backtraces with "ocfs2_fast_follow_link" in them.  The autofs
> > oops is the only one I ran into so far.
> 
> 	Do you have any ocfs2 OOPSen that are *not* in
> fast_follow_link()?  Where are they?

No, all (about 15) I saw from ocfs2 all have ocfs2_fast_follow_link in
them, the first few lines of the backtrace are always identical.

Here is another one:

Apr 29 21:00:22 web5 kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
Apr 29 21:00:22 web5 kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
Apr 29 21:00:22 web5 kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
Apr 29 21:00:22 web5 kernel:  [<ffffffff8113c760>] ? link_path_walk+0x480/0x890
Apr 29 21:00:22 web5 kernel:  [<ffffffff8113ccd2>] ? path_lookupat+0x52/0x740
Apr 29 21:00:22 web5 kernel:  [<ffffffff81320049>] ? sock_aio_read.part.22+0xd9/0x100
Apr 29 21:00:22 web5 kernel:  [<ffffffff8113d3ec>] ? do_path_lookup+0x2c/0xc0
Apr 29 21:00:22 web5 kernel:  [<ffffffff8113a9fd>] ? getname_flags+0xed/0x260
Apr 29 21:00:22 web5 kernel:  [<ffffffff8113ebae>] ? user_path_at_empty+0x5e/0xb0
Apr 29 21:00:22 web5 kernel:  [<ffffffff8112f4d8>] ? do_sync_read+0xb8/0xf0
Apr 29 21:00:22 web5 kernel:  [<ffffffff81036c52>] ? pvclock_clocksource_read+0x52/0xf0
Apr 29 21:00:22 web5 kernel:  [<ffffffff81134482>] ? vfs_fstatat+0x32/0x60
Apr 29 21:00:22 web5 kernel:  [<ffffffff8100b4dd>] ? xen_clocksource_read+0x3d/0x70
Apr 29 21:00:22 web5 kernel:  [<ffffffff811345f2>] ? sys_newstat+0x12/0x30

(all others are also coming from either sys_netstatat or sys_newlstat,
except for this one - still, the top part looks the same again):

Apr 30 10:07:30 web5 kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
Apr 30 10:07:30 web5 kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
Apr 30 10:07:30 web5 kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
Apr 30 10:07:30 web5 kernel:  [<ffffffff8113c760>] ? link_path_walk+0x480/0x890
Apr 30 10:07:30 web5 kernel:  [<ffffffff8113e7fe>] ? path_openat+0xbe/0x3f0
Apr 30 10:07:30 web5 kernel:  [<ffffffffa00e1617>] ? ocfs2_lock_res_free+0x77/0x730 [ocfs2]
Apr 30 10:07:30 web5 kernel:  [<ffffffff8113ec55>] ? do_filp_open+0x45/0xb0
Apr 30 10:07:30 web5 kernel:  [<ffffffff8114a98b>] ? alloc_fd+0xcb/0x110
Apr 30 10:07:30 web5 kernel:  [<ffffffff8112f0e6>] ? do_sys_open+0xf6/0x1d0
Apr 30 10:07:30 web5 kernel:  [<ffffffff814241b9>] ? system_call_fastpath+0x16/0x1b

	Jana


> > OCFS2 oops:
> > 
> > Apr 30 14:02:46 web5 kernel: PGD 180c067 PUD bf5f5067 PMD bf635067 PTE 0
> > Apr 30 14:02:46 web5 kernel: Oops: 0000 [#8] PREEMPT SMP 
> > Apr 30 14:02:46 web5 kernel: CPU 0 
> > Apr 30 14:02:46 web5 kernel: Modules linked in: nfs lockd auth_rpcgss nfs_acl sunrpc autofs4 ocfs2 jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs
> > Apr 30 14:02:46 web5 kernel: 
> > Apr 30 14:02:46 web5 kernel: Pid: 18880, comm: apache2 Tainted: G      D      3.4.0-js1 #1  
> > Apr 30 14:02:46 web5 kernel: RIP: e030:[<ffffffff8113c29b>]  [<ffffffff8113c29b>] link_path_walk+0xab/0x890
> > Apr 30 14:02:46 web5 kernel: RSP: e02b:ffff88001e7a3bc8  EFLAGS: 00010257
> > Apr 30 14:02:46 web5 kernel: RAX: 0000000000000000 RBX: ffff88001e7a3e08 RCX: 0000000000000000
> > Apr 30 14:02:46 web5 kernel: RDX: 0000000000000000 RSI: 0000000000003230 RDI: 8080808080808080
> > Apr 30 14:02:46 web5 kernel: RBP: ffff880147e6dff9 R08: fefefefefefefeff R09: 2f2f2f2f2f2f2f2f
> > Apr 30 14:02:46 web5 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800646c7878
> > Apr 30 14:02:46 web5 kernel: R13: ffff880012103c00 R14: 0000000000000000 R15: ffff880012103c00
> > Apr 30 14:02:46 web5 kernel: FS:  00007f9940f51750(0000) GS:ffff8800bff0c000(0000) knlGS:0000000000000000
> > Apr 30 14:02:46 web5 kernel: CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > Apr 30 14:02:46 web5 kernel: CR2: ffff880147e6e000 CR3: 00000000051a8000 CR4: 0000000000000660
> > Apr 30 14:02:46 web5 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > Apr 30 14:02:46 web5 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Apr 30 14:02:46 web5 kernel: Process apache2 (pid: 18880, threadinfo ffff88001e7a2000, task ffff880012103c00)
> > Apr 30 14:02:46 web5 kernel: Stack:
> > Apr 30 14:02:46 web5 kernel:  ffff880012103c00 ffffffff8112538c 0000000000000020 ffffffffa014f7d5
> > Apr 30 14:02:46 web5 kernel:  ffff88001e7a3c40 ffff880012103c00 ffff88001e7a3e08 ffff8800a115ed20
> > Apr 30 14:02:46 web5 kernel:  ffff8800646f33c0 000000094e96972a ffff880147e6dfef ffffffffa014f808
> > Apr 30 14:02:46 web5 kernel: Call Trace:
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8112538c>] ? __kmalloc+0x17c/0x1e0
> > Apr 30 14:02:46 web5 kernel:  [<ffffffffa014f7d5>] ? ocfs2_fast_follow_link+0x95/0x320 [ocfs2]
> > Apr 30 14:02:46 web5 kernel:  [<ffffffffa014f808>] ? ocfs2_fast_follow_link+0xc8/0x320 [ocfs2]
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8113c670>] ? link_path_walk+0x480/0x890
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8113cbe2>] ? path_lookupat+0x52/0x740
> > Apr 30 14:02:46 web5 kernel:  [<ffffffffa00fe05f>] ? ocfs2_wait_for_recovery+0x2f/0xc0 [ocfs2]
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff810056c9>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8113d2fc>] ? do_path_lookup+0x2c/0xc0
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8113a94d>] ? getname_flags+0xed/0x260
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8113ed0e>] ? user_path_at_empty+0x5e/0xb0
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff8141d251>] ? _raw_spin_lock_irqsave+0x11/0x60
> > Apr 30 14:02:46 web5 kernel:  [<ffffffffa00e2c7d>] ? __ocfs2_cluster_unlock.isra.28+0x2d/0xe0 [ocfs2]
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff81420a30>] ? do_page_fault+0x2d0/0x540
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff811342f0>] ? cp_new_stat+0xe0/0x100
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff81134482>] ? vfs_fstatat+0x32/0x60
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff81134622>] ? sys_newlstat+0x12/0x30
> > Apr 30 14:02:46 web5 kernel:  [<ffffffff814242f9>] ? system_call_fastpath+0x16/0x1b
> > Apr 30 14:02:46 web5 kernel: Code: 49 b9 2f 2f 2f 2f 2f 2f 2f 2f 49 b8 ff fe fe fe fe fe fe fe 48 bf 80 80 80 80 80 80 80 80 66 90 4c 01 d0 48 83 c1 08 4c 8d 14 c0 <48> 8b 44 0d 00 48 89 c6 4e 8d 24 00 4c 31 ce 4a 8d 14 06 48 f7 
> > Apr 30 14:02:46 web5 kernel:  RSP <ffff88001e7a3bc8>
> > Apr 30 14:02:46 web5 kernel: CR2: ffff880147e6e000
> > Apr 30 14:02:46 web5 kernel: ---[ end trace d2be4a7423d225ba ]---


