Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2FTMNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:13:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36224 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2FTMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:13:06 -0400
Date: Wed, 20 Jun 2012 17:37:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] uprobes: __replace_page() should not use
 page_address_in_vma()
Message-ID: <20120620120742.GK4629@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120619194636.GA30137@redhat.com>
 <20120619194712.GB30146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120619194712.GB30146@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062012-6148-0000-0000-000006E100F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-19 21:47:12]:

> page_address_in_vma(old_page) in __replace_page() is ugly and wrong.
> The caller already knows the correct virtual address, this page was
> found by get_user_pages(vaddr).
> 
> However, page_address_in_vma() can actually fail if page->mapping was
> cleared by __delete_from_page_cache() after get_user_pages() returns.
> But this means the race with page reclaim, write_opcode() should not
> fail, it should retry and read this page again. Not sure this race is
> really possible though, page_freeze_refs() logic should prevent it.
> 
> We could change __replace_page() to return -EAGAIN in this case, but
> it would be better to simply use the caller's vaddr and rely on
> page_check_address().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a2b32a5..5b10705 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -132,17 +132,13 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
>   *
>   * Returns 0 on success, -EFAULT on failure.
>   */
> -static int __replace_page(struct vm_area_struct *vma, struct page *page, struct page *kpage)
> +static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
> +				struct page *page, struct page *kpage)

Could please update the comment above __replace_page to mention that it
now takes addr as a parameter?

