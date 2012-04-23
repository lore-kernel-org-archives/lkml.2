Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2DWXoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2DWXoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:44:07 -0400
Date: Mon, 23 Apr 2012 16:44:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V6 04/14] hugetlb: Use mmu_gather instead of a
 temporary linked list for accumulating pages
Message-Id: <20120423164405.4b628580.akpm@linux-foundation.org>
In-Reply-To: <1334573091-18602-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1334573091-18602-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 16:14:41 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Use mmu_gather instead of temporary linked list for accumulating pages when
> we unmap a hugepage range. This also allows us to get rid of i_mmap_mutex
> unmap_hugepage_range in the following patch.
> 

Another warning and a build error, due to inadequate coverage testing.

mm/memory.c: In function 'unmap_single_vma':
mm/memory.c:1334: error: implicit declaration of function '__unmap_hugepage_range'

--- a/include/linux/hugetlb.h~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix
+++ a/include/linux/hugetlb.h
@@ -41,8 +41,9 @@ int follow_hugetlb_page(struct mm_struct
 			unsigned long *, int *, int, unsigned int flags);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *,
-			    unsigned long, unsigned long, struct page *);
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vms,
+				unsigned long start, unsigned long end,
+				struct page *ref_page);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
@@ -119,6 +120,12 @@ static inline void copy_huge_page(struct
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
+static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
+			struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, struct page *ref_page)
+{
+}
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 
 #define HUGETLB_ANON_FILE "anon_hugepage"


I also fixed up that __unmap_hugepage_range() declaration - it's quite
maddening to work on and review and read code when people have gone and
left out the names of the arguments.

