Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0G2B6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:58:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0G2B63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JdSXz9MLl+uFGZCzV5rV1MMImIyOy6c9W+1AlZZfAh0mZqXLn0UtcGGiMKsvF+0o3g
         RoHdHvpw5JWQZI0PrHqlrcm7ZYFezXNpD/NGQxsksjH5u01X+IENsedIrjFVt07QTRsM
         0UfQhUHa/4YH2BMNlhigb0rX1yynEpL/FjCG4=
Date: Thu, 29 Jul 2010 03:58:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] ftrace: record command lines at more appropriate
	moment
Message-ID: <20100729015832.GC13088@nowhere>
References: <1280284180-17863-1-git-send-email-imunsie@au1.ibm.com> <4C4F9C3A.6020406@cn.fujitsu.com> <1280317404-sup-4657@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280317404-sup-4657@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 09:44:01PM +1000, Ian Munsie wrote:
> Excerpts from Li Zefan's message of Wed Jul 28 12:55:54 +1000 2010:
> > > @@ -1112,6 +1110,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
> > >  {
> > >      struct task_struct *tsk = current;
> > >  
> > > +    tracing_record_cmdline(tsk);
> > 
> > Now this function is called everytime a tracepoint is triggered, so
> > did you run some benchmarks to see if the performance is improved
> > or even worse?
> 
> Admittedly when I posted the patch I had not done that. For the below
> benchmark I isolated the trace_sched_switch tracepoint from the
> context_switch function (since it is called often) into it's own function
> (tp_benchmark) which I could then run the ftrace function profiler on
> while the tracepoint was active through debugfs.
> 
> On my test system there is a performance hit for an active event of
> ~0.233 us per event (which I have now reduced to ~0.127 us by inlining
> tracing_record_cmdline and trace_save_cmdline). At least that is only on
> active events as opposed to every single context switch as before.
> 
> Before:
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   .tp_benchmark                         1494    2699.670 us     1.807 us        0.536 us    
>   .tp_benchmark                          212    357.546 us      1.686 us        0.363 us    
>   .tp_benchmark                          215    389.984 us      1.813 us        0.404 us    
>   .tp_benchmark                          649    1116.156 us     1.719 us        0.626 us    
>   .tp_benchmark                          273    483.530 us      1.771 us        0.350 us    
>   .tp_benchmark                          333    599.600 us      1.800 us        0.378 us    
>   .tp_benchmark                          203    355.038 us      1.748 us        0.351 us    
>   .tp_benchmark                          270    473.222 us      1.752 us        0.360 us   
> 
> After existing patch:
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   .tp_benchmark                         1427    2815.906 us     1.973 us        0.623 us    
>   .tp_benchmark                          358    645.550 us      1.803 us        0.240 us    
>   .tp_benchmark                          437    867.762 us      1.985 us        0.684 us    
>   .tp_benchmark                          701    1445.618 us     2.062 us        0.906 us    
>   .tp_benchmark                          121    257.166 us      2.125 us        0.949 us    
>   .tp_benchmark                          162    329.536 us      2.034 us        0.671 us    
>   .tp_benchmark                          216    448.420 us      2.076 us        0.754 us    
>   .tp_benchmark                          238    452.244 us      1.900 us        0.384 us    
> 
> With inlining:
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   .tp_benchmark                         1478    2834.292 us     1.917 us        0.451 us    
>   .tp_benchmark                          316    583.166 us      1.845 us        0.227 us    
>   .tp_benchmark                          160    312.752 us      1.954 us        0.302 us    
>   .tp_benchmark                          687    1251.652 us     1.821 us        0.445 us    
>   .tp_benchmark                          177    352.310 us      1.990 us        0.451 us    
>   .tp_benchmark                          324    603.848 us      1.863 us        0.239 us    
>   .tp_benchmark                          150    284.444 us      1.896 us        0.343 us    
>   .tp_benchmark                          339    617.716 us      1.822 us        0.215 us    
> 
> 
> > Another problem in this patch is, tracing_generic_entry_update() is also
> > called by perf, but cmdline recoding is not needed in perf.
> 
> That's a good point - I could move the call into
> trace_buffer_lock_reserve so that perf does not get the unneeded
> overhead.  Actually there's probably no reason I couldn't put it in
> __trace_buffer_unlock_commit to avoid the overhead if the event has been
> filtered out.
> 
> Anyway, what do you think? Is the extra overhead per event acceptable?



In fact I don't really understand what is this tp_benchmark function, when and
where is it called?

But anyway, I'll rather comment the idea on the patch.

