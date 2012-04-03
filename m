Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2DCOiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab2DCOiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:38:09 -0400
Date: Tue, 3 Apr 2012 16:37:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm: account VMA before forced-COW via /proc/pid/mem
Message-ID: <20120403143752.GA5150@redhat.com>
References: <20120402153631.5101.44091.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402153631.5101.44091.stgit@zurg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Konstantin Khlebnikov wrote:
>
> Currently kernel does not account read-only private mappings into memory commitment.
> But these mappings can be force-COW-ed in get_user_pages().

Heh. tail -n3 Documentation/vm/overcommit-accounting
may be you should update it then.

Can't really comment the patch, this is not my area. Still,

> +	down_write(&mm->mmap_sem);
> +	*pvma = vma = find_vma(mm, addr);
> +	if (vma && vma->vm_start <= addr) {
> +		ret = vma->vm_end - addr;
> +		if ((vma->vm_flags & (VM_ACCOUNT | VM_NORESERVE | VM_SHARED |
> +				VM_HUGETLB | VM_MAYWRITE)) == VM_MAYWRITE) {
> +			if (!security_vm_enough_memory_mm(mm, vma_pages(vma)))

Oooooh, the whole vma. Say, gdb installs the single breakpoint into
the huge .text mapping...

I am not sure, but probably you want to check at least VM_IO/PFNMAP
as well. We do not want to charge this memory and retry with FOLL_FORCE
before vm_ops->access(). Say, /dev/mem.

Hmm. OTOH, if I am right then mprotect_fixup() should be fixed??


We drop ->mmap_sem... Say, the task does mremap() in between and
len == 2 * PAGE_SIZE. Then, for example, copy_to_user_page() can
write to the same page twice. Perhaps not a problem in practice,
I dunno.

Oleg.

