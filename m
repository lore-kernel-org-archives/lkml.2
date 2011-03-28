Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1C1Q6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:58:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:45740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1C1Q6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,256,1299484800"; 
   d="scan'208";a="726075714"
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]mmap: not merge cloned VMA
References: <1301277534.3981.26.camel@sli10-conroe>
Date: Mon, 28 Mar 2011 09:57:06 -0700
In-Reply-To: <1301277534.3981.26.camel@sli10-conroe> (Shaohua Li's message of
	"Mon, 28 Mar 2011 09:58:54 +0800")
Message-ID: <m2k4fj18v1.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> Avoid merging a VMA with another VMA which is cloned from parent process. The
> cloned VMA shares lock with parent process's VMA. If we do the merge, more vma
> area (even the new range is only for current process) uses perent process's
> anon_vma lock, so introduces scalability issues.
> find_mergeable_anon_vma already considers this.

In theory this could prevent quite some VMA merging, but I guess the 
tradeoff is worth it and that should be unlikely to hit anyways.

>  static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
> -					struct anon_vma *anon_vma2)
> +					struct anon_vma *anon_vma2,
> +					struct vm_area_struct *vma)
>  {
> -	return !anon_vma1 || !anon_vma2 || (anon_vma1 == anon_vma2);
> +	if ((!anon_vma1 || !anon_vma2) && (!vma ||
> +		list_is_singular(&vma->anon_vma_chain)))
> +		return 1;

I think this if () needs a comment.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
