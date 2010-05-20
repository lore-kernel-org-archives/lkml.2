Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab0ETP5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:57:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab0ETP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:57:23 -0400
Date: Thu, 20 May 2010 08:55:20 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: mmotm 2010-05-19 BUG weirdness...
Message-Id: <20100520085520.5176d13c.akpm@linux-foundation.org>
In-Reply-To: <4637.1274370470@localhost>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
	<4637.1274370470@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 11:47:50 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 19 May 2010 16:13:09 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-05-19-16-12 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> So I'm looking closer at the BUG I just posted

I can't see that BUG report on lkml or in inbox.

> - I had deleted two further
> BUGs because they were obviously follow-ons to the original.  But then...
> 
> Note the following 2 lines:
> 
> [   35.357018] note: keymap[2481] exited with preempt_count 1
> [   35.360503] BUG: scheduling while atomic: keymap/2481/0x10000002
> 
> The kernel reports the instigating process exited - and then reports it as
> the offender for a "scheduling while atomic". Insufficient attempted cleanup
> after the first BUG?  Do we care because this is a sign of a scheduler bug
> that could trip on a non-BUG as well, or is it "all bets are off" because of
> the first BUG?

Yes, the oops code will end up calling do_exit() to get rid of this
process and to try to keep the machine limping along.  So if you hit an
oops with (say) a spinlock held, the task will end up calling do_exit()
with a non-zero preempt_count.

So the only problem I'm seeing here is .... Dmitry's ;)

