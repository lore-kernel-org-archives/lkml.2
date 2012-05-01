Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2EANjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:39:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52403 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2EANjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:39:23 -0400
Date: Tue, 1 May 2012 06:39:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120501133900.GA4462@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
 <1335832418.20866.95.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335832418.20866.95.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050113-5806-0000-0000-000014C3E8BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 10:33:38AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> > 
> > BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> > in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> 
> Hrm ... in_atomic and irqs_disabled are both 0 ... so yeah it smells
> like a preempt count problem... odd.

All of the preempt-count patches are now in mainline.  :-(

The CONFIG_PROVE_RCU checks verify that either the task is new or it
is the same task that was last context-switched to on this CPU.  So
the most likely suspect is a newly created task that starts running
without schedule_tail() being invoked on the path from parent task
to child task.  If so, the fix would be to invoke rcu_switch_from()
and rcu_switch_to() on that code path.

So, does Power have a way of switching to a new task without involving
schedule_tail()?  I convinced myself that my old bugbear, usermode helpers,
aren't causing this problem, but I could easily be missing something.

> Did you get a specific bisect target yet ?

On this one, Hugh is close enough.  ;-)

							Thanx, Paul

> Cheers,
> Ben.
> 
> > Call Trace:
> > [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> > [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> > [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> > [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> > [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> > [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30
> > 
> > I've plenty more examples, most of them from page faults or from kswapd;
> > but I don't think there's any more useful information in them.
> > 
> > Anything I can try later on? 
> 

