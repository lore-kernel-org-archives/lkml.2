Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LAEmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 23:42:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38753 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0LAEmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 23:42:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: [RFC] mlock: release mmap_sem every 256 faulted pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20101123050052.GA24039@google.com>
References: <20101123050052.GA24039@google.com>
Message-Id: <20101201134020.ABC8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 13:42:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


minor additionl comments.

> +		/*
> +		 * Limit batch size to 256 pages in order to reduce
> +		 * mmap_sem hold time.
> +		 */
> +		nfault = nstart + 256 * PAGE_SIZE;

You made 256 pages batch and __mlock_vma_pages_range() has 16 pages 
another batch.
Can we unify this two batch?

Plus, PeterZ implemeted mutex contention detect method (see "[PATCH 18/21] 
mutex: Provide mutex_is_contended"). now you can easily implemnt akpm proposed
efficient batching.

Thanks.


> +
> +		/*
> +		 * Now fault in a batch of pages. We need to check the vma
> +		 * flags again, as we've not been holding mmap_sem.
> +		 */
> +		if ((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
> +		    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current)) {
> +			if (nfault < nend)
> +				nend = nfault;
> +			make_pages_present(nstart, nend);
> +		} else if (vma->vm_flags & VM_LOCKED) {
> +			if (nfault < nend)
> +				nend = nfault;
> +			error = __mlock_vma_pages_range(vma, nstart, nend);
> +		}
> +	up:
> +		up_read(&mm->mmap_sem);
> +		if (error)
> +			return __mlock_posix_error_return(error);
> +	}
> +	return 0;
> +}


