Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0HCD0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:26:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55872 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0HCD0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:26:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 3 Aug 2010 12:21:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/5] quick lookup memcg by ID
Message-Id: <20100803122158.c01b9921.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100803032216.GC3863@balbir.in.ibm.com>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802191304.8e520808.kamezawa.hiroyu@jp.fujitsu.com>
	<20100803032216.GC3863@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 08:52:16 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-02 19:13:04]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, memory cgroup has an ID per cgroup and make use of it at
> >  - hierarchy walk,
> >  - swap recording.
> > 
> > This patch is for making more use of it. The final purpose is
> > to replace page_cgroup->mem_cgroup's pointer to an unsigned short.
> > 
> > This patch caches a pointer of memcg in an array. By this, we
> > don't have to call css_lookup() which requires radix-hash walk.
> > This saves some amount of memory footprint at lookup memcg via id.
> >
> 
> It is a memory versus speed tradeoff, but if the number of created
> cgroups is low, it might not be all that slow, besides we do that for
> swap_cgroup anyway - no?
>  

In following patch, pc->page_cgroup is changed from pointer to ID.
Then, this lookup happens in lru_add/del, for example.
And, by this, we can place all lookup related things to __read_mostly.
With css_lookup(), we can't do it and have to be afraid of cache
behavior.

I hear there are a users who create 2000+ cgroups and considering
about "low number" user here is not important.
This patch is a help for getting _stable_ performance even when there are
many cgroups.

Thanks,
-Kame

