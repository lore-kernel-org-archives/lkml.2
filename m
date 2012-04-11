Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab2DKPiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:38:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab2DKPiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:38:13 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_FBgzLvS3gEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=vPnSQqfOyXTFX1iqDCwA:9 a=gYJ8DOujBvRdHmj3DFwA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334158690.23924.252.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Wed, 11 Apr 2012 11:38:10 -0400
In-Reply-To: <20120411152059.GE16257@infradead.org>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
	 <20120411152059.GE16257@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 12:20 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Apr 06, 2012 at 12:47:53AM +0200, Frederic Weisbecker escreveu:
> > From: Steven Rostedt <srostedt@redhat.com>
> > +struct cmdline {
> > +	char *comm;
> > +	int pid;
> > +};
> 
> In perf we have 'struct thread' for that and some more stuff, they are
> kept in an rb_tree located in a 'struct machine', 'machine's exist to
> support KVM.
> 
> At some point would be good to avoid this, but then it would make this
> code need parts of perf, that would have to then be moved to
> tools/libsymbol/ or some other more suitable name.

Agreed, this can be broken out too. Lets see if we can get the code in
first, and then start fixing it. As said, this would be the smoothest
transition of getting trace-cmd libary into perf. As it has been tested
quit intensively. Note, perf already has an older version built in. And
does most of this nastiness already.
 
> 
> > +static int cmdline_cmp(const void *a, const void *b)
> > +{
> > +	const struct cmdline *ca = a;
> > +	const struct cmdline *cb = b;
> > +
> > +	if (ca->pid < cb->pid)
> > +		return -1;
> > +	if (ca->pid > cb->pid)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +struct cmdline_list {
> > +	struct cmdline_list	*next;
> > +	char			*comm;
> > +	int			pid;
> > +};
> > +
> > +static int cmdline_init(struct pevent *pevent)
> > +{
> > +	struct cmdline_list *cmdlist = pevent->cmdlist;
> > +	struct cmdline_list *item;
> > +	struct cmdline *cmdlines;
> > +	int i;
> > +
> > +	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);
> 
> My biggest pet peeve, looks like this is New Hampshire code, all these
> "do foo or die" strikes a nerve in me :-(
> 
> Die calls in library code should just... die.

I also agree :-) We can keep this for now, and then nuke it in the next
patch. But to do so, would require an audit of this code. I could do the
work in trace-cmd, and then we could port it. Or we can port this as is,
and then update it.

The one thing I really wish C had, was the try/catch of C++. That would
solve the error code issue. But for now we need to do it with goto's and
such.

> 
> Only tools can die, libraries just can't, IMHO.
> 
> > +struct func_map {
> > +	unsigned long long		addr;
> > +	char				*func;
> > +	char				*mod;
> > +};
> > +
> > +struct func_list {
> > +	struct func_list	*next;
> > +	unsigned long long	addr;
> > +	char			*func;
> > +	char			*mod;
> > +};
> 
> For this we have tools/perf/utils/symbol.c, that supports userland as
> well as java JIT maps, etc. The perf.data file doesn't have to carry a
> copy of kallsyms, etc, build-id support is there to make sure we don't
> misresolve symbols using the right DSO found in a cache or in -debuginfo
> packages, etc.

This could be cleaned up too. Currently perf uses this code for the sw
events (aka tracepoints) of the kernel. The func_map and friends are
already used in perf.

> 
> > +int pevent_register_function(struct pevent *pevent, char *func,
> > +			     unsigned long long addr, char *mod)
> > +{
> > +	struct func_list *item;
> > +
> > +	item = malloc_or_die(sizeof(*item));
> > +
> > +	item->next = pevent->funclist;
> > +	item->func = strdup(func);
> > +	if (mod)
> > +		item->mod = strdup(mod);
> > +	else
> > +		item->mod = NULL;
> 
> strdup can fail, and no, we shouldn't die if that happens :-)

Again, this all needs to be audited. But this isn't much different than
what perf already does with the tools/perf/util/trace-event-parse.c

Thus, getting the code out can be the first step. Cleaning it up into a
nice library the second.

-- Steve



