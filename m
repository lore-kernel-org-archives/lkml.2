Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2DRC43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:56:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DRC42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:56:28 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wom5GMh1gUkA:10 a=7aeNQT76kZUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=3Q-E-28bOuAONHjO8GEA:9 a=7f-Py1lven6ighDzIQsA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 17 Apr 2012 22:56:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
Message-ID: <20120418025626.GB23877@home.goodmis.org>
References: <1334561244.3339.7.camel@aep-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334561244.3339.7.camel@aep-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 01:27:24PM +0600, Alexander E. Patrakov wrote:
> Hello.
> 
> With linux-3.3.0, my computer at work is rather unstable. The kernel

Have you tried other kernels? The leak just started with 3.3?

> seems to leak memory, however, kmemleak finds nothing significant.
> 
> Finally, the computer started swapping heavily and responded only via
> ssh. In dmesg, I found this (repeated every two seconds):
> 
> [ 6709.483956] BUG: sleeping function called from invalid context at
> kernel/mutex.c:271
> [ 6709.483968] in_atomic(): 0, irqs_disabled(): 0, pid: 1210, name:

I'm a little baffled here, as preempt_count() is zero (in_atomic) and
irqs are not disabled.

> NetworkManager

Ah there's your problem! (just kidding)


> [ 6709.483974] INFO: lockdep is turned off.
> [ 6709.483981] Pid: 1210, comm: NetworkManager Tainted: G          I
> 3.3.0-gentoo #4
> [ 6709.483987] Call Trace:
> [ 6709.484006]  [<ffffffff810683fc>] __might_sleep+0xff/0x103
> [ 6709.484019]  [<ffffffff81548783>] mutex_lock_nested+0x2a/0x2ff
> [ 6709.484031]  [<ffffffff811261b5>] ? fget_light+0x6a/0x118
> [ 6709.484043]  [<ffffffff8115a738>] inotify_poll+0x35/0x53
> [ 6709.484052]  [<ffffffff81135eb1>] do_sys_poll+0x266/0x3f2
> [ 6709.484060]  [<ffffffff81134e33>] ? poll_freewait+0x8f/0x8f
> [ 6709.484069]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484076]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484084]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484092]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484099]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484107]  [<ffffffff81134efa>] ? __pollwait+0xc7/0xc7
> [ 6709.484118]  [<ffffffff8112fde0>] ? putname+0x2d/0x36
> [ 6709.484127]  [<ffffffff8112fde0>] ? putname+0x2d/0x36
> [ 6709.484138]  [<ffffffff81045cb7>] ? timespec_add_safe+0x32/0x5f
> [ 6709.484146]  [<ffffffff81018078>] ? read_tsc+0x9/0x1b
> [ 6709.484155]  [<ffffffff8113509a>] ? poll_select_set_timeout+0x61/0x75
> [ 6709.484163]  [<ffffffff811360d8>] sys_poll+0x4e/0xb7
> [ 6709.484173]  [<ffffffff81552896>] sysenter_dispatch+0x7/0x21
> 

Hmm, this can also be reported if you have an rcu leak. Which would also
explain your memory leak. RCU is the kernel's "garbage collector" and if
it gets stuck, then you will definitely start seeing memory leaks, as
memory wont be freed.

Paul, know of any fixes in RCU that could have caused this?

-- Steve

> The taint is due to nouveau. I am sure that this
> "sleeping-in-invalid-context" report is a consequence of the memory leak
> that I could not convert into something reportable. But still, it is
> something that the kernel wants me to report, that's why this e-mail.
> 
> The kernel is configured as CONFIG_PREEMPT=y, if this is relevant.
> 
> -- 
> Alexander E. Patrakov
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
