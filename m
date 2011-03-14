Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1CNV4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:56:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49306 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1CNV4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=pc/YwPH0QX5W6sPwTlOjhDugF0vUAU9qMGfGWO5N44VdZ8gwBMrAhfY0tLRtvSMgod
         9aDDz5IeRxA5QVPVzpfkWDDTQigX1LK3uAeoa68s138Qy4ZTdHxc5CbM2UhfqUlaM14H
         6vSrzodkjCyALFc2f2wtSJsCzqizry//N2oV0=
Date: Mon, 14 Mar 2011 18:56:03 -0300
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
Message-ID: <20110314215603.GD2388@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314212050.GH6139@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 10:20:53PM +0100, Frederic Weisbecker escreveu:
> On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Mar 14, 2011 at 09:51:02PM +0100, Frederic Weisbecker escreveu:
> > > On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:

> > But starter on a starter? Couldn't grok, could you provide an example?
> 
> I have no strong example in mind.
> 
> But one may want to count instructions when we are in an interrupt and
> lock A is held.

Those would be and/or starter/stopper expressions, something like:

$ perf record -e instructions@(irq:irq_handler_entry(irq=eth0) && lock:lock_acquired(foo_lock))..irq:irq_handler_exit(\1) \
	      -e instructions \
	netperf

when all starters before the stopper are valid, we entered a range.
 
> Or count instruction when A and B are held.

Using wildcards that matches just the things we want to make it a bit
more compact:

$ perf record -e inst*@(irq:*entry(irq=eth0) && lock:*acquired(A) && \
			lock:*acquired(B))..(lock:*release(A) || lock:*release(B)) \
	./my_workload

Parenthesis don't have to be used just for filters :) Just like in C,
they can be used to express the list of parameters for a function or for
expressions, etc.

> Or count instruction in page faults happening in read() syscall.

We would need to use 'perf probe' first to insert the entry and exit
probes on the page fault handling path:

[root@felicio ~]# perf list *fault* *:*fault*

List of pre-defined events (to be used in -e):
  page-faults OR faults                      [Software event]
  minor-faults                               [Software event]
  major-faults                               [Software event]
  alignment-faults                           [Software event]
  emulation-faults                           [Software event]

  kvm:kvm_page_fault                         [Tracepoint event]
[root@felicio ~]#

But then an expression could be used like I showed above for the
previous use case you mentioned.

> Event range define a state, and anytime you need to profile/trace a
> desired stacked state, starters on starters can be a good solution,
> thus even a common practice.

See above, is that what you're thinking about?
  
> > But I could think of this as a way to express filters:
> > 
> > $ perf record -e instructions@irq:irq:irq_handler_entry(irq=eth0)..irq:irq_handler_exit(\1) \
> > 	      -e instructions \
> > 	netperf
> > 
> > looks quite natural for someone used to git and sed, i.e. developers :)
> 
> Yeah indeed, I like filters defined in parenthesis after the event!

:-)

- Arnaldo
