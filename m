Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2FNRHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:07:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2FNRHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:07:07 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=F9W-Qb2LExiYUY8_IJsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339693625.13377.242.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 14 Jun 2012 13:07:05 -0400
In-Reply-To: <20120614154153.GD17140@kroah.com>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
	 <20120614045930.GA10508@kroah.com>
	 <1339671715.13377.209.camel@gandalf.stny.rr.com>
	 <20120614154153.GD17140@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 08:41 -0700, Greg Kroah-Hartman wrote:
>  
> > But I find that ugly ;-)
> 
> I find printk_flush() ugly :)
> 

I guess beauty is really in the eye of the beholder.

> > I know you can argue that the extra timestamp may be ugly too, but we
> > can work that out as well. I was just too tired to do so last night and
> > wanted to kick off the discussion before I got too tied up in other
> > things.
> > 
> > Currently we have something like this:
> > 
> > [    6.834073] Testing tracer function: [    7.136194] PASSED
> > [    7.567062] Testing dynamic ftrace: PASSED
> > [    8.053670] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 18) (2 2 4 1 37) PASSED
> > [    8.566062] Testing dynamic ftrace ops #2: (1 0 1 7 0) (1 1 2 38 0) (2 1 3 1 6) (2 2 4 36 36) PASSED
> 
> That's ugly to me :)

No no, that's pretty to you. Maybe meaningless, but pretty!

> 
> > [    8.596063] Testing tracer irqsoff: [    9.014064] PASSED
> > [    9.038062] Testing tracer wakeup: [    9.681063] PASSED
> > [    9.705066] Testing tracer wakeup_rt: [   10.347064] PASSED
> > [   10.371063] Testing tracer function_graph: [   10.876064] PASSED
> > 
> > I didn't fix the dynamic ftrace ops #1 and #2 to flush, but that should
> > too, as each set of (1 0 1 1 0) etc, numbers are important, and is a
> > separate test. That could lock up the system as well and knowing where
> > it locked up is key to debugging.
> > 
> > To make this work with the current printk, I have to do:
> > 
> > Tracer function test started
> > Tracer function test succeeded
> > Tracer dynamic ftrace test started
> > Tracer dynamic ftrace test succeeded
> > Tracer dynamic ftrace ops #1 test started
> > (1 0 1 1 0)
> > (1 1 2 1 0)
> > (2 1 3 1 18)
> > (2 2 4 1 37)
> 
> I suggest better prefixes here.

And let people in on my secret (well, without having to read the
code) ;-)

> 
> > Tracer dynamic ftrace ops #1 test succeeded
> > Tracer dynamic ftrace ops #2 test started
> > (1 0 1 7 0)
> > (1 1 2 38 0)
> > (2 1 3 1 6)
> > (2 2 4 36 36)
> 
> And here.
> 
> > Tracer dynamic ftrace ops #2 succeeded
> > Tracer irqsoff test started
> > Tracer irqsoff test succeeded
> > Tracer wakeup test started
> > Tracer wakeup test succeeded
> > Tracer wakeup_rt test started
> > Tracer wakeup_rt test succeeded
> > Tracer function_graph test started
> > Tracer function_graph test succeeded
> > 
> > 
> > Yes, this would give us the functionality of today but more lines of
> > text on the output line. Then we have to worry about the trace event
> > tests:
> 
> So what?  You are doing development tests, it's ok to print out a lot of
> messages, that is what you want to see, especially when something fails,
> right?

I actually would like to make these more compact. As all my test box
consoles go through serial ports, just booting through this takes more
time the the compile itself.

