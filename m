Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2EAFK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:10:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47916 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2EAFKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:10:25 -0400
Date: Mon, 30 Apr 2012 22:10:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
In-Reply-To: <1335832418.20866.95.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils> <1335832418.20866.95.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Benjamin Herrenschmidt wrote:
> On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> > 
> > BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> > in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> 
> Hrm ... in_atomic and irqs_disabled are both 0 ... so yeah it smells
> like a preempt count problem... odd.
> 
> Did you get a specific bisect target yet ?

Oh, I went as far as we need, I think, but I didn't bother quite to
complete it because, once in that area, we know the schedule_tail()
omission would muddy the waters: the tail of my bisect log was

# bad: [e798cf3385d3aa7c84afa65677eb92e0c0876dfd] rcu: Add exports for per-CPU variables used for inlining
git bisect bad e798cf3385d3aa7c84afa65677eb92e0c0876dfd
# good: [90aec3b06194393c909e3e5a47b6ed99bb8caba5] rcu: Make exit_rcu() more precise and consolidate
git bisect good 90aec3b06194393c909e3e5a47b6ed99bb8caba5

from which I concluded that the patch responsible is

commit ab8fc41a8545d40a4b58d745876c125af72a8a5c
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Fri Apr 13 14:32:01 2012 -0700

    rcu: Move __rcu_read_lock() and __rcu_read_unlock() to per-CPU variables
    
    This commit is another step towards inlinable __rcu_read_lock() and
    __rcu_read_unlock() functions for preemptible RCU.  This keeps these two
    functions out of line, but switches them to use the per-CPU variables
    that are required to export their definitions without requiring that
    all RCU users include sched.h.  These per-CPU variables are saved and
    restored at context-switch time.

> 
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

I'd forgotten about CONFIG_PROVE_RCU (and hadn't been using PROVE_LOCKING
on that machine), but following Paul's suggestion have now turned them on.

But not much light shed, I'm afraid.  Within minutes it showed a trace
exactly like the one above, but the only thing PROVE_LOCKING and PROVE_RCU
had to say was that we're holding mmap_sem at that point, which is no
surprise and not a problem, just something lockdep is right to note.

That was an isolated occurrence, it continued quietly for maybe 20 minutes,
then output lots to the console screen - but garbled in a way I've not
seen before - the 0s came out just right (or perhaps all the hex digits
were being shown as 0s), but most everything else was grayly unreadable.
Then after a few minutes, spontaneously rebooted.

Perhaps I should remind myself of netdump; but getting the trace above
without complaint from PROVE_RCU tells me that it is not helping.

Hugh
