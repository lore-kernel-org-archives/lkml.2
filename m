Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1FMNsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1FMNsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:48:52 -0400
Date: Mon, 13 Jun 2011 15:46:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
	replacement.
Message-ID: <20110613134636.GA21979@redhat.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Srikar Dronamraju wrote:
>
> +static int __replace_page(struct vm_area_struct *vma, struct page *page,
> +					struct page *kpage)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *ptep;
> +	spinlock_t *ptl;
> +	unsigned long addr;
> +	int err = -EFAULT;
> +
> +	addr = page_address_in_vma(page, vma);
> +	if (addr == -EFAULT)
> +		goto out;
> +
> +	pgd = pgd_offset(mm, addr);
> +	if (!pgd_present(*pgd))
> +		goto out;
> +
> +	pud = pud_offset(pgd, addr);
> +	if (!pud_present(*pud))
> +		goto out;
> +
> +	pmd = pmd_offset(pud, addr);
> +	if (pmd_trans_huge(*pmd) || (!pmd_present(*pmd)))
> +		goto out;

Hmm. So it doesn't work with transhuge pages? May be the caller should
use __gup(FOLL_SPLIT), otherwise set_bkpt/etc can fail "mysteriously", no?
OTOH, I don't really understand how pmd_trans_huge() is possible, valid_vma()
checks ->vm_file != NULL and I iiuc transparent hugepages can only work
with anonymous mappings. Confused...

But the real problem (afaics) is VM_HUGETLB mappings. I can't understand
how __replace_page() can work in this case. Probably valid_vma() should
fail if is_vm_hugetlb_page()?

Oleg.

