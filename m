Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2IYItP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:49:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33315 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2IYItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:49:12 -0400
Message-ID: <50617008.5000207@oracle.com>
Date: Tue, 25 Sep 2012 10:49:12 +0200
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: tty ldisc lockups in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity in a KVM tools guest running linux-next kernel, I keep hitting the following lockup:

[  842.780242] INFO: task init:1 blocked for more than 120 seconds.
[  842.780732] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  842.781559] init            D ffff88000d5b0000  3344     1      0 0x00000002
[  842.783226]  ffff88000d5adc28 0000000000000082 ffff88000d5adbe8 ffffffff81150ac5
[  842.784714]  ffff88000d5adfd8 ffff88000d5adfd8 ffff88000d5adfd8 ffff88000d5adfd8
[  842.785737]  ffffffff84e2e420 ffff88000d5b0000 ffff88000d5b08f0 7fffffffffffffff
[  842.786764] Call Trace:
[  842.787102]  [<ffffffff81150ac5>] ? sched_clock_local+0x25/0xa0
[  842.787858]  [<ffffffff83a0be45>] schedule+0x55/0x60
[  842.788511]  [<ffffffff83a09dd5>] schedule_timeout+0x45/0x360
[  842.789251]  [<ffffffff83a0d54d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  842.790149]  [<ffffffff8117b13d>] ? trace_hardirqs_on+0xd/0x10
[  842.790594]  [<ffffffff83a0d574>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  842.791096]  [<ffffffff81137af7>] ? prepare_to_wait+0x77/0x90
[  842.791535]  [<ffffffff81b9b2c6>] tty_ldisc_wait_idle.isra.7+0x76/0xb0
[  842.792016]  [<ffffffff81137cd0>] ? abort_exclusive_wait+0xb0/0xb0
[  842.792490]  [<ffffffff81b9c03b>] tty_ldisc_hangup+0x1cb/0x320
[  842.792924]  [<ffffffff81b933a2>] ? __tty_hangup+0x122/0x430
[  842.793364]  [<ffffffff81b933aa>] __tty_hangup+0x12a/0x430
[  842.794077]  [<ffffffff83a0d574>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  842.794942]  [<ffffffff81b955cc>] disassociate_ctty+0x6c/0x230
[  842.795693]  [<ffffffff8110e7e8>] do_exit+0x3d8/0xa90
[  842.796361]  [<ffffffff83a0e4d9>] ? retint_swapgs+0x13/0x1b
[  842.797079]  [<ffffffff8110ef64>] do_group_exit+0x84/0xd0
[  842.797818]  [<ffffffff8110efc2>] sys_exit_group+0x12/0x20
[  842.798524]  [<ffffffff83a0edcd>] system_call_fastpath+0x1a/0x1f
[  842.799294] 1 lock held by init/1:
[  842.799734]  #0:  (&tty->ldisc_mutex){+.+.+.}, at: [<ffffffff81b9bf92>] tty_ldisc_hangup+0x122/0x320


Thanks,
Sasha
