Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0CRFtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 01:49:41 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61661 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0CRFtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 01:49:40 -0400
Message-ID: <4BA1BEF2.4050706@dcl.info.waseda.ac.jp>
Date: Thu, 18 Mar 2010 14:49:38 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <4BA0852D.1090300@dcl.info.waseda.ac.jp> <20100317153858.GA5059@nowhere>
In-Reply-To: <20100317153858.GA5059@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 00:39, Frederic Weisbecker wrote:
 > On Wed, Mar 17, 2010 at 04:30:53PM +0900, Hitoshi Mitake wrote:
 >> On 03/17/10 10:32, Frederic Weisbecker wrote:
 >>> On Sun, Mar 14, 2010 at 07:13:55PM +0100, Peter Zijlstra wrote:
 >>>> On Sun, 2010-03-14 at 19:38 +0900, Hitoshi Mitake wrote:
 >>>>> Current lockdep is too complicated because,
 >>>>>    * dependency validation
 >>>>>    * statistics
 >>>>>    * event tracing
 >>>>> are all implemented by it.
 >>>>> This cause problem of overhead.
 >>>>> If user enables one of them, overhead of rests part is not avoidable.
 >>>>> (tracing is exception. If user enables validation or stat,
 >>>>> overhead of tracing doesn't occur.)
 >>>>>
 >>>>> So I suggest new subsystem "lock monitor".
 >>>>> This is a general purpose lock event hooking mechanism.
 >>>>>
 >>>>> lock monitor will be enable easy implementing and running
 >>>>> these features related to lock.
 >>>>>
 >>>>> And I'm hoping that lock monitor will reduce overhead of perf lock.
 >>>>> Because lock monitor separates dependency validation and event
 >> tracing clearly,
 >>>>> so calling of functions of lockdep (e.g. lock_acquire()) only for
 >> validation
 >>>>> will not occur lock events.
 >>>>>
 >>>>> I implemented it on the branch perf/inject of Frederic's
 >> random-tracing tree.
 >>>>> Because the branch is hottest place of lock and tracing :)
 >>>>
 >>>> OK, so I really don't like this much..
 >>>>
 >>>> Building a lockstat kernel (PROVE_LOCKING=n) should not have much more
 >>>> overhead than the proposed solution, if the simple lock acquistion
 >>>> tracking bothers you, you can do a patch to weaken that.
 >>>>
 >>>> I really really dislike how you add a monitor variable between
 >>>> everything for no reason what so ever.
 >>>>
 >>>> You use a new rwlock_t, which is an instant fail, those things are 
worse
 >>>> than useless.
 >>>>
 >>>> You add chained indirect calls into all lock ops, that's got to hurt.
 >>>
 >>>
 >>> Well, the idea was not bad at the first glance. It was separating
 >>> lockdep and lock events codes.
 >>>
 >>> But indeed, the indirect calls plus the locking are not good
 >>> for such a fast path.
 >>>
 >>> There is something else, it would be nice to keep the
 >>> lockdep_map ->   lockdep_class mapping so that we can
 >>> do lock profiling based on classes too. So we actually
 >>> need the lockdep code. What we don't need is the prove
 >>> locking or the lock stats. So I guess we can have a new
 >>> config to enable lock events and get rid of the prove
 >>> locking / lock stat code if we don't need it.
 >>>
 >>>
 >>
 >> Thanks for your comments, Peter and Frederic.
 >>
 >> My main motivation of writing this patch series was that
 >> some kernel codes uses lockdep functions (e.g. lock_acquire()) directly,
 >> so perf lock gets a lot of trace events without actual locks (e.g.
 >> might_lock_read()).
 >> I think that these are confusable things for users.
 >>
 >> But I noticed that these events can be reduced by
 >> turning off CONFIG_PROVE_LOCKING. Yeah, my patch series was 
pointless... :)
 >>
 >> Should perf lock warn not to use with CONFIG_PROVE_LOCKING?
 >
 >
 > Ah I see.
 >
 > might_lock_read() uses might_fault(), rcu, workqueues and probably
 > yet some others use sequences of lock_acquire/lock_release to prove
 > locking while there is actually no real lock operation involved, but
 > this is to detect dependency/balance mistakes.
 >
 > I think that these cases are easily detectable in that they never have
 > any lock_acquired in their scenario. So may be we can just ignore
 > scenarios without lock_acquired and indeed advise users not to use
 > PROVE_LOCKING.

Unfortunately, we cannot use this detection method.
Because trylock series (e.g. spin_trylock()) only issues
lock_acquire() like this,

static inline int __raw_spin_trylock(raw_spinlock_t *lock)
{
	preempt_disable();
	if (do_raw_spin_trylock(lock)) {
		spin_acquire(&lock->monitor, 0, 1, _RET_IP_); <- spin_acquire() only 
issues lock_acquire()
		return 1;
	}
	preempt_enable();
	return 0;
}

So distinguishing trylocks and lock_acquire()/lock_release() pairs from
might_lock_read(), might_fault() and etc is hard.

It seems that turning off PROVE_LOCKING must be required
for state machine of perf lock.
