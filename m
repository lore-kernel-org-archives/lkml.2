Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1BWIbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:31:44 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33215 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1BWIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:31:42 -0500
Date: Wed, 23 Feb 2011 14:01:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: balbir@linux.vnet.ibm.com, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110223083048.GA3159@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <4D61D230.907@cn.fujitsu.com>
 <AANLkTinyZSeTQd9t9wCp+LMZ+gGM4H0mZBc+daZgnZ5u@mail.gmail.com>
 <20110223075121.GI3379@balbir.in.ibm.com>
 <AANLkTi=_iZfr8EGWqwrsm0D_wP6dNdaVDqAq3pS0fbuW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=_iZfr8EGWqwrsm0D_wP6dNdaVDqAq3pS0fbuW@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:56:20PM -0800, Paul Turner wrote:
> On Tue, Feb 22, 2011 at 11:51 PM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> > * Paul Turner <pjt@google.com> [2011-02-22 23:42:48]:
> >
> >> Thanks for the report Xiao -- I wasn't able to reproduce this yet with
> >> a simple guest, I will try a more modern image tomorrow.
> >>
> >> One suspicion is that this might be connected with the missing
> >> runnable accounting in sched_stoptask.c.
> >>
> >
> > I can confirm that, my guests work fine after the changes posted this
> > morning. I still see some lockdep errors, but none associated with the
> > scheduler.
> >
> 
> Excellent!
> 
> Ok, if this is resolved I'll roll this up and repost tomorrow, thanks!

As I said in an earlier reply, I too saw the lockups in guests. However those
lockups didn't occur consistently. After the sched_stoptask.c changes, I haven't
seen any lockups till now.

BTW, the lockups looked like this for me:

...
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Loading /lib/kbd/keymaps/i386/qwerty/us.map
BUG: soft lockup - CPU#0 stuck for 61s! [init:1]
Modules linked in:

