Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2BCKXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2BCKXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:23:43 -0500
Date: Fri, 3 Feb 2012 11:23:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 3/7] ftrace, perf: Add open/close tracepoint perf
 registration actions
Message-ID: <20120203102329.GA1531@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-4-git-send-email-jolsa@redhat.com>
 <20120202173503.GF9071@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202173503.GF9071@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 06:35:06PM +0100, Frederic Weisbecker wrote:
> On Sat, Jan 28, 2012 at 07:43:25PM +0100, Jiri Olsa wrote:
> > Adding TRACE_REG_PERF_OPEN and TRACE_REG_PERF_CLOSE to differentiate
> > register/unregister from open/close actions.
> > 
> > The register/unregister actions are invoked for the first/last
> > tracepoint user when opening/closing the event.
> > 
> > The open/close actions are invoked for each tracepoint user when
> > opening/closing the event.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  include/linux/ftrace_event.h    |    6 +-
> >  kernel/trace/trace.h            |    5 ++
> >  kernel/trace/trace_event_perf.c |  116 +++++++++++++++++++++++++--------------
> >  kernel/trace/trace_events.c     |   10 ++-
> >  kernel/trace/trace_kprobe.c     |    6 ++-
> >  kernel/trace/trace_syscalls.c   |   14 +++-
> >  6 files changed, 106 insertions(+), 51 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index c3da42d..195e360 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -146,6 +146,8 @@ enum trace_reg {
> >  	TRACE_REG_UNREGISTER,
> >  	TRACE_REG_PERF_REGISTER,
> >  	TRACE_REG_PERF_UNREGISTER,
> > +	TRACE_REG_PERF_OPEN,
> > +	TRACE_REG_PERF_CLOSE,
> >  };
> >  
> >  struct ftrace_event_call;
> > @@ -157,7 +159,7 @@ struct ftrace_event_class {
> >  	void			*perf_probe;
> >  #endif
> >  	int			(*reg)(struct ftrace_event_call *event,
> > -				       enum trace_reg type);
> > +				       enum trace_reg type, void *data);
> >  	int			(*define_fields)(struct ftrace_event_call *);
> >  	struct list_head	*(*get_fields)(struct ftrace_event_call *);
> >  	struct list_head	fields;
> > @@ -165,7 +167,7 @@ struct ftrace_event_class {
> >  };
> >  
> >  extern int ftrace_event_reg(struct ftrace_event_call *event,
> > -			    enum trace_reg type);
> > +			    enum trace_reg type, void *data);
> >  
> >  enum {
> >  	TRACE_EVENT_FL_ENABLED_BIT,
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 55c6ea0..0eaf077 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -828,4 +828,9 @@ extern const char *__stop___trace_bprintk_fmt[];
> >  	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
> >  #include "trace_entries.h"
> >  
> > +#ifdef CONFIG_PERF_EVENTS
> > +int perf_ftrace_event_register(struct ftrace_event_call *call,
> > +			       enum trace_reg type, void *data);
> > +#endif
> 
> Seem to belong to a further patch. Nevermind.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

right, I'll make the change in new version

thanks,
jirka
