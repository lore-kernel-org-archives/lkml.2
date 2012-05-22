Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2EVV2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2EVV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:28:37 -0400
Date: Tue, 22 May 2012 14:28:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, aarcange@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, hughd@google.com, rientjes@google.com,
        adobriyan@gmail.com, mel@csn.ul.ie, stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix resv_map leak in error path
Message-Id: <20120522142835.50b86ddc.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1205221603290.21828@router.home>
References: <20120521202814.E01F0FE1@kernel>
	<20120522134558.49255899.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1205221603290.21828@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012 16:05:02 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> > How far back does this bug go?  The patch applies to 3.4 but gets
> > rejects in 3.3 and earlier.
> 
> The earliest that I have seen it on was 2.6.32. I have rediffed the patch
> against 2.6.32 and 3.2.0.

Great, thanks.  I did

: From: Dave Hansen <dave@linux.vnet.ibm.com>
: Subject: hugetlb: fix resv_map leak in error path
: 
: When called for anonymous (non-shared) mappings, hugetlb_reserve_pages()
: does a resv_map_alloc().  It depends on code in hugetlbfs's
: vm_ops->close() to release that allocation.
: 
: However, in the mmap() failure path, we do a plain unmap_region() without
: the remove_vma() which actually calls vm_ops->close().
: 
: This is a decent fix.  This leak could get reintroduced if new code (say,
: after hugetlb_reserve_pages() in hugetlbfs_file_mmap()) decides to return
: an error.  But, I think it would have to unroll the reservation anyway.
: 
: Christoph's test case:
: 
: 	http://marc.info/?l=linux-mm&m=133728900729735
: 
: This patch applies to 3.4 and later.  A version for earlier kernels is at
: https://lkml.org/lkml/2012/5/22/418.
: 
: Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
: Acked-by: Mel Gorman <mel@csn.ul.ie>
: Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
: Reported-by: Christoph Lameter <cl@linux.com>
: Tested-by: Christoph Lameter <cl@linux.com>
: Cc: Andrea Arcangeli <aarcange@redhat.com>
: Cc: <stable@vger.kernel.org>	[2.6.32+]

