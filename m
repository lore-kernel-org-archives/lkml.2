Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1FUOEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:04:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18497 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1FUOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:04:00 -0400
Date: Tue, 21 Jun 2011 10:03:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 08/15] xen/trace: add segment desc tracing
Message-ID: <20110621140331.GC28229@dumpdata.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
 <834e06a069d43f0cd34794326aaa7094cd53433b.1308607697.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <834e06a069d43f0cd34794326aaa7094cd53433b.1308607697.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E00A4C0.00CA:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:15:04PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/enlighten.c   |   16 +++++++++-
>  include/trace/events/xen.h |   75 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 90 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index dd7b88f..fa4e2d2 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -341,6 +341,8 @@ static void xen_set_ldt(const void *addr, unsigned entries)
>  	struct mmuext_op *op;
>  	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
>  
> +	trace_xen_cpu_set_ldt(addr, entries);
> +
>  	op = mcs.args;
>  	op->cmd = MMUEXT_SET_LDT;
>  	op->arg1.linear_addr = (unsigned long)addr;
> @@ -496,6 +498,8 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
>  	xmaddr_t mach_lp = arbitrary_virt_to_machine(&dt[entrynum]);
>  	u64 entry = *(u64 *)ptr;
>  
> +	trace_xen_cpu_write_ldt_entry(dt, entrynum, entry);
> +
>  	preempt_disable();
>  
>  	xen_mc_flush();
> @@ -565,6 +569,8 @@ static void xen_write_idt_entry(gate_desc *dt, int entrynum, const gate_desc *g)
>  	unsigned long p = (unsigned long)&dt[entrynum];
>  	unsigned long start, end;
>  
> +	trace_xen_cpu_write_idt_entry(dt, entrynum, g);
> +
>  	preempt_disable();
>  
>  	start = __this_cpu_read(idt_desc.address);
> @@ -619,6 +625,8 @@ static void xen_load_idt(const struct desc_ptr *desc)
>  	static DEFINE_SPINLOCK(lock);
>  	static struct trap_info traps[257];
>  
> +	trace_xen_cpu_load_idt(desc);
> +
>  	spin_lock(&lock);
>  
>  	__get_cpu_var(idt_desc) = *desc;
> @@ -637,6 +645,8 @@ static void xen_load_idt(const struct desc_ptr *desc)
>  static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
>  				const void *desc, int type)
>  {
> +	trace_xen_cpu_write_gdt_entry(dt, entry, desc, type);
> +
>  	preempt_disable();
>  
>  	switch (type) {
> @@ -665,6 +675,8 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
>  static void __init xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
>  					    const void *desc, int type)
>  {
> +	trace_xen_cpu_write_gdt_entry(dt, entry, desc, type);
> +
>  	switch (type) {
>  	case DESC_LDT:
>  	case DESC_TSS:
> @@ -684,7 +696,9 @@ static void __init xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
>  static void xen_load_sp0(struct tss_struct *tss,
>  			 struct thread_struct *thread)
>  {
> -	struct multicall_space mcs = xen_mc_entry(0);
> +	struct multicall_space mcs;
> +
> +	mcs = xen_mc_entry(0);

<scratches his head> Is this prepping it for another commit?

>  	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->sp0);
>  	xen_mc_issue(PARAVIRT_LAZY_CPU);
>  }
> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
> index 5811c24..b1f73c4 100644
> --- a/include/trace/events/xen.h
> +++ b/include/trace/events/xen.h
> @@ -405,6 +405,81 @@ TRACE_EVENT(xen_mmu_pgd_unpin,
>  	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
>  	);
>  
> +/* CPU */
> +TRACE_EVENT(xen_cpu_write_ldt_entry,
> +	    TP_PROTO(struct desc_struct *dt, int entrynum, u64 desc),
> +	    TP_ARGS(dt, entrynum, desc),
> +	    TP_STRUCT__entry(
> +		    __field(struct desc_struct *, dt)
> +		    __field(int, entrynum)
> +		    __field(u64, desc)
> +		    ),
> +	    TP_fast_assign(__entry->dt = dt;
> +			   __entry->entrynum = entrynum;
> +			   __entry->desc = desc;
> +		    ),
> +	    TP_printk("dt %p  entrynum %d  entry %016llx",
> +		      __entry->dt, __entry->entrynum,
> +		      (unsigned long long)__entry->desc)
> +	);
> +
> +TRACE_EVENT(xen_cpu_write_idt_entry,
> +	    TP_PROTO(gate_desc *dt, int entrynum, const gate_desc *ent),
> +	    TP_ARGS(dt, entrynum, ent),
> +	    TP_STRUCT__entry(
> +		    __field(gate_desc *, dt)
> +		    __field(int, entrynum)
> +		    ),
> +	    TP_fast_assign(__entry->dt = dt;
> +			   __entry->entrynum = entrynum;
> +		    ),
> +	    TP_printk("dt %p  entrynum %d",
> +		      __entry->dt, __entry->entrynum)
> +	);

The 'ent' isn't being printed?

> +
> +TRACE_EVENT(xen_cpu_load_idt,
> +	    TP_PROTO(const struct desc_ptr *desc),
> +	    TP_ARGS(desc),
> +	    TP_STRUCT__entry(
> +		    __field(unsigned long, addr)
> +		    ),
> +	    TP_fast_assign(__entry->addr = desc->address),
> +	    TP_printk("addr %lx", __entry->addr)
> +	);
> +
> +TRACE_EVENT(xen_cpu_write_gdt_entry,
> +	    TP_PROTO(struct desc_struct *dt, int entrynum, const void *desc, int type),
> +	    TP_ARGS(dt, entrynum, desc, type),
> +	    TP_STRUCT__entry(
> +		    __field(struct desc_struct *, dt)
> +		    __field(int, entrynum)
> +		    __field(int, type)
> +		    __field(u64, desc)

The order here is different from the arguments.
> +		    ),
> +	    TP_fast_assign(__entry->dt = dt;
> +			   __entry->entrynum = entrynum;
> +			   __entry->type = type;
> +			   __entry->desc = *(u64 *)desc;
> +		    ),

Ditto
> +	    TP_printk("dt %p  entrynum %d  type %d  desc %016llx",
> +		      __entry->dt, __entry->entrynum, __entry->type,
> +		      (unsigned long long)__entry->desc)
> +	);
> +
> +TRACE_EVENT(xen_cpu_set_ldt,
> +	    TP_PROTO(const void *addr, unsigned entries),
> +	    TP_ARGS(addr, entries),
> +	    TP_STRUCT__entry(
> +		    __field(const void *, addr)
> +		    __field(unsigned, entries)
> +		    ),
> +	    TP_fast_assign(__entry->addr = addr;
> +			   __entry->entries = entries),
> +	    TP_printk("addr %p  entries %u",
> +		      __entry->addr, __entry->entries)
> +	);
> +
> +
>  #endif /*  _TRACE_XEN_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.7.5.4
