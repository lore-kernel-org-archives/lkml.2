Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1K1UJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:09:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1K1UJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:09:08 -0500
Message-ID: <1322510931.2921.170.camel@twins>
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:08:51 +0100
In-Reply-To: <1322510318.17003.14.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 14:58 -0500, Steven Rostedt wrote:
> > +static int perf_ftrace_function_register(struct perf_event *event)
> > +{
> > +     struct ftrace_ops *ops = &event->ftrace_ops;
> > +
> > +     ops->flags |= FTRACE_OPS_FL_CONTROL;
> > +     atomic_set(&ops->disabled, 1);
> > +     ops->func = perf_ftrace_function_call;
> > +     return register_ftrace_function(ops);
> 
> When is ADD called? Because as soon as you register this function, even
> though you have it "disabled" the system takes about a 13% impact on
> performance just by calling this.

Typically at context switch time.

> > +static void perf_ftrace_function_enable(struct perf_event *event)
> > +{
> > +     struct ftrace_ops *ops = &event->ftrace_ops;
> > +     enable_ftrace_function(ops);
> 
> Is it really an issue that we shouldn't call the full blown register
> instead? I'm not really understanding why this is a problem. Note, one
> of the improvements to ftrace in the near future is to enable ftrace
> without stop_machine. 

Yeah, but still not something you want to do during context switches,
right?
