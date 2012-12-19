Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2LSU2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:28:24 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:53001 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751303Ab2LSU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:28:13 -0500
Message-ID: <1355948878.7008.12.camel@thor.lan>
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Sasha Levin <levinsasha928@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Dec 2012 15:27:58 -0500
In-Reply-To: <50D0D5B5.5080506@ilyx.ru>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
	  <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com>
	 <1355849302.26487.15.camel@thor.lan> <50D0D5B5.5080506@ilyx.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 00:44 +0400, Ilya Zykov wrote:
> Stress test for tty. :)
> You can use this program for debug new tty changes.
> Use with caution.

Thanks a lot for writing this. I was really struggling to come up with a
test that would exercise the code races in tty properly. I'm going test
this tonight and tomorrow (During the interlull, I've been doing the
yearly refresh of my desktop with mixed results :).

> In any case(with/without Peter's patches) I have BUG():
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000004c
> IP: [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
> PGD 48696067 PUD a79c5067 PMD 0 
> Oops: 0000 [#1] SMP 
> Pid: 7877, comm: a.out Tainted: P           O 3.7.0-next-20121214-tty.1+ #9 System manufacturer P5K Premium/P5K Premium
> RIP: 0010:[<ffffffff81116650>]  [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
> RSP: 0018:ffff8800484a3aa8  EFLAGS: 00010292
> RAX: ffff88012f0385a0 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000000
> RBP: ffff8800484a3ac8 R08: 0000000000000000 R09: ffff880046f26d40
> R10: ffffffff81426ec8 R11: 0000000000000246 R12: ffff8800486a6c00
> R13: ffff8800484c7180 R14: ffff880046ec4890 R15: 00000000fffffffb
> FS:  00007f9a64345700(0000) GS:ffff88012fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000000004c CR3: 00000000a7a01000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process a.out (pid: 7877, threadinfo ffff8800484a2000, task ffff88007576d220)
> Stack:
>  ffff880000000001 ffff88004854a400 ffff8800486a6c00 ffff8800484c7180
>  ffff8800484a3ae8 ffffffff811e0c1b ffff8800484c7180 ffff88004854a400
>  ffff8800484a3bd8 ffffffff811d83aa ffff880046f26d78 0000000000000009
> Call Trace:
>  [<ffffffff811e0c1b>] pty_close+0x123/0x14f
>  [<ffffffff811d83aa>] tty_release+0x17a/0x53d
>  [<ffffffff812e7442>] ? __mutex_unlock_slowpath+0x15/0x39
>  [<ffffffff811e1003>] ptmx_open+0x12c/0x161
>  [<ffffffff810c6d4b>] chrdev_open+0x12a/0x14b
>  [<ffffffff810c6c21>] ? cdev_put+0x23/0x23
>  [<ffffffff810c27a9>] do_dentry_open+0x170/0x217
>  [<ffffffff810c2933>] finish_open+0x34/0x40
>  [<ffffffff810ce069>] do_last+0x8c4/0xa72
>  [<ffffffff810ce2ed>] ? path_init+0xd6/0x2fe
>  [<ffffffff810ceaf4>] path_openat+0xcb/0x363
>  [<ffffffff81051033>] ? __dequeue_entity+0x2e/0x33
>  [<ffffffff810cee91>] do_filp_open+0x38/0x84
>  [<ffffffff810d9846>] ? __alloc_fd+0x51/0x110
>  [<ffffffff810c24ed>] do_sys_open+0x6d/0xff
>  [<ffffffff810c25ac>] sys_open+0x1c/0x1e
>  [<ffffffff812ee652>] system_call_fastpath+0x16/0x1b
> Code: 08 02 00 00 48 89 c7 e8 6c f3 fb ff 5b 4c 89 e0 41 5c c9 c3 55 48 89 e5 41 55 41 54 53 48 89 fb 48 83 ec 08 48 8b 05 80 43 71 00 <81> 7f 4c 02 00 50 00 48 8b 40 08 4c 8b 60 60 75 04 0f 0b eb fe 
> RIP  [<ffffffff81116650>] devpts_pty_kill+0x17/0x81
>  RSP <ffff8800484a3aa8>
> CR2: 000000000000004c

[...]

> With Peter's patches I have WARN():

Yep. Sasha found this Saturday. It's a false positive that I need to
correct for this code path explicitly.

> WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xe7/0xf8()
> Hardware name: P5K Premium
> scheduling buffer work for halted ldisc
> Pid: 3127, comm: a.out Tainted: P        W  O 3.7.0-next-20121214-tty.1+ #9
> Call Trace:
>  [<ffffffff8102ce58>] warn_slowpath_common+0x80/0x98
>  [<ffffffff8102cf04>] warn_slowpath_fmt+0x41/0x43
>  [<ffffffff811dae01>] n_tty_set_room+0xe7/0xf8
>  [<ffffffff811db2cf>] reset_buffer_flags+0xad/0xb6
>  [<ffffffff811dd01b>] n_tty_open+0xca/0x11f
>  [<ffffffff811de4c9>] tty_ldisc_open+0x4e/0x5f
>  [<ffffffff811ded14>] tty_ldisc_hangup+0x1f5/0x292
>  [<ffffffff810d0289>] ? fasync_helper+0x22/0x6c
>  [<ffffffff811d7a03>] __tty_hangup+0x102/0x30e
>  [<ffffffff810d52ad>] ? d_delete+0x12d/0x136
>  [<ffffffff811d7c2a>] tty_vhangup+0x9/0xb
>  [<ffffffff811e0c3b>] pty_close+0x143/0x14f
>  [<ffffffff811d83aa>] tty_release+0x17a/0x53d
>  [<ffffffff8104b9f7>] ? __wake_up+0x3f/0x48
>  [<ffffffff810efb55>] ? fsnotify+0x21d/0x244
>  [<ffffffff810c4bc5>] __fput+0xf9/0x1bd
>  [<ffffffff810c4ccf>] ____fput+0x9/0xb
>  [<ffffffff81041cd4>] task_work_run+0x80/0x98
>  [<ffffffff810025bd>] do_notify_resume+0x58/0x69
>  [<ffffffff812ee8da>] int_signal+0x12/0x17
> 
> 
> ---
> /*
>  *  stress_test_tty.c
>  *
>  *  Created on: Dec, 2012
>  *  Copyright (C) 2012  Ilya Zykov
>  *
>  *  This program is free software: you can redistribute it and/or modify
>  *  it under the terms of the GNU General Public License as published by
>  *  the Free Software Foundation, either version 2 of the License, or
>  *  (at your option) any later version.
>  *
>  *  This program is distributed in the hope that it will be useful,
>  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  *  GNU General Public License for more details.
>  *
>  *  You should have received a copy of the GNU General Public License
>  *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  */

Thanks for GPL'ing this test. It will make things much easier to test
and comment on.

Happy Holidays,
Peter Hurley



