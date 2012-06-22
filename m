Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506Ab2FVHRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:17:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64488 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761472Ab2FVHRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:17:24 -0400
Date: Fri, 22 Jun 2012 09:17:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        AndrewMorton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120622071718.GC22167@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340322723.27036.220.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

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
> 
> But with the new printk() changes, text without a newline gets buffered
> and does not print out to the console at the location of the printk.
> This caused the "Testing tracer function: " not to print out and because
> the test caused the kernel to lock up, we are clueless to the fact that
> the problem was with the function tracer test and not the rcu_torture
> test. As it made sense that the rcu_torture test could lock up the
> system, many kernel developer hours were wasted chasing the wrong wild
> goose.
> 
> If the "Testing tracer function: " had printed out in the first place,
> we would have caught the correct wild goose and saved precious kernel
> developer's time.
> 
> Thus a need for the following utility. That is to add a 'printk_flush()'
> that acts like a fflush() in userspace to flush out the buffers used by
> the printing facility so we don't have unexpected hunts for nature
> roaming fowl.
> 
> I hooked onto the 'facility' infrastructure and used '0x1ffc' (the max
> number) as a way to communicate printk() commands to the msg_print_text()
> which is performed at a later time (console_unlock()).
> 
> I tested this out, (adding pr_flush() after my printk) and now the
> lockup shows:
> 
> [    9.018231] Kprobe smoke test passed successfully
> [    9.023084] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_hold
> off=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> [    9.066065] Testing tracer function:
> 
> To prevent the flush to cause the next printk to have a timestamp that
> would produce the following:
> 
> [    6.834073] Testing tracer function: [    7.136194] PASSED
> 
> I made the KERN_CONT ("<c>") use the facility as well to pass info to
> not print the timestamp. This fixes the abve issue to print:
> 
> [    1.291025] Testing tracer function: PASSED
> 
> Link: http://lkml.kernel.org/r/1339649173.13377.191.camel@gandalf.stny.rr.com
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "kay.sievers" <kay.sievers@vrfy.org>
> Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/printk.h |    8 ++++
>  kernel/printk.c        |  104 ++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 101 insertions(+), 11 deletions(-)

Maybe also add the actual usage sites, to demonstrate how it's 
going to be used?

Thanks,

	Ingo
