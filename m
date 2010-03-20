Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0CTFvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 01:51:05 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51843 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0CTFvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 01:51:01 -0400
Message-ID: <4BA4624F.4030208@dcl.info.waseda.ac.jp>
Date: Sat, 20 Mar 2010 14:51:11 +0900
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
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <4BA0852D.1090300@dcl.info.waseda.ac.jp> <20100317153858.GA5059@nowhere> <4BA1BEF2.4050706@dcl.info.waseda.ac.jp> <20100318203047.GF5103@nowhere>
In-Reply-To: <20100318203047.GF5103@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/10 05:30, Frederic Weisbecker wrote:
> On Thu, Mar 18, 2010 at 02:49:38PM +0900, Hitoshi Mitake wrote:
>> Unfortunately, we cannot use this detection method.
>> Because trylock series (e.g. spin_trylock()) only issues
>> lock_acquire() like this,
>>
>> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
>> {
>> 	preempt_disable();
>> 	if (do_raw_spin_trylock(lock)) {
>> 		spin_acquire(&lock->monitor, 0, 1, _RET_IP_);<- spin_acquire() only
>> issues lock_acquire()
>> 		return 1;
>> 	}
>> 	preempt_enable();
>> 	return 0;
>> }
>>
>> So distinguishing trylocks and lock_acquire()/lock_release() pairs from
>> might_lock_read(), might_fault() and etc is hard.
>>
>> It seems that turning off PROVE_LOCKING must be required
>> for state machine of perf lock.
>
>
> No that's really not a problem. trylocks are pointless in latency
> profiling because by definition they don't content. OTOH, they
> grab the lock and other locks might wait and raise latencies. So
> they are part of the profile. But we don't care about having the
> usual acquire/aquired/release sequence as we have the flags that
> tell us if this is a trylock.
>
> So we just need to consider that acquire:try_lock - release is
> a right lock scenario, but that acquire - release is only a lockdep
> check.

Ah, I see. The argument flags of lock_acquire event can be used for
distinguishing try or read lock and pure verifying.

Thanks,
	Hitoshi
