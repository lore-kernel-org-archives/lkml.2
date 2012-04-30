Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2D3Whe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:37:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59247 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab2D3Wh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:37:29 -0400
Date: Mon, 30 Apr 2012 15:37:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 3.4.0-rc4-next-20120427 and preceding linux-nexts (I've not tried
rc5-next-20120430 but expect it's the same), on PowerPC G5 quad with
CONFIG_PREEMPT=y and CONFIG_DEBUG_ATOMIC_SLEEP=y, I'm getting spurious
"BUG: sleeping function called from invalid context" messages from
__might_sleep().

Just once I saw such a message during startup.  Once I saw such a
message when rebuilding the machine's kernel.  Usually I see them
when I'm running a swapping load of kernel builds under memory
pressure (but that's what I'm habitually running there): perhaps
after a few minutes a flurry comes, then goes away, comes back
again later, and after perhaps a couple of hours of that I see
"INFO: rcu_preempt detected stalls" messages too, and soon it
freezes (or perhaps it's still running, but I'm so flooded by
messages that I reboot anyway).

Rather like from before you fixed schedule_tail() for your per-cpu
RCU mods, but not so easy to reproduce.  I did a bisection and indeed
it converged as expected on the RCU changes.  No such problem seen on
x86: it looks as if there's some further tweak required on PowerPC.

Here are my RCU config options (I don't usually have the TORTURE_TEST
in, but tried that for half an hour this morning, in the hope that it
would generate the issue: but it did not).

# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_HAVE_RCU_TABLE_FREE=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y

Here's the message when I was rebuilding the G5's kernel:

BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
Call Trace:
[c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
[c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
[c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
[c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
[c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
[c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30

I've plenty more examples, most of them from page faults or from kswapd;
but I don't think there's any more useful information in them.

Anything I can try later on?

Thanks!
Hugh
