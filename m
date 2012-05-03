Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2ECLZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab2ECLZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:25:38 -0400
Date: Thu, 3 May 2012 13:25:30 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference
 transparent_hugepage_enabled
Message-ID: <20120503112530.GE2410@redhat.com>
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com>
 <20120430160520.4c1cc05c.akpm@linux-foundation.org>
 <4FA0A743.2070904@intel.com>
 <20120502175508.GC2410@redhat.com>
 <4FA1D7D9.1050402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA1D7D9.1050402@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 03, 2012 at 08:56:57AM +0800, Alex Shi wrote:
> 
> > My preference would still be to remove the is_vma_temporary_stack and
> > use two vmas during mremap of execve, that would remove the "vma"
> > parameter from transparent_hugepage_enabled() but others prefers to
> > skip a vma allocation in execve and stick to is_vma_temporary_stack,
> > which is fair enough argument.
> 
> 
> Actually, current transparent_hugepage_enabled just means the vma is in
> THP enable ENV, the vma is just possibly has some large page, no grantee
> really has.  But in lots situations, user wants to know if a vma or a
> part of memory really include a large page. not the possibility.
> 
> So, it will be great to see a real large page checking function appearing.

Well, to know if a VMA (or a memory range) really includes a THP, it'd
require to hold the page_table_lock and a loop on all pmds in the
range, but by the time you relase the lock things may have already
changed as split_huge_page can run at any time, madvise(MADV_DONTNEED)
too if you only hold the mmap_sem in read mode and the THP page
fault. In fact while holding the mmap_sem in read mode (the usual read
lock you need to take to lookup and stabilize the vma) a THP can be
freed and reallocated under it, and that's what pmd_trans_unstable is
about.
