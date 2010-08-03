Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0HCAYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:24:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49705 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0HCAYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:24:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 3 Aug 2010 09:19:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH -mm] hibernation: freeze swap at hibernation (Was
 Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100803091927.914a5808.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100802155945.GR3863@balbir.in.ibm.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802155945.GR3863@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 21:29:45 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-02 15:02:25]:
> 
> > +/*
> > + * Because updateing swap_map[] can make not-saved-status-change,
> > + * we use our own easy allocator.
> > + * Please see kernel/power/swap.c, Used swaps are recorded into
> > + * RB-tree.
> > + */
> > +swp_entry_t get_swap_for_hibernation(int type)
> > +{
> > +	pgoff_t off;
> > +	swp_entry_t val = {0};
> > +	struct swap_info_struct *si;
> > +
> > +	spin_lock(&swap_lock);
> > +	/*
> > +	 * Once hibernation starts to use swap, we freeze swap_map[]. Otherwise,
> > +	 * saved swap_map[] image to the disk will be an incomplete because it's
> > +	 * changing without synchronization with hibernation snap shot.
> > +	 * At resume, we just make swap_for_hibernation=false. We can forget
> > +	 * used maps easily.
> 
> I don't understand the consequences of this action. Once swap_map is
> fixed, we get additional swapping because we need more free memory,
> what happens to the swapped out contents, since resume will never see
> the changes? 

Sorry, I can't understand what you write. Why "we get additional swapping?"
before starting hibernation, shrink_memory() is called and hibernation codes
should have enough memory to work.

This patch does

	1. set swap_for_hibernation = true 
                   => After this, kswapd/direct reclaim will make no swap.
		   => But hibernation can make use of swap.
	2. this variable, swap_for_hibernation is saved to disk as it is.

At resume
	3. swap_for_hibernation is loaded and it's value is "true"
	4. hibernation_thaw_swap() is called and set swap_for_hibernation=false.
	

> How did this work before 2.6.31?
> 

hmm? Are you talking about regression itself ?

   Before 2.6.31
    - At scan_swap_map(), free swap_map[] was used.
   After 2.6.31
    - At scan_swap_map(), if "swapcache-only" swap entry is found,
      it's reused by try_to_free_swapcache(). Because this happens
      during saving image of system memory, the snapshot will have inconsitency
      between swap_map <=> swap cache (I think mem_map is saved firstly)
      Then, memory corruption happens.
   After this patch.
    - scan_swap_map() is never called while saving snapshot to the disk.


> > +	 */
> > +	if (!swap_for_hibernation)
> > +		hibernation_freeze_swap();
> > +
> > +	si = swap_info[type];
> > +	if (!si || !(si->flags & SWP_WRITEOK))
> > +		goto done;
> > +
> > +	for (off = hibernation_offset[type]; off < si->max; ++off) {
> > +		if (!si->swap_map[off])
> > +			break;
> 
> So this is a linear scan for the first free entry, right?
> 
yes. Maybe some clever code can be added but start from simple one.
The result will not be very different because "write" time is long.
Thanks,
-Kame

