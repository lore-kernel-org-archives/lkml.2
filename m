Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab1GJP7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:59:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:20773 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab1GJP7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,509,1304319600"; 
   d="scan'208";a="25938642"
Date: Sun, 10 Jul 2011 08:59:06 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [TOME] Re: [PATCH 3/3] mm/readahead: Move the check for
 ra_pages after VM_SequentialReadHint()
Message-ID: <20110710155906.GB7432@localhost>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
 <20110709205308.GC17463@localhost>
 <20110710125909.GA4460@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710125909.GA4460@Xye>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 08:59:09PM +0800, Raghavendra D Prabhu wrote:
> * On Sat, Jul 09, 2011 at 01:53:08PM -0700, Wu Fengguang <fengguang.wu@intel.com> wrote:
> >On Sun, Jul 10, 2011 at 03:41:20AM +0800, Raghavendra D Prabhu wrote:
> >>page_cache_sync_readahead checks for ra->ra_pages again, so moving the check after VM_SequentialReadHint.
> >
> >NAK. This patch adds nothing but overheads.
> >
> >>--- a/mm/filemap.c
> >>+++ b/mm/filemap.c
> >>@@ -1566,8 +1566,6 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
> >> 	/* If we don't want any read-ahead, don't bother */
> >> 	if (VM_RandomReadHint(vma))
> >> 		return;
> >>-	if (!ra->ra_pages)
> >>-		return;
> 
> >> 	if (VM_SequentialReadHint(vma)) {
> >> 		page_cache_sync_readahead(mapping, ra, file, offset,
> >>@@ -1575,6 +1573,9 @@ static void do_sync_mmap_readahead(struct vm_area_struct *vma,
> >> 		return;
> >> 	}
> 
> >>+	if (!ra->ra_pages)
> >>+		return;
> >>+
> >
> >page_cache_sync_readahead() has the same
> >
> >	if (!ra->ra_pages)
> >		return;
> 1. Yes, I saw that and that is why I moved it after the condition, so that duplicate checks are
> not needed -- ie., if VM_SequentialReadHint is true, then
> (!ra->ra_pages) is checked twice otherwise.

Ok, I see.

> 2. Also, another thought, is the check needed at its original place (if
> not it can be removed), reasons being -- filesystems like tmpfs which
> have ra_pages set to 0 don't use filemap_fault in their VMA ops and also

Good point. tmpfs is using shmem_fault().. Can you remove the test?  

> do_sync_mmap_readahead is called in a major page fault context.

Right. This is irrelevant however, because if pa_pages==0, the
page faults will normally be major ones.

Thanks,
Fengguang

> >So the patch adds the call into page_cache_sync_readahead() just to return..
> >
> >Thanks,
> >Fengguang
> >
> --------------------------
> Raghavendra Prabhu
> GPG Id : 0xD72BE977
> Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
> www: wnohang.net


