Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2CLPKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:10:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab2CLPKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:10:07 -0400
Date: Mon, 12 Mar 2012 16:09:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Tejun Heo <tj@kernel.org>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: free mem_cgroup by RCU to fix oops
Message-ID: <20120312150945.GA14551@redhat.com>
References: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
 <alpine.LSU.2.00.1203091138260.19300@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1203091138260.19300@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 11:58:34AM -0800, Hugh Dickins wrote:
> On Wed, 7 Mar 2012, Hugh Dickins wrote:
> > 
> > I'm posting this a little prematurely to get eyes on it, since it's
> > more than a two-liner, but 3.3 time is running out.  If it is what's
> > needed to fix my oopses, I won't really be sure before Friday morning.
> > What's running now on the machine affected is using kfree_rcu(), but I
> > did hack it earlier to check that the vfree_rcu() alternative works.
> 
> Yes, please do send that patch on to Linus for 3.3.
> 
> It did not get as much as the 36 hours of testing I had hoped for, only
> 25 hours so far.  12 hours while I was out yesterday got wasted by a
> wireless driver interrupt spewing approximately one million messages:
> 
> iwl3945 0000:08:00.0: MAC is in deep sleep!. CSR_GP_CNTRL = 0xFFFFFFFF

I replaced that with WARN_ONCE
http://marc.info/?l=linux-wireless&m=132912863701997&w=2
(the patch is currently in net-next).

> which I've not suffered from before, and hope not again.  Having kdb
> in, I did take a look what was going on with the memcg load when it was
> interrupted: it appeared to be normal, and I've no reason to suppose that
> my kfree_rcu() was in any way responsible for the wireless aberration.

I don't know if is possible if test patch influence pci or mac80211 code
(we use rcu quite intensively in mac8021). Those "MAC is in deep sleep" 
usually mean that wireless device registers can not be read through pcie
bus - i.e. when pcie bridge is erroneously disabled like in report here:
http://marc.info/?l=linux-wireless&m=132577331132329&w=2

Note that wireless device is one of a few connected through pcie bridge
on most of the laptops, others external pcie devices like mmc are not
used frequently, hence breakage in pci code looks frequently like
breakage in wireless driver. Not sure if that was the case here though.

Stanislaw
