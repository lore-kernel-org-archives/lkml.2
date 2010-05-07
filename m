Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0EGSGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:06:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62745 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab0EGSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C6pFoMhFZ9xbVJe9vkzmY/Zkw/vesQHFKHq1MMhwJyHCpWfSwjXxMP6WSpY09CDT0C
         1ewylo5VK1kq4yF3tw7/DeCyM8ewh1J5odC1s2cIJDLVdIuxCEyW3gm2GMdzOnmJgzPu
         33cI55OHbewJFHig3DQJU0yywy9+YZNfdMHsE=
Date: Fri, 7 May 2010 20:06:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have data
	passed to tracepoint callbacks
Message-ID: <20100507180628.GB5401@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034201.896240097@goodmis.org> <20100507035230.GB8069@nowhere> <1273241371.22438.81.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273241371.22438.81.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:09:31AM -0400, Steven Rostedt wrote:
> > > +#define DECLARE_TRACE(name, proto, args)				\
> > > +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> > > +				PARAMS(proto, void *__data),		\
> > > +				PARAMS(args, __data))
> > >  
> > >  #define DEFINE_TRACE_FN(name, reg, unreg)				\
> > >  	static const char __tpstrtab_##name[]				\
> > > @@ -100,19 +133,37 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> > >  	struct tracepoint *end);
> > >  
> > >  #else /* !CONFIG_TRACEPOINTS */
> > > -#define DECLARE_TRACE(name, proto, args)				\
> > > -	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> > > -	{ }								\
> > > +#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
> > >  	static inline void trace_##name(proto)				\
> > > -	{ }								\
> > > +	{								\
> > > +	}								\
> > >  	static inline int register_trace_##name(void (*probe)(proto))	\
> > >  	{								\
> > >  		return -ENOSYS;						\
> > >  	}								\
> > > -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> > > +	static inline int unregister_trace_##name(void (*probe)(proto)) \
> > > +	{								\
> > > +		return -ENOSYS;						\
> > > +	}								\
> > > +	static inline int						\
> > > +	register_trace_##name##_data(void (*probe)(data_proto),		\
> > > +				     void *data)			\
> > > +	{								\
> > > +		return -ENOSYS;						\
> > > +	}								\
> > > +	static inline int						\
> > > +	unregister_trace_##name##_data(void (*probe)(data_proto),	\
> > > +				       void *data)			\
> > >  	{								\
> > >  		return -ENOSYS;						\
> > >  	}
> > > +#define DECLARE_TRACE_NOARGS(name)					\
> > > +		__DECLARE_TRACE(name, void, , void *__data, __data)
> > > +
> > > +#define DECLARE_TRACE(name, proto, args)				\
> > > +		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
> > > +				PARAMS(proto, void *__data),		\
> > > +				PARAMS(args, __data))
> > 
> > 
> > 
> > 
> > It seems that the on and off cases are exactly the same for DECLARE_TRACE*(),
> > you could provide a single version and let the __DECLARE_TRACE() do
> > the on/off trick.
> 
> 
> I don't know what you mean here. How would __DECLARE_TRACE() do what
> both DECLARE_TRACE() and DECLARE_TRACE_NOARGS() do? It will fail the
> compile if proto is "void".



No, what I meant is that you have:

#ifdef CONFIG_TRACEPOINTS
[...]
+#define DECLARE_TRACE_NOARGS(name)                                       \
      __DECLARE_TRACE(name, void, , void *__data, __data)

#define DECLARE_TRACE(name, proto, args)                         \
      __DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),      \
                      PARAMS(proto, void *__data),            \
                      PARAMS(args, __data))
[...]
#else
[...]
+#define DECLARE_TRACE_NOARGS(name)                                       \
      __DECLARE_TRACE(name, void, , void *__data, __data)

#define DECLARE_TRACE(name, proto, args)                         \
      __DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),      \
                      PARAMS(proto, void *__data),            \
                      PARAMS(args, __data)
[...]
#endif


See? They seem to be the exact same version, so this could be only
one version outside the ifdef.
And the CONFIG_TRACEPOINTS on/off case is dealt from __DECLARE_TRACE().

