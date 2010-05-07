Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0EGOz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:55:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0EGOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:55:26 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=HwkIGVdAOiAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=2IemZA3HlO9qZh5dc-MA:9 a=Hey8zEur1oYf-i7WRRIA:7 a=cUY3lqaShVXXFC6PmlKPgg9MAEQA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have
 data?passed to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100507143901.GA18408@Krystal>
References: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com>
	 <20100507143901.GA18408@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 10:55:23 -0400
Message-ID: <1273244123.22438.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 10:39 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > 
> > "Frederic Weisbecker" <fweisbec@gmail.com> wrote:
> > 
> > >On Mon, May 03, 2010 at 11:40:47PM -0400, Steven Rostedt wrote:
> [...]
> > >> 
> > >> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > >> index 78b4bd3..ee8059a 100644
> > >> --- a/include/linux/tracepoint.h
> > >> +++ b/include/linux/tracepoint.h
> > >> @@ -20,12 +20,17 @@
> > >>  struct module;
> > >>  struct tracepoint;
> > >>  
> > >> +struct tracepoint_func {
> > >> +	void *func;
> > >> +	void *data;
> > >> +};
> > >> +
> > >>  struct tracepoint {
> > >>  	const char *name;		/* Tracepoint name */
> > >>  	int state;			/* State. */
> > >>  	void (*regfunc)(void);
> > >>  	void (*unregfunc)(void);
> > >> -	void **funcs;
> > >> +	struct tracepoint_func *funcs;
> > >>  } __attribute__((aligned(32)));		/*
> > >>  					 * Aligned on 32 bytes because it is
> > >>  					 * globally visible and gcc happily
> > >> @@ -46,14 +51,18 @@ struct tracepoint {
> > >>   */
> > >>  #define __DO_TRACE(tp, proto, args)					\
> > >>  	do {								\
> > >> -		void **it_func;						\
> > >> +		struct tracepoint_func *it_func_ptr;			\
> > >> +		void *it_func;						\
> > >> +		void *__data;						\
> > >>  									\
> > >>  		rcu_read_lock_sched_notrace();				\
> > >> -		it_func = rcu_dereference_sched((tp)->funcs);		\
> > >> -		if (it_func) {						\
> > >> +		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
> > >> +		if (it_func_ptr) {					\
> > >>  			do {						\
> > >> -				((void(*)(proto))(*it_func))(args);	\
> > >> -			} while (*(++it_func));				\
> > >> +				it_func = (it_func_ptr)->func;		\
> > >> +				__data = (it_func_ptr)->data;		\
> > >> +				((void(*)(proto))(it_func))(args);	\
> > >
> > >
> > >So, we had a talk about this and we concluded that it is probably fine
> > >on every archs to push one more argument than needed in a function.
> > >
> > 
> > Yeah, I'm hoping it's fine.
> 
> How about changing the callback prototypes to match the call arguments (changing
> the type expected in register/unregister_trace, as well as an additional "check
> type" that I proposed for Ftrace) ?

This can not happen!!!! As I said before, the register is done in C,
there is no macro that will help here. We create the call back with the
macro, but the registering is in kernel/trace/trace_events.c. One
register for ___ALL___ events!!!

 Thus there is no check.

Understand this yet?


> 
> Otherwise, you basically expect here that:
> 
> void fct(void *foo, void *bar, etc etc) (N parameters expected)
> {
> 
> }
> 
> called by:
> 
> fct(foo, bar, etc etc, foobar) (N + 1 parameters)
> 
> will always work.
> 
> Can you show me where the C standard says it is safe to do so ?

No, but it seems safe in the kernel ;-)

But that said. There is another option that will conform to this, and
that is to add flags to registering tracepoints. I already wrote a patch
for this in trying to do some other work (that I threw away).


So here's the proposal.

Change struct tracepoint_func to...

struct tracepoint_func {
	void *func;
	void *data;
	unsigned int flags;
};


The flags is set when registered. If a function is registered with data,
then the flags field will be set. Then the calling of the function can
be:

	if ((it_func_ptr)->flags & TP_FL_DATA)
		((void(*)(proto, void *))(it_func)(args, __data);
	else
		((void(*)(proto))(it_func)(args);

This would comply with the C standard.

-- Steve


