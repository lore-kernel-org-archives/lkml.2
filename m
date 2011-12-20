Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1LTO6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:58:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1LTO55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:57:57 -0500
Date: Tue, 20 Dec 2011 15:57:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Christoph Lameter <christoph@lameter.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 03/10] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20111220145727.GB4393@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-4-git-send-email-jolsa@redhat.com>
 <1324323335.5916.46.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324323335.5916.46.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:35:35PM -0500, Steven Rostedt wrote:
> On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> >  
> > +static inline void enable_ftrace_function(struct ftrace_ops *ops)
> > +{
> > +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> > +	atomic_dec(disabled);
> > +}
> > +
> > +static inline void disable_ftrace_function(struct ftrace_ops *ops)
> > +{
> > +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> > +	atomic_inc(disabled);
> > +}
> > +
> 
> The above should be renamed to ftrace_function_enable/disable(), and
> they should pass in the cpu. There may be a case we want to disable
> ftrace functions on another CPU.
> 
> Not to mention, this is the perfect example of "this_cpu_ptr" being used
> incorrectly. It's not made for this purpose, and again the naming of
> "this_cpu" totally confuses other kernel developers. We need to change
> this name as it was agreed to at Kernel Summit.

ok, will make the changes

> 
> If the above is called with preemption enabled, it will not do what is
> expected. We could disable function tracing on one CPU and then
> re-enable it for another CPU even though it is already enabled.

It is only called inside perf reg callback within the
schedule function where the preemption is disabled.

The ftrace_function_enable is called when task is scheduled in
on respective cpu. Likewise the ftrace_function_disable is called 
when task is scheduled out on respective cpu.

thanks,
jirka
