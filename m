Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0D1X41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:56:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42433 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0D1X4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:56:25 -0400
X-Authority-Analysis: v=1.1 cv=tamp8Om8S85MB4Qj1n2yU9kNzNdU9gdJUe8fX0YwrYg= c=1 sm=0 a=3VUK4oP7sswA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=P5QBW08gkczDmv96wIoA:9 a=ldxBhJukOkUELJBnrLwA:7 a=S0vGai5O-MCIPm_YB_PgWzVSU5YA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 02/10][RFC] tracing: Let tracepoints have data passed
 to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20100428203759.GC8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200241.631945432@goodmis.org>  <20100428203759.GC8591@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 28 Apr 2010 19:56:21 -0400
Message-ID: <1272498981.9739.84.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 16:37 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch allows data to be passed to the tracepoint callbacks
> > if the tracepoint was created to do so.
> > 
> > If a tracepoint is defined with:
> > 
> > DECLARE_TRACE_DATA(name, proto, args)
> > 
> > Then a registered function can also register data to be passed
> > to the tracepoint as such:
> > 
> >   DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> > 
> >   /* In the C file */
> > 
> >   DEFINE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> > 
> >   [...]
> > 
> >        trace_mytacepoint(status);
> > 
> >   /* In a file registering this tracepoint */
> > 
> >   int my_callback(int status, void *data)
> >   {
> > 	struct my_struct my_data = data;
> > 	[...]
> >   }
> > 
> >   [...]
> > 	my_data = kmalloc(sizeof(*my_data), GFP_KERNEL);
> > 	init_my_data(my_data);
> > 	register_trace_mytracepoint_data(my_callback, my_data);
> > 
> > The same callback can also be registered to the same tracepoint as long
> > as the data registered is the same. Note, the data must also be used
> > to unregister the callback:
> > 
> > 	unregister_trace_mytracepoint_data(my_callback, my_data);
> > 
> > Because of the data parameter, tracepoints declared this way can not have
> > no args. That is:
> > 
> >   DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(void), TP_ARGS());
> > 
> > will cause an error, but the original DECLARE_TRACE still allows for this.
> > 
> > The DECLARE_TRACE_DATA() will be used by TRACE_EVENT() so that it
> > can reuse code and bring the size of the tracepoint footprint down.
> > This means that TRACE_EVENT()s must have at least one argument defined.
> > This should not be a problem since we should never have a static
> > tracepoint in the kernel that simply says "Look I'm here!".
> > 
> 
> I'm not convinced DECLARE_TRACE_DATA() is an appropriate name. Sounds
> confusing. What kind of data is this ? It is not obvious that this
> refers to callback private data.

Well, looking at the examples, it's pretty obvious what data is ;-)

> 
> Why can't we just extend the existing DECLARE_TRACE() instead and add a
> "callback_data" argument (or something slightly less verbose) ? We can
> update all users anyway.
> 
> We can also create a variant when there are no arguments passed:
> 
> DECLARE_TRACE_NOARG()

I have no problem with modifying DECLARE_TRACE() this way. In fact that
was the original way I did it. I was just concerned about changing the
fact that DECLARE_TRACE() no longer allows for (void), and it breaks
your example in the samples dir.

We can make DECLARE_TRACE() add the callback data, and add a NOARG()
version for those that do not have any args.


> 
> We had to do the same for the Linux kernel markers in the past. Then we
> can create a TRACE_EVENT_NOARG() macro if necessary.

Hmm, this may be difficult, since the TRACE_EVENT() requires passing of
a arg. I guess we can make NOARG will just ignore the "arg" value.

> 
> I don't think it makes sense to require users to pass arguments. It
> should be possible to just say "I'm here". Cases where this could make
> sense includes cases where we'd only be interested in global variables
> at a specific tracepoint.

Well, as Li just pointed out, we already require it ;-)

Not a big deal, we can add a noarg version in the future, but this is
the cost for doing advance work with CPP.

-- Steve


