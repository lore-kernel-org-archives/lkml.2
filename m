Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab1CNUv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:51:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35280 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1CNUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=InYIplhW7WtioLO/QKFJkOxEYs9c3UScVHS3ZzGUCkLMCpVpdVqozsHA0tWt1mpqqj
         msofcdv762MXBeAeI8zGs9HxoE8m9frDfaPXZ/vz/ZzTiIWA5HOoKNg12LmEt1JvH301
         0hq2yIvnlPu+b+N8o8mD1HyOSZSfozqqE1fCQ=
Date: Mon, 14 Mar 2011 21:51:02 +0100
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
Message-ID: <20110314205100.GG6139@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314204341.GC9388@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 14, 2011 at 08:17:59PM +0100, Frederic Weisbecker escreveu:
> > Some examples:
> > 
> > - Trace lock events inside irqs
> > 
> > 	$ perf record -e irq:irq_handler_entry -e irq:irq_handler_exit \
> > 		-e lock:lock_acquire --starter 0 --stopper 1 --enable-on-starter \
> > 		perf bench sched messaging
> 
> A more compact alternative that uses .. to delimit ranges (start and/or
> stop), like git does for changeset ranges and @ to determine where to
> enable the event:
> 
> perf record -e instructions@irq:irq_handler_entry..irq:irq_handler_exit \
> 	perf bench sched messaging
> 
> event-A at-range event-B to event-C
> 
> open ended ranges being possible as well, i.e. start counting when
> event-B triggers and stop only when the workload finishes, or count from
> workload start till event-C triggers.
>  		
> > 	$ perf script
> > 	
> > 	perf-4300  [000]  2000.209721: irq_handler_entry: irq=40 name=ahci
> >       perf-4300  [000]  2000.209725: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
> >       perf-4300  [000]  2000.209731: irq_handler_exit: irq=40 ret=handled
> >       perf-4300  [000]  2000.209821: irq_handler_entry: irq=40 name=ahci
> >       perf-4300  [000]  2000.209823: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
> >       perf-4300  [000]  2000.209828: irq_handler_exit: irq=40 ret=handled
> > - Count instructions inside softirqs, outside softirqs and everywhere:
> > 
> > 	$ perf stat -e irq:softirq_entry -e irq:softirq_exit \
> > 		-e instructions --starter 0 --stopper 1 --enable-on-starter \
> > 		-e instructions --starter 1 --stopper 0 \
> > 		-e instructions ./perf bench sched messaging
> 
> $ perf record -e instructions@irq:softirq_entry..irq:softirq_exit \
> 	      -e instructions@irq:softirq_exit..irq:softirq_entry \
> 	      -e instructions \
> 	perf bench sched messaging
> 
> - Arnaldo


Agreed that's nice but may be more as a shortcut than a full replacement?
Otherwise it becomes hard or unreadable to define a filter on a starter. Or
a starter on a starter.
