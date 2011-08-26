Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1HZAXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:23:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46207 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1HZAXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:23:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 09:16:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code
Message-Id: <20110826091619.1ad27e9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default>
References: <20110823145815.GA23190@ca-server1.us.oracle.com
 20110825150532.a4d282b1.kamezawa.hiroyu@jp.fujitsu.com>
	<d0b4c414-e90f-4ae0-9b70-fd5b54d2b011@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 10:37:05 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> > Subject: Re: Subject: [PATCH V7 2/4] mm: frontswap: core code

> > BTW, Do I have a chance to implement frontswap accounting per cgroup
> > (under memcg) ? Or Do I need to enable/disale switch for frontswap per memcg ?
> > Do you think it is worth to do ?
> 
> I'm not very familiar with cgroups or memcg but I think it may be possible
> to implement transcendent memory with cgroup as the "guest" and the default
> cgroup as the "host" to allow for more memory elasticity for cgroups.
> (See http://lwn.net/Articles/454795/ for a good overview of all of
> transcendent memory.)
> 
Ok, I'll see it.

I just wonder following case.

Assume 2 memcgs.
	memcg X: memory limit = 300M.
	memcg Y: memory limit = 300M.

This limitation is done for performance isolation.
When using frontswap, X and Y can cause resource confliction in frontswap and
performance of X and Y cannot be predictable.


> > > +/*
> > > + * This global enablement flag reduces overhead on systems where frontswap_ops
> > > + * has not been registered, so is preferred to the slower alternative: a
> > > + * function call that checks a non-global.
> > > + */
> > > +int frontswap_enabled;
> > > +EXPORT_SYMBOL(frontswap_enabled);
> > > +
> > > +/* useful stats available in /sys/kernel/mm/frontswap */
> > > +static unsigned long frontswap_gets;
> > > +static unsigned long frontswap_succ_puts;
> > > +static unsigned long frontswap_failed_puts;
> > > +static unsigned long frontswap_flushes;
> > > +
> > 
> > What lock guard these ? swap_lock ?
> 
> These are informational statistics so do not need to be protected
> by a lock or an atomic-type.  If an increment is lost due to a cpu
> race, it is not a problem.
> 

Hmm...Personally, I don't like incorrect counters. Could you add comments ?
Or How anout using percpu_counter ? (see lib/percpu_counter.c)


> > > +/* Called when a swap device is swapon'd */
> > > +void __frontswap_init(unsigned type)
> > > +{
> > > +	struct swap_info_struct *sis = swap_info[type];
> > > +
> > > +	BUG_ON(sis == NULL);
> > > +	if (sis->frontswap_map == NULL)
> > > +		return;
> > > +	if (frontswap_enabled)
> > > +		(*frontswap_ops.init)(type);
> > > +}
> > > +EXPORT_SYMBOL(__frontswap_init);
> > > +
> > > +/*
> > > + * "Put" data from a page to frontswap and associate it with the page's
> > > + * swaptype and offset.  Page must be locked and in the swap cache.
> > > + * If frontswap already contains a page with matching swaptype and
> > > + * offset, the frontswap implmentation may either overwrite the data
> > > + * and return success or flush the page from frontswap and return failure
> > > + */
> > 
> > What lock should be held to guard global variables ? swap_lock ?
> 
> Which global variables do you mean and in what routines?  I think the
> page lock is required for put/get (as documented in the comments)
> but not the swap_lock.
> 

My concern was race in counters. Even you allow race in frontswap_succ_puts++,

Don't you need some lock for
	sis->frontswap_pages++
	sis->frontswap_pages--
?

Thanks,
-Kame





