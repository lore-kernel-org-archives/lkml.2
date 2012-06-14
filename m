Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2FNE7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:59:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62244 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2FNE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:59:34 -0400
Date: Wed, 13 Jun 2012 21:59:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120614045930.GA10508@kroah.com>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339649173.13377.191.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 12:46:13AM -0400, Steven Rostedt wrote:
> Fengguang Wu had a config that caused the system to lockup. It reported:
> 
> [    6.086395] type=2000 audit(1339501575.085:1): initialized                                                                                                                       
> [    6.116356] Kprobe smoke test started                                                                                                                                            
> [    6.125915] Kprobe smoke test passed successfully                                                                                                                                
> [    6.127478] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0         
> +fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0         
> 
> and then froze. So naturally, the suspected bug was with rcu-torture.
> Fengguang did a git bisect and discovered that the crash came with a
> function trace update. He also noticed that if he reverted that update,
> the system got farther and showed:
> 
> [    1.611901] Testing tracer function: PASSED
> 
> His time was wasted by the fact that the function tracing self test
> first prints:
> 
>   "Testing tracer function: "
> 
> then runs the test, and if it succeeds, it prints "PASSED", giving us
> the nice output you see above.

You can't do a simple:
	"Tracer function test starting"
	"Tracer function test succeeded"
instead?

What happens if other parts of the system are doing printk() calls?
Wouldn't it make more sense just to pair them up like this instead of
flushing (as you then end up with the timestamp messing things up like
you showed.)

Also, this way you know how long your tests take, which might be nice to
know to figure out where boot time is going :)

thanks,

greg k-h
