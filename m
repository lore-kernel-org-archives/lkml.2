Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1K2LVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:21:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1K2LVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:21:51 -0500
Date: Tue, 29 Nov 2011 12:21:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] ftrace: Fix shutdown to disable calls properly
Message-ID: <20111129112140.GD1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-4-git-send-email-jolsa@redhat.com>
 <1322507928.17003.7.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322507928.17003.7.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 02:18:48PM -0500, Steven Rostedt wrote:
> On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> > Each ftrace_startup call increases the call record's flag,
> > so we need allways to decrease it when shutting down the
> > ftrace_ops.
> 
> No, that's not how this works. I probably should comment this code
> better, because it caused me to reread it too ;)
> 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/ftrace.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index c6d0293..0ca0c0d 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1744,8 +1744,7 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
> >  	if (ops != &global_ops || !global_start_up)
> >  		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
> >  
> > -	if (!ftrace_start_up)
> > -		command |= FTRACE_DISABLE_CALLS;
> > +	command |= FTRACE_DISABLE_CALLS;
> 
> FTRACE_DISABLE_CALLS will disable *all* functions for all tracers. If
> you are tracing with ftrace and perf, and one calls this with
> FTRACE_DISABLE_CALLS then both will no long be tracing anything.
> 
> When you call unregister_ftrace_function() it will disable the functions
> that you have enabled by the ops.
> 
> Nacked-by: Steven Rostedt <rostedt@goodmis.org.

ops, should read/test more carefully.. however the problem stays, here's
one possible scenario of the issue:

	- enable function trace like:
		echo "mm_*" > ./set_ftrace_filter 
		echo function > ./current_tracer 
	- run:
		./perf record  -e ftrace:function cal
		- this runs: register_ftrace_function/unregister_ftrace_function

	- bad result: after perf is finished, function trace will have all the functions enabled

The reason is, that after the perf record calls unregister_ftrace_function,
only the functions' record flags (struct dyn_ftrace::flags) are changed, but
functions' mcount calls are not replaced accordingly.

In our case, when function trace becomes again the only tracer, it will be
plugged directly into the entry_BIT.S code, and thus getting all the functions
from previous perf ftrace_ops without any filtering.

I think we need to project the function record flags state into the
function call replacement during the unregister_ftrace_function.

jirka

> 
> -- Steve
> 
> 
> >  
> >  	if (saved_ftrace_func != ftrace_trace_function) {
> >  		saved_ftrace_func = ftrace_trace_function;
> 
> 
