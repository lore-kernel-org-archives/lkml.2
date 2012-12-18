Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2LRPpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:45:18 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53916 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2LRPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:45:15 -0500
MIME-Version: 1.0
In-Reply-To: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 18 Dec 2012 10:44:49 -0500
Message-ID: <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 1:22 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> I wasn't sure if this is something to squeeze into 3.8, so don't yell
> if not. At least Sasha can apply this and re-test against trinity.
>
> Changes in v2:
>
> - Please review "tty: Don't flush buffer when closing ldisc".
>   This patch replaces the earlier
>   "tty: Don't reschedule buffer work while closing". The text of
>   this commit details why not calling n_tty_flush_buffer() is the
>   correct thing to do, so I won't repeat it here.
>
> - Jiri's debug patch "tty: debug buffer work race with tty free"
>   has been included (albeit a slightly different version)
>   Jiri, please sign off (or point out what you'd like changed).
>
> - The test jig has been included in the commit message for
>   "tty: Don't flush buffer when closing ldisc" as Alan requested.
>
> - Ilya Zykov was added as the Signed-off-by: for the test jig in
>   that same commit message.
>
> - Sasha Levin was added as the Reported-by: in that same patch.
>
>
> This patch series addresses the causes of flush_to_ldisc accessing
> the tty after freeing.
>
> The most common cause stems from the n_tty_close() path spuriously
> scheduling buffer work, when the ldisc has already been halted.
> This is fixed in 'tty: Don't flush buffer when closing ldisc'

I'm still seeing that warning with the new patch series:

[  549.561769] ------------[ cut here ]------------
[  549.598755] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xff/0x130()
[  549.604058] scheduling buffer work for halted ldisc
[  549.607741] Pid: 9417, comm: trinity-child28 Tainted: G      D W
3.7.0-next-20121217-sasha-00023-g8689ef9 #219
[  549.652580] Call Trace:
[  549.662754]  [<ffffffff81c432cf>] ? n_tty_set_room+0xff/0x130
[  549.665458]  [<ffffffff8110cae7>] warn_slowpath_common+0x87/0xb0
[  549.668257]  [<ffffffff8110cb71>] warn_slowpath_fmt+0x41/0x50
[  549.671007]  [<ffffffff81c432cf>] n_tty_set_room+0xff/0x130
[  549.673268]  [<ffffffff81c44597>] reset_buffer_flags+0x137/0x150
[  549.675607]  [<ffffffff81c45b71>] n_tty_open+0x131/0x1c0
[  549.677699]  [<ffffffff81c47824>] tty_ldisc_open.isra.5+0x54/0x70
[  549.680147]  [<ffffffff81c482bf>] tty_ldisc_hangup+0x11f/0x1e0
[  549.682409]  [<ffffffff81c3fa17>] __tty_hangup+0x137/0x440
[  549.684634]  [<ffffffff81c3fd49>] tty_vhangup+0x9/0x10
[  549.686443]  [<ffffffff81c4a42c>] pty_close+0x14c/0x160
[  549.688446]  [<ffffffff81c41225>] tty_release+0xd5/0x490
[  549.690460]  [<ffffffff8127d8a2>] __fput+0x122/0x250
[  549.692577]  [<ffffffff8127d9d9>] ____fput+0x9/0x10
[  549.694534]  [<ffffffff811348c2>] task_work_run+0xb2/0xf0
[  549.696349]  [<ffffffff81113c6d>] do_exit+0x36d/0x580
[  549.698286]  [<ffffffff8107d964>] ? syscall_trace_enter+0x24/0x2e0
[  549.702729]  [<ffffffff81113f4a>] do_group_exit+0x8a/0xc0
[  549.706775]  [<ffffffff81113f92>] sys_exit_group+0x12/0x20
[  549.711088]  [<ffffffff83cfab18>] tracesys+0xe1/0xe6
[  549.728001] ---[ end trace 73eb41728f11f87e ]---


Thanks,
Sasha
