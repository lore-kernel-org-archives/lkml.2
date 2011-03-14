Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1CNXCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:02:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53193 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1CNXCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=S2sXVXWHaf378CIzGm37pt8trEpns2IpYBwFZSTSB7t5UWbyt/Wwy5FVi9htoypC/m
         OOM3LGUh/Eb4qJ69mnUzza0h6Oq9yabhPl7ehjOiMNJmhBH33Tg/5pOtBPzxJkrVoBhI
         XW000I+R5eF0VU0o48B134dEoTm1W2oeG2/lw=
Date: Mon, 14 Mar 2011 20:02:11 -0300
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
Message-ID: <20110314230211.GG2388@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
 <20110314224344.GA11443@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314224344.GA11443@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 11:43:46PM +0100, Frederic Weisbecker escreveu:
> On Mon, Mar 14, 2011 at 06:56:03PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Mar 14, 2011 at 10:20:53PM +0100, Frederic Weisbecker escreveu:
> > > On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Mon, Mar 14, 2011 at 09:51:02PM +0100, Frederic Weisbecker escreveu:
> > > > > On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > 
> > > > But starter on a starter? Couldn't grok, could you provide an example?
> > > 
> > > I have no strong example in mind.
> > > 
> > > But one may want to count instructions when we are in an interrupt and
> > > lock A is held.
> > 
> > Those would be and/or starter/stopper expressions, something like:
> > 
> > $ perf record -e instructions@(irq:irq_handler_entry(irq=eth0) && lock:lock_acquired(foo_lock))..irq:irq_handler_exit(\1) \
> > 	      -e instructions \
> > 	netperf
> > 
> > when all starters before the stopper are valid, we entered a range.
> 
> So, if we want to stop when lock is released, we do:
> 
> perf record -e instructions@(irq:irq_handler_entry(irq=eth0) && lock:lock_acquired(foo_lock))..lock:lock_release(foo_lock) && irq:irq_handler_exit(\1) \
>              -e instructions \
> 	netperf
> 
> Or || for stoppers like you do below? Hmm, I'm confused...
> 
> >  
> > > Or count instruction when A and B are held.
> > 
> > Using wildcards that matches just the things we want to make it a bit
> > more compact:
> > 
> > $ perf record -e inst*@(irq:*entry(irq=eth0) && lock:*acquired(A) && \
> > 			lock:*acquired(B))..(lock:*release(A) || lock:*release(B)) \
> > 	./my_workload
> > 
> > Parenthesis don't have to be used just for filters :) Just like in C,
> > they can be used to express the list of parameters for a function or for
> > expressions, etc.
> 
> The && make sense. But the || ?
> 
> What about:
> 
> -e inst*@(lock:*acquire(A)..lock:*release(A))@(lock:*acquire(B)..lock:*release(B))@(irq:*entry(irq=eth0)..irq:*exit(irq=eth0))
> 
> That looks to me less confusing.

Now it seems its me that needs to have some sleep :-) I find the above
confusing, but I'm in a hurry right now, will try to comment more
tomorrow.
 
> 
> > 
> > > Or count instruction in page faults happening in read() syscall.
> > 
> > We would need to use 'perf probe' first to insert the entry and exit
> > probes on the page fault handling path:
> > 
> > [root@felicio ~]# perf list *fault* *:*fault*
> > 
> > List of pre-defined events (to be used in -e):
> >   page-faults OR faults                      [Software event]
> >   minor-faults                               [Software event]
> >   major-faults                               [Software event]
> >   alignment-faults                           [Software event]
> >   emulation-faults                           [Software event]
> > 
> >   kvm:kvm_page_fault                         [Tracepoint event]
> > [root@felicio ~]#
> > 
> > But then an expression could be used like I showed above for the
> > previous use case you mentioned.
> 
> Right.
> 
> > 
> > > Event range define a state, and anytime you need to profile/trace a
> > > desired stacked state, starters on starters can be a good solution,
> > > thus even a common practice.
> > 
> > See above, is that what you're thinking about?
> 
> I'm not sure. I can find the meaning of && in your expressions. But not
> the meaning of ||. I lack some sleep though :)
> 
> But still, I'm all for trying to make a better and smarter way to
> express these events, following your suggestions, but I'm not sure I have
> the motivation to write a full parser capable of evaluating near C expressions.

See the other message, the start of it is there, thanks to Masami.
