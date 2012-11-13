Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2KMUAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:00:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34431 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab2KMUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:00:33 -0500
Message-ID: <50A2A6DE.4030305@suse.cz>
Date: Tue, 13 Nov 2012 21:00:30 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tty_ldisc_hangup: waiting (init) for ttyS0 took too long, but
 we keep waiting...
References: <509DDC15.5040502@gmail.com>
In-Reply-To: <509DDC15.5040502@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2012 05:46 AM, Sasha Levin wrote:
> Hi all,
> 
> I'm seeing lots of cases when my fuzzing session hangs with a message that
> starts with:
> 
> [  104.670841] tty_ldisc_hangup: waiting (init) for ttyS0 took too long, but we keep waiting...
> 
> And continues with a hung task spew, such as:
> 
> [  242.990329] INFO: task init:1 blocked for more than 120 seconds.
> [  242.990955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  242.991527] init            D ffff8800132c0000  3408     1      0 0x00000002
> [  242.992156]  ffff88001327dc18 0000000000000002 ffff88001327dbd8 ffffffff81152f95
> [  242.992784]  ffff880013280000 ffff88001327dfd8 ffff88001327dfd8 ffff88001327dfd8
> [  242.994200]  ffff8800132c0000 ffff880013280000 ffff880013280910 7fffffffffffffff
> [  242.995780] Call Trace:
> [  242.996429]  [<ffffffff81152f95>] ? sched_clock_local+0x25/0xa0
> [  242.997704]  [<ffffffff83bdf065>] schedule+0x55/0x60
> [  242.999864]  [<ffffffff83bdcea5>] schedule_timeout+0x45/0x360
> [  243.008415]  [<ffffffff83be077d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
> [  243.008980]  [<ffffffff8117ff8d>] ? trace_hardirqs_on+0xd/0x10
> [  243.009756]  [<ffffffff83be07a4>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
> [  243.010662]  [<ffffffff81139e17>] ? prepare_to_wait+0x77/0x90
> [  243.011452]  [<ffffffff81bb7a56>] tty_ldisc_wait_idle.isra.6+0x76/0xb0
> [  243.012314]  [<ffffffff81139ff0>] ? abort_exclusive_wait+0xb0/0xb0
> [  243.013157]  [<ffffffff81bb83bb>] tty_ldisc_hangup+0x1cb/0x320
> [  243.013927]  [<ffffffff81baf712>] ? __tty_hangup+0x122/0x430
> [  243.014687]  [<ffffffff81baf71a>] __tty_hangup+0x12a/0x430
> [  243.015410]  [<ffffffff83be07a4>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
> [  243.016321]  [<ffffffff81bb187a>] disassociate_ctty+0x6a/0x230
> [  243.017112]  [<ffffffff811107fa>] do_exit+0x4ea/0xbd0
> [  243.017793]  [<ffffffff811ccc65>] ? rcu_user_exit+0xc5/0xf0
> [  243.018549]  [<ffffffff8117ff8d>] ? trace_hardirqs_on+0xd/0x10
> [  243.019339]  [<ffffffff81110fa4>] do_group_exit+0x84/0xd0
> [  243.020109]  [<ffffffff81111002>] sys_exit_group+0x12/0x20
> [  243.020815]  [<ffffffff83be2298>] tracesys+0xe1/0xe6
> [  243.021607] 1 lock held by init/1:
> [  243.022079]  #0:  (&tty->ldisc_mutex){+.+...}, at: [<ffffffff81bb8312>] tty_ldisc_hangup+0x122/0x320
> 
> All of this on latest -next, inside a KVM tools guest.
> 
> Help appreciated.

Hi, for me this looks like a false positive. The TTY layer just waits
for the process sitting on the TTY to vanish. Maybe we should touch the
watchdogs?

thanks,
-- 
js
suse labs
