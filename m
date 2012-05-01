Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2EAMEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:04:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2EAMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:04:51 -0400
Message-ID: <1335873936.16988.148.camel@lappy>
Subject: WARNING: at include/linux/iocontext.h:140 copy_io+0xb9/0x130()
From: Sasha Levin <levinsasha928@gmail.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 01 May 2012 14:05:36 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've stumbled on the warning at the bottom with today's linux-next within a KVM guest doing syscall fuzzing using trinity.

I haven't encountered this warning before, and it looks like it's not easy to reproduce it within the guest. Looking at the code in that area I guess it's some sorts of a rare race condition.

The only recent commits in that area are the work done on blk cgroup. It is enabled in the test kernel.

[  418.101833] WARNING: at include/linux/iocontext.h:140 copy_io+0xb9/0x130()
[  418.108177] Pid: 29267, comm: trinity Tainted: G        W    3.4.0-rc5-next-20120501-sasha #104
[  418.108180] Call Trace:
[  418.108186]  [<ffffffff810b6c67>] warn_slowpath_common+0x87/0xb0
[  418.108189]  [<ffffffff810b6ca5>] warn_slowpath_null+0x15/0x20
[  418.108192]  [<ffffffff810b44d9>] copy_io+0xb9/0x130
[  418.108196]  [<ffffffff810b5ae4>] copy_process+0x884/0xf90
[  418.108200]  [<ffffffff810f17c5>] ? sched_clock_local+0x25/0x90
[  418.108203]  [<ffffffff810b65b7>] do_fork+0x137/0x240
[  418.108208]  [<ffffffff810e808e>] ? sub_preempt_count+0xae/0xf0
[  418.108212]  [<ffffffff82d92cf9>] ? _raw_spin_unlock_irq+0x59/0x80
[  418.108216]  [<ffffffff82d93be5>] ? sysret_check+0x22/0x5d
[  418.108219]  [<ffffffff81057b13>] sys_clone+0x23/0x30
[  418.108222]  [<ffffffff82d93f43>] stub_clone+0x13/0x20
[  418.108225]  [<ffffffff82d93bb9>] ? system_call_fastpath+0x16/0x1b
[  418.108228] ---[ end trace 8f6ca168297608bb ]---

