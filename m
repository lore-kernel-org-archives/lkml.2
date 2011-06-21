Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1FUA2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:28:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab1FUA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:28:20 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=ogTdH59n8DkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tHz9FfFoAAAA:8 a=wjQiPgO9Tk7QNIx8TbcA:9 a=1QxbqjE6Gvz6qidyCp0A:7 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/15] xen/trace: add xen_pgd_(un)pin tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cdfa49a00e83b62d4fbd0cab251c9c1571a3ce6f.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <cdfa49a00e83b62d4fbd0cab251c9c1571a3ce6f.1308607697.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Jun 2011 20:28:18 -0400
Message-ID: <1308616098.531.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 15:15 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/mmu.c         |    4 ++++
>  include/trace/events/xen.h |   24 ++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 84c796f..8aaa398 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -884,6 +884,8 @@ static int xen_pin_page(struct mm_struct *mm, struct page *page,
>     read-only, and can be pinned. */
>  static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
>  {
> +	trace_xen_mmu_pgd_pin(mm, pgd);
> +
>  	xen_mc_batch();
>  
>  	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
> @@ -1009,6 +1011,8 @@ static int xen_unpin_page(struct mm_struct *mm, struct page *page,
>  /* Release a pagetables pages back as normal RW */
>  static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
>  {
> +	trace_xen_mmu_pgd_unpin(mm, pgd);
> +
>  	xen_mc_batch();
>  
>  	xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index 16edcb7..5811c24 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -381,6 +381,30 @@ TRACE_EVENT(xen_mmu_release_ptpage,
>  		      __entry->pinned ? "" : "un")
>  	);
>  
> +TRACE_EVENT(xen_mmu_pgd_pin,
> +	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
> +	    TP_ARGS(mm, pgd),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(pgd_t *, pgd)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->pgd = pgd),
> +	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
> +	);
> +
> +TRACE_EVENT(xen_mmu_pgd_unpin,
> +	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
> +	    TP_ARGS(mm, pgd),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(pgd_t *, pgd)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->pgd = pgd),
> +	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
> +	);
> +
>  #endif /*  _TRACE_XEN_H */


Looks like there's lots of candidates for DECLARE_EVENT_CLASS() and
DEFINE_EVENT()s.

-- Steve

>  
>  /* This part must be outside protection */


