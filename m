Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825Ab2JYSCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:02:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49087 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab2JYSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:02:15 -0400
Message-ID: <50897E98.5080502@gmail.com>
Date: Thu, 25 Oct 2012 14:02:00 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz> <1350592007-9216-22-git-send-email-jslaby@suse.cz>
In-Reply-To: <1350592007-9216-22-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On 10/18/2012 04:26 PM, Jiri Slaby wrote:
> So this is it. The big step why we did all the work over the past
> kernel releases. Now everything is prepared, so nothing protects us
> from doing that big step.
> 
>            |  |            \  \ nnnn/^l      |  |
>            |  |             \  /     /       |  |
>            |  '-,.__   =>    \/   ,-`    =>  |  '-,.__
>            | O __.´´)        (  .`           | O __.´´)
>             ~~~   ~~          ``              ~~~   ~~
> The buffers are now in the tty_port structure and we can start
> teaching the buffer helpers (insert char/string, flip etc.) to use
> tty_port instead of tty_struct all around.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---

Fuzzing with trinity inside a KVM tools (lkvm) guest with -next kernel
uncovered the following warning:

[ 1339.448706] ------------[ cut here ]------------
[ 1339.451224] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x60/0x200()
[ 1339.454272] tty is NULLPid: 7147, comm: kworker/4:0 Tainted: G        W    3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #75
[ 1339.458693] Call Trace:
[ 1339.459410]  [<ffffffff81bb1ea0>] ? flush_to_ldisc+0x60/0x200
[ 1339.461289]  [<ffffffff81109b86>] warn_slowpath_common+0x86/0xb0
[ 1339.462992]  [<ffffffff81109c11>] warn_slowpath_fmt+0x41/0x50
[ 1339.464772]  [<ffffffff81bb1ea0>] flush_to_ldisc+0x60/0x200
[ 1339.467076]  [<ffffffff8112d5a9>] process_one_work+0x3b9/0x770
[ 1339.469501]  [<ffffffff8112d458>] ? process_one_work+0x268/0x770
[ 1339.472053]  [<ffffffff8112dcc1>] ? worker_thread+0x51/0x3f0
[ 1339.473831]  [<ffffffff81bb1e40>] ? __tty_buffer_request_room+0x180/0x180
[ 1339.475834]  [<ffffffff8112df2a>] worker_thread+0x2ba/0x3f0
[ 1339.478027]  [<ffffffff8112dc70>] ? rescuer_thread+0x2d0/0x2d0
[ 1339.480431]  [<ffffffff81138c33>] kthread+0xe3/0xf0
[ 1339.482383]  [<ffffffff8117d7be>] ? put_lock_stats.isra.16+0xe/0x40
[ 1339.484171]  [<ffffffff81138b50>] ? insert_kthread_work+0x90/0x90
[ 1339.485886]  [<ffffffff83aedebc>] ret_from_fork+0x7c/0xb0
[ 1339.487943]  [<ffffffff81138b50>] ? insert_kthread_work+0x90/0x90
[ 1339.490435] ---[ end trace e01a8b0af77894c4 ]---

I'm guessing it happens because we never cancel the scheduled work when we
free the buffer, so the scheduled work may run even after we freed the buffer.

Besides the warning itself, I think that 'tty is NULL' would need a newline
after it. Greg, should I send a patch for that?


Thanks,
Sasha
