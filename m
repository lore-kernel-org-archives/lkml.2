Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab0D3RVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:21:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab0D3RUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:20:38 -0400
X-Authority-Analysis: v=1.1 cv=m27xf9DC4olkrNDaWzGlhfWN1WyLlD0+t5Z5YaFh7bA= c=1 sm=0 a=khrRrPIfVHAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=Vf2hoa83DMIxToDjmyoA:9 a=nsuG50dEblcvOlq5_6Rz9BDF7qwA:4 a=PUjeQqilurYA:10 a=WMe4tq3x45HqZ2jx:21 a=RxJ6P11oiNK1KP8X:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/10][RFC] tracing: Move fields from event to class
 structure
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
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20100429133213.GA14617@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200242.470116062@goodmis.org> <20100428205803.GF8591@Krystal>
	 <1272499342.9739.88.camel@gandalf.stny.rr.com>
	 <20100429133213.GA14617@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 29 Apr 2010 09:50:32 -0400
Message-ID: <1272549033.9739.120.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 09:32 -0400, Mathieu Desnoyers wrote:

> OK, just to make sure I understand what we currently have and how I
> could deal with it:
> 
> Let's say syscall_entry has ID 17 in the event header. Let's suppose its
> first field is the system call number (an unsigned short). This system
> call number will determine the following binary format (how many fields
> recorded in the event) and the metadata telling how to print these
> fields as well.
> 
> So for a syscall_entry event, we could have metadata describing it
> (I'm doing an ad-hoc metadata format here, don't mind about the exact
> formulation for now). The first field value would determine the type
> cast of the following fields:
> 
> event {
>   name: syscall_entry;
>   id: 17;
>   field {
>     name: syscall_id;
>     type: unsigned short;
>     typecast: syscall_entry_params;
>   }
>   typecast {
>     name: syscall_entry_params;
>     map {
>       value: 0;  /* sys_read on x86_64 */
>       field {
>         type: unsigned int;
>         name: fd;
>       }
>       field {
>         type: char __user *;
>         name: buf;
>       }
>       field {
>         type: size_t;
>         name: count;
>       }
>     }
>    map {
>      value: 1;	/* sys_write on x86_64 */
>      ....
>   }
>   and so on for all other ......
> }
> 
> Does that look correct ? Maybe I'm just re-doing something already
> existing, so I prefer to ask first.

I'm a little confused by your example, but perhaps you are describing
what we already have.

All syscall_entrys have the same class, and all syscall_exits have their
own too.

What each syscall has separate is a meta-data, which is unique to
syscalls, and normal TRACE_EVENT()s do not have them. It is put in the
call->private field.

So what we have is:

struct ftrace_event_class event_class_syscall_enter;


This handles the printing of most of the data. What it does not cover is
how to print the parameters of the syscall itself. The meta-data is
created per syscall that specifies the syscalls parameters.

And the same metadata is used by both the syscall enter and exit events.
The meta data is described in include/trace/syscalls.h

struct syscall_metadata {
	cost char	*name;
	int		syscall_nr;
	int		nb_args;
	const char	**types;
	const char	**args;

	struct ftrace_event_call *enter_event;
	struct ftrace_event_call *exit_event;
};


Here the description is how to print the syscall parameters.

I don't see how we can group it any better, without manually doing it.

Hope this explains things better.

-- Steve


