Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0HIS1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:27:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:36960 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0HIS1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:27:02 -0400
Message-ID: <4C60484B.8030002@windriver.com>
Date: Mon, 09 Aug 2010 13:26:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] rcu,debug_core: allow the kernel debugger to
 reset the rcu stall timer
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com> <1281330732-17164-2-git-send-email-jason.wessel@windriver.com> <1281330732-17164-3-git-send-email-jason.wessel@windriver.com> <20100809174353.GH3026@linux.vnet.ibm.com>
In-Reply-To: <20100809174353.GH3026@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2010 18:26:23.0166 (UTC) FILETIME=[5EC245E0:01CB37F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 12:43 PM, Paul E. McKenney wrote:
> On Mon, Aug 09, 2010 at 12:12:12AM -0500, Jason Wessel wrote:
>
>> +void rcu_cpu_stall_reset(void)
>> +{
>> +    rcu_sched_state.jiffies_stall = 0;
>> +    rcu_bh_state.jiffies_stall = 0;
>> +}
>> +
>
> OK, so you are suppressing RCU CPU stall warnings for rcu_sched and
> rcu_bh, but not for preemptible RCU.  I believe that you want all of
> them covered.
>

What is the state variable for the preemptible RCU I had not hit a
warning in my testing so I must needs some more test cases. :-)

> I have a number of recent patches that allow RCU CPU stall warnings to
> be suppressed, one of which allows them to be suppressed using sysfs.
> Would that work for you, or do you need an in-kernel interface?
>

We need an in-kernel interface for sure.

> If you do need an in-kernel interface, I could export (and probably
> rename) rcu_panic(), which is a static in 2.6.35.  This assumes that you
> never want to re-enable RCU CPU stall warnings once you suppress them,
> which is what your patch appears to do.
>
> So, if I export a suppress_rcu_cpu_stall() function that permanently
> disabled RCU CPU stall warnings, would that work for you?  (They could
> be manually re-enabled via sysfs.)
>

This is an RFC patch for a reason.  The intent behind the interface is
to allow for one stall check cycle to go by after resuming kernel
execution and after that the normal rules are in play.  Code flow
wise, it looked like the easiest thing to do was set the jiffies_stall
value to zero and then exit when the.  The patch I created was
supposed to only ignore one stall cycle.

Here is the pseudo code.

/* before restarting kernel execution zero out the jiffies_stall  value.

__rcu_pending() {

    check_cpu_stall();  <- Here we check if the stall val is set to zero
and just return
    /* do all normal work */

}

In the normal flow of things rc_start_gp() will ultimately call
record_gp_stall_check_time which updates the jiffies_stall back to non
zero and the stall accounting is back in play.


Jason.