> 
> > [   72.177731] Testing event rpc_bind_status: OK
> > [   72.187100] Testing event rpc_connect_status: OK
> > [   72.196501] Testing event rpc_task_begin: OK
> > [   72.205504] Testing event rpc_task_run_action: OK
> > [   72.214487] Testing event rpc_task_complete: OK
> > [   72.223504] Testing event rpc_task_sleep: OK
> > [   72.232500] Testing event rpc_task_wakeup: OK
> > [   72.241504] Testing event kfree_skb: OK
> > [   72.249486] Testing event consume_skb: OK
> > [   72.257504] Testing event skb_copy_datagram_iovec: OK
> > [   72.267500] Testing event net_dev_xmit: OK
> > [   72.276486] Testing event net_dev_queue: OK
> > [   72.285504] Testing event netif_receive_skb: OK
> > [   72.294486] Testing event netif_rx: OK
> > [   72.302504] Testing event napi_poll: OK
> > [   72.310486] Testing event sock_rcvqueue_full: OK
> > [   72.319504] Testing event sock_exceed_buf_limit: OK
> > [   72.328486] Testing event udp_fail_queue_rcv_skb: OK
> > [   72.337503] Testing event hda_send_cmd: OK
> > [   72.346501] Testing event hda_get_response: OK
> > [   72.355503] Testing event hda_bus_reset: OK
> > [   72.364501] Testing event hda_power_down: OK
> > [   72.373503] Testing event hda_power_up: OK
> > [   72.382500] Testing event hda_unsol_event: OK
> > [   72.391504] Testing event scsi_dispatch_cmd_start: OK
> > [   72.401501] Testing event scsi_dispatch_cmd_error: OK
> > [   72.411487] Testing event scsi_dispatch_cmd_done: OK
> > [   72.420503] Testing event scsi_dispatch_cmd_timeout: OK
> > [   72.430501] Testing event scsi_eh_wakeup: OK
> > [   72.439505] Testing event i915_gem_object_create: OK
> > [   72.448486] Testing event i915_gem_object_bind: OK
> > [   72.457504] Testing event i915_gem_object_unbind: OK
> > [   72.466487] Testing event i915_gem_object_change_domain: OK
> > [   72.476504] Testing event i915_gem_object_pwrite: OK
> > [   72.485486] Testing event i915_gem_object_pread: OK
> > [   72.494504] Testing event i915_gem_object_fault: OK
> > [   72.503485] Testing event i915_gem_object_clflush: OK
> > [   72.513488] Testing event i915_gem_object_destroy: OK
> > [   72.523488] Testing event i915_gem_evict: OK
> > [   72.532479] Testing event i915_gem_evict_everything: OK
> > [   72.542505] Testing event i915_gem_ring_dispatch: OK
> > [   72.551486] Testing event i915_gem_ring_flush: OK
> > [   72.560478] Testing event i915_gem_request_add: OK
> > [   72.569506] Testing event i915_gem_request_complete: OK
> > [   72.579501] Testing event i915_gem_request_retire: OK
> > [   72.589485] Testing event i915_gem_request_wait_begin: OK
> > [   72.599506] Testing event i915_gem_request_wait_end: OK
> > [   72.609501] Testing event i915_ring_wait_begin: OK
> > [   72.618504] Testing event i915_ring_wait_end: OK
> > [   72.627488] Testing event i915_flip_request: OK
> > [...]
> > 
> > This does it for every event that is created. This case had 1556 events
> > tested.
> 
> Great, lots of messages, be sure to increment your printk buffer size.
> Or write saner tests :)

No reason for extended buffer size, this is all recorded on serial
console.

> 
> > The config had:
> > 
> > CONFIG_FTRACE_SELFTEST=y
> > CONFIG_FTRACE_STARTUP_TEST=y
> > # CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
> > 
> > If CONFIG_EVENT_TRACE_TEST_SYSCALLS is set, then it does the testing of
> > every system call entry and exit event.
> 
> Ok, but then again, that's your choice to do so, no "sane" person
> normally enables that option...

No "sane" person would enable any of the above options. They are for
testing purposes only. This of course assumes that kernel developers are
not "sane".


> 
> > > What happens if other parts of the system are doing printk() calls?
> > > Wouldn't it make more sense just to pair them up like this instead of
> > > flushing (as you then end up with the timestamp messing things up like
> > > you showed.)
> > 
> > On system boot up there's not much that gets interrupted. And yeah, I
> > don't like the timestamp in the middle. But that just means we need to
> > work to fix that too ;-)
> 
> I think with a few minor changes as mentioned above, your messages will
> look just fine, and you will know better how long things take,

I've never really worried about how long, as the output of the message
itself takes up more time than most of those tests.

>  and what
> exactly fails, which is what you want to know, right?

Well, it did that before the updated printk() code.

> 
> > > Also, this way you know how long your tests take, which might be nice to
> > > know to figure out where boot time is going :)
> > 
> > Hehe, if you have self tests enabled, you can bet the boot time is going
> > to them. I have no intention on speeding the tests up, if anything, I
> > want to add more to them, which would slow them down.
> > 
> > If you are concerned about boot up (and for production environments) you
> > do not enable these self tests. That wasn't their purpose. They were
> > created for developers to test their systems, just like lockdep and
> > kmemcheck are. You don't want those running on your production
> > environment either.
> 
> Ok, then you just answered your own question there, make the messages a
> bit "prettier" and all is fine, as no one will ever use this in
> production, only for developers, and we can handle the little bit extra
> printk noise, at the expense of providing accurate information.

That accurate information is there with the original printk(), but is
broken with the new method.

Currently, I have a patch to force printk() to become early_printk()
that I'll be using for the time being. Until it bothers me enough (read,
user reports are messed up), will this get fixed.

-- Steve


