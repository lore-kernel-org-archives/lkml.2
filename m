Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2D0Vgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:36:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2D0Vgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:36:48 -0400
Date: Fri, 27 Apr 2012 14:36:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
Message-Id: <20120427143646.8209627e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
	<4F9ABF9C.2070707@xenotime.net>
	<alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
	<20120427132343.fbb443b9.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 14:27:13 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Fri, 27 Apr 2012, Andrew Morton wrote:
> 
> > Seems reasonable.  But the CONFIG_HUGETLB_PAGE=y,
> > CONFIG_MEM_RES_CTLR_HUGETLB=n combination will cause unneeded code
> > generation and space consumption in memcontrol.c.
> > 
> > I wonder if we can additionally do, within memcontrol.c:
> > 
> > /*
> >  * Nice comment goes here
> >  */
> > #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
> > #define HUGE_MAX_HSTATE_FOO HUGE_MAX_HSTATE
> > #else
> > #define HUGE_MAX_HSTATE_FOO 0
> > #endif
> > 
> > and s/HUGE_MAX_HSTATE/HUGE_MAX_HSTATE_FOO/ in that file.
> > 
> 
> I haven't looked at the hugetlb memcg controller in-depth (yet), but I 
> really think we should start considering breaking things like this off 
> into its own cgroup.  The hugetlb extension seems like something that 
> could be easily separtated, but perhaps I'm saying "easily" because I 
> haven't looked at the implementation.
> 
> mm/memcontrol.c in linux-next is 5877 lines and, if history is any guide, 
> it's going to continue growing.
> 
> If the hugetlb usage isn't charged against the memcg's 
> memory.usage_in_bytes like thp is, then I really think it should be its 
> own cgroup.  From the hugetlb perspective absent any cgroups, things like 
> hstates (since we're talking about HUGE_MAX_HSTATE) are global resources 
> and so you'd need to preallocate these on the command line or via sysfs 
> before you could mmap them.  So if my assumption that the hugetlb memcg 
> controller is only governing these global resources and charging a set of 
> tasks for what they use, then it really has no business in mm/memcontrol.c 
> to begin with, in my opinion.

Minor matter: that's non-responsive to my suggestion.

Major matter: that's a big fat nack to this patchset:

hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

so please take it up at a convenient time, in the appropriate
thread, with the appropriate cc's!

