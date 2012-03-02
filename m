Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2CBFuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:50:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56278 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab2CBFuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:50:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Mar 2012 14:48:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
Message-Id: <20120302144828.e985c63a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Mar 2012 14:46:11 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Hi,
> 
> This patchset implements a memory controller extension to control
> HugeTLB allocations. It is similar to the existing hugetlb quota
> support in that, the limit is enforced at mmap(2) time and not at
> fault time. HugeTLB's quota mechanism limits the number of huge pages
> that can allocated per superblock.
> 

Thank you, I think memcg-extension is better than hugetlbfs cgroup.


> For shared mappings we track the regions mapped by a task along with the
> memcg. We keep the memory controller charged even after the task
> that did mmap(2) exits. Uncharge happens during truncate. For Private
> mappings we charge and uncharge from the current task cgroup.
> 

What "current" means here ? current task's cgroup ?


> A sample strace output for an application doing malloc with hugectl is given
> below. libhugetlbfs will fall back to normal pagesize if the HugeTLB mmap fails.
> 
> open("/mnt/libhugetlbfs.tmp.uhLMgy", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
> unlink("/mnt/libhugetlbfs.tmp.uhLMgy")  = 0
> 
> .........
> 
> mmap(0x20000000000, 50331648, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = -1 ENOMEM (Cannot allocate memory)
> write(2, "libhugetlbfs", 12libhugetlbfs)            = 12
> write(2, ": WARNING: New heap segment map" ....
> mmap(NULL, 42008576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xfff946c0000
> ....
> 
> 
> Goals:
> 
> 1) We want to keep the semantic closer to hugelb quota support. ie, we want
>    to extend quota semantics to a group of tasks. Currently hugetlb quota
>    mechanism allows one to control number of hugetlb pages allocated per
>    hugetlbfs superblock.
> 
> 2) Applications using hugetlbfs always fallback to normal page size allocation when they
>    fail to allocate huge pages. libhugetlbfs internally handles this for malloc(3). We
>    want to retain this behaviour when we enforce the controller limit. ie, when huge page
>    allocation fails due to controller limit, applications should fallback to
>    allocation using normal page size. The above implies that we need to enforce
>    limit at mmap(2).
> 

Hm, ok. 

> 3) HugeTLBfs doesn't support page reclaim. It also doesn't support write(2). Applications
>    use hugetlbfs via mmap(2) interface. Important point to note here is hugetlbfs
>    extends file size in mmap.
> 
>    With shared mappings, the file size gets extended in mmap and file will remain in hugetlbfs
>    consuming huge pages until it is truncated. We want to make sure we keep the controller
>    charged until the file is truncated. This implies, that the controller will be charged
>    even after the task that did mmap exit.
> 

O.K. hugetlbfs is charged until the file is removed.
Then, next question will be 'can we destory cgroup....'

> Implementation details:
> 
> In order to achieve the above goals we need to track the cgroup information
> along with mmap range in a charge list in inode for shared mapping and in
> vm_area_struct for private mapping. We won't be using page to track cgroup
> information because with the above goals we are not really tracking the pages used.
> 
> Since we track cgroup in charge list, if we want to remove the cgroup, we need to update
> the charge list to point to the parent cgroup. Currently we take the easy route
> and prevent a cgroup removal if it's non reclaim resource usage is non zero.
> 

As Andrew pointed out, there are some ongoing works about page-range tracking.
Please check.

Thanks,
-Kame

> Changes from V1:
> * Changed the implementation as a memcg extension. We still use
>   the same logic to track the cgroup and range.
> 
> Changes from RFC post:
> * Added support for HugeTLB cgroup hierarchy
> * Added support for task migration
> * Added documentation patch
> * Other bug fixes
> 
> -aneesh
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

