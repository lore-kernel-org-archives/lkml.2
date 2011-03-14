Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1CNVU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:20:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56568 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1CNVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WsCV2HT+SXSdLFDASzcaGN3gr+0yY1xoFP+bcEgDEfJ29xexcTv11UvQPWIITJRB/C
         /l6S1OvPIch74Uy6/tDATUhQFDhbsQvrsJK258nkQZLB5EmiAgSc0VDpd9+e+hKe6Dns
         QMXb5aVAhMyppPsq9GRM1MKd37LlpESiGkZVk=
Date: Mon, 14 Mar 2011 22:20:53 +0100
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
Message-ID: <20110314212050.GH6139@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314210315.GC2388@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 06:03:15PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 14, 2011 at 09:51:02PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > - Count instructions inside softirqs, outside softirqs and everywhere:
> 
> > > > 	$ perf stat -e irq:softirq_entry -e irq:softirq_exit \
> > > > 		-e instructions --starter 0 --stopper 1 --enable-on-starter \
> > > > 		-e instructions --starter 1 --stopper 0 \
> > > > 		-e instructions ./perf bench sched messaging
> 
> > > $ perf record -e instructions@irq:softirq_entry..irq:softirq_exit \
> > > 	      -e instructions@irq:softirq_exit..irq:softirq_entry \
> > > 	      -e instructions \
> > > 	perf bench sched messaging
> 
> > Agreed that's nice but may be more as a shortcut than a full replacement?
> > Otherwise it becomes hard or unreadable to define a filter on a starter. Or
> > a starter on a starter.
> 
> Sure, multiple ways to express ranges probably is ok, with more complex
> ones for more complex cases, like the way you did, that first defines an
> evlist that is the set of starters/stoppers and then evsel->evidx to add
> starters/stoppers to later events.

Yep.

> But starter on a starter? Couldn't grok, could you provide an example?

I have no strong example in mind.

But one may want to count instructions when we are in an interrupt and
lock A is held.

Or count instruction when A and B are held. Or count instruction in
page faults happening in read() syscall.

Event range define a state, and anytime you need to profile/trace a
desired stacked state, starters on starters can be a good solution,
thus even a common practice.
 
> But I could think of this as a way to express filters:
> 
> $ perf record -e instructions@irq:irq:irq_handler_entry(irq=eth0)..irq:irq_handler_exit(\1) \
> 	      -e instructions \
> 	netperf
> 
> looks quite natural for someone used to git and sed, i.e. developers :)

Yeah indeed, I like filters defined in parenthesis after the event!
