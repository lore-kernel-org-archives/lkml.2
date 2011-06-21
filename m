Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1FUOH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:07:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24177 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FUOH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:07:27 -0400
Date: Tue, 21 Jun 2011 10:07:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/15] xen/trace: add tlb flush tracepoints
Message-ID: <20110621140705.GD28229@dumpdata.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
 <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E00A595.0019:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:15:05PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/mmu.c         |    8 +++++++
>  include/trace/events/xen.h |   48 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 8aaa398..ad8a226 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1221,6 +1221,8 @@ static void xen_flush_tlb(void)
>  	struct mmuext_op *op;
>  	struct multicall_space mcs;
>  
> +	trace_xen_mmu_flush_tlb(0);
> +
>  	preempt_disable();
>  
>  	mcs = xen_mc_entry(sizeof(*op));
> @@ -1239,6 +1241,8 @@ static void xen_flush_tlb_single(unsigned long addr)
>  	struct mmuext_op *op;
>  	struct multicall_space mcs;
>  
> +	trace_xen_mmu_flush_tlb_single(addr);
> +
>  	preempt_disable();
>  
>  	mcs = xen_mc_entry(sizeof(*op));
> @@ -1261,6 +1265,8 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>  	} *args;
>  	struct multicall_space mcs;
>  
> +	trace_xen_mmu_flush_tlb_others(cpus, mm, va);
> +
>  	if (cpumask_empty(cpus))
>  		return;		/* nothing to do */
>  
> @@ -1300,6 +1306,8 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
>  	struct multicall_space mcs;
>  	unsigned long mfn;
>  
> +	trace_xen_mmu_write_cr3(kernel, cr3);
> +
>  	if (cr3)
>  		mfn = pfn_to_mfn(PFN_DOWN(cr3));
>  	else
> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index b1f73c4..7d88f7d 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -405,6 +405,54 @@ TRACE_EVENT(xen_mmu_pgd_unpin,
>  	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
>  	);
>  
> +TRACE_EVENT(xen_mmu_flush_tlb,
> +	    TP_PROTO(int x),
> +	    TP_ARGS(x),
> +	    TP_STRUCT__entry(__array(char, x, 0)),
> +	    TP_fast_assign((void)x),
> +	    TP_printk("%s", "")

Um, why not just "" without the %s?
> +	);
> +
> +TRACE_EVENT(xen_mmu_flush_tlb_single,
> +	    TP_PROTO(unsigned long addr),
> +	    TP_ARGS(addr),
> +	    TP_STRUCT__entry(
> +		    __field(unsigned long, addr)
> +		    ),
> +	    TP_fast_assign(__entry->addr = addr),
> +	    TP_printk("addr %lx", __entry->addr)
> +	);
> +
> +TRACE_EVENT(xen_mmu_flush_tlb_others,
> +	    TP_PROTO(const struct cpumask *cpus, struct mm_struct *mm,
> +		     unsigned long addr),
> +	    TP_ARGS(cpus, mm, addr),
> +	    TP_STRUCT__entry(
> +		    __field(unsigned, ncpus)
> +		    __field(struct mm_struct *, mm)
> +		    __field(unsigned long, addr)
> +		    ),
> +	    TP_fast_assign(__entry->ncpus = cpumask_weight(cpus);
> +			   __entry->mm = mm;
> +			   __entry->addr = addr),
> +	    TP_printk("ncpus %d mm %p addr %lx",
> +		      __entry->ncpus, __entry->mm, __entry->addr)
> +	);
> +
> +TRACE_EVENT(xen_mmu_write_cr3,
> +	    TP_PROTO(bool kernel, unsigned long cr3),
> +	    TP_ARGS(kernel, cr3),
> +	    TP_STRUCT__entry(
> +		    __field(bool, kernel)
> +		    __field(unsigned long, cr3)
> +		    ),
> +	    TP_fast_assign(__entry->kernel = kernel;
> +			   __entry->cr3 = cr3),
> +	    TP_printk("%s cr3 %lx",
> +		      __entry->kernel ? "kernel" : "user", __entry->cr3)
> +	);
> +
> +
>  /* CPU */
>  TRACE_EVENT(xen_cpu_write_ldt_entry,
>  	    TP_PROTO(struct desc_struct *dt, int entrynum, u64 desc),
> -- 
> 1.7.5.4
