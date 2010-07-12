Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0GLRlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:41:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57940 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab0GLRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:41:22 -0400
Date: Mon, 12 Jul 2010 23:02:30 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
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
Subject: Re: [PATCHv9 2.6.35-rc4-tip 11/13]  perf: perf interface for
 uprobes
Message-ID: <20100712173230.GE23776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103422.27491.84056.sendpatchset@localhost6.localdomain6>
 <20100712160306.GE25238@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100712160306.GE25238@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before some more comments: this is getting really nice! Kudos!
> 

Thanks.

> > +
> > +	/* check if user has specifed a virtual address */
> > +	vaddr = strtoul(pp->function, NULL, 0);
> > +	session = perf_session__new(NULL, O_WRONLY, false, false);
> 
> At first creating a session here looks too much, lets see below...

Okay. 

> 
> > +	if (!vaddr)
> > +		symbol_conf.sort_by_name = true;
> > +	if (symbol__init() < 0) {
> > +		pr_warning("Cannot initialize symbols.\n");
> > +		goto free_session;
> > +	}
> 
> Configuring the symbol lib on a library function is a no-go, this
> function (symbol__init()) should be marked with the equivalent of
> "module_init()" on tools that need the symbol library, i.e. be called
> from the cmd_{top,report,probe,etc} level.


Oh okay, I then might be doing the same thing in patch 13/13. 
I will correct there too.

> 
> > +	event__synthesize_thread(pev->upid, event__process, session);
> > +	thread = perf_session__findnew(session, pev->upid);
> > +	if (!thread) {
> > +		pr_warning("Cannot initialize perf session.\n");
> > +		goto free_session;
> > +	}
> 
> Got it, you want to read an existing thread, get it into the
> perf_session threads rb_tree to then use what was parsed from /proc.
> 
> I think you should change event__synthesize_thread somehow to achieve
> taht same goal instead of going in such a roundabout way, unless you
> need the session for some other need.


Right, I need the session for the thread.

> 
> Probably we could change it to create a thread instance that then would
> be used to synthesize the MMAP and COMM events... but then for the
> existing use case we would be creating such events just to trow those
> objects away right after synthesizing the PERF_RECORD_{MMAP,COMM}
> events... perhaps duplicate them after all :-\
> 
> If I don't come with something for this quickly we can go on using what
> you coded and later refactor it to remove the fat.

Okay. I am fine either way.

> > +					struct probe_trace_event *tev)
> >  {
> > -	struct kprobe_trace_point *tp = &tev->point;
> > +	struct probe_trace_point *tp = &tev->point;
> >  	char pr;
> >  	char *p;
> >  	int ret, i, argc;
> >  	char **argv;
> >  
> > -	pr_debug("Parsing kprobe_events: %s\n", cmd);
> > +	pr_debug("Parsing probe_events: %s\n", cmd);
> 
> I suggest you put these s/kprobe/probe/g parts in a separate patch for
> easing review :)
> 

Okay . 

--
Thanks and Regards
Srikar
