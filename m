Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1LTNKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:10:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1LTNKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:10:30 -0500
Date: Tue, 20 Dec 2011 14:10:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
Message-ID: <20111220131019.GA4393@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
 <1324321380.5916.26.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324321380.5916.26.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:03:00PM -0500, Steven Rostedt wrote:
> On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> > The current logic of updating calls is to do the mcount replacement
> > only when ftrace_ops is being registered. When ftrace_ops is being
> > unregistered then only in case it was the last registered ftrace_ops,
> > all calls are disabled.
> > 
> > This is an issue when ftrace_ops without FTRACE_OPS_FL_GLOBAL flag
> > is being unregistered, because all the functions stays enabled
> > and thus inherrited by global_ops, like in following scenario:
> > 
> >   - set restricting global filter
> >   - enable function trace
> >   - register/unregister ftrace_ops with flags != FTRACE_OPS_FL_GLOBAL
> >     and with no filter
> 
> I don't see this problem. I just changed stack_tracer to have its own
> filter (I've been wanting to do that for a long time, so when I saw this
> email, I decided it's a good time to implement it).
> 
> Here's what I did:
> 
> # echo schedule > set_ftrace_filter
> # cat set_ftrace_filter
> schedule
> # cat enabled_functions
> schedule (1)
> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
> # cat enabled_functions
> do_one_initcall (1)
> match_dev_by_uuid (1)
> name_to_dev_t (1)
> idle_notifier_unregister (1)
> idle_notifier_register (1)
> start_thread_common.constprop.6 (1)
> enter_idle (1)
> exit_idle (1)
> cpu_idle (1)
> __show_regs (1)
> release_thread (1)
> [...]
> _cond_resched (1)
> preempt_schedule_irq (1)
> schedule (2)
> io_schedule (1)
> yield_to (1)
> yield (1)
> 
> // note that schedule is (2)
> 
> # echo 0 > /proc/sys/kernel/stack_tracer_enabled
> # cat enabled_functions
> schedule (1)
> 
> 
> > 
> > Now the global_ops will get by all the functions regardless the
> > global_ops filter. So we need all functions that where enabled via
> > this ftrace_ops and are not part of global filter to be disabled.
> 
> The global functions are not at issue here. What do you see?
> 
> Maybe I fixed something as I'm using the latest tip/perf/core. Note, I
> can send you the stack_tracer patch if you want to take a look at this
> example. I need to clean it up too.

that would be great, thanks

> 
> > 
> > Note, currently if there are only global ftrace_ops registered,
> > there's no filter hash check and the filter is represented only
> > by enabled records.
> > 
> > Changing the ftrace_shutdown logic to ensure the replacement
> > is called for each ftrace_ops being unregistered.
> > 
> > Also changing FTRACE_ENABLE_CALLS into FTRACE_UPDATE_CALLS
> > calls which seems more suitable now.
> 
> I still think this patch is wrong. What's the problem you are seeing?

let me try with an example..

say we have only 2 traceable functions - A and B ;)

1) set global filter for function A with 'echo A > ./set_ftrace_filter'
	a - A is put to the global_ops filter

2) enable function trace with 'echo function > current_tracer'
	a - register_ftrace_function is called with function trace ftrace_ops (GLOBAL flag)
	b - update_ftrace_function is called, setting ftrace_ops callback function
	    to be called directly from the assembly entry_* code
	c - ftrace_hash_rec_enable is called, and dyn_ftrace record
	    for function A is updated:
		A::flags|FL_MASK = 1
	d - ftrace_replace_code(1) is called, and function A is
	    brought in to life

3) enable function trace via perf ftrace_ops
	a - register_ftrace_function is called with perf event ftrace_ops (!GLOBAL flag)
	b - update_ftrace_function is called, setting ftrace_ops_list_func
	    function to be called from the assembly entry_* code and
	    handle the ftrace_ops' dispatch
	c - ftrace_hash_rec_enable is called, and A and B dyn_ftrace records
	    are updated:
		A::flags|FL_MASK = 2
		B::flags|FL_MASK = 1
	d - ftrace_replace_code(1) is called, and function B is
	    brought in to life

4) disable function trace via perf ftrace_ops
	a - unregister_ftrace_function is called with perf event ftrace_ops (same as in step 3)
	b - update_ftrace_function is called, setting global ftrace_ops (from step 2)
	    callback function to be called directly from the assembly entry_* code
	c - ftrace_hash_rec_disable is called, and A and B dyn_ftrace
	    records are updated:
		A::flags|FL_MASK = 1
		B::flags|FL_MASK = 0
	d - ??? see below..

Now, only the global function trace ftrace_ops is enabled (from step 2),
but both A and B are alive and feeding the tracer despite its filter (function A),
because its ftrace_ops is directly linked to the assembly entry_* code (step 4b).

The reason is that even though we updated the B's dyn_ftrace record (step 4c)
to be 'B::flags|FL_MASK == 0', we did not update the B call itself and disable it.

If we'd call ftrace_replace_code(1) at 4d), the B function would be
disabled, and we would get expected behaviour.

So thats the reason I think we should update the calls (mcount call code)
each time we unregister the ftrace_ops, because some records could be
enabled only for the specific ftrace_ops and we need to put them down
when we disable this ftrace_ops.


hopefully it make any sense.. :)

thanks,
jirka
