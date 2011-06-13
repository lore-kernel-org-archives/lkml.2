Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1FMLjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:39:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1FMLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:39:47 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=1ZhljathgHUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=D19gQVrFAAAA:8 a=b0PbnzpxkEkjc0M2Li4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism
 for buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110613101248.GC30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172910.950101158@goodmis.org>  <20110613101248.GC30962@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:39:45 -0400
Message-ID: <1307965185.9218.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:12 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +	switch (cmd) {
> > +	case TRACE_RINGBUF_FREE_ON_CLOSE: {
> > +		info->free_buffer_on_close = !!arg;
> > +		ret = 0;
> > +		break;
> > +	}
> >  	}
> 
> that doesn't look very tidy.
> 
> > @@ -3635,9 +3700,12 @@ static const struct file_operations tracing_pipe_fops = {
> >  };
> >  
> >  static const struct file_operations tracing_entries_fops = {
> > -	.open		= tracing_open_generic,
> > +	.open		= tracing_entries_open,
> >  	.read		= tracing_entries_read,
> >  	.write		= tracing_entries_write,
> > +	.unlocked_ioctl	= tracing_entries_ioctl,
> > +	.compat_ioctl	= tracing_entries_ioctl,
> 
> i don't like it at all that you are adding to the ftrace ABI here. 
> The *only* premise of the whole /debug/tracing/ muck was to allow it 
> to be human-parseable and scripted - an ioctl is clearly outside that 
> scope. Instead of increasing the mess in /debug/tracing/ we want 
> clean tracing done via the perf ABI ...

Vaibhav originally suggested adding a "buffer_free" file that you could
write into and cause it to free the buffer. It would do this on the
release so you could also have an app (like Google needs) to open this
file and if the app dies, it will automatically free the buffer closing
it.

https://lkml.org/lkml/2011/3/17/366

I didn't really like adding another file to the debugfs system, and
recommended the ioctl. It seemed like a nice "unix" fit. But if you want
to go back to the Vaibhav's original method, which will stay in the
frame of "human-parseable and scripted". We could do that.

-- Steve


