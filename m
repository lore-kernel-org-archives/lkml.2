Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0HBQAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:00:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53816 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0HBQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:00:12 -0400
Date: Mon, 2 Aug 2010 21:29:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH -mm] hibernation: freeze swap at hibernation (Was
 Re: Memory corruption during hibernation since 2.6.31
Message-ID: <20100802155945.GR3863@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201007282334.08063.rjw@sisk.pl>
 <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
 <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
 <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
 <20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
 <20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-02 15:02:25]:

> +/*
> + * Because updateing swap_map[] can make not-saved-status-change,
> + * we use our own easy allocator.
> + * Please see kernel/power/swap.c, Used swaps are recorded into
> + * RB-tree.
> + */
> +swp_entry_t get_swap_for_hibernation(int type)
> +{
> +	pgoff_t off;
> +	swp_entry_t val = {0};
> +	struct swap_info_struct *si;
> +
> +	spin_lock(&swap_lock);
> +	/*
> +	 * Once hibernation starts to use swap, we freeze swap_map[]. Otherwise,
> +	 * saved swap_map[] image to the disk will be an incomplete because it's
> +	 * changing without synchronization with hibernation snap shot.
> +	 * At resume, we just make swap_for_hibernation=false. We can forget
> +	 * used maps easily.

I don't understand the consequences of this action. Once swap_map is
fixed, we get additional swapping because we need more free memory,
what happens to the swapped out contents, since resume will never see
the changes? How did this work before 2.6.31?

> +	 */
> +	if (!swap_for_hibernation)
> +		hibernation_freeze_swap();
> +
> +	si = swap_info[type];
> +	if (!si || !(si->flags & SWP_WRITEOK))
> +		goto done;
> +
> +	for (off = hibernation_offset[type]; off < si->max; ++off) {
> +		if (!si->swap_map[off])
> +			break;

So this is a linear scan for the first free entry, right?

> +	}
> +	if (off < si->max) {
> +		val = swp_entry(type, off);
> +		hibernation_offset[type] = off + 1;
> +	}
> +done:
> +	spin_unlock(&swap_lock);
> +	return val;
> +}
> +

-- 
	Three Cheers,
	Balbir
