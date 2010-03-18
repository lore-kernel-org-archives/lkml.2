Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0CRVQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:16:39 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:46579 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0CRVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uxbzqMFbSE0H/S1vvtZI9C5P+FBd0FMwR0YXm/G9kCiSGea1Rr6O8FJv6gJM70HCdv
         S43Qg+VceGS0Nw0Jr7VKEy1B7rgGqAmAyzjtF0U3jrX2jY3DDr3WVE2UXCTgPtQizzg7
         jDpVBeh3ZwpsO1aCAJJVqkpSUL594Co6FdHhI=
Date: Thu, 18 Mar 2010 22:16:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100318211633.GG5103@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1C141.8050409@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:59:29PM +0900, Hitoshi Mitake wrote:
> On 03/17/10 18:52, Ingo Molnar wrote:
> >
> > * Frederic Weisbecker<fweisbec@gmail.com>  wrote:
> >
> >>> You add chained indirect calls into all lock ops, that's got to hurt.
> >>
> >> Well, the idea was not bad at the first glance. It was separating  
> lockdep
> >> and lock events codes.
> >>
> >> But indeed, the indirect calls plus the locking are not good for such 
> a fast
> >> path.
> >
> > What would be nice to have is some sort of dynamic patching approach  
> to enable
> > _both_ lockdep, lockstat and perf lock.
> >
> > If TRACE_EVENT() tracepoints were patchable we could use them. (but  
> they arent
> > right now)
>
> I'll try it!



I sometimes wonder which trick between jmp optimization and hot patching
would be the best to optimize the tracepoints off-cases.

I should look more closely at the jmp optimization. I don't know if
it avoids to push the tracepoints parameters in the off case, in
which case it could be perhaps more efficient than hot patching,
although perhaps most of the time the given arguments are already in
registers because the traced function uses them for its own needs.

Also, adopting hot patching means the tracepoint calls would be
in a non-inlined separated function. The result would be probably
less i-cache footprint from the caller, and better for the off-case,
worse for the on-case. But tracing off-case is most important.

(Adding more people in Cc)


> And I have a question related to this dynamic patching approach for lockdep.
> If dynamic proving turning on/off is provided,
> lockdep will be confused by inconsistency of lock acquiring log.
>
> Will the sequence,
>
> lock_acquire(l) -> turning off -> lock_release(l) -> turning on ->  
> lock_acquire(l)
>
> detected as double acquiring?
>
> Should turning on/off lockdep be done in the time
> when every processes have no lock?


There is almost always a process with a lock somewhere ;-)

This is not a big deal, it's very similar to unfinished scenarios
due to the end of the tracing that can happen anytime and you miss
a lock_release or whatever. We can also begin the tracing anytime,
and you may receive orphan lock_release in the very beginning
because you missed the lock_acquire that happened before the tracing.

Any locking scenario that doesn't fit into the state machine
or is incomplete must be considered as broken and then ignored.

