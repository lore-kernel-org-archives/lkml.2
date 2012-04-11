Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab2DKPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:21:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab2DKPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:21:10 -0400
Date: Wed, 11 Apr 2012 12:20:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
Message-ID: <20120411152059.GE16257@infradead.org>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 06, 2012 at 12:47:53AM +0200, Frederic Weisbecker escreveu:
> From: Steven Rostedt <srostedt@redhat.com>
> +struct cmdline {
> +	char *comm;
> +	int pid;
> +};

In perf we have 'struct thread' for that and some more stuff, they are
kept in an rb_tree located in a 'struct machine', 'machine's exist to
support KVM.

At some point would be good to avoid this, but then it would make this
code need parts of perf, that would have to then be moved to
tools/libsymbol/ or some other more suitable name.

> +static int cmdline_cmp(const void *a, const void *b)
> +{
> +	const struct cmdline *ca = a;
> +	const struct cmdline *cb = b;
> +
> +	if (ca->pid < cb->pid)
> +		return -1;
> +	if (ca->pid > cb->pid)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +struct cmdline_list {
> +	struct cmdline_list	*next;
> +	char			*comm;
> +	int			pid;
> +};
> +
> +static int cmdline_init(struct pevent *pevent)
> +{
> +	struct cmdline_list *cmdlist = pevent->cmdlist;
> +	struct cmdline_list *item;
> +	struct cmdline *cmdlines;
> +	int i;
> +
> +	cmdlines = malloc_or_die(sizeof(*cmdlines) * pevent->cmdline_count);

My biggest pet peeve, looks like this is New Hampshire code, all these
"do foo or die" strikes a nerve in me :-(

Die calls in library code should just... die.

Only tools can die, libraries just can't, IMHO.

> +struct func_map {
> +	unsigned long long		addr;
> +	char				*func;
> +	char				*mod;
> +};
> +
> +struct func_list {
> +	struct func_list	*next;
> +	unsigned long long	addr;
> +	char			*func;
> +	char			*mod;
> +};

For this we have tools/perf/utils/symbol.c, that supports userland as
well as java JIT maps, etc. The perf.data file doesn't have to carry a
copy of kallsyms, etc, build-id support is there to make sure we don't
misresolve symbols using the right DSO found in a cache or in -debuginfo
packages, etc.

> +int pevent_register_function(struct pevent *pevent, char *func,
> +			     unsigned long long addr, char *mod)
> +{
> +	struct func_list *item;
> +
> +	item = malloc_or_die(sizeof(*item));
> +
> +	item->next = pevent->funclist;
> +	item->func = strdup(func);
> +	if (mod)
> +		item->mod = strdup(mod);
> +	else
> +		item->mod = NULL;

strdup can fail, and no, we shouldn't die if that happens :-)

