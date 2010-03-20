Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0CTIXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 04:23:44 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53039 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0CTIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 04:23:42 -0400
Message-ID: <4BA4860C.3050001@dcl.info.waseda.ac.jp>
Date: Sat, 20 Mar 2010 17:23:40 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <4BA4638C.40307@dcl.info.waseda.ac.jp>
In-Reply-To: <4BA4638C.40307@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/10 14:56, Hitoshi Mitake wrote:
 > On 03/19/10 06:16, Frederic Weisbecker wrote:
 >  >> And I have a question related to this dynamic patching approach for
 > lockdep.
 >  >> If dynamic proving turning on/off is provided,
 >  >> lockdep will be confused by inconsistency of lock acquiring log.
 >  >>
 >  >> Will the sequence,
 >  >>
 >  >> lock_acquire(l) -> turning off -> lock_release(l) -> turning on ->
 >  >> lock_acquire(l)
 >  >>
 >  >> detected as double acquiring?
 >  >>
 >  >> Should turning on/off lockdep be done in the time
 >  >> when every processes have no lock?
 >  >
 >  >
 >  > There is almost always a process with a lock somewhere ;-)
 >
 > Yeah :)
 >
 >  >
 >  > This is not a big deal, it's very similar to unfinished scenarios
 >  > due to the end of the tracing that can happen anytime and you miss
 >  > a lock_release or whatever. We can also begin the tracing anytime,
 >  > and you may receive orphan lock_release in the very beginning
 >  > because you missed the lock_acquire that happened before the tracing.
 >  >
 >  > Any locking scenario that doesn't fit into the state machine
 >  > or is incomplete must be considered as broken and then ignored.
 >  >
 >  >
 >
 > I see, thanks.
 > I have to fix state machine of perf lock.
 > Now it doesn't consider read, try and orphan events,
 > it is very incompletely..
 >

Ah, sorry, I've mentioned that these cases might be
a problem for validation part of lockdep, not for events.

If the lock and turning on/off sequence like this happened,
lock_acquire(l) -> turning off -> lock_release(l) -> turning on -> 
lock_acquire(l)
this will confuse validator of lockdep.
At least, task_struct.lockdep_depth will be corrupted.

And I have a trivial question to Ingo.
In lockdep, held_locks of task_struct are accessed this arithmetical way
		prev = curr->held_locks + i;
Of course this is valid way, but I feel it is more simple and natural way
		prev = curr->held_locks[i];

Is there a reason for this style?
This is a pure question. I have no intention to rewrite them :)

Thanks,
	Hitoshi
