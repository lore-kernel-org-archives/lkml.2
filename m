Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1DORn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:43:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58307 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab1DORnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:43:24 -0400
Date: Fri, 15 Apr 2011 10:43:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3 3/4] lib, Make gen_pool memory allocator lockless
Message-ID: <20110415174320.GA2283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1302684835-14133-1-git-send-email-ying.huang@intel.com>
 <1302684835-14133-4-git-send-email-ying.huang@intel.com>
 <20110413210757.GA11683@Krystal>
 <4DA7903B.5030508@intel.com>
 <20110415164629.GA13983@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415164629.GA13983@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:46:29PM -0400, Mathieu Desnoyers wrote:
> * Huang Ying (ying.huang@intel.com) wrote:
> > On 04/14/2011 05:07 AM, Mathieu Desnoyers wrote:
> > > * Huang Ying (ying.huang@intel.com) wrote:
> > > [...]
> > >> + * rcu_read_lock and rcu_read_unlock is not used int gen_pool_alloc,
> > >> + * gen_pool_free, gen_pool_avail and gen_pool_size etc, because chunks
> > >> + * are only added into pool, not deleted from pool unless the pool
> > >> + * itself is destroyed.  If chunk will be deleted from pool,
> > >> + * rcu_read_lock and rcu_read_unlock should be uses in these
> > >> + * functions.
> > > 
> > > So how do you protect between pool destruction and adding chunks into
> > > the pool ?
> > 
> > Because the pool itself will be freed when destruction, we need some
> > mechanism outside of pool.  For example, if gen_pool_add() is called via
> > device file IOCTL, we must un-register the device file first, and
> > destroy the pool after the last reference to device has gone.
> 
> I am concerned about the list_for_each_entry_rcu() (and thus
> rcu_dereference_raw()) used outside of rcu_read_lock/unlock pairs.
> Validation infrastructure as recently been added to RCU: it triggers
> warnings when these situations are encountered in some RCU debugging
> configurations. The case of RCU list iteration is not covered by the
> checks, but it would make sense to be aware of it.
> 
> So although it seems like your code does not require rcu read lock
> critical sections, I'd prefer to let Paul McKenney have a look.

As long as you add elements and never remove them, then you can get
away with using list_for_each_entry_rcu() outside of an RCU read-side
critical section.  But please comment this -- it is all too easy
for someone to decide later to start deleting elements without also
inserting the needed rcu_read_lock() and rcu_read_unlock() pairs.

But I have lost the thread -- what code am I supposed to look at?

							Thanx, Paul
