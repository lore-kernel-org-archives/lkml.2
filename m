Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab2CVVVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:21:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030799Ab2CVVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:21:08 -0400
Date: Thu, 22 Mar 2012 14:21:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/16] mm/arm: use vm_flags_t for vma flags
Message-Id: <20120322142106.3aa383a5.akpm@linux-foundation.org>
In-Reply-To: <20120321065642.13852.95838.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
	<20120321065642.13852.95838.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 10:56:42 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Cast vm_flags to unsigned int for __cpuc_flush_user_range(),
> because its vm_flags argument declared as unsigned int.
> Asssembler code wants to test VM_EXEC bit on vma->vm_flags,
> but for big-endian we should get upper word for this.
> 
> ...
>
> --- a/arch/arm/include/asm/cacheflush.h
> +++ b/arch/arm/include/asm/cacheflush.h
> @@ -217,7 +217,7 @@ vivt_flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned
>  {
>  	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
>  		__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
> -					vma->vm_flags);
> +					(__force unsigned int)vma->vm_flags);
>  }

This won't work if a later version of __cpuc_flush_user_range() needs
access to newly-added flags in the upper 32 bits.

I guess we don't have to do anything about it at this stage, and that
if we do ever hit this problem, we'll need to put those newly-added
flags into the lower 32 bits of the vm_flags_t.
