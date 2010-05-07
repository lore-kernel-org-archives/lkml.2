Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0EGPPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:15:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0EGPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:15:42 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=HwkIGVdAOiAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=h-sSn279LmOJlxuotmkA:9 a=ONkIGXIUiewfI3AHDwsA:7 a=vZXaD3FV1N7IsW6oKWTI2UNIAvoA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <20100507150838.GB30356@Krystal>
References: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com>
	 <20100507143901.GA18408@Krystal>
	 <1273244123.22438.140.camel@gandalf.stny.rr.com>
	 <20100507150838.GB30356@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 11:15:38 -0400
Message-ID: <1273245338.22438.168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:08 -0400, Mathieu Desnoyers wrote:

> > > Can you show me where the C standard says it is safe to do so ?
> > 
> > No, but it seems safe in the kernel ;-)
> 
> The use of "seems" here does not give me a warm feeling of safety. ;)

Right, which is why I added the below.

> 
> > 
> > But that said. There is another option that will conform to this, and
> > that is to add flags to registering tracepoints. I already wrote a patch
> > for this in trying to do some other work (that I threw away).
> > 
> > 
> > So here's the proposal.
> > 
> > Change struct tracepoint_func to...
> > 
> > struct tracepoint_func {
> > 	void *func;
> > 	void *data;
> > 	unsigned int flags;
> > };
> > 
> > 
> > The flags is set when registered. If a function is registered with data,
> > then the flags field will be set. Then the calling of the function can
> > be:
> > 
> > 	if ((it_func_ptr)->flags & TP_FL_DATA)
> > 		((void(*)(proto, void *))(it_func)(args, __data);
> > 	else
> > 		((void(*)(proto))(it_func)(args);
> > 
> > This would comply with the C standard.
> 
> This would also add a branch on the tracing fast path, which I would like to
> avoid. Why can't we simply change all prototypes to take an extra void *__data
> parameter instead ?

I'm fine with making the data parameter mandatory with all tracers. Thus
the call back must require it. I would then move the data parameter from
the end to the beginning.

So a tracepoint with proto, will have a callback:

	void callback(void *data, proto);

I'm fine with forcing all callbacks to include a data parameter if you
are. This would also make the changes simpler.

-- Steve


