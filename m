Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1FUNzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:55:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60616 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab1FUNzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:55:35 -0400
Date: Tue, 21 Jun 2011 09:55:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/15] xen/trace: add ptpage alloc/release tracepoints
Message-ID: <20110621135511.GB28229@dumpdata.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
 <a92051a41ed96ad362d1f79c7b3e36c8cc4dd80b.1308607697.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a92051a41ed96ad362d1f79c7b3e36c8cc4dd80b.1308607697.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E00A2CD.0033:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:15:02PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/mmu.c         |   10 ++++++++--
>  include/trace/events/xen.h |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 90101c5..84c796f 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1473,8 +1473,11 @@ static void __init xen_release_pmd_init(unsigned long pfn)
>  static void xen_alloc_ptpage(struct mm_struct *mm, unsigned long pfn, unsigned level)
>  {
>  	struct page *page = pfn_to_page(pfn);
> +	int pinned = PagePinned(virt_to_page(mm->pgd));

Why not use 'bool' as you
> + 

^ this above has a space right after it.
> +	trace_xen_mmu_alloc_ptpage(mm, pfn, level, pinned);
>  
> -	if (PagePinned(virt_to_page(mm->pgd))) {
> +	if (pinned) {
>  		SetPagePinned(page);
>  
>  		if (!PageHighMem(page)) {
> @@ -1503,8 +1506,11 @@ static void xen_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
>  static void xen_release_ptpage(unsigned long pfn, unsigned level)
>  {
>  	struct page *page = pfn_to_page(pfn);
> +	bool pinned = PagePinned(page);

..do here?
>  
> -	if (PagePinned(page)) {
> +	trace_xen_mmu_release_ptpage(pfn, level, pinned);
> +
> +	if (pinned) {
>  		if (!PageHighMem(page)) {
>  			if (level == PT_PTE && USE_SPLIT_PTLOCKS)
>  				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index 5c4e967..16edcb7 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -347,6 +347,39 @@ TRACE_EVENT(xen_mmu_ptep_modify_prot_commit,
>  		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
>  	);
>  
> +TRACE_EVENT(xen_mmu_alloc_ptpage,
> +	    TP_PROTO(struct mm_struct *mm, unsigned long pfn, unsigned level, bool pinned),
> +	    TP_ARGS(mm, pfn, level, pinned),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, pfn)
> +		    __field(unsigned, level)
> +		    __field(bool, pinned)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->pfn = pfn;
> +			   __entry->level = level;
> +			   __entry->pinned = pinned),
> +	    TP_printk("mm %p  pfn %lx  level %d  %spinned",
> +		      __entry->mm, __entry->pfn, __entry->level,
> +		      __entry->pinned ? "" : "un")
> +	);
> +
> +TRACE_EVENT(xen_mmu_release_ptpage,
> +	    TP_PROTO(unsigned long pfn, unsigned level, bool pinned),
> +	    TP_ARGS(pfn, level, pinned),
> +	    TP_STRUCT__entry(
> +		    __field(unsigned long, pfn)
> +		    __field(unsigned, level)
> +		    __field(bool, pinned)
> +		    ),
> +	    TP_fast_assign(__entry->pfn = pfn;
> +			   __entry->level = level;
> +			   __entry->pinned = pinned),
> +	    TP_printk("pfn %lx  level %d  %spinned",
> +		      __entry->pfn, __entry->level,
> +		      __entry->pinned ? "" : "un")
> +	);
>  
>  #endif /*  _TRACE_XEN_H */
>  
> -- 
> 1.7.5.4