Pid: 1, comm: init Not tainted (2.6.27.24-170.2.68.fc10.i686 #1) KVM
EIP: 0060:[<c041b93e>] EFLAGS: 00000297 CPU: 0
EIP is at __ticket_spin_lock+0x13/0x19
EAX: c080ff00 EBX: 00000000 ECX: c05751ca EDX: 00008584
ESI: df92c904 EDI: dd700d80 EBP: df819e50 ESP: df819e50
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 0805d3dc CR3: 1d706000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c06ab6cc>] lock_kernel+0x1f/0x2d
 [<c05751dc>] tty_open+0x12/0x2aa
 [<c0494a8c>] ? exact_match+0x0/0x7
 [<c0494dc7>] chrdev_open+0x12b/0x142
 [<c049141e>] __dentry_open+0x10e/0x1fc
 [<c0491593>] nameidata_to_filp+0x1f/0x33
 [<c0494c9c>] ? chrdev_open+0x0/0x142
 [<c049b0b7>] do_filp_open+0x31c/0x611
 [<c0422602>] ? set_next_entity+0x8b/0xf7
 [<c041f81a>] ? need_resched+0x18/0x22
 [<c049123c>] do_sys_open+0x42/0xb7
 [<c04912f3>] sys_open+0x1e/0x26
 [<c0404c8a>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup - CPU#3 stuck for 61s! [plymouthd:562]
Modules linked in:

Pid: 562, comm: plymouthd Not tainted (2.6.27.24-170.2.68.fc10.i686 #1) KVM
EIP: 0060:[<c041b93e>] EFLAGS: 00000293 CPU: 3
EIP is at __ticket_spin_lock+0x13/0x19
EAX: c080ff00 EBX: 00000000 ECX: df469198 EDX: 00008684
ESI: df469198 EDI: df424018 EBP: dd6b9dc0 ESP: dd6b9dc0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: 0804e767 CR3: 1d6b7000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c06ab6cc>] lock_kernel+0x1f/0x2d
 [<c04c827a>] proc_lookup_de+0x15/0xc0
 [<c04c8337>] proc_lookup+0x12/0x17
 [<c04c4934>] proc_root_lookup+0x11/0x2b
 [<c0498fe2>] do_lookup+0xae/0x11e
 [<c049a408>] __link_path_walk+0x57e/0x6b5
 [<c049a92b>] path_walk+0x4c/0x9b
 [<c049ab27>] do_path_lookup+0x12d/0x175
 [<c049abb4>] __path_lookup_intent_open+0x45/0x76
 [<c049abf5>] path_lookup_open+0x10/0x12
 [<c049ae3c>] do_filp_open+0xa1/0x611
 [<c04fadaa>] ? selinux_file_alloc_security+0x22/0x41
 [<c052048c>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0404cd7>] ? restore_nocheck_notrace+0x0/0xe
 [<c049123c>] do_sys_open+0x42/0xb7
 [<c04912f3>] sys_open+0x1e/0x26
 [<c0404c8a>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup - CPU#2 stuck for 63s! [setfont:559]
Modules linked in:

Pid: 559, comm: setfont Not tainted (2.6.27.24-170.2.68.fc10.i686 #1) KVM
EIP: 0060:[<c053a892>] EFLAGS: 00010283 CPU: 2
EIP is at vgacon_do_font_op+0x177/0x3ec
EAX: c095a1f8 EBX: df904000 ECX: 00000001 EDX: 00000043
ESI: 00000004 EDI: c095a1f4 EBP: dd743e0c ESP: dd743df0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 0826d000 CR3: 1d73c000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c053abac>] vgacon_font_set+0x59/0x208
 [<c04427d8>] ? down+0x2b/0x2f
 [<c053ab53>] ? vgacon_font_set+0x0/0x208
 [<c057f659>] con_font_op+0x15c/0x378
 [<c041f81a>] ? need_resched+0x18/0x22
 [<c057a80f>] vt_ioctl+0x1338/0x14fd
 [<c04fa419>] ? inode_has_perm+0x5b/0x65
 [<c05794d7>] ? vt_ioctl+0x0/0x14fd
 [<c0574b88>] tty_ioctl+0x665/0x6cf
 [<c04fa689>] ? file_has_perm+0x7b/0x84
 [<c0574523>] ? tty_ioctl+0x0/0x6cf
 [<c049c74a>] vfs_ioctl+0x22/0x69
 [<c049c9cc>] do_vfs_ioctl+0x23b/0x247
 [<c04fa7ac>] ? selinux_file_ioctl+0x35/0x38
 [<c049ca18>] sys_ioctl+0x40/0x5c
 [<c0404c8a>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup - CPU#1 stuck for 63s! [loadkeys:560]
Modules linked in:

Pid: 560, comm: loadkeys Not tainted (2.6.27.24-170.2.68.fc10.i686 #1) KVM
EIP: 0060:[<c06ab54e>] EFLAGS: 00000282 CPU: 1
EIP is at _spin_unlock_irqrestore+0x2d/0x38
EAX: 00000282 EBX: 00000282 ECX: dd5b7f80 EDX: 00000282
ESI: c096f740 EDI: c096f7fc EBP: c08a5f78 ESP: c08a5f74
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 009f0210 CR3: 1d73b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0593456>] serial8250_handle_port+0x220/0x230
 [<c059114e>] ? serial_in+0x5a/0x61
 [<c05934af>] serial8250_interrupt+0x49/0xc9
 [<c0465313>] handle_IRQ_event+0x2f/0x64
 [<c04662b5>] handle_edge_irq+0xb2/0xf4
 [<c0466203>] ? handle_edge_irq+0x0/0xf4
 [<c0406e6e>] do_IRQ+0xc7/0xfe
 [<c0405668>] common_interrupt+0x28/0x30
 [<c06ab54e>] ? _spin_unlock_irqrestore+0x2d/0x38
 [<c058ef7d>] uart_start+0x4e/0x53
 [<c058fa1e>] uart_write+0xce/0xd9
 [<c0575d88>] write_chan+0x1e5/0x2b0
 [<c0428218>] ? default_wake_function+0x0/0xd
 [<c05742c9>] tty_write+0x155/0x1d5
 [<c0575ba3>] ? write_chan+0x0/0x2b0
 [<c05743a9>] redirected_tty_write+0x60/0x6d
 [<c0574349>] ? redirected_tty_write+0x0/0x6d
 [<c04930d6>] vfs_write+0x84/0xdf
 [<c04931ca>] sys_write+0x3b/0x60
 [<c0404c8a>] syscall_call+0x7/0xb
 =======================
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
Setting up hotplug.
Creating block device nodes.
Creating character device nodes.
