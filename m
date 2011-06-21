Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1FUA1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:27:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1FUA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:27:18 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=NKcxFZwDKg0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=33_jwaMYAIimnE1oTKYA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 05/15] xen/trace: add mmu tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <81e1942a6f60ee5760056b6f5a8054e8b379462b.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
	 <81e1942a6f60ee5760056b6f5a8054e8b379462b.1308607697.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Jun 2011 20:27:14 -0400
Message-ID: <1308616034.531.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 15:15 -0700, Jeremy Fitzhardinge wrote:

> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index 54600a7..5c4e967 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -125,6 +125,229 @@ TRACE_EVENT(xen_mc_extend_args,
>  		      __entry->res == XEN_MC_XE_BAD_OP ? "BAD_OP" :
>  		      __entry->res == XEN_MC_XE_NO_SPACE ? "NO_SPACE" : "???")
>  	);
> +
> +/* mmu */
> +TRACE_EVENT(xen_mmu_set_pte,
> +	    TP_PROTO(pte_t *ptep, pte_t pteval),
> +	    TP_ARGS(ptep, pteval),
> +	    TP_STRUCT__entry(
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    ),
> +	    TP_fast_assign(__entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte),
> +	    TP_printk("ptep %p pteval %0*llx (raw %0*llx)",
> +		      __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_set_pte_atomic,
> +	    TP_PROTO(pte_t *ptep, pte_t pteval),
> +	    TP_ARGS(ptep, pteval),
> +	    TP_STRUCT__entry(
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    ),
> +	    TP_fast_assign(__entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte),
> +	    TP_printk("ptep %p pteval %0*llx (raw %0*llx)",
> +		      __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
> +	);
> +

When possible, please use DECLARE_EVENT_CLASS() and DEFINE_EVENT() for
trace events that are identical but just have a different name. You can
save kilobytes of .text by doing so.

-- Steve

> +TRACE_EVENT(xen_mmu_set_domain_pte,
> +	    TP_PROTO(pte_t *ptep, pte_t pteval, unsigned domid),
> +	    TP_ARGS(ptep, pteval, domid),
> +	    TP_STRUCT__entry(
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    __field(unsigned, domid)
> +		    ),
> +	    TP_fast_assign(__entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte;
> +			   __entry->domid = domid),
> +	    TP_printk("ptep %p pteval %0*llx (raw %0*llx) domid %u",
> +		      __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval,
> +		      __entry->domid)
> +	);
> +
> +TRACE_EVENT(xen_mmu_set_pte_at,
> +	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
> +		     pte_t *ptep, pte_t pteval),
> +	    TP_ARGS(mm, addr, ptep, pteval),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, addr)
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->addr = addr;
> +			   __entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte),
> +	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
> +		      __entry->mm, __entry->addr, __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_pte_clear,
> +	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
> +	    TP_ARGS(mm, addr, ptep),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, addr)
> +		    __field(pte_t *, ptep)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->addr = addr;
> +			   __entry->ptep = ptep),
> +	    TP_printk("mm %p addr %lx ptep %p",
> +		      __entry->mm, __entry->addr, __entry->ptep)
> +	);
> +
> +TRACE_EVENT(xen_mmu_set_pmd,
> +	    TP_PROTO(pmd_t *pmdp, pmd_t pmdval),
> +	    TP_ARGS(pmdp, pmdval),
> +	    TP_STRUCT__entry(
> +		    __field(pmd_t *, pmdp)
> +		    __field(pmdval_t, pmdval)
> +		    ),
> +	    TP_fast_assign(__entry->pmdp = pmdp;
> +			   __entry->pmdval = pmdval.pmd),
> +	    TP_printk("pmdp %p pmdval %0*llx (raw %0*llx)",
> +		      __entry->pmdp,
> +		      (int)sizeof(pmdval_t) * 2, (unsigned long long)pmd_val(native_make_pmd(__entry->pmdval)),
> +		      (int)sizeof(pmdval_t) * 2, (unsigned long long)__entry->pmdval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_pmd_clear,
> +	    TP_PROTO(pmd_t *pmdp),
> +	    TP_ARGS(pmdp),
> +	    TP_STRUCT__entry(
> +		    __field(pmd_t *, pmdp)
> +		    ),
> +	    TP_fast_assign(__entry->pmdp = pmdp),
> +	    TP_printk("pmdp %p", __entry->pmdp)
> +	);
> +
> +#if PAGETABLE_LEVELS >= 4
> +
> +TRACE_EVENT(xen_mmu_set_pud,
> +	    TP_PROTO(pud_t *pudp, pud_t pudval),
> +	    TP_ARGS(pudp, pudval),
> +	    TP_STRUCT__entry(
> +		    __field(pud_t *, pudp)
> +		    __field(pudval_t, pudval)
> +		    ),
> +	    TP_fast_assign(__entry->pudp = pudp;
> +			   __entry->pudval = native_pud_val(pudval)),
> +	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
> +		      __entry->pudp,
> +		      (int)sizeof(pudval_t) * 2, (unsigned long long)pud_val(native_make_pud(__entry->pudval)),
> +		      (int)sizeof(pudval_t) * 2, (unsigned long long)__entry->pudval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_set_pgd,
> +	    TP_PROTO(pgd_t *pgdp, pgd_t *user_pgdp, pgd_t pgdval),
> +	    TP_ARGS(pgdp, user_pgdp, pgdval),
> +	    TP_STRUCT__entry(
> +		    __field(pgd_t *, pgdp)
> +		    __field(pgd_t *, user_pgdp)
> +		    __field(pgdval_t, pgdval)
> +		    ),
> +	    TP_fast_assign(__entry->pgdp = pgdp;
> +			   __entry->user_pgdp = user_pgdp;
> +			   __entry->pgdval = pgdval.pgd),
> +	    TP_printk("pgdp %p user_pgdp %p pgdval %0*llx (raw %0*llx)",
> +		      __entry->pgdp, __entry->user_pgdp,
> +		      (int)sizeof(pgdval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->pgdval)),
> +		      (int)sizeof(pgdval_t) * 2, (unsigned long long)__entry->pgdval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_pud_clear,
> +	    TP_PROTO(pud_t *pudp),
> +	    TP_ARGS(pudp),
> +	    TP_STRUCT__entry(
> +		    __field(pud_t *, pudp)
> +		    ),
> +	    TP_fast_assign(__entry->pudp = pudp),
> +	    TP_printk("pudp %p", __entry->pudp)
> +	);
> +#else
> +
> +TRACE_EVENT(xen_mmu_set_pud,
> +	    TP_PROTO(pud_t *pudp, pud_t pudval),
> +	    TP_ARGS(pudp, pudval),
> +	    TP_STRUCT__entry(
> +		    __field(pud_t *, pudp)
> +		    __field(pudval_t, pudval)
> +		    ),
> +	    TP_fast_assign(__entry->pudp = pudp;
> +			   __entry->pudval = native_pud_val(pudval)),
> +	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
> +		      __entry->pudp,
> +		      (int)sizeof(pudval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->pudval)),
> +		      (int)sizeof(pudval_t) * 2, (unsigned long long)__entry->pudval)
> +	);
> +
> +#endif
> +
> +TRACE_EVENT(xen_mmu_pgd_clear,
> +	    TP_PROTO(pgd_t *pgdp),
> +	    TP_ARGS(pgdp),
> +	    TP_STRUCT__entry(
> +		    __field(pgd_t *, pgdp)
> +		    ),
> +	    TP_fast_assign(__entry->pgdp = pgdp),
> +	    TP_printk("pgdp %p", __entry->pgdp)
> +	);
> +
> +TRACE_EVENT(xen_mmu_ptep_modify_prot_start,
> +	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
> +		     pte_t *ptep, pte_t pteval),
> +	    TP_ARGS(mm, addr, ptep, pteval),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, addr)
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->addr = addr;
> +			   __entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte),
> +	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
> +		      __entry->mm, __entry->addr, __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
> +	);
> +
> +TRACE_EVENT(xen_mmu_ptep_modify_prot_commit,
> +	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
> +		     pte_t *ptep, pte_t pteval),
> +	    TP_ARGS(mm, addr, ptep, pteval),
> +	    TP_STRUCT__entry(
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, addr)
> +		    __field(pte_t *, ptep)
> +		    __field(pteval_t, pteval)
> +		    ),
> +	    TP_fast_assign(__entry->mm = mm;
> +			   __entry->addr = addr;
> +			   __entry->ptep = ptep;
> +			   __entry->pteval = pteval.pte),
> +	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
> +		      __entry->mm, __entry->addr, __entry->ptep,
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
> +		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
> +	);
> +
> +
>  #endif /*  _TRACE_XEN_H */
>  
>  /* This part must be outside protection */


