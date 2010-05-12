Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0ELOeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:34:16 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49583 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0ELOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:34:15 -0400
Date: Wed, 12 May 2010 20:04:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/11] Uprobes traceevents patch.
Message-ID: <20100512143408.GP7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
 <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6>
 <20100512110224.GB5408@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100512110224.GB5408@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > +config UPROBE_EVENT
> > +	depends on UPROBES
> > +	bool "Enable uprobes-based dynamic events"
> > +	select TRACING
> > +	default y
> > +	help
> > +	  This allows the user to add tracing events (similar to tracepoints)
> > +	  on the fly via the traceevents interface.
> 
> 
> 
> That doesn't explain much what it does. Please explain its goal of
> creating a trace event on top of a userspace dynamic probe.
> 

Okay. 

> 
> 
> > +#define MAX_TRACE_ARGS 128
> > +#define MAX_ARGSTR_LEN 63
> > +#define MAX_EVENT_NAME_LEN 64
> 
> 
> This can be shared with kprobes in a new kernel/trace/dyn_probes.h
> or something.
> 

Okay. 

> > +	ret = register_uprobe_event(tp);
> > +	if (ret) {
> > +		pr_warning("Faild to register probe event(%d)\n", ret);
> 
> 
> "Failed"

Okay. 

> 
> 
> > +		group = UPROBE_EVENT_SYSTEM;
> > +
> > +	if (is_delete) {
> > +		if (!event) {
> > +			pr_info("Delete command needs an event name.\n");
> > +			return -EINVAL;
> > +		}
> > +		tp = find_probe_event(event, group);
> > +		if (!tp) {
> > +			pr_info("Event %s/%s doesn't exist.\n", group, event);
> > +			return -ENOENT;
> > +		}
> > +		/* delete an event */
> > +		unregister_trace_uprobe(tp);
> 
> 
> 
> Doesn't seem to be under uprobe_lock.

Agree, the unregister_trace_uprobe() has to be called after locking 
uprobe_lock.

> 
> 
> 
> > +/* Make a debugfs interface for controling probe points */
> > +static __init int init_uprobe_trace(void)
> > +{
> > +	struct dentry *d_tracer;
> > +	struct dentry *entry;
> > +
> > +	d_tracer = tracing_init_dentry();
> > +	if (!d_tracer)
> > +		return 0;
> > +
> > +	entry = debugfs_create_file("uprobe_events", 0644, d_tracer,
> > +				    NULL, &uprobe_events_ops);
> > +
> > +	/* Event list interface */
> > +	if (!entry)
> > +		pr_warning("Could not create debugfs "
> > +			   "'uprobe_events' entry\n");
> 
> 
> 
> You can use trace_create_file I think.

Okay, will check that. 

> 
> 

-- 
Thanks and Regards
Srikar
