Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab2HXRsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:48:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57661 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2HXRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:48:03 -0400
Message-ID: <5037BE4C.80609@acm.org>
Date: Fri, 24 Aug 2012 17:47:56 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel hangs in truncate_inode_pages()
References: <50377DDD.7060404@acm.org> <5037B8C1.8050903@cs.wisc.edu>
In-Reply-To: <5037B8C1.8050903@cs.wisc.edu>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/12 17:24, Mike Christie wrote:
> On 08/24/2012 08:13 AM, Bart Van Assche wrote:
>> If I log in with the open-iscsi initiator to an iSCSI target an power
>> down the target the initiator hangs in truncate_inode_pages(). This
>> happens systematically with kernel 3.6-rc3 and it's something I've
>> never seen with kernel 3.4 or before. Has anyone else already run into
>> this issue ?
> 
> I have not seen this issue before and have not seen it reported.
> 
> Are you doing IO the disk at the time of power down, or are you doing a
> iscsiadm -m node ... --logout command?

There was no I/O load test running at the time of the target power down.
The call stack I posted is what I see before logout. And this is what I
get after iscsi logout:

BUG: soft lockup - CPU#3 stuck for 23s! [iscsid:8589]
Modules linked in: ... [last unloaded: crc32c]
irq event stamp: 918076162
hardirqs last  enabled at (918076161): [<ffffffff8140d98f>] _raw_spin_unlock_irqrestore+0x3f/0x70
hardirqs last disabled at (918076162): [<ffffffff814167d7>] apic_timer_interrupt+0x67/0x80
softirqs last  enabled at (917955754): [<ffffffff81044162>] __do_softirq+0x142/0x2a0
softirqs last disabled at (917955749): [<ffffffff81416f5c>] call_softirq+0x1c/0x30
CPU 3 
Pid: 8589, comm: iscsid Not tainted 3.6.0-rc3+ #1 Gigabyte Technology Co., Ltd. Z68X-UD3H-B3/Z68X-UD3H-B3
RIP: 0010:[<ffffffff8140d991>]  [<ffffffff8140d991>] _raw_spin_unlock_irqrestore+0x41/0x70
RSP: 0018:ffff8800ae7e5928  EFLAGS: 00000286
RAX: ffff880106002eb0 RBX: ffffffff810956a2 RCX: 0000000000000006
RDX: 0000000000000040 RSI: ffff880106003498 RDI: ffff880106002eb0
RBP: ffff8800ae7e5938 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000006
R13: 0000000000000007 R14: ffff880106002eb0 R15: ffff880106003498
FS:  00007fa8cfc22700(0000) GS:ffff88012fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fa8cf26617c CR3: 00000000bc87c000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process iscsid (pid: 8589, threadinfo ffff8800ae7e4000, task ffff880106002eb0)
Stack:
ffff88011af0c000 ffff88001ea0fff0 ffff8800ae7e5988 ffffffffa00aaafc
0000000000000286 ffff88001ea10000 ffff8800ae7e5968 ffff88008ae44a28
ffff88008ae44800 ffff88008ae44818 0000000000000000 0000000000000001
Call Trace:
[<ffffffffa00aaafc>] scsi_remove_target+0x1bc/0x1f0 [scsi_mod]
[<ffffffffa06af6c6>] __iscsi_unbind_session+0xc6/0x1a0 [scsi_transport_iscsi]
[<ffffffffa06af8a5>] iscsi_remove_session+0x105/0x1e0 [scsi_transport_iscsi]
[<ffffffffa06af996>] iscsi_destroy_session+0x16/0x60 [scsi_transport_iscsi]
[<ffffffffa07bc549>] iscsi_session_teardown+0xa9/0xd0 [libiscsi]
[<ffffffffa07c91a0>] iscsi_sw_tcp_session_destroy+0x50/0x70 [iscsi_tcp]
[<ffffffffa06aeef8>] iscsi_if_rx+0xab8/0xf60 [scsi_transport_iscsi]
[<ffffffff81350cad>] netlink_unicast+0x1ad/0x230
[<ffffffff8135102b>] netlink_sendmsg+0x2fb/0x350
[<ffffffff8131c458>] ? sock_update_classid+0xc8/0x140
[<ffffffff813162d2>] sock_sendmsg+0xa2/0xe0
[<ffffffff8111c9ac>] ? might_fault+0x9c/0xb0
[<ffffffff8111c963>] ? might_fault+0x53/0xb0
[<ffffffff81325356>] ? verify_iovec+0x56/0xd0
[<ffffffff81317ac2>] __sys_sendmsg+0x382/0x390
[<ffffffff8111c9ac>] ? might_fault+0x9c/0xb0
[<ffffffff8111c963>] ? might_fault+0x53/0xb0
[<ffffffff81069c63>] ? lg_local_unlock+0x23/0x50
[<ffffffff811501f6>] ? cp_new_stat+0x116/0x130
[<ffffffff813198f9>] sys_sendmsg+0x49/0x90
[<ffffffff81415d52>] system_call_fastpath+0x16/0x1b

Bart.
