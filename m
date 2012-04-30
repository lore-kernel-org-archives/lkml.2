Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2D3XVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:21:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51902 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab2D3XVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:21:17 -0400
Date: Mon, 30 Apr 2012 16:14:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120430231433.GO2429@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043023-1780-0000-0000-0000052EE573
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000273; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00135433; UDB=6.00031634; UTC=2012-04-30
 23:21:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:37:10PM -0700, Hugh Dickins wrote:
> Hi Paul,
> 
> On 3.4.0-rc4-next-20120427 and preceding linux-nexts (I've not tried
> rc5-next-20120430 but expect it's the same), on PowerPC G5 quad with
> CONFIG_PREEMPT=y and CONFIG_DEBUG_ATOMIC_SLEEP=y, I'm getting spurious
> "BUG: sleeping function called from invalid context" messages from
> __might_sleep().
> 
> Just once I saw such a message during startup.  Once I saw such a
> message when rebuilding the machine's kernel.  Usually I see them
> when I'm running a swapping load of kernel builds under memory
> pressure (but that's what I'm habitually running there): perhaps
> after a few minutes a flurry comes, then goes away, comes back
> again later, and after perhaps a couple of hours of that I see
> "INFO: rcu_preempt detected stalls" messages too, and soon it
> freezes (or perhaps it's still running, but I'm so flooded by
> messages that I reboot anyway).
> 
> Rather like from before you fixed schedule_tail() for your per-cpu
> RCU mods, but not so easy to reproduce.  I did a bisection and indeed
> it converged as expected on the RCU changes.  No such problem seen on
> x86: it looks as if there's some further tweak required on PowerPC.
> 
> Here are my RCU config options (I don't usually have the TORTURE_TEST
> in, but tried that for half an hour this morning, in the hope that it
> would generate the issue: but it did not).
> 
> # RCU Subsystem
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_FANOUT=64
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_TREE_RCU_TRACE=y
> # CONFIG_RCU_BOOST is not set
> CONFIG_HAVE_RCU_TABLE_FREE=y
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_RCU_TORTURE_TEST=m
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_RCU_CPU_STALL_VERBOSE is not set
> # CONFIG_RCU_CPU_STALL_INFO is not set
> CONFIG_RCU_TRACE=y
> 
> Here's the message when I was rebuilding the G5's kernel:
> 
> BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> Call Trace:
> [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30
> 
> I've plenty more examples, most of them from page faults or from kswapd;
> but I don't think there's any more useful information in them.
> 
> Anything I can try later on?

Interesting...  As you say, I saw this sort of thing before applying
the changes to schedule_tail(), and it is all too possible that there
is some other "sneak path" for context switches.

Have you tried running with CONFIG_PROVE_RCU?  This enables some
additional debugging in rcu_switch_from() and rcu_switch_to() that
helped track down the schedule_tail() problem.

						Thanx, Paul

