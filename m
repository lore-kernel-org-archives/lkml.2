Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1H3Klj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:41:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53107 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3Kli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:41:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 30 Aug 2011 19:34:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Brestic <abrestic@google.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
Message-Id: <20110830193406.361d758a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110830101726.GD13061@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110829155113.GA21661@redhat.com>
	<20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830070424.GA13061@redhat.com>
	<20110830162050.f6c13c0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830084245.GC13061@redhat.com>
	<20110830175609.4977ef7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830101726.GD13061@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 12:17:26 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 30, 2011 at 05:56:09PM +0900, KAMEZAWA Hiroyuki wrote:

> > > > > I don't get why this has to be done completely different from the way
> > > > > we usually do things, without any justification, whatsoever.
> > > > > 
> > > > > Why do you want to pass a recording structure down the reclaim stack?
> > > > 
> > > > Just for reducing number of passed variables.
> > > 
> > > It's still sitting on bottom of the reclaim stack the whole time.
> > > 
> > > With my proposal, you would only need to pass the extra root_mem
> > > pointer.
> > 
> > I'm sorry I miss something. Do you say to add a function like
> > 
> > mem_cgroup_record_reclaim_stat(memcg, root_mem, anon_scan, anon_free, anon_rotate,
> >                                file_scan, file_free, elapsed_ns)
> > 
> > ?
> 
> Exactly, though passing it a stat item index and a delta would
> probably be closer to our other statistics accounting, i.e.:
> 
> 	mem_cgroup_record_reclaim_stat(sc->mem_cgroup, sc->root_mem_cgroup,
> 				       MEM_CGROUP_SCAN_ANON, *nr_anon);
> 
> where sc->mem_cgroup is `victim' and sc->root_mem_cgroup is `root_mem'
> from hierarchical_reclaim.  ->root_mem_cgroup might be confusing,
> though.  I named it ->target_mem_cgroup in my patch set but I don't
> feel too strongly about that.
> 
> Even better would be to reuse enum vm_event_item and at one point
> merge all the accounting stuff into a single function and have one
> single set of events that makes sense on a global level as well as on
> a per-memcg level.
> 
> There is deviation and implementing similar things twice with slight
> variations and I don't see any justification for all that extra code
> that needs maintaining.  Or counters that have similar names globally
> and on a per-memcg level but with different meanings, like the rotated
> counter.  Globally, a rotated page (PGROTATED) is one that is moved
> back to the inactive list after writeback finishes.  Per-memcg, the
> rotated counter is our internal heuristics value to balance pressure
> between LRUs and means either rotated on the inactive list, activated,
> not activated but countes as activated because of VM_EXEC etc.
> 
> I am still for reverting this patch before the release until we have
> this all sorted out.  I feel rather strongly that these statistics are
> in no way ready to make them part of the ABI and export them to
> userspace as they are now.
> 

How about fixing interface first ? 1st version of this patch was 
in April and no big change since then.
I don't want to be starved more.

Thanks,
-Kame



