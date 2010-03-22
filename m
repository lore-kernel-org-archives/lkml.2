Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0CVUpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0CVUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:44:58 -0400
Date: Mon, 22 Mar 2010 16:44:20 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH 4/5] jump label: tracepoint support
Message-ID: <20100322204420.GE2278@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com> <6ede473837c2c7c55dde179690c2ae73223417c6.1269272444.git.jbaron@redhat.com> <1269276214.2957.7.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269276214.2957.7.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 12:43:34PM -0400, Steven Rostedt wrote:
> On Mon, 2010-03-22 at 12:07 -0400, Jason Baron wrote:
> > Make use of the jump label infrastructure for tracepoints.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  include/linux/tracepoint.h |   34 +++++++++++++++++++---------------
> >  kernel/tracepoint.c        |    8 ++++++++
> >  2 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index f59604e..c18b9c0 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -16,6 +16,7 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/rcupdate.h>
> > +#include <linux/jump_label.h>
> >  
> >  struct module;
> >  struct tracepoint;
> > @@ -63,20 +64,22 @@ struct tracepoint {
> >   * not add unwanted padding between the beginning of the section and the
> >   * structure. Force alignment to the same alignment as the section start.
> >   */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > -	extern struct tracepoint __tracepoint_##name;			\
> > -	static inline void trace_##name(proto)				\
> > -	{								\
> > -		if (unlikely(__tracepoint_##name.state))		\
> > -			__DO_TRACE(&__tracepoint_##name,		\
> > -				TP_PROTO(proto), TP_ARGS(args));	\
> > -	}								\
> > -	static inline int register_trace_##name(void (*probe)(proto))	\
> > -	{								\
> > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > -	}								\
> > -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> > -	{								\
> > +#define DECLARE_TRACE(name, proto, args)				 \
> > +	extern struct tracepoint __tracepoint_##name;			 \
> > +	static inline void trace_##name(proto)				 \
> > +	{								 \
> > +		JUMP_LABEL(name, do_trace, __tracepoint_##name.state);   \
> > +		return;							 \
> > +do_trace:								 \
> > +		__DO_TRACE(&__tracepoint_##name,			 \
> > +			   TP_PROTO(proto), TP_ARGS(args));		 \
> 
> Does this still work on all archs, and when jump labels are not
> supported?

yes. See the base patch. If the arch doesn't have jump label support we
do:

#define JUMP_LABEL(tag, label, cond)            \
        if (unlikely(cond))                     \
                goto label;

-Jason
