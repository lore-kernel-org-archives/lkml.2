Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0ELO54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:57:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:35113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0ELO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gxORhJBMIoRuN8rPR9Htnsg0sKsoFTIqS/omIJpix5GZMRGiQnriEmXVPvL4x2mrRB
         PJzbhcy1PoY2foxvktMMtXIVa8ZEMavCdTPUPQsJQqlKtwv58CYfbH3R8S7y7ZMdZcoL
         bQbxUwyiiTHzYKeoEecvW1qM3b1flqMtVBvV8=
Date: Wed, 12 May 2010 16:57:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: rostedt@goodmis.org, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/11] Uprobes traceevents patch.
Message-ID: <20100512145746.GC5405@nowhere>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6> <1270070691.19685.7899.camel@gandalf.stny.rr.com> <4BB41E38.8080406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB41E38.8080406@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:16:56AM -0400, Masami Hiramatsu wrote:
> Hi Steven,
> 
> Steven Rostedt wrote:
> > On Wed, 2010-03-31 at 21:23 +0530, Srikar Dronamraju wrote:
> > 
> >>  libftrace-y := ftrace.o
> >> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> >> index 2825ef2..9fe02ab 100644
> >> --- a/kernel/trace/trace.h
> >> +++ b/kernel/trace/trace.h
> >> @@ -126,6 +126,18 @@ struct kretprobe_trace_entry {
> >>  	(offsetof(struct kretprobe_trace_entry, args) +	\
> >>  	(sizeof(unsigned long) * (n)))
> >>  
> >> +struct uprobe_trace_entry {
> >> +	struct trace_entry	ent;
> >> +	pid_t			pid;
> > 
> > Unless pid is not the current pid, ent already records it.
> 
> Indeed.
> 
> >> +	unsigned long		ip;
> >> +	int			nargs;
> >> +	unsigned long		args[];
> >> +};
> > 
> > Note, you want to really add this to trace_entries.h instead:
> > 
> > FTRACE_ENTRY(uprobe, uprobe_trace_entry,
> > 
> > 	TRACE_GRAPH_ENT,
> > 
> > 	F_STRUCT(
> > 		__field(	unsigned long,	ip	)
> > 		__field(	int,		nargs	)
> > 		__dynamic_array(unsigned long,	args	)
> > 	),
> > 
> > 	F_printk("%lx nrargs:%u", __entry->ip, __entry->nargs)
> > );
> > 
> > 
> > This will put this event into the events/ftrace directory. Don't worry
> > about the printk format, we can write a plugin for it to override it if
> > need be.
> 
> Hmm, interesting idea. But this dynamic event definition allows us
> to filter events based on each argument value.
> 
> As you can see this code, 
> 
> >> +struct probe_arg {
> >> +	struct fetch_func	fetch;
> >> +	const char		*name;
> >> +};
> 
> each argument can have unique name. Therefore user can write a filter
> by using these names.
> 
> Moreover, dynamic events (at least kprobe-tracer) are going to support
> 'types' for each argument. this means that the arg[] in *probe_trace_entry
> will be no longer an unsigned long array.
> 
> Thank you,


Yeah, I don't think we should FTRACE_ENTRY for that. The format files for
[k|u]probes events are created dynamically on top of what the user requested,
which is a very nice feature.