> [   35.294528] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   35.295005] IP: [<(null)>] (null)
> [   35.296935] PGD 11da3c067 PUD 11d4ad067 PMD 0 
> [   35.296935] Oops: 0010 [#1] PREEMPT SMP 
> [   35.299667] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/idVendor
> [   35.300328] CPU 0 
> [   35.300328] Modules linked in:
> [   35.300328] 
> [   35.300328] Pid: 2481, comm: keymap Not tainted 2.6.34-mmotm0519 #1 0X564R/Latitude E6500                  
> [   35.300328] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
> [   35.300328] RSP: 0018:ffff88011d4d5cb0  EFLAGS: 00010046
> [   35.310163] RAX: 0000000000000000 RBX: ffff88011c03e000 RCX: 0000000000000081
> [   35.310163] RDX: ffff88011d4d5cc4 RSI: ffff88011d4d5cc8 RDI: ffff88011c03e000
> [   35.310163] RBP: ffff88011d4d5d28 R08: ffff88011e9b28e8 R09: 0000000000000001
> [   35.310163] R10: ffffffff81e0b160 R11: 0000000000000004 R12: 00000000000000a4
> [   35.310163] R13: ffff88011c03e830 R14: 0000000000000286 R15: ffff88011d4d5cc8
> [   35.310163] FS:  00007f4b86283700(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
> [   35.319397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   35.319397] CR2: 0000000000000000 CR3: 000000011d575000 CR4: 00000000000406f0
> [   35.319397] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   35.319397] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   35.319397] Process keymap (pid: 2481, threadinfo ffff88011d4d4000, task ffff88011e9b28c0)
> [   35.319397] Stack:
> [   35.319397]  ffffffff813bf3d1 ffff88011d4d5cf8 0000008100000246 00000081000000a4
> [   35.319397] <0> 0000000000000004 0000000000000000 ffff88011d4d5cc4 ffff88011cf11200
> [   35.319397] <0> ffff88011c179000 ffff88011d4d5d28 0000000000000081 00007fff9ee21fa0
> [   35.319397] Call Trace:
> [   35.319397]  [<ffffffff813bf3d1>] ? input_set_keycode+0xad/0x12c
> [   35.319397]  [<ffffffff813c231d>] evdev_do_ioctl+0x22b/0x79b
> [   35.337913]  [<ffffffff815a4b04>] ? __mutex_lock_common+0x564/0x580
> [   35.337913]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.341507]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.341507]  [<ffffffff813c28f0>] evdev_ioctl_handler+0x63/0x80
> [   35.344034]  [<ffffffff813c292a>] evdev_ioctl+0xb/0xd
> [   35.344034]  [<ffffffff810ea6cd>] vfs_ioctl+0x2d/0xa1
> [   35.344034]  [<ffffffff810eac4c>] do_vfs_ioctl+0x494/0x4cd
> [   35.344034]  [<ffffffff810eacdc>] sys_ioctl+0x57/0x95
> [   35.344034]  [<ffffffff8100266b>] system_call_fastpath+0x16/0x1b
> [   35.344034] Code:  Bad RIP value.
> [   35.344034] RIP  [<(null)>] (null)
> [   35.344034]  RSP <ffff88011d4d5cb0>
> [   35.344034] CR2: 0000000000000000
> [   35.357018] ---[ end trace 394fa5aa8a77b6f3 ]---
> [   35.357018] note: keymap[2481] exited with preempt_count 1
> [   35.360503] BUG: scheduling while atomic: keymap/2481/0x10000002
> [   35.361774] INFO: lockdep is turned off.
> [   35.363106] Modules linked in:
> [   35.364442] Pid: 2481, comm: keymap Tainted: G      D     2.6.34-mmotm0519 #1
> [   35.365759] Call Trace:
> [   35.367082]  [<ffffffff810653af>] ? __debug_show_held_locks+0x1b/0x24
> [   35.368391]  [<ffffffff8102e742>] __schedule_bug+0x6d/0x72
> [   35.369716]  [<ffffffff815a34de>] schedule+0x10a/0x902
> [   35.371012]  [<ffffffff81030b30>] __cond_resched+0x13/0x1f
> [   35.372305]  [<ffffffff815a3dfa>] _cond_resched+0x16/0x1d
> [   35.373576]  [<ffffffff810c3f10>] unmap_vmas+0x7b7/0x828
> [   35.374850]  [<ffffffff810c922b>] exit_mmap+0x82/0xfd
> [   35.376093]  [<ffffffff81035ede>] mmput+0x43/0xcf
> [   35.377339]  [<ffffffff8103a23a>] exit_mm+0x11d/0x12a
> [   35.378564]  [<ffffffff8103c21e>] do_exit+0x2e1/0x932
> [   35.379792]  [<ffffffff810393cf>] ? kmsg_dump+0x136/0x150
> [   35.381014]  [<ffffffff815a78b5>] oops_end+0x89/0x8e
> [   35.382211]  [<ffffffff8101fc79>] no_context+0x1f7/0x206
> [   35.383384]  [<ffffffff8101fe0f>] __bad_area_nosemaphore+0x187/0x1c7
> [   35.384571]  [<ffffffff810674bf>] ? __lock_acquire+0xc58/0xd09
> [   35.385751]  [<ffffffff8101fe5d>] bad_area_nosemaphore+0xe/0x10
> [   35.386936]  [<ffffffff815a9433>] do_page_fault+0x1f3/0x44b
> [   35.388111]  [<ffffffff815a58f2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [   35.389296]  [<ffffffff815a6cbf>] page_fault+0x1f/0x30
> [   35.390437]  [<ffffffff813bf3d1>] ? input_set_keycode+0xad/0x12c
> [   35.391534]  [<ffffffff813c231d>] evdev_do_ioctl+0x22b/0x79b
> [   35.392639]  [<ffffffff815a4b04>] ? __mutex_lock_common+0x564/0x580
> [   35.393722]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.394747]  [<ffffffff813c28ca>] ? evdev_ioctl_handler+0x3d/0x80
> [   35.395748]  [<ffffffff813c28f0>] evdev_ioctl_handler+0x63/0x80
> [   35.396686]  [<ffffffff813c292a>] evdev_ioctl+0xb/0xd
> [   35.397627]  [<ffffffff810ea6cd>] vfs_ioctl+0x2d/0xa1
> [   35.398541]  [<ffffffff810eac4c>] do_vfs_ioctl+0x494/0x4cd
> [   35.399471]  [<ffffffff810eacdc>] sys_ioctl+0x57/0x95
> [   35.400387]  [<ffffffff8100266b>] system_call_fastpath+0x16/0x1b
> 
