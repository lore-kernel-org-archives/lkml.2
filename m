Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab0CRUaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:30:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50186 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0CRUau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EgBzHazoTADO59iCqjMoNx22+gjcwIkDY6C/DKkLJpV4MGeRXNEKFWYZGks9HNidGH
         EDq9r1H+Yj7rj23zshgmLmyNv6VVCfifc5Gj+6cD2kvbt1XvZ8fR58oY2cxsFOi3B22F
         x4Bz3/hfffC6XMfrRlf7QrzBHpcZVwo1YMPog=
Date: Thu, 18 Mar 2010 21:30:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100318203047.GF5103@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <4BA0852D.1090300@dcl.info.waseda.ac.jp> <20100317153858.GA5059@nowhere> <4BA1BEF2.4050706@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1BEF2.4050706@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:49:38PM +0900, Hitoshi Mitake wrote:
> Unfortunately, we cannot use this detection method.
> Because trylock series (e.g. spin_trylock()) only issues
> lock_acquire() like this,
>
> static inline int __raw_spin_trylock(raw_spinlock_t *lock)
> {
> 	preempt_disable();
> 	if (do_raw_spin_trylock(lock)) {
> 		spin_acquire(&lock->monitor, 0, 1, _RET_IP_); <- spin_acquire() only  
> issues lock_acquire()
> 		return 1;
> 	}
> 	preempt_enable();
> 	return 0;
> }
>
> So distinguishing trylocks and lock_acquire()/lock_release() pairs from
> might_lock_read(), might_fault() and etc is hard.
>
> It seems that turning off PROVE_LOCKING must be required
> for state machine of perf lock.


No that's really not a problem. trylocks are pointless in latency
profiling because by definition they don't content. OTOH, they
grab the lock and other locks might wait and raise latencies. So
they are part of the profile. But we don't care about having the
usual acquire/aquired/release sequence as we have the flags that
tell us if this is a trylock.

So we just need to consider that acquire:try_lock - release is
a right lock scenario, but that acquire - release is only a lockdep
check.

Hm?

