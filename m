Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1CYMne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:43:34 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:48546 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1CYMnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:43:32 -0400
X-ASG-Debug-ID: 1301057010-03d6a55ed0007d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8C8DEF.80901@fusionio.com>
Date: Fri, 25 Mar 2011 13:43:27 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <20110325044128.GJ26611@dastard> <91CCAB14-F9CC-4676-94C3-FBCDD0663FD5@mit.edu> <4D8C872C.1030805@fusionio.com> <20110325123350.GE2548@thunk.org>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110325123350.GE2548@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301057010
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58925
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-25 13:33, Ted Ts'o wrote:
> On Fri, Mar 25, 2011 at 01:14:36PM +0100, Jens Axboe wrote:
>> But this plugging change is merged, so it is a very likely candidate.
>> With the oddness going on, I suspect that we end up flushing a plug that
>> resides on a stack that is no longer valid.
> 
> Ah, sorry, I was typing this while I was still doing my morning e-mail
> reading/deleting in bed, so I couldn't check to see if it had been
> merged already.
> 
> I'm downstairs now, and you could very well be right, since here's the
> the stack trace from the kvm console output, and it features
> flush_plug_list very prominently in the stack trace (see attached).
> 
>> So I'd really like to have something ala:
>>
>>         if (is_str_ptr_valid(current, ptr, size))
>>                 ...
>>
>> to aid the debugging.
> 
> Well, I can repro the problem in an hour or two of running xfstests
> under KVM, so I'm happy to try any debugging patches.  Let me know
> where you'd like that placed, and I'll do a run.

Tests are running here locally too, so far not much luck. Can you give
the patch at the end of this email a whirl?

>       	    	      	      	       	    - Ted
> 
> P.S.  Hmm, and I this one does have ext4 in the stack trace.  My bad;
> I misremembered.  The other one didn't, though.  (Oh, and this one
> died in test #130, but if it's related to some kind of plug/unplug
> race, it's probably quite random when it happens.)
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000c
> IP: [<c036429a>] cfq_insert_request+0x39/0x4a2
> *pdpt = 00000000017f0001 *pde = 0000000000000000 
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: 
> Modules linked in:
> 
> Pid: 15723, comm: xfs_io Not tainted 2.6.38-08184-g108052f #1489 Bochs Bochs
> EIP: 0060:[<c036429a>] EFLAGS: 00010046 CPU: 0
> EIP is at cfq_insert_request+0x39/0x4a2
> EAX: 00000000 EBX: 00000000 ECX: c096e710 EDX: cb599870
> ESI: f596c000 EDI: cb599870 EBP: f6db3bfc ESP: f6db3bd0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process xfs_io (pid: 15723, ti=f6db2000 task=c5f6e7c0 task.ti=f6db2000)
> Stack:
>  f6db3c04 00000046 00000028 f6db3c14 00000046 00000000 c03573c8 c03573c8
>  cb599870 f5839d60 f6db3e84 f6db3c14 c0354613 00000006 02a00091 f5839d60
>  f6db3e84 f6db3c24 c03546a9 cb599870 f5839d60 f6db3c40 c03573dd f6db3e88
> Call Trace:
>  [<c03573c8>] ? flush_plug_list+0xa5/0x114
>  [<c03573c8>] ? flush_plug_list+0xa5/0x114
>  [<c0354613>] elv_insert+0x173/0x1a6
>  [<c03546a9>] __elv_add_request+0x63/0x67
>  [<c03573dd>] flush_plug_list+0xba/0x114
>  [<c035744c>] __blk_flush_plug+0x15/0x31
>  [<c0686899>] schedule+0x25b/0x6d9
>  [<c017c71d>] ? sched_clock_cpu+0x134/0x144
>  [<c03594f4>] ? __make_request+0x1fa/0x231
>  [<c06871ab>] schedule_timeout+0x1b/0x9b
>  [<c01876df>] ? mark_lock+0x1e/0x1df
>  [<c01878e3>] ? mark_held_locks+0x43/0x5b
>  [<c0688d3a>] ? _raw_spin_unlock_irq+0x27/0x30
>  [<c0187b3f>] ? trace_hardirqs_on_caller+0x104/0x125
>  [<c0187b6b>] ? trace_hardirqs_on+0xb/0xd
>  [<c0687042>] wait_for_common+0xc6/0x11f
>  [<c015d4d4>] ? default_wake_function+0x0/0x12
>  [<c068713a>] wait_for_completion+0x17/0x19
>  [<c035a837>] blkdev_issue_flush+0x96/0xcf
>  [<c0686fb2>] ? wait_for_common+0x36/0x11f
>  [<c025c06d>] ext4_sync_file+0x205/0x250
>  [<c021a04b>] vfs_fsync_range+0x46/0x68
>  [<c021a0c2>] generic_write_sync+0x55/0x64
>  [<c01cfd78>] generic_file_aio_write+0x99/0xb8
>  [<c025bd7c>] ext4_file_write+0x1df/0x22f
>  [<c01fbbd0>] do_sync_write+0x8f/0xca
>  [<c033622f>] ? security_file_permission+0x27/0x2b
>  [<c01fbd9f>] ? rw_verify_area+0xca/0xed
>  [<c01fbb41>] ? do_sync_write+0x0/0xca
>  [<c01fc51c>] vfs_write+0x85/0xe3
>  [<c0688ef6>] ? restore_all_notrace+0x0/0x18
>  [<c01fc5c2>] sys_pwrite64+0x48/0x61
>  [<c0688ebd>] syscall_call+0x7/0xb
> Code: 8b 40 0c 8b 5a 5c 89 d7 8b 70 04 8b 06 8b 80 74 04 00 00 85 c0 74 11 ff 73 74 68 33 0a 87 c0 50 e8 ce a7 e5 ff 83 c4 0c 8b 47 58 <8b> 50 0c 89 d8 e8 68 f0 ff ff 8b 57 20 a1 40 6a 92 c0 83 e2 11 
> EIP: [<c036429a>] cfq_insert_request+0x39/0x4a2 SS:ESP 0068:f6db3bd0
> CR2: 000000000000000c
> ---[ end trace da176424940e586f ]---

This looks somewhat similar to what Markus is reporting, essentially the
badness is coming out of the flush-on-schedule. Whether that is what
triggers this bug or if it's just a normal place to flush the plug, hard
to say. For this particular case it looks quite normal -
wait_for_completion() will block, so we flush it out.


diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..8906ff1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1197,6 +1197,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 	if (!plug)
 		goto out;
 
+	preempt_disable();
 	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
 		int el_ret;
 
@@ -1214,6 +1215,7 @@ static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
 				break;
 		}
 	}
+	preempt_enable();
 out:
 	return ret;
 }

-- 
Jens Axboe

