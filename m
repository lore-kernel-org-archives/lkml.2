Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0GHOR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:17:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0GHORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:17:24 -0400
X-Authority-Analysis: v=1.1 cv=FmZLatDjtfD3C7oE6GdrxaCbsxiNBR9ZXBX9JZchN1o= c=1 sm=0 a=zNANCjgXmV0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=vEas5-0IiIlQYgzUsbMA:9 a=G9dWNWxNfB19uy5sRXsA:7 a=fcsNZq6nQW9rcq4acdgf6Nrs5QEA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.35 regression
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100708140854.GA11983@merkur.ravnborg.org>
References: <loom.20100705T144459-919@post.gmane.org>
	 <20100708132237.GA22830@goodmis.org>
	 <20100708140854.GA11983@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 08 Jul 2010 10:17:22 -0400
Message-ID: <1278598643.1537.121.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 16:08 +0200, Sam Ravnborg wrote:

> In vmlinux.lds.h we have the following code:
> #define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
>                          *(__syscalls_metadata)                         \
>                          VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
> 
> But there is nothing that guarantee that
> __syscalls_metadata starts at the address
> assigned to __start_syscalls_metadata.
> 
> The will align __syscalls_metadata accoding to the
> largest member in that section.
> 
> We need to do one of two things:
> 1) Make sure __start_syscalls_metadata is properly aligned
> 2) or make the code robust against misaligned symbols.

1 is much easier to do than 2, so I would say we need to do 1.

Hmm, looking at include/linux/syscalls.h:

#define SYSCALL_TRACE_ENTER_EVENT(sname)				\
	static const struct syscall_metadata __syscall_meta_##sname;	\
	static struct ftrace_event_call					\
	__attribute__((__aligned__(4))) event_enter_##sname;		\
	static struct trace_event enter_syscall_print_##sname = {	\
		.trace                  = print_syscall_enter,		\
	};								\
	static struct ftrace_event_call __used				\
	  __attribute__((__aligned__(4)))				\
	  __attribute__((section("_ftrace_events")))			\
	  event_enter_##sname = {					\

The __syscall_meta_##sname is not forced aligned. The forced 4 byte
alignment compacts the code in a nice array, as the event_enter_##sname
is done.


> 
> > 
> > Zeev, can you try to reproduce it with gcc 4.4.
> > 
> > And for now could you send me the output of this:
> > 
> >  objdump -Dr --start-addr 0x`nm vmlinux | grep __start_syscalls_metadata | cut -d' ' -f 1` \
> >     --stop-addr 0x`nm vmlinux | grep __stop_syscalls_metadata | cut -d' ' -f 1` vmlinux
> > 
> This output would be great to have just to check if my assumption above is correct.

Yeah, that's why I asked about it. I want to confirm it too. I think
adding the align attribute to the meta data will fix it.

-- Steve


