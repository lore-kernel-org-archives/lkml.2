Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1CBKBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:01:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59440 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab1CBKBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:01:23 -0500
Message-ID: <4D6E1556.5060905@cn.fujitsu.com>
Date: Wed, 02 Mar 2011 18:00:54 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6 v5.1] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
References: <4D61FE91.60705@cn.fujitsu.com> <4D6201A3.70301@cn.fujitsu.com> <4D64788F.6040408@cn.fujitsu.com> <20110224181140.GE18494@redhat.com> <4D670C14.9040504@cn.fujitsu.com> <20110227231618.GA1014@redhat.com> <20110228001544.GA2762@redhat.com>
In-Reply-To: <20110228001544.GA2762@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 18:00:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 18:00:13,
	Serialize complete at 2011-03-02 18:00:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sun, Feb 27, 2011 at 06:16:18PM -0500, Vivek Goyal wrote:
>> On Fri, Feb 25, 2011 at 09:55:32AM +0800, Gui Jianfeng wrote:
>>> Vivek Goyal wrote:
>>>> On Wed, Feb 23, 2011 at 11:01:35AM +0800, Gui Jianfeng wrote:
>>>>> Hi
>>>>>
>>>>> I rebase this series on top of *for-next* branch, it will make merging life easier.
>>>>>
>>>>> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
>>>>> in the way that it puts all CFQ queues in a hidden group and schedules with other 
>>>>> CFQ group under their parent. The patchset is available here,
>>>>> http://lkml.org/lkml/2010/8/30/30
>>>> Gui,
>>>>
>>>> I was running some tests (iostest) with these patches and my system crashed
>>>> after a while.
>>>>
>>>> To be precise I was running "brrmmap" test of iostest.
>>> Vivek,
>>>
>>> I simply run iostest with brrmmap mode, I can't reproduce this bug.
>>> Would you give more details.
>>> Can you tell me the iostest command line options?
>> iostest /dev/dm-1 -G --nrgrp 4 -m 8 --cgtime --io_serviced --dequeue --total
>>
>> I was actually trying to run all the workloads defined but after running
>> 2 workloads it crashed on 3rd workload.
>>
>> Now I tried to re-run brrmmap and it did not crash. So I am trying to run
>> all the inbuilt workloads again.
>>
>>> Did you enable use_hierarchy in root group?
>> No I did not. Trying to test the flat setup first.
> 
> Again was running above job and after 3 workloads it ran into a different
> BUG_ON().

Vivek,

It seems there's a race.
Would you try the following patch. This patch seems working for me.

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 380d667..abbbb0e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4126,11 +4126,12 @@ new_queue:
 	cfqq->allocated[rw]++;
 	cfqq->ref++;
 
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	rq->elevator_private[0] = cic;
 	rq->elevator_private[1] = cfqq;
 	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
 	return 0;
 
 queue_fail:

Thanks
Gui



> 
> Thanks
> Vivek
> 
> login: [277063.539001] ------------[ cut here ]------------
> [277063.539001] kernel BUG at block/cfq-iosched.c:1407!
> [277063.539001] invalid opcode: 0000 [#1] SMP 
> [277063.539001] last sysfs file: /sys/devices/virtual/block/dm-1/queue/scheduler
> [277063.539001] CPU 2 
> [277063.539001] Modules linked in: kvm_intel kvm qla2xxx scsi_transport_fc [last unloaded: scsi_wait_scan]
> [277063.539001] 
> [277063.539001] Pid: 24628, comm: iostest Not tainted 2.6.38-rc4+ #3 0A98h/HP xw8600 Workstation
> [277063.539001] RIP: 0010:[<ffffffff8121c6f0>]  [<ffffffff8121c6f0>] cfq_put_cfqg+0x13/0xc8
> [277063.539001] RSP: 0018:ffff880129a81d48  EFLAGS: 00010046
> [277063.539001] RAX: 0000000000000000 RBX: ffff880135e4b800 RCX: ffff88012b9d8ed0
> [277063.539001] RDX: ffff880135e4be30 RSI: ffff880135070c00 RDI: ffff880135070c00
> [277063.539001] RBP: ffff880129a81d58 R08: ffff880135e4bbc8 R09: ffffffff81ad76d0
> [277063.539001] R10: ffff880129a81d48 R11: ffff880129a81d78 R12: ffff880135e4bc18
> [277063.539001] R13: ffff880135e4bbc8 R14: ffff8801359c3020 R15: ffff880135033310
> [277063.539001] FS:  00007f1329ed4700(0000) GS:ffff8800bfc80000(0000) knlGS:0000000000000000
> [277063.539001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [277063.539001] CR2: 0000000000b89c08 CR3: 00000001230a5000 CR4: 00000000000006e0
> [277063.539001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [277063.539001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [277063.539001] Process iostest (pid: 24628, threadinfo ffff880129a80000, task ffff880131394a60)
> [277063.539001] Stack:
> [277063.539001]  ffff880135e4b800 ffff880135e4b800 ffff880129a81d68 ffffffff8121d0a0
> [277063.539001]  ffff880129a81db8 ffffffff8121d6b6 ffff880133af1850 ffff880135070c00
> [277063.539001]  ffff880129a81db8 ffff88012c908900 ffff88012c908958 ffff880133af1840
> [277063.539001] Call Trace:
> [277063.539001]  [<ffffffff8121d0a0>] cfq_destroy_cfqg+0x45/0x47
> [277063.539001]  [<ffffffff8121d6b6>] cfq_exit_queue+0xcc/0x164
> [277063.539001]  [<ffffffff81209f19>] elevator_exit+0x2a/0x47
> [277063.539001]  [<ffffffff8120a8cc>] elevator_change+0x12f/0x1b7
> [277063.539001]  [<ffffffff8120a976>] elv_iosched_store+0x22/0x4c
> [277063.539001]  [<ffffffff812111f2>] queue_attr_store+0x6a/0x89
> [277063.539001]  [<ffffffff8113e093>] sysfs_write_file+0xfc/0x138
> [277063.539001]  [<ffffffff810e9fd4>] vfs_write+0xa9/0x105
> [277063.539001]  [<ffffffff810ea0e9>] sys_write+0x45/0x6c
> [277063.539001]  [<ffffffff8100293b>] system_call_fastpath+0x16/0x1b
> [277063.539001] Code: 75 09 48 85 db 0f 85 77 ff ff ff 41 5c 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 53 48 83 ec 08 8b 87 20 03 00 00 85 c0 7f 04 <0f> 0b eb fe ff c8 85 c0 89 87 20 03 00 00 0f 85 9d 00 00 00 4c 
> [277063.539001] RIP  [<ffffffff8121c6f0>] cfq_put_cfqg+0x13/0xc8
> [277063.539001]  RSP <ffff880129a81d48>
> [277063.539001] ---[ end trace d7596ee55221d6a7 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
