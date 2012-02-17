Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2BQIEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:04:07 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42615 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2BQIEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:04:05 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/6] hugetlbfs: Add cgroup resource controller for hugetlbfs
In-Reply-To: <20120214155843.42a090c2.kamezawa.hiroyu@jp.fujitsu.com>
References: <1328909806-15236-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120214155843.42a090c2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Feb 2012 13:33:38 +0530
Message-ID: <87d39devj9.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12021708-5564-0000-0000-00000168291E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kamezawa,

Sorry for the late response as I was out of office for last few days.

On Tue, 14 Feb 2012 15:58:43 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sat, 11 Feb 2012 03:06:40 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > This patchset implements a cgroup resource controller for HugeTLB pages.
> > It is similar to the existing hugetlb quota support in that the limit is
> > enforced at mmap(2) time and not at fault time. HugeTLB quota limit the
> > number of huge pages that can be allocated per superblock.
> > 
> > For shared mapping we track the region mapped by a task along with the
> > hugetlb cgroup in inode region list. We keep the hugetlb cgroup charged
> > even after the task that did mmap(2) exit. The uncharge happens during
> > file truncate. For Private mapping we charge and uncharge from the current
> > task cgroup.
> > 
> 
> Hm, Could you provide an Documenation/cgroup/hugetlb.txt at RFC ?
> It makes clear what your patch does.

Will do in the next iteration.

> 
> I wonder whether this should be under memory cgroup or not. In the 1st design
> of cgroup, I think it was considered one-feature-one-subsystem was good.
> 
> But in recent discussion, I tend to hear that's hard to use.
> Now, memory cgroup has 
> 
>    memory.xxxxx for controlling anon/file
>    memory.memsw.xxxx for controlling memory+swap
>    memory.kmem.tcp_xxxx for tcp controlling.
> 
> How about memory.hugetlb.xxxxx ?
> 

That is how i did one of the earlier version of the patch. But there are
few difference with the way we want to control hugetlb allocation. With
hugetlb cgroup, we actually want to enable application to fall back to
using normal pagesize if we are crossing cgroup limit. ie, we need to
enforce the limit during mmap. memcg tracks cgroup details along
with pages, hence implementing above gets challenging. Another
difference is we keep the cgroup charged even if the task exit as long as
the file is present in hugetlbfs. ie, if an application did mmap with
MAP_SHARED in hugetlbfs, the file size will be extended to the requested
length arg in mmap. This file will consume pages from hugetlb resource
until it is truncated. We want to track that resource usage as a part
of hugetlb cgroup. 

>From the interface point of view what we have in hugetlb cgroup is
similar to what is in memcg. We end up with files like the below

hugetlb.16GB.limit_in_bytes
hugetlb.16GB.max_usage_in_bytes 
hugetlb.16GB.usage_in_bytes
hugetlb.16MB.limit_in_bytes
hugetlb.16MB.max_usage_in_bytes  
hugetlb.16MB.usage_in_bytes

> 
> > The current patchset doesn't support cgroup hierarchy. We also don't
> > allow task migration across cgroup.
> 
> What happens when a user destroys a cgroup which contains alive hugetlb pages ?
> 
> Thanks,
> -Kame
> 

Thanks
-aneesh

