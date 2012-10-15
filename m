Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2JOOrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:47:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2JOOrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:47:40 -0400
Date: Mon, 15 Oct 2012 16:47:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] memcg: oom: fix totalpages calculation for
 swappiness==0
Message-ID: <20121015144736.GI29069@dhcp22.suse.cz>
References: <20121010141142.GG23011@dhcp22.suse.cz>
 <507BD33C.4030209@jp.fujitsu.com>
 <20121015094907.GE29069@dhcp22.suse.cz>
 <CAHGf_=p4d33t7i5++YHTkc0PbAUckca1oBxR5dZ48EzybKYHgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=p4d33t7i5++YHTkc0PbAUckca1oBxR5dZ48EzybKYHgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-10-12 10:25:14, KOSAKI Motohiro wrote:
> > diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> > index 078701f..308fd77 100644
> > --- a/Documentation/sysctl/vm.txt
> > +++ b/Documentation/sysctl/vm.txt
> > @@ -640,6 +640,9 @@ swappiness
> >  This control is used to define how aggressive the kernel will swap
> >  memory pages.  Higher values will increase agressiveness, lower values
> >  decrease the amount of swap.
> > +The value can be used from the [0, 100] range, where 0 means no swapping
> > +at all (even if there is a swap storage enabled) while 100 means that
> > +anonymous pages are reclaimed in the same rate as file pages.
> 
> I think this only correct when memcg. Even if swappiness==0, global reclaim swap
> out anon pages before oom.

Right you are (we really do swap when the file pages are really
low)! Sorry about the confusion. I kind of became if(global_reclaim)
block blind...

Then this really needs a memcg specific documentation fix. What about
the following?
---
>From 59a60705abd2faf9e266a4270bbf302001845588 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 15 Oct 2012 11:43:56 +0200
Subject: [PATCH] doc: describe memcg swappiness more precisely

since fe35004f (mm: avoid swapping out with swappiness==0) memcg reclaim
stopped swapping out anon pages completely when 0 value is used.
Although this is somehow expected it hasn't been done for a really long
time this way and so it is probably better to be explicit about the
effect. Moreover global reclaim swapps out even when swappiness is 0
to prevent from OOM killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index c07f7b4..71c4da4 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -466,6 +466,10 @@ Note:
 5.3 swappiness
 
 Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
+Please note that unlike the global swappiness, memcg knob set to 0
+really prevents from any swapping even if there is a swap storage
+available. This might lead to memcg OOM killer if there are no file
+pages to reclaim.
 
 Following cgroups' swappiness can't be changed.
 - root cgroup (uses /proc/sys/vm/swappiness).
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
