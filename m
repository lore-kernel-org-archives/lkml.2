Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679Ab2EPUAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:00:32 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:48244 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965561Ab2EPUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:00:27 -0400
From: Roland Dreier <roland@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: lockdep false positive in double_lock_balance()?
Date: Wed, 16 May 2012 13:00:20 -0700
Message-Id: <1337198420-5062-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
References: <1335314100-532-1-git-send-email-roland@kernel.org> <alpine.LSU.2.00.1204251411460.4188@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi scheduler hackers,

I'm very occasionally seeing the lockdep warning below on our boxes
running 2.6.39 (PREEMPT=n, so "unfair" _double_lock_balance()).  I
think I see the explanation, and it's probably not even worth fixing:

On the unlock side, we have:

	static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
		__releases(busiest->lock)
	{
		raw_spin_unlock(&busiest->lock);
		lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
	}

while on the lock side we have:

	static int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
		__releases(this_rq->lock)
		__acquires(busiest->lock)
		__acquires(this_rq->lock)
	{
		int ret = 0;

		if (unlikely(!raw_spin_trylock(&busiest->lock))) {
			if (busiest < this_rq) {
				raw_spin_unlock(&this_rq->lock);
				raw_spin_lock(&busiest->lock);
				raw_spin_lock_nested(&this_rq->lock,
						      SINGLE_DEPTH_NESTING);
				ret = 1;
			} else
				raw_spin_lock_nested(&busiest->lock,
						      SINGLE_DEPTH_NESTING);
		}
		return ret;
	}

So it seems we have the following (purely lockdep-related) race:

    unlock:				lock:

					if (unlikely(!raw_spin_trylock(&busiest->lock))) { //fail to lock

    raw_spin_unlock(&busiest->lock);

						if (busiest < this_rq) { //not true
						} else
							raw_spin_lock_nested(&busiest->lock,
									      SINGLE_DEPTH_NESTING);

    lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_); //too late

where we end up trying to take a second lock with SINGLE_DEPTH_NESTING
before we've promoted our first lock to subclass 0.

I'm not sure this is easily fixable (if we flipped the
lock_set_subclass() to before the raw_spin_unlock(), would we
introduce other lockdep problems?).  Mostly I want to make sure
my diagnosis is correct and there's not some actual deadlock
that could happen.

So does this make sense?

Thanks,
  Roland

Here's the actual lockdep warning:

[89945.638847] =============================================
[89945.638974] [ INFO: possible recursive locking detected ]
[89945.639033] 2.6.39.3-dbg+ #13245
[89945.639079] ---------------------------------------------
[89945.639131] foed/7820 is trying to acquire lock:
[89945.639180]  (&rq->lock/1){..-.-.}, at: [<ffffffff8103fa1a>] double_lock_balance+0x5a/0x90
[89945.639291] 
[89945.639292] but task is already holding lock:
[89945.639374]  (&rq->lock/1){..-.-.}, at: [<ffffffff8103fa3b>] double_lock_balance+0x7b/0x90
[89945.639480] 
[89945.639481] other info that might help us debug this:
[89945.639566] 2 locks held by foed/7820:
[89945.639611]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8156a445>] do_page_fault+0x1f5/0x560
[89945.639717]  #1:  (&rq->lock/1){..-.-.}, at: [<ffffffff8103fa3b>] double_lock_balance+0x7b/0x90
[89945.639829] 
[89945.639830] stack backtrace:
[89945.639908] Pid: 7820, comm: foed Tainted: G        W   2.6.39.3-dbg+ #13245
[89945.639965] Call Trace:
[89945.640011]  [<ffffffff8109293f>] __lock_acquire+0x153f/0x1da0
[89945.640069]  [<ffffffff81009235>] ? native_sched_clock+0x15/0x70
[89945.640126]  [<ffffffff810812ef>] ? local_clock+0x6f/0x80
[89945.640179]  [<ffffffff8103fa3b>] ? double_lock_balance+0x7b/0x90
[89945.640235]  [<ffffffff8109384d>] lock_acquire+0x9d/0x130
[89945.640288]  [<ffffffff8103fa1a>] ? double_lock_balance+0x5a/0x90
[89945.640345]  [<ffffffff810fe47f>] ? cpupri_find+0xcf/0x140
[89945.640401]  [<ffffffff81565ce4>] _raw_spin_lock_nested+0x34/0x70
[89945.640456]  [<ffffffff8103fa1a>] ? double_lock_balance+0x5a/0x90
[89945.640512]  [<ffffffff8103fa1a>] double_lock_balance+0x5a/0x90
[89945.640568]  [<ffffffff8104c546>] push_rt_task+0xc6/0x290
[89945.640621]  [<ffffffff8104c7c0>] push_rt_tasks+0x20/0x30
[89945.640674]  [<ffffffff8104c83e>] post_schedule_rt+0xe/0x10
[89945.640729]  [<ffffffff81562d8c>] schedule+0x53c/0xa70
[89945.640781]  [<ffffffff810941c8>] ? mark_held_locks+0x78/0xb0
[89945.640781]  [<ffffffff810941c8>] ? mark_held_locks+0x78/0xb0
[89945.640836]  [<ffffffff81565b15>] rwsem_down_failed_common+0xb5/0x150
[89945.640893]  [<ffffffff8108122d>] ? sched_clock_cpu+0xbd/0x110
[89945.640949]  [<ffffffff8108e33d>] ? trace_hardirqs_off+0xd/0x10
[89945.641004]  [<ffffffff81565be5>] rwsem_down_read_failed+0x15/0x17
[89945.641061]  [<ffffffff812c0a54>] call_rwsem_down_read_failed+0x14/0x30
[89945.641120]  [<ffffffff81139565>] ? sys_mprotect+0xe5/0x230
[89945.641174]  [<ffffffff81564f1e>] ? down_read+0x7e/0xa0
[89945.641227]  [<ffffffff8156a445>] ? do_page_fault+0x1f5/0x560
[89945.641281]  [<ffffffff8156a445>] do_page_fault+0x1f5/0x560
[89945.641336]  [<ffffffff812bb5fc>] ? rwsem_wake+0x4c/0x60
[89945.641388]  [<ffffffff812c0aa7>] ? call_rwsem_wake+0x17/0x30
[89945.641443]  [<ffffffff812c0b5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[89945.641501]  [<ffffffff81566d25>] page_fault+0x25/0x30
