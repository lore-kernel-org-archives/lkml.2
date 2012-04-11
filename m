Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab2DKRzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:55:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2DKRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:55:08 -0400
Date: Wed, 11 Apr 2012 14:54:57 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
Message-ID: <20120411175457.GF16257@infradead.org>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
 <20120411152059.GE16257@infradead.org>
 <1334158690.23924.252.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334158690.23924.252.camel@gandalf.stny.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 11, 2012 at 11:38:10AM -0400, Steven Rostedt escreveu:
> On Wed, 2012-04-11 at 12:20 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Apr 06, 2012 at 12:47:53AM +0200, Frederic Weisbecker escreveu:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > +struct cmdline {
> > > +	char *comm;
> > > +	int pid;
> > > +};

> > In perf we have 'struct thread' for that and some more stuff, they are
> > kept in an rb_tree located in a 'struct machine', 'machine's exist to
> > support KVM.

> > At some point would be good to avoid this, but then it would make this
> > code need parts of perf, that would have to then be moved to
> > tools/libsymbol/ or some other more suitable name.
> 
> Agreed, this can be broken out too. Lets see if we can get the code in
> first, and then start fixing it. As said, this would be the smoothest
> transition of getting trace-cmd libary into perf. As it has been tested
> quit intensively. Note, perf already has an older version built in. And
> does most of this nastiness already.

I just wanted to make sure my main pet peeves and concerns were written
down :-)

Knowing beforehand we agree on having them fixed eventually is enough
for me, thanks.

> > > +	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
> > 
> > My biggest pet peeve, looks like this is New Hampshire code, all these
> > "do foo or die" strikes a nerve in me :-(
> > 
> > Die calls in library code should just... die.
> 
> I also agree :-) We can keep this for now, and then nuke it in the next
> patch. But to do so, would require an audit of this code. I could do the
> work in trace-cmd, and then we could port it. Or we can port this as is,
> and then update it.
> 
> The one thing I really wish C had, was the try/catch of C++. That would
> solve the error code issue. But for now we need to do it with goto's and
> such.

Yeah, we have to use what we can, and that is to do how we solve this
matter in the kernel.

I.e. trying to follow the kernel coding style is something we should
strive to in tools/ code, so that we encourage kernel developers to
contribute as they will find the code familiar to how things are done in
kernel land.

> > Only tools can die, libraries just can't, IMHO.
> > 
> > > +struct func_map {
> > > +	unsigned long long		addr;
> > > +	char				*func;
> > > +	char				*mod;
> > > +};
> > For this we have tools/perf/utils/symbol.c, that supports userland as
> > well as java JIT maps, etc. The perf.data file doesn't have to carry a
> > copy of kallsyms, etc, build-id support is there to make sure we don't
> > misresolve symbols using the right DSO found in a cache or in -debuginfo
> > packages, etc.
> 
> This could be cleaned up too. Currently perf uses this code for the sw
> events (aka tracepoints) of the kernel. The func_map and friends are
> already used in perf.

Right, one more thing we agree we should fix at some point, good.

> > > +	if (mod)
> > > +		item->mod = strdup(mod);
> > > +	else
> > > +		item->mod = NULL;

> > strdup can fail, and no, we shouldn't die if that happens :-)

> Again, this all needs to be audited. But this isn't much different than
> what perf already does with the tools/perf/util/trace-event-parse.c

> Thus, getting the code out can be the first step. Cleaning it up into a
> nice library the second.

Ok.

- Arnaldo
