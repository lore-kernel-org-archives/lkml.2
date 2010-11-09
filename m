Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KIBo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:44:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:53350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0KIBoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:44:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,172,1288594800"; 
   d="scan'208";a="675577413"
Date: Tue, 9 Nov 2010 09:44:39 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Tracing: do export trace_set_clr_event
Message-ID: <20101109014439.GA32721@localhost.localdomain>
References: <1289196312-25323-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20101108095610.GA22592@infradead.org>
 <5b55a1$ijitko@fmsmga002.fm.intel.com>
 <1289224934.12418.1.camel@gandalf.stny.rr.com>
 <20101108141420.GA12548@infradead.org>
 <1289226184.12418.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289226184.12418.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 09:23:04AM -0500, Steven Rostedt wrote:
> On Mon, 2010-11-08 at 09:14 -0500, Christoph Hellwig wrote:
> > On Mon, Nov 08, 2010 at 09:02:14AM -0500, Steven Rostedt wrote:
> > > I like the trace=on parameter much better. If that is set we could
> > > enable the tracepoints of that module at load time. I really do not want
> > > to export the function that was proposed in that patch.
> > 
> > Yes.  Adding generic support in the module loader to turn on tracepoint
> > seems like the much better long term strategy.  Even better if it allows
> > turning on individual points instead of all or nothing.
> 
> I was thinking the same. How about this:
> 
> trace=1  - all tracepoints in the module is enabled
> trace=0  - same as leaving it off
> 
> trace=name - a specific tracepoint is enabled, using the simple globs
> that set_event allows.
> 
> trace=name1,name2,name3  - for more than one tracepoint.

Yes, agreed. I thought that's the way to make a generate interface for
active trace event on module load.

I have some other ideas for this:
1. For make it be consistent with the Documentation/trace/events.txt, I
   guess we should use:
   trace=*     - all tracepoints in the module is enabled
   trace=NULL  - same as leaving it off

2. How about make it be module specific? Since there is aready a global
   boot option for this: trace_event=[event_list], which doesn't work if
   the coresponding event doesn't exist. I think it's the module's task
   to enable it's own event at load time. Take i915 module as example, if
   user put something like following in the boot command line:

   i915.trace=i915_reg_rw,i915_gem_object_create

   then the i915 module will try to enable these two envent at the init
   function.

   so, how about the following pseudo-code which should be in trace_events.c:

void trace_enable_module_event(struct module *mod, const char *event_list)
{
	for_each_token(token, event_list) {
		for_each_event(event, mod->trace_events) {
			if (strcmp(mod->name, token) == 0) 
				ftrace_set_clr_event(token, 1);
		}
	}
}


   then, on the i915 side:
   i915_init ()
{
	....
	....
	if (event_list)
		trace_enable_module_event(THIS_MODULE, i915_trace);
	...
}


Comments?

Thanks,

--
Yuanhan Liu
