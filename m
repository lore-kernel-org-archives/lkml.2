Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab0EEH30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:29:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:38905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab0EEH3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:29:25 -0400
Message-ID: <4BE11E29.6040106@kernel.org>
Date: Wed, 05 May 2010 09:28:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
References: <1272980864-27235-1-git-send-email-tj@kernel.org> <1272980864-27235-4-git-send-email-tj@kernel.org> <20100505013351.GN2639@linux.vnet.ibm.com>
In-Reply-To: <20100505013351.GN2639@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 07:28:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 03:33 AM, Paul E. McKenney wrote:
> o	Therefore, when CPU 0 queues the work for CPU 1, CPU 1
> 	loops right around and processes it.  There will be no
> 	context switch on CPU 1.

Yes, that can happen.

> 	At first glance, this looks safe because:
> 
> 	1.	Although there is no context switch, there (presumably)
> 		can be no RCU read-side critical sections on CPU 1 that
> 		span this sequence of events.  (As far as I can see,
> 		any such RCU read-side critical section would be due
> 		to abuse of rcu_read_lock() and friends.)

AFAICS, this must hold; otherwise, synchronize_sched_expedited()
wouldn't have worked in the first place.  On entry to any cpu_stop
function, there can be no RCU read-side critical section in progress.

> 	2.	CPU 1 will acquire and release stopper->lock, and
> 		further more will do an atomic_dec_and_test() in
> 		cpu_stop_signal_done().  The former is a weak
> 		guarantee, but the latter guarantees a memory
> 		barrier, so that any subsequent code on CPU 1 will
> 		be guaranteed to see changes on CPU 0 prior to the
> 		call to synchronize_sched_expedited().
> 
> 		The guarantee required is that there will be a
> 		full memory barrier on each affected CPU between
> 		the time that try_stop_cpus() is called and the
> 		time that it returns.

Ah, right.  I think it would be dangerous to depend on the implicit
barriers there.  It might work today but it can easily break with
later implementation detail changes which seem completely unrelated.
Adding smp_mb() in the cpu_stop function should suffice, right?  It's
not like the cost of smp_mb() there would mean anything anyway.

Thank you.

-- 
tejun
