Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2EGQWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:22:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46232 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2EGQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:22:08 -0400
Date: Mon, 7 May 2012 09:21:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
In-Reply-To: <alpine.LSU.2.00.1205021721350.24869@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205070858450.1416@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils> <1335832418.20866.95.camel@pasglop> <alpine.LSU.2.00.1204302142310.27208@eggly.anvils> <20120501142208.GA2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205021324430.24246@eggly.anvils> <1335993615.4088.1.camel@pasglop> <20120502215406.GL2450@linux.vnet.ibm.com> <CANsGZ6bw4JwMRgUriooDvFB=g-HkpyL8XJa9s47RPfOEPCMcpw@mail.gmail.com>
 <20120503001433.GO2450@linux.vnet.ibm.com> <alpine.LSU.2.00.1205021721350.24869@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012, Hugh Dickins wrote:
> On Wed, 2 May 2012, Paul E. McKenney wrote:
> > 
> > In any case, I must confess that I feel quite silly about my series
> > of patches.  I have reverted them aside from a couple that did useful
> > optimizations, and they should show up in -next shortly.
> 
> A wee bit sad, but thank you - it was an experiment worth trying,
> and perhaps there will be reason to come back to it future.

The revert indeed showed up in next-20120504: thanks, no problem now.

But although it's just history, and not worth anyone's time to
investigate, I shouldn't let this thread die without an epilogue.

Although the patch I posted (this_cpu_inc in __rcu_read_lock,
preempt_disable and enable in __rcu_read_unlock) ran well until
I killed the test after 70 hours, it did not _entirely_ eliminate
the sleeping function BUG messages.

In 70 hours I got six isolated messages like the below (but from
different __might_sleep callsites) - where before I'd have flurries
of hundreds(?) and freeze within the hour.

And the "rcu_nesting" debug line I'd added to the message was different:
where before it was showing ffffffff on some tasks and 1 on others i.e.
increment or decrement had been applied to the wrong task, these messages
now all showed 0s throughout i.e. by the time the message was printed,
there was no longer any justification for the message.

As if a memory barrier were missing somewhere, perhaps.

BUG: sleeping function called from invalid context at arch/powerpc/mm/fault.c:305
cpu=2 preempt_count=0 preempt_offset=0 rcu_nesting=0 nesting_save=0
in_atomic(): 0, irqs_disabled(): 0, pid: 12266, name: cc1
Call Trace:
[c000000003affac0] [c00000000000f36c] .show_stack+0x6c/0x16c (unreliable)
[c000000003affb70] [c000000000078788] .__might_sleep+0x150/0x170
[c000000003affc00] [c0000000000255f4] .do_page_fault+0x288/0x664
[c000000003affe30] [c000000000005868] handle_page_fault+0x10/0x30

Hugh
