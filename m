Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2JZAo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:44:59 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:39246 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2JZAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:44:52 -0400
Message-ID: <5089DCA2.2040200@oracle.com>
Date: Thu, 25 Oct 2012 20:43:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ipc, msgqueue: NULL ptr deref in msgrcv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools (lkvm) guest running latest -next,
I've stumbled on the follwing:

[   80.110944] NULL pointer dereference at 0000000000000011
[   80.110944] IP: [<ffffffff8190cf90>] testmsg.isra.5+0x40/0x70
[   80.110944] PGD 23812067 PUD 23811067 PMD 0
[   80.110944] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   80.110944] Dumping ftrace buffer:
[   80.110944]    (ftrace buffer empty)
[   80.110944] CPU 1
[   80.110944] Pid: 6452, comm: trinity-child84 Tainted: G        W    3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #77
[   80.110944] RIP: 0010:[<ffffffff8190cf90>]  [<ffffffff8190cf90>] testmsg.isra.5+0x40/0x70
[   80.110944] RSP: 0018:ffff88004dda9e78  EFLAGS: 00010246
[   80.110944] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 000000000000000f
[   80.110944] RDX: 0000000000000002 RSI: 00000000282c796a RDI: 0000000000000011
[   80.110944] RBP: ffff88004dda9e78 R08: 0000000000000000 R09: 0000000000000000
[   80.110944] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000282c796a
[   80.110944] R13: ffff8800621ab7c0 R14: 0000000000000001 R15: ffff8800621ab710
[   80.110944] FS:  00007f777fd4d700(0000) GS:ffff880027800000(0000) knlGS:0000000000000000
[   80.110944] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.110944] CR2: 0000000000000011 CR3: 0000000024bf9000 CR4: 00000000000406e0
[   80.110944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   80.110944] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   80.110944] Process trinity-child84 (pid: 6452, threadinfo ffff88004dda8000, task ffff88004dd9b000)
[   80.110944] Stack:
[   80.110944]  ffff88004dda9f68 ffffffff8190e2ce 00000000001d7840 ffff88004dd9b000
[   80.110944]  ffff88004dd9b000 ffff88004dd9b000 0000000000000000 ffffffff8190cda0
[   80.110944]  0000000000000000 ffffffff854e3160 0000000000000000 0000000000000000
[   80.110944] Call Trace:
[   80.110944]  [<ffffffff8190e2ce>] do_msgrcv+0x1ae/0x640
[   80.110944]  [<ffffffff8190cda0>] ? load_msg+0x190/0x190
[   80.110944]  [<ffffffff8107dc30>] ? syscall_trace_enter+0x20/0x2e0
[   80.110944]  [<ffffffff8190e770>] sys_msgrcv+0x10/0x20
[   80.110944]  [<ffffffff83aee198>] tracesys+0xe1/0xe6
[   80.110944] Code: eb 51 66 0f 1f 84 00 00 00 00 00 83 fa 03 74 2b 83 fa 04 75 2e 48 39 37 b8 01 00 00 00 7f 24 eb 32 66 2e 0f
1f 84 00 00 00 00 00 <48> 3b 37 75 13 eb 19 66 0f 1f 84 00 00 00 00 00 48 3b 37 75 0b
[   80.110944] RIP  [<ffffffff8190cf90>] testmsg.isra.5+0x40/0x70
[   80.110944]  RSP <ffff88004dda9e78>
[   80.110944] CR2: 0000000000000011
[   80.246961] ---[ end trace 1d24d488413d3159 ]---

	case SEARCH_EQUAL:
		if (msg->m_type == type) <--- here
			return 1;

My guess is that we managed to get testmsg() called without INIT_LIST_HEAD() somehow,
but I'm still not sure why.


Thanks,
Sasha
