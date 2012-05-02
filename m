Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab2EBRzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2EBRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:55:16 -0400
Date: Wed, 2 May 2012 19:55:08 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference
 transparent_hugepage_enabled
Message-ID: <20120502175508.GC2410@redhat.com>
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com>
 <20120430160520.4c1cc05c.akpm@linux-foundation.org>
 <4FA0A743.2070904@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA0A743.2070904@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:17:23AM +0800, Alex Shi wrote:
> On 05/01/2012 07:05 AM, Andrew Morton wrote:
> 
> > On Sat, 28 Apr 2012 14:33:15 +0800
> > Alex Shi <alex.shi@intel.com> wrote:
> > 
> >> When the transparent_hugepage_enabled() used out of mm/,
> >> is_vma_temporary_stack() need be referenced. Otherwise, it has compile
> >> error.
> > 
> > This is a poor changelog - it doesn't tell us how this compilation
> > error comes about.  Is there some known build error in the mainline
> > kernel, or did you discover this when altering the kernel, or what?
> 
> > 
> 
> > One of the several reasons for this information is to permit others to
> > work out which kernel version(s) should be fixed.
> > 

I wanted to ask the same question.

> I am sorry for the unclear log!
> When I try to transparent_hugepage_enabled() in arch/x86/mm/tlb.c with
> huge_mm.h include: +#include <linux/huge_mm.h>. make give me the following
> error:

I already guessed it was for development code out of tree code but I
wasn't sure, thanks for the clarification.

> ...
>   CC      arch/x86/mm/srat.o
> arch/x86/mm/tlb.c: In function ‘flush_tlb_range’:
> arch/x86/mm/tlb.c:324:4: error: implicit declaration of function ‘is_vma_temporary_stack’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> ...
> Since it is not convenitant for user to include 2 head files just for one 
> target function, I send this patch. 
> 
> > is_vma_temporary_stack() is already declared in rmap.h.  We should not
> > declare it in two places.

My preference would still be to remove the is_vma_temporary_stack and
use two vmas during mremap of execve, that would remove the "vma"
parameter from transparent_hugepage_enabled() but others prefers to
skip a vma allocation in execve and stick to is_vma_temporary_stack,
which is fair enough argument.

> Oh, yes. Since is_vma_temporay_stack is just used in rmap.c and huge_memory.c
> . is it better to move it to huge_mm.h?

I guess it was cleaner on rmap.h as this is not related to THP, but
clearly it works better in huge_mm.h (and rmap.h->mm.h->huge_mm.h is
included automatically) so the patch looks fine to me.

Thanks,
Andrea
