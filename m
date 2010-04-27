Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0D0JGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:06:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0D0JGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:06:42 -0400
Message-ID: <4BD6A98D.6010706@cn.fujitsu.com>
Date: Tue, 27 Apr 2010 17:08:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 02/10][RFC] tracing: Let tracepoints have data passed
 to tracepoint callbacks
References: <20100426195024.256424113@goodmis.org> <20100426200241.631945432@goodmis.org>
In-Reply-To: <20100426200241.631945432@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch allows data to be passed to the tracepoint callbacks
> if the tracepoint was created to do so.
> 
> If a tracepoint is defined with:
> 
> DECLARE_TRACE_DATA(name, proto, args)
> 
> Then a registered function can also register data to be passed
> to the tracepoint as such:
> 
>   DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> 
>   /* In the C file */
> 
>   DEFINE_TRACE(mytracepoint, TP_PROTO(int status), TP_ARGS(status));
> 
>   [...]
> 
>        trace_mytacepoint(status);
> 
>   /* In a file registering this tracepoint */
> 
>   int my_callback(int status, void *data)
>   {
> 	struct my_struct my_data = data;
> 	[...]
>   }
> 
>   [...]
> 	my_data = kmalloc(sizeof(*my_data), GFP_KERNEL);
> 	init_my_data(my_data);
> 	register_trace_mytracepoint_data(my_callback, my_data);
> 
> The same callback can also be registered to the same tracepoint as long
> as the data registered is the same. Note, the data must also be used
> to unregister the callback:
> 
> 	unregister_trace_mytracepoint_data(my_callback, my_data);
> 
> Because of the data parameter, tracepoints declared this way can not have
> no args. That is:
> 
>   DECLARE_TRACE_DATA(mytracepoint, TP_PROTO(void), TP_ARGS());
> 
> will cause an error, but the original DECLARE_TRACE still allows for this.
> 
> The DECLARE_TRACE_DATA() will be used by TRACE_EVENT() so that it
> can reuse code and bring the size of the tracepoint footprint down.
> This means that TRACE_EVENT()s must have at least one argument defined.

We have to define at least on argument in TRACE_EVENT() even without
this patch, otherwise it'll cause compile error while expanding the
macros.

> This should not be a problem since we should never have a static
> tracepoint in the kernel that simply says "Look I'm here!".
> 

We do have such a tracepoint. ;)

That is trace_power_end, and it uses a dummy argument merely for
passing compilation.

