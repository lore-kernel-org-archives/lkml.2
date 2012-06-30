Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab2F3CWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 22:22:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2F3CWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 22:22:43 -0400
Date: Fri, 29 Jun 2012 19:22:39 -0700
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm v2 07/11] mm: make cache alignment code generic
Message-ID: <20120630022239.GA23735@google.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
 <1340315835-28571-8-git-send-email-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340315835-28571-8-git-send-email-riel@surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 05:57:11PM -0400, Rik van Riel wrote:
>  				/* Is this gap large enough? Remember it. */
>  				vma_start = max(vma->vm_prev->vm_end, lower_limit);
> +				vma_start = arch_align_addr(vma_start, filp,
> +						pgoff, flags, ALLOC_UP);
>  				if (vma->vm_start - len >= vma_start) {
>  					addr = vma_start;
>  					found_here = true;


So, right there you're losing the benefit of O(log N) allocations on these
vmas that require alignment. The rbtree lets you quickly find an allocation
that has the desired size, but you may see any number of them without ever
finding one that is large enough after alignment.

I wonder if one could go with a two-stage process:

1- figure out what gap size would guarantee a successful, aligned allocation.
basically it's desired size + desired alignment - PAGE_SIZE. See if you
can find a gap of that size, and carve your aligned allocation into it
if possible.

2- if that failed, look for all gaps of at least the desired size,
as you are proposing, and see if any of them is aligned enough for
your requirements.

This would possibly cause a bit more virtual address space fragmentation,
but I think this should still work ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
