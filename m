Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0GLQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:03:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0GLQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:03:26 -0400
Date: Mon, 12 Jul 2010 13:03:06 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 11/13]  perf: perf interface for uprobes
Message-ID: <20100712160306.GE25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103422.27491.84056.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712103422.27491.84056.sendpatchset@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before some more comments: this is getting really nice! Kudos!

Em Mon, Jul 12, 2010 at 04:04:22PM +0530, Srikar Dronamraju escreveu:
<SNIP>
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 09cf546..ef7c2d5 100644
<SNIP>
> @@ -403,6 +426,115 @@ static bool check_event_name(const char *name)
>  	return true;
>  }
>  
> +/*
> + * uprobe_events only accepts address:
> + * Convert function and any offset to address
> + */
> +static int convert_name_to_addr(struct perf_probe_event *pev)
> +{
> +	struct perf_probe_point *pp = &pev->point;
> +	struct perf_session *session;
> +	struct thread *thread;
> +	struct symbol *sym;
> +	struct map *map;
> +	char *name;
> +	int ret = -EINVAL;
> +	unsigned long long vaddr;
> +
> +	/* check if user has specifed a virtual address */
> +	vaddr = strtoul(pp->function, NULL, 0);
> +	session = perf_session__new(NULL, O_WRONLY, false, false);

At first creating a session here looks too much, lets see below...

> +	if (!session) {
> +		pr_warning("Cannot initialize perf session.\n");
> +		return -ENOMEM;
> +	}
> +
> +	symbol_conf.try_vmlinux_path = false;
> +	if (!vaddr)
> +		symbol_conf.sort_by_name = true;
> +	if (symbol__init() < 0) {
> +		pr_warning("Cannot initialize symbols.\n");
> +		goto free_session;
> +	}

Configuring the symbol lib on a library function is a no-go, this
function (symbol__init()) should be marked with the equivalent of
"module_init()" on tools that need the symbol library, i.e. be called
from the cmd_{top,report,probe,etc} level.

> +	event__synthesize_thread(pev->upid, event__process, session);
> +	thread = perf_session__findnew(session, pev->upid);
> +	if (!thread) {
> +		pr_warning("Cannot initialize perf session.\n");
> +		goto free_session;
> +	}

Got it, you want to read an existing thread, get it into the
perf_session threads rb_tree to then use what was parsed from /proc.

I think you should change event__synthesize_thread somehow to achieve
taht same goal instead of going in such a roundabout way, unless you
need the session for some other need.

Probably we could change it to create a thread instance that then would
be used to synthesize the MMAP and COMM events... but then for the
existing use case we would be creating such events just to trow those
objects away right after synthesizing the PERF_RECORD_{MMAP,COMM}
events... perhaps duplicate them after all :-\

If I don't come with something for this quickly we can go on using what
you coded and later refactor it to remove the fat.

<SNIP>

> @@ -712,16 +858,17 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
>  	return false;
>  }
>  
> -/* Parse kprobe_events event into struct probe_point */
> -int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
> +/* Parse probe_events (uprobe_events) event into struct probe_point */
> +static int parse_probe_trace_command(const char *cmd,
> +					struct probe_trace_event *tev)
>  {
> -	struct kprobe_trace_point *tp = &tev->point;
> +	struct probe_trace_point *tp = &tev->point;
>  	char pr;
>  	char *p;
>  	int ret, i, argc;
>  	char **argv;
>  
> -	pr_debug("Parsing kprobe_events: %s\n", cmd);
> +	pr_debug("Parsing probe_events: %s\n", cmd);

I suggest you put these s/kprobe/probe/g parts in a separate patch for
easing review :)

<SNIP>

- Arnaldo
