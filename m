Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2E0U3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:29:09 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46850 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2E0U3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:29:07 -0400
Date: Mon, 28 May 2012 01:58:48 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Message-ID: <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12052720-8256-0000-0000-000002B2E3F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:52:26PM -0700, David Rientjes wrote:
> On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:
> 
> > This patch implements a memcg extension that allows us to control HugeTLB
> > allocations via memory controller. The extension allows to limit the
> > HugeTLB usage per control group and enforces the controller limit during
> > page fault. Since HugeTLB doesn't support page reclaim, enforcing the limit
> > at page fault time implies that, the application will get SIGBUS signal if it
> > tries to access HugeTLB pages beyond its limit. This requires the application
> > to know beforehand how much HugeTLB pages it would require for its use.
> > 
> > The charge/uncharge calls will be added to HugeTLB code in later patch.
> > Support for memcg removal will be added in later patches.
> > 
> 
> Again, I disagree with this approach because it's adding the functionality 
> to memcg when it's unnecessary; it would be a complete legitimate usecase 
> to want to limit the number of globally available hugepages to a set of 
> tasks without incurring the per-page tracking from memcg.
> 
> This can be implemented as a seperate cgroup and as we move to a single 
> hierarchy, you lose no functionality if you mount both cgroups from what 
> is done here.
> 
> It would be much cleaner in terms of
> 
>  - build: not requiring ifdefs and dependencies on CONFIG_HUGETLB_PAGE, 
>    which is a prerequisite for this functionality and is not for 
>    CONFIG_CGROUP_MEM_RES_CTLR,

I am not sure we have large number of #ifdef as you have outlined above.
Most of the hugetlb limit code is well isolated already. If we were to
split it as a seperate controller, we will be duplicating code related
cgroup deletion,  migration support etc from memcg, because in case
of memcg and hugetlb limit they depend on struct page. So I would expect
we would be end up #ifdef around that code or duplicate them in the
new controller if we were to do hugetlb limit as a seperate controller.

Another reason for it to be part of memcg is, it is normal to look
at hugetlb usage also as a memory usage. One of the feedback I got
for the earlier post is to see if i can enhace the current code to
make sure memory.usage_in_bytes can also account for hugetlb usage.
People would also like to look at memory.limit_in_bytes to limit total
usage. (inclusive of hugetlb).

> 
>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
>    mm/memcontrol.c beyond its current 5650 lines, and
> 

I can definitely look at spliting mm/memcontrol.c 


>  - performance: not incurring any overhead of enabling memcg for per-
>    page tracking that is unnecessary if users only want to limit hugetlb 
>    pages.
> 

-aneesh

