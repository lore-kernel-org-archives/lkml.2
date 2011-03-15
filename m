Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab1COTYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:24:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53462 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344Ab1COTYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=QbRz2oTHIuXgzPn6dfkr4gOVv2+/ew7YrkHc4taNs2J5pXrJ+kwmmr1q6BEMBSqUSV
         7ohSx1qA/vJGvy0XYpPXxjUaauuFX0MPPAI7yxfLLMbTobfLqsPiza7FshqBziWgsVwU
         i/BtFQGmp5a+p3Jfo+JMUZKnofRGPsVn92mds=
Date: Tue, 15 Mar 2011 16:24:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110315192422.GF7011@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
 <20110314224344.GA11443@nowhere>
 <20110314230211.GG2388@ghostprotocols.net>
 <20110315185812.GB6605@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315185812.GB6605@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 15, 2011 at 07:58:16PM +0100, Frederic Weisbecker escreveu:
> On Mon, Mar 14, 2011 at 08:02:11PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Mar 14, 2011 at 11:43:46PM +0100, Frederic Weisbecker escreveu:
> > > On Mon, Mar 14, 2011 at 06:56:03PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Mon, Mar 14, 2011 at 10:20:53PM +0100, Frederic Weisbecker escreveu:
> > > > > On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Using wildcards that matches just the things we want to make it a bit
> > > > more compact:
> > > > 
> > > > $ perf record -e inst*@(irq:*entry(irq=eth0) && lock:*acquired(A) && \
> > > > 			lock:*acquired(B))..(lock:*release(A) || lock:*release(B)) \
> > > > 	./my_workload
> > > > 
> > > > Parenthesis don't have to be used just for filters :) Just like in C,
> > > > they can be used to express the list of parameters for a function or for
> > > > expressions, etc.
> > > 
> > > The && make sense. But the || ?
> > > 
> > > What about:
> > > 
> > > -e inst*@(lock:*acquire(A)..lock:*release(A))@(lock:*acquire(B)..lock:*release(B))@(irq:*entry(irq=eth0)..irq:*exit(irq=eth0))
> > > 
> > > That looks to me less confusing.
> > 
> > Now it seems its me that needs to have some sleep :-) I find the above
> > confusing, but I'm in a hurry right now, will try to comment more
> > tomorrow.
> 
> Hehe :)
> 
> -e inst*@(lock:*acquire(A)..lock:*release(A))@(lock:*acquire(B)..lock:*release(B))
> 
> means we want to count instructions when we hold A and B, with A held
> inside a section where we hold B.
> 
> Right?

Understood, see below about the &&, I think we're improving the syntax
for expressing these narrowing ranges where events should be active.
 
> But that's limited. We should express it that way:
> 
> 	-e inst*@((lock:*acquire(B)..lock:*release(B) && (lock:*acquire(A)..lock:*release(A)))
> 
> Which means we first define a state where B is held. Inside that state we define
> another one where A is held.
> 
> If we want to have an event always running, from the beginning, until we
> acquire B:
> 
> 	-e inst*@(..lock:*acquire(B))
> or:
> 	-e inst*@..lock:*acquire(B)

Yeah, extra parenthesis, like in a C expression, are just ellided away.
And agreed on the above, record instructions until that event takes
place.

> If we want to only count once we hold B:
> 
> 	-e inst*@lock:*acquire(B)..

agreed
 
> If we want to count everywhere but when we hold B:
> 
> 	-e inst*@(..lock:*acquire(B) && lock:*release(B)..)

Makes sense but looks confusing at first sight, how to translate that to
events starter/stoppers?

its an event: instructions, it starts in what state? Enabled, i.e. the
first part of the expression has precedence: ..lock:*acquire(B), then,
after it is disabled, because we acquired B, the second part gets armed,
i.e. when the release(B) event takes place, the first part gets armed
again.

That is why I felt '&&' to be confusing, its not that both are in
effect, its that one is only armed when the previous was disarmed.

Perhaps we could find some other operator that was more natural, or just
agree that && in this context works this way, almost like what we do in
shell scripting with && and || (the cycle to rearm the first range after
the last one is disarmed is the part that doesn't matches the shell
use).

Also:

 	-e inst*@(lock:*release(B)..lock:*acquire(B))

Wouldn't be simpler? Not equivalent tho if one is interested in
everything that happens till the first time the lock is acquired in some
specific thread that is started from the tool, etc.
 
> This covers about everything. Now if in the future we want to support having
> multiple starters or stoppers for a single target, in order to union custom
> contexts, we can use the ||.
> 
> Like only count when we hold B or when we hold A:
> 
> 	-e inst*@(lock:*acquire(A)..lock:*release(A) || lock:*acquire(B)..lock:*release(B))

> Right?

Yeah, this one is natural at first sight. As is:

 	-e (inst*,cycles,dTLB*misses)@(lock:*acquire(A)..lock:*release(A) || lock:*acquire(B)..lock:*release(B))

I.e. we're expressing an evlist (list of event selectors) to be counted
when the 'at' expression allows.

> > > > > Event range define a state, and anytime you need to profile/trace a
> > > > > desired stacked state, starters on starters can be a good solution,
> > > > > thus even a common practice.
> > > > 
> > > > See above, is that what you're thinking about?
> > > 
> > > I'm not sure. I can find the meaning of && in your expressions. But not
> > > the meaning of ||. I lack some sleep though :)
> > > 
> > > But still, I'm all for trying to make a better and smarter way to
> > > express these events, following your suggestions, but I'm not sure I have
> > > the motivation to write a full parser capable of evaluating near C expressions.
> > 
> > See the other message, the start of it is there, thanks to Masami.
> 
> Indeed. I just had a look and it provides a basic parsing. Now it's tied to string
> glob comparison and it needs to be generalized to support some custom set of
> operation. Notwithstanding the final intepretation that is not trivial.
> 
> So that's a lot of work. I'd rather suggest to do this as a separate work. And
> may be start with the raw --starter/--stopper things or alike to start. We can
> still remove that, with the --filter thing, once we have the event comprehension
> well settled.
