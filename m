Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1CNUoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:44:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab1CNUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:44:05 -0400
Date: Mon, 14 Mar 2011 17:43:41 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
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
Message-ID: <20110314204341.GC9388@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 08:17:59PM +0100, Frederic Weisbecker escreveu:
> Some examples:
> 
> - Trace lock events inside irqs
> 
> 	$ perf record -e irq:irq_handler_entry -e irq:irq_handler_exit \
> 		-e lock:lock_acquire --starter 0 --stopper 1 --enable-on-starter \
> 		perf bench sched messaging

A more compact alternative that uses .. to delimit ranges (start and/or
stop), like git does for changeset ranges and @ to determine where to
enable the event:

perf record -e instructions@irq:irq_handler_entry..irq:irq_handler_exit \
	perf bench sched messaging

event-A at-range event-B to event-C

open ended ranges being possible as well, i.e. start counting when
event-B triggers and stop only when the workload finishes, or count from
workload start till event-C triggers.
 		
> 	$ perf script
> 	
> 	perf-4300  [000]  2000.209721: irq_handler_entry: irq=40 name=ahci
>       perf-4300  [000]  2000.209725: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
>       perf-4300  [000]  2000.209731: irq_handler_exit: irq=40 ret=handled
>       perf-4300  [000]  2000.209821: irq_handler_entry: irq=40 name=ahci
>       perf-4300  [000]  2000.209823: lock_acquire: 0xffff880037851c40 &(&host->lock)->rlock
>       perf-4300  [000]  2000.209828: irq_handler_exit: irq=40 ret=handled
> - Count instructions inside softirqs, outside softirqs and everywhere:
> 
> 	$ perf stat -e irq:softirq_entry -e irq:softirq_exit \
> 		-e instructions --starter 0 --stopper 1 --enable-on-starter \
> 		-e instructions --starter 1 --stopper 0 \
> 		-e instructions ./perf bench sched messaging

$ perf record -e instructions@irq:softirq_entry..irq:softirq_exit \
	      -e instructions@irq:softirq_exit..irq:softirq_entry \
	      -e instructions \
	perf bench sched messaging

- Arnaldo
