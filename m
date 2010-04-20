Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0DTDLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:11:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43636 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0DTDLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:11:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Apr 2010 12:07:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: error at compaction (Re: mmotm 2010-04-15-14-42 uploaded
Message-Id: <20100420120753.b161dea9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	<20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419181442.GA19264@csn.ul.ie>
	<20100419193919.GB19264@csn.ul.ie>
	<s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 11:39:46 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Apr 20, 2010 at 4:39 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On Mon, Apr 19, 2010 at 07:14:42PM +0100, Mel Gorman wrote:
> >> On Mon, Apr 19, 2010 at 07:01:33PM +0900, KAMEZAWA Hiroyuki wrote:
> >> >
> >> > mmotm 2010-04-15-14-42
> >> >
> >> > When I tried
> >> >  # echo 0 > /proc/sys/vm/compaction
> >> >
> >> > I see following.
> >> >
> >> > My enviroment was
> >> >   2.6.34-rc4-mm1+ (2010-04-15-14-42) (x86-64) CPUx8
> >> >   allocating tons of hugepages and reduce free memory.
> >> >
> >> > What I did was:
> >> >   # echo 0 > /proc/sys/vm/compact_memory
> >> >
> >> > Hmm, I see this kind of error at migation for the 1st time..
> >> > my.config is attached. Hmm... ?
> >> >
> >> > (I'm sorry I'll be offline soon.)
> >>
> >> That's ok, thanks you for the report. I'm afraid I made little progress
> >> as I spent most of the day on other bugs but I do have something for
> >> you.
> >>
> >> First, I reproduced the problem using your .config. However, the problem does
> >> not manifest with the .config I normally use which is derived from the distro
> >> kernel configuration (Debian Lenny). So, there is something in your .config
> >> that triggers the problem. I very strongly suspect this is an interaction
> >> between migration, compaction and page allocation debug.
> >
> > I unexpecedly had the time to dig into this. Does the following patch fix
> > your problem? It Worked For Me.
> 
> Nice catch during shot time. Below is comment.
> 
> >
> > ==== CUT HERE ====
> > mm,compaction: Map free pages in the address space after they get split for compaction
> >
> > split_free_page() is a helper function which takes a free page from the
> > buddy lists and splits it into order-0 pages. It is used by memory
> > compaction to build a list of destination pages. If
> > CONFIG_DEBUG_PAGEALLOC is set, a kernel paging request bug is triggered
> > because split_free_page() did not call the arch-allocation hooks or map
> > the page into the kernel address space.
> >
> > This patch does not update split_free_page() as it is called with
> > interrupts held. Instead it documents that callers of split_free_page()
> > are responsible for calling the arch hooks and to map the page and fixes
> > compaction.
> 
> Dumb question. Why can't we call arch_alloc_page and kernel_map_pages
> as interrupt disabled? It's deadlock issue or latency issue?
> I don't found any comment about it.
> It should have added the comment around that functions. :)
> 

I guess it's from the same reason as vfree(), which can't be called under
irq-disabled.

Both of them has to flush TLB of all cpus. At flushing TLB (of other cpus), cpus has
to send IPI via smp_call_function. What I know from old stories is below.

At sendinf IPI, usual sequence is following. (This may be old.)

	spin_lock(&ipi_lock);
		set up cpu mask for getting notification from other cpu for declearing
		"I received IPI and finished my own work".
	spin_unlock(&ipi_lock);

Then,
          CPU0                             CPU1

    irq_disable (somewhere)             spin_lock
                                        send IPI and wait for notification.
    spin_lock()

deadlock.  Seeing decription of kernel/smp.c::smp_call_function_many(), it says
this function should not be called under irq-disabled.
(Maybe the same kind of spin-wait deadlock can happen.)


Thanks,
-Kame


