Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2BVVe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:34:26 -0500
Received: from ozlabs.org ([203.10.76.45]:54660 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab2BVVeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:34:23 -0500
Date: Thu, 23 Feb 2012 08:33:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222081855.GB25318@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 09:18:55AM +0100, Ingo Molnar wrote:

> The problem with static_branch_def_false/def_true was that the 
> very intuitively visible bias that we see with 
> likely()/unlikely() is confused in jump label constructs through 
> two layers of modifiers. And the fix is so easy, a simple rename 
> in most cases ;-)
> 
> So instead of that, in this series we have:
> 
> +       if (very_unlikely(&perf_sched_events.key))
> 
> which is a heck of an improvement IMO. I'd still up its 
> readability a notch, by also signalling the overhead of the 
> update path by making it:
> 
> +       if (very_unlikely(&perf_sched_events.slow_flag))
> 
> ... but I don't want to be that much of a readability nazi ;-)

I have to say I don't like the "very_unlikely" name.  It's confusing
because the condition being evaluated appears to be the address of
something, i.e. &perf_sched_events.key in your example, and that looks
to me to be very very likely to be true, i.e. non-zero.  But the code
is telling me that's very *un*likely, which is confusing.

In other words I can't think about "very_unlikely" as being similar to
"unlikely".  Clearly very_unlikely isn't just passing through the
true/falseness of its argument to the surrounding if, the way that
unlikely does; it (very_unlikely) is a real function that is doing
something more complicated with its argument -- dereferencing it,
conceptually at least, for a start.

Just from a readability perspective, I like the static_branch name,
and if we want to add information about the execution bias, I'd
suggest we do:

	if (likely(static_branch(&x))) ...

	if (unlikely(static_branch(&x))) ...

if that can be made to work, or else have variants like this:

   	if (likely_static_branch(&x)) ...

	if (unlikely_static_branch(&x)) ...

Paul.
