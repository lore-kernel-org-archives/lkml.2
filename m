Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1FDXGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 19:06:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60102 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1FDXGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 19:06:37 -0400
Date: Sat, 4 Jun 2011 16:06:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110604230633.GD6093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
 <20110603050724.GB2304@linux.vnet.ibm.com>
 <1307191830.23387.24.camel@t41.thuisdomein>
 <20110604160326.GA6093@linux.vnet.ibm.com>
 <1307227686.28359.23.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307227686.28359.23.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 12:48:05AM +0200, Paul Bolle wrote:
> On Sat, 2011-06-04 at 09:03 -0700, Paul E. McKenney wrote:
> > More like "based on these diagnostics, I see no evidence of the RCU
> > implementation misbehaving."  Which is of course different than "I can
> > prove that the RCU implementation is not misbehaving".  That said, the
> > fact that you are running on a single CPU makes it hard for me to see
> > any latitude for RCU-implementation misbehavior.
> > 
> > Clearly something is wrong somewhere.
> 
> Yes.
> 
> > Given the fact that on a single-CPU
> > system, synchronize_rcu() is a no-op, and given that you weren't able
> > to reproduce with CONFIG_TREE_PREEMPT_RCU=y, my guess is that there is
> > a synchronize_rcu() that occasionally (illegally) gets executed within
> > an RCU read-side critical section.
> 
> I think I finally found it!

Very cool!!!

> The culprit seems to be io_context.ioc_data (not the most clear of
> names!). It seems to be a single entry "last-hit cache" of an hlist
> called cic_list. (There are three, subtly different, cic_lists in the
> CFQ code!) It is not entirely clear, but that last-hit cache can get out
> of sync with the hlist it is supposed to cache. My guess it that every
> now and then a member of the hlist gets deleted while it's still in that
> (single entry) cache. If it then gets retrieved from that cache it
> already points to poisoned memory. For some strange reason this only
> results in an Oops if one or more debugging options are set (as are set
> in the Fedora Rawhide non-stable kernels that I ran into this). I have
> no clue whatsoever, why that is ...

Oooh...  If I understand you correctly, this is exactly analogous to my
first-ever RCU bug way back in the early 90s.  This was a hashed version
of a BSD-style routing table, where each hash bucket maintained a pointer
to the last routing entry used.  When I deleted a routing entry, I forgot
to check the last-entry pointer.

The amazing thing is that the guy who found and fixed this bug generated
a correct fix despite having absolutely no idea what RCU was or how it
worked.  All he knew was that if he waited for the sun to reach Oregon,
his users were going to be way beyond upset.  ;-)

> Anyhow, after ripping out ioc_data this bug seems to have disappeared!
> Jens, Vivek, could you please have a look at this? In the mean time I
> hope to pinpoint this issue and draft a small patch to really solve it
> (ie, not by simply ripping out ioc_data).

Again, very cool!!!

							Thanx, Paul
