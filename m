Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0IFUlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:41:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0IFUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:40:57 -0400
Date: Mon, 6 Sep 2010 16:40:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
Message-ID: <20100906204042.GA19815@infradead.org>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
 <1283377414.2059.1729.camel@laptop>
 <20100903164219.GB1904@linux.vnet.ibm.com>
 <1283534349.2050.297.camel@laptop>
 <20100906174642.GG14891@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100906174642.GG14891@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:16:42PM +0530, Srikar Dronamraju wrote:
> > You don't have to, but you can. The problem I have with this stuff is
> > that it makes the pid thing a primary interface, whereas it should be
> > one of many filter possibilities.
> 
> I think the otherway, 
> Why instrument a process and filter it out, if we are not interested in it.
> While instrumenting kernel, we dont have this flexibility. So
> having a pid based filter is the right thing to do for kernel
> based tracing.
> 
> If we can get the per process based tracing right, we can build
> higher lever stuff including the file based tracing easily.
> 
> All tools/debuggers in the past have all worked with process based
> tracing.

I have the feeling that you guys are at least partially talking past
each other.

For the "perf probe --add" interface the only sane interface is one by
filename and then symbol / liner number / etc.

But that is just the interface - these probes don't nessecarily have to
be armed and cause global overhead once they are define.  If the
implenmentation is smart enough it will defer arming the probe until
we actually use it, and that will be per-process quite often.

Which btw, brings up two more issues, one in uprobes and one in perf.
For one even in userspace I think the dynamic probes will really just
be the tip of the iceberg and we'll get more bang for the buck from
static traces, which is something that's no supported in uprobes yet.
As a start supporting the dtrace-style sdt.h header would be a great
help, and then we can decide if we need somthing even better on top.

The other things is that perf currently only supports per-kernel pid
recording, while we'd really need per Posix process, which may contain
multiple threads for useful tracing of complex userspace applications.
I also suspect that this will fit the uprobes model much better given
that the probes will be in any given address space.

