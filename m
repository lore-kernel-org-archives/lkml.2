Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2KNIRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:17:49 -0500
Received: from mx2.parallels.com ([64.131.90.16]:37927 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab2KNIRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:17:48 -0500
Message-ID: <50A3C42F.9020901@parallels.com>
Date: Wed, 14 Nov 2012 17:17:51 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, "Ying Han" <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] rework mem_cgroup iterator
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 04:30 PM, Michal Hocko wrote:
> Hi all,
> this patch set tries to make mem_cgroup_iter saner in the way how it
> walks hierarchies. css->id based traversal is far from being ideal as it
> is not deterministic because it depends on the creation ordering.
> 
> Diffstat looks promising but it is fair the say that the biggest cleanup is
> just css_get_next removal. The memcg code has grown a bit but I think it is
> worth the resulting outcome (the sanity ;)).
> 
> The first patch fixes a potential misbehaving which I haven't seen but the
> fix is needed for the later patches anyway. We could take it alone as well
> but I do not have any bug report to base the fix on.
> 
> The second patch replaces css_get_next by cgroup iterators which are
> scheduled for 3.8 in Tejun's tree and I depend on the following two patches:
> fe1e904c cgroup: implement generic child / descendant walk macros
> 7e187c6c cgroup: use rculist ops for cgroup->children
> 
> The third patch is an attempt for simplification of the mem_cgroup_iter. It
> basically removes all css usages to make the code easier. The next patch
> removes the big while(!memcg) loop around the iterating logic. It could have
> been folded into #3 but I rather have the rework separate from the code
> moving noise.
> 
> The last patch just removes css_get_next as there is no user for it any
> longer.
> 
> I am also thinking that leaf-to-root iteration makes more sense but this
> patch is not included in the series yet because I have to think some
> more about the justification.
> 
> So far I didn't get to testing but I am posting this early if everybody is
> OK with this change.
> 
> Any thoughts?
> 

Why can't we reuse the scheduler iterator and move it to kernel/cgroup.c
? It already exists, provide sane ordering, and only relies on parent
information - which cgroup core already have - to do the walk.

The only minor problem is that we'll have to handle the damn
use_hierarchy case, so we may not be able to blindly rely on
cgroup->parent. But maybe we can, if we don't guarantee any particular
leaf-order.

