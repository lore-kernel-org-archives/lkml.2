Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2E3Onw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:43:52 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60473 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2E3Onr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:43:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, mgorman@suse.de,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com,
        aarcange@redhat.com, mhocko@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 30 May 2012 20:13:31 +0530
Message-ID: <87lik920h8.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12053014-8256-0000-0000-000002BBE273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Thu, May 24, 2012 at 02:52:26PM -0700, David Rientjes wrote:
>> On Mon, 16 Apr 2012, Aneesh Kumar K.V wrote:
>> 
>> > This patch implements a memcg extension that allows us to control HugeTLB
>> > allocations via memory controller. The extension allows to limit the
>> > HugeTLB usage per control group and enforces the controller limit during
>> > page fault. Since HugeTLB doesn't support page reclaim, enforcing the limit
>> > at page fault time implies that, the application will get SIGBUS signal if it
>> > tries to access HugeTLB pages beyond its limit. This requires the application
>> > to know beforehand how much HugeTLB pages it would require for its use.
>> > 
>> > The charge/uncharge calls will be added to HugeTLB code in later patch.
>> > Support for memcg removal will be added in later patches.
>> > 
>> 
>> Again, I disagree with this approach because it's adding the functionality 
>> to memcg when it's unnecessary; it would be a complete legitimate usecase 
>> to want to limit the number of globally available hugepages to a set of 
>> tasks without incurring the per-page tracking from memcg.
>> 
>> This can be implemented as a seperate cgroup and as we move to a single 
>> hierarchy, you lose no functionality if you mount both cgroups from what 
>> is done here.
>> 
>> It would be much cleaner in terms of
>> 
>>  - build: not requiring ifdefs and dependencies on CONFIG_HUGETLB_PAGE, 
>>    which is a prerequisite for this functionality and is not for 
>>    CONFIG_CGROUP_MEM_RES_CTLR,
>
> I am not sure we have large number of #ifdef as you have outlined above.
> Most of the hugetlb limit code is well isolated already. If we were to
> split it as a seperate controller, we will be duplicating code related
> cgroup deletion,  migration support etc from memcg, because in case
> of memcg and hugetlb limit they depend on struct page. So I would expect
> we would be end up #ifdef around that code or duplicate them in the
> new controller if we were to do hugetlb limit as a seperate controller.
>
> Another reason for it to be part of memcg is, it is normal to look
> at hugetlb usage also as a memory usage. One of the feedback I got
> for the earlier post is to see if i can enhace the current code to
> make sure memory.usage_in_bytes can also account for hugetlb usage.
> People would also like to look at memory.limit_in_bytes to limit total
> usage. (inclusive of hugetlb).
>
>> 
>>  - code: seperating hugetlb bits out from memcg bits to avoid growing 
>>    mm/memcontrol.c beyond its current 5650 lines, and
>> 
>
> I can definitely look at spliting mm/memcontrol.c 
>
>
>>  - performance: not incurring any overhead of enabling memcg for per-
>>    page tracking that is unnecessary if users only want to limit hugetlb 
>>    pages.
>> 

Since Andrew didn't sent the patchset to Linus because of this
discussion, I looked at reworking the patchset as a seperate
controller. The patchset I sent here

http://thread.gmane.org/gmane.linux.kernel.mm/79230

have seen minimal testing. I also folded the fixup patches
Andrew had in -mm to original patchset.

Let me know if the changes looks good.
-aneesh

