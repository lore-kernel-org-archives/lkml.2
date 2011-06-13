Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1FMLtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:49:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1FMLtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:49:20 -0400
Date: Mon, 13 Jun 2011 13:49:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism for
 buffer_size_kb
Message-ID: <20110613114904.GD10960@elte.hu>
References: <20110609172744.333794089@goodmis.org>
 <20110609172910.950101158@goodmis.org>
 <20110613101248.GC30962@elte.hu>
 <1307965185.9218.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307965185.9218.53.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2011-06-13 at 12:12 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > +	switch (cmd) {
> > > +	case TRACE_RINGBUF_FREE_ON_CLOSE: {
> > > +		info->free_buffer_on_close = !!arg;
> > > +		ret = 0;
> > > +		break;
> > > +	}
> > >  	}
> > 
> > that doesn't look very tidy.
> > 
> > > @@ -3635,9 +3700,12 @@ static const struct file_operations tracing_pipe_fops = {
> > >  };
> > >  
> > >  static const struct file_operations tracing_entries_fops = {
> > > -	.open		= tracing_open_generic,
> > > +	.open		= tracing_entries_open,
> > >  	.read		= tracing_entries_read,
> > >  	.write		= tracing_entries_write,
> > > +	.unlocked_ioctl	= tracing_entries_ioctl,
> > > +	.compat_ioctl	= tracing_entries_ioctl,
> > 
> > i don't like it at all that you are adding to the ftrace ABI here. 
> > The *only* premise of the whole /debug/tracing/ muck was to allow it 
> > to be human-parseable and scripted - an ioctl is clearly outside that 
> > scope. Instead of increasing the mess in /debug/tracing/ we want 
> > clean tracing done via the perf ABI ...
> 
> Vaibhav originally suggested adding a "buffer_free" file that you 
> could write into and cause it to free the buffer. It would do this 
> on the release so you could also have an app (like Google needs) to 
> open this file and if the app dies, it will automatically free the 
> buffer closing it.
> 
> https://lkml.org/lkml/2011/3/17/366
> 
> I didn't really like adding another file to the debugfs system, and 
> recommended the ioctl. It seemed like a nice "unix" fit. But if you 
> want to go back to the Vaibhav's original method, which will stay 
> in the frame of "human-parseable and scripted". We could do that.

Yes, i think so - the *only* point of the /debug/tracing/ muck is 
that it's scriptable and human parseable. If Google wants to use it 
for more than that then they should help us enhance the perf syscall 
ABI for tracing ...

Thanks,

	Ingo
