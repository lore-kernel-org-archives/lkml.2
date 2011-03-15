Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab1COS6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:58:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56944 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1COS6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H2cRcvtOQNoZB9lCL1Gz3eIxYJKu/kQeWV2x6fhI5HmVI7BHlBeZi1UjJ/6EMmtmTn
         UqBHN2WigRMxbfrXipjU1jdgI+uvUjKmMk1WJiOgM4XRdgIirQDLi6J3/cjkgIDMY7Wo
         nvvVMtydTw0JqXREV8g3F9EDHP6f/wefjNtrs=
Date: Tue, 15 Mar 2011 19:58:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110315185812.GB6605@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
 <20110314224344.GA11443@nowhere>
 <20110314230211.GG2388@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314230211.GG2388@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 08:02:11PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 14, 2011 at 11:43:46PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Mar 14, 2011 at 06:56:03PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Mar 14, 2011 at 10:20:53PM +0100, Frederic Weisbecker escreveu:
> > > > On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > Em Mon, Mar 14, 2011 at 09:51:02PM +0100, Frederic Weisbecker escreveu:
> > > > > > On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > > 
> > > > > But starter on a starter? Couldn't grok, could you provide an example?
> > > > 
> > > > I have no strong example in mind.
> > > > 
> > > > But one may want to count instructions when we are in an interrupt and
> > > > lock A is held.
> > > 
> > > Those would be and/or starter/stopper expressions, something like:
> > > 
> > > $ perf record -e instructions@(irq:irq_handler_entry(irq=eth0) && lock:lock_acquired(foo_lock))..irq:irq_handler_exit(\1) \
> > > 	      -e instructions \
> > > 	netperf
> > > 
> > > when all starters before the stopper are valid, we entered a range.
> > 
> > So, if we want to stop when lock is released, we do:
> > 
> > perf record -e instructions@(irq:irq_handler_entry(irq=eth0) && lock:lock_acquired(foo_lock))..lock:lock_release(foo_lock) && irq:irq_handler_exit(\1) \
> >              -e instructions \
> > 	netperf
> > 
> > Or || for stoppers like you do below? Hmm, I'm confused...
> > 
> > >  
> > > > Or count instruction when A and B are held.
> > > 
> > > Using wildcards that matches just the things we want to make it a bit
> > > more compact:
> > > 
> > > $ perf record -e inst*@(irq:*entry(irq=eth0) && lock:*acquired(A) && \
> > > 			lock:*acquired(B))..(lock:*release(A) || lock:*release(B)) \
> > > 	./my_workload
> > > 
> > > Parenthesis don't have to be used just for filters :) Just like in C,
> > > they can be used to express the list of parameters for a function or for
> > > expressions, etc.
> > 
> > The && make sense. But the || ?
> > 
> > What about:
> > 
> > -e inst*@(lock:*acquire(A)..lock:*release(A))@(lock:*acquire(B)..lock:*release(B))@(irq:*entry(irq=eth0)..irq:*exit(irq=eth0))
> > 
> > That looks to me less confusing.
> 
> Now it seems its me that needs to have some sleep :-) I find the above
> confusing, but I'm in a hurry right now, will try to comment more
> tomorrow.

Hehe :)

-e inst*@(lock:*acquire(A)..lock:*release(A))@(lock:*acquire(B)..lock:*release(B))

means we want to count instructions when we hold A and B, with A held
inside a section where we hold B.

Right?

But that's limited. We should express it that way:

	-e inst*@((lock:*acquire(B)..lock:*release(B) && (lock:*acquire(A)..lock:*release(A)))

Which means we first define a state where B is held. Inside that state we define
another one where A is held.

If we want to have an event always running, from the beginning, until we
acquire B:

	-e inst*@(..lock:*acquire(B))
or:
	-e inst*@..lock:*acquire(B)

If we want to only count once we hold B:

	-e inst*@lock:*acquire(B)..

If we want to count everywhere but when we hold B:

	-e inst*@(..lock:*acquire(B) && lock:*release(B)..)

This covers about everything. Now if in the future we want to support having
multiple starters or stoppers for a single target, in order to union custom
contexts, we can use the ||.

Like only count when we hold B or when we hold A:

	-e inst*@(lock:*acquire(A)..lock:*release(A) || lock:*acquire(B)..lock:*release(B))

Right?

  
> > > > Event range define a state, and anytime you need to profile/trace a
> > > > desired stacked state, starters on starters can be a good solution,
> > > > thus even a common practice.
> > > 
> > > See above, is that what you're thinking about?
> > 
> > I'm not sure. I can find the meaning of && in your expressions. But not
> > the meaning of ||. I lack some sleep though :)
> > 
> > But still, I'm all for trying to make a better and smarter way to
> > express these events, following your suggestions, but I'm not sure I have
> > the motivation to write a full parser capable of evaluating near C expressions.
> 
> See the other message, the start of it is there, thanks to Masami.

Indeed. I just had a look and it provides a basic parsing. Now it's tied to string
glob comparison and it needs to be generalized to support some custom set of
operation. Notwithstanding the final intepretation that is not trivial.

So that's a lot of work. I'd rather suggest to do this as a separate work. And
may be start with the raw --starter/--stopper things or alike to start. We can
still remove that, with the --filter thing, once we have the event comprehension
well settled.
