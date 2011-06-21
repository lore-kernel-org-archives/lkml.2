Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1FUROr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:14:47 -0400
Received: from claw.goop.org ([74.207.240.146]:50739 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab1FUROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:14:46 -0400
Message-ID: <4E00D185.4030409@goop.org>
Date: Tue, 21 Jun 2011 10:14:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Xen Devel <Xen-devel@lists.xensource.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 08/15] xen/trace: add segment desc tracing
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com> <834e06a069d43f0cd34794326aaa7094cd53433b.1308607697.git.jeremy.fitzhardinge@citrix.com> <20110621140331.GC28229@dumpdata.com>
In-Reply-To: <20110621140331.GC28229@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 07:03 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 20, 2011 at 03:15:04PM -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  arch/x86/xen/enlighten.c   |   16 +++++++++-
>>  include/trace/events/xen.h |   75 ++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 90 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index dd7b88f..fa4e2d2 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -341,6 +341,8 @@ static void xen_set_ldt(const void *addr, unsigned entries)
>>  	struct mmuext_op *op;
>>  	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
>>  
>> +	trace_xen_cpu_set_ldt(addr, entries);
>> +
>>  	op = mcs.args;
>>  	op->cmd = MMUEXT_SET_LDT;
>>  	op->arg1.linear_addr = (unsigned long)addr;
>> @@ -496,6 +498,8 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
>>  	xmaddr_t mach_lp = arbitrary_virt_to_machine(&dt[entrynum]);
>>  	u64 entry = *(u64 *)ptr;
>>  
>> +	trace_xen_cpu_write_ldt_entry(dt, entrynum, entry);
>> +
>>  	preempt_disable();
>>  
>>  	xen_mc_flush();
>> @@ -565,6 +569,8 @@ static void xen_write_idt_entry(gate_desc *dt, int entrynum, const gate_desc *g)
>>  	unsigned long p = (unsigned long)&dt[entrynum];
>>  	unsigned long start, end;
>>  
>> +	trace_xen_cpu_write_idt_entry(dt, entrynum, g);
>> +
>>  	preempt_disable();
>>  
>>  	start = __this_cpu_read(idt_desc.address);
>> @@ -619,6 +625,8 @@ static void xen_load_idt(const struct desc_ptr *desc)
>>  	static DEFINE_SPINLOCK(lock);
>>  	static struct trap_info traps[257];
>>  
>> +	trace_xen_cpu_load_idt(desc);
>> +
>>  	spin_lock(&lock);
>>  
>>  	__get_cpu_var(idt_desc) = *desc;
>> @@ -637,6 +645,8 @@ static void xen_load_idt(const struct desc_ptr *desc)
>>  static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
>>  				const void *desc, int type)
>>  {
>> +	trace_xen_cpu_write_gdt_entry(dt, entry, desc, type);
>> +
>>  	preempt_disable();
>>  
>>  	switch (type) {
>> @@ -665,6 +675,8 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
>>  static void __init xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
>>  					    const void *desc, int type)
>>  {
>> +	trace_xen_cpu_write_gdt_entry(dt, entry, desc, type);
>> +
>>  	switch (type) {
>>  	case DESC_LDT:
>>  	case DESC_TSS:
>> @@ -684,7 +696,9 @@ static void __init xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
>>  static void xen_load_sp0(struct tss_struct *tss,
>>  			 struct thread_struct *thread)
>>  {
>> -	struct multicall_space mcs = xen_mc_entry(0);
>> +	struct multicall_space mcs;
>> +
>> +	mcs = xen_mc_entry(0);
> <scratches his head> Is this prepping it for another commit?

Urm, not sure.  Will check.

>>  	MULTI_stack_switch(mcs.mc, __KERNEL_DS, thread->sp0);
>>  	xen_mc_issue(PARAVIRT_LAZY_CPU);
>>  }
>> diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
>> index 5811c24..b1f73c4 100644
>> --- a/include/trace/events/xen.h
>> +++ b/include/trace/events/xen.h
>> @@ -405,6 +405,81 @@ TRACE_EVENT(xen_mmu_pgd_unpin,
>>  	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
>>  	);
>>  
>> +/* CPU */
>> +TRACE_EVENT(xen_cpu_write_ldt_entry,
>> +	    TP_PROTO(struct desc_struct *dt, int entrynum, u64 desc),
>> +	    TP_ARGS(dt, entrynum, desc),
>> +	    TP_STRUCT__entry(
>> +		    __field(struct desc_struct *, dt)
>> +		    __field(int, entrynum)
>> +		    __field(u64, desc)
>> +		    ),
>> +	    TP_fast_assign(__entry->dt = dt;
>> +			   __entry->entrynum = entrynum;
>> +			   __entry->desc = desc;
>> +		    ),
>> +	    TP_printk("dt %p  entrynum %d  entry %016llx",
>> +		      __entry->dt, __entry->entrynum,
>> +		      (unsigned long long)__entry->desc)
>> +	);
>> +
>> +TRACE_EVENT(xen_cpu_write_idt_entry,
>> +	    TP_PROTO(gate_desc *dt, int entrynum, const gate_desc *ent),
>> +	    TP_ARGS(dt, entrynum, ent),
>> +	    TP_STRUCT__entry(
>> +		    __field(gate_desc *, dt)
>> +		    __field(int, entrynum)
>> +		    ),
>> +	    TP_fast_assign(__entry->dt = dt;
>> +			   __entry->entrynum = entrynum;
>> +		    ),
>> +	    TP_printk("dt %p  entrynum %d",
>> +		      __entry->dt, __entry->entrynum)
>> +	);
> The 'ent' isn't being printed?

Nor stored.  I don't remember why; possibly because its not all that
interesting and the trace is just there for consistency's sake.  The idt
entries are only ever set at boot time.

>> +
>> +TRACE_EVENT(xen_cpu_load_idt,
>> +	    TP_PROTO(const struct desc_ptr *desc),
>> +	    TP_ARGS(desc),
>> +	    TP_STRUCT__entry(
>> +		    __field(unsigned long, addr)
>> +		    ),
>> +	    TP_fast_assign(__entry->addr = desc->address),
>> +	    TP_printk("addr %lx", __entry->addr)
>> +	);
>> +
>> +TRACE_EVENT(xen_cpu_write_gdt_entry,
>> +	    TP_PROTO(struct desc_struct *dt, int entrynum, const void *desc, int type),
>> +	    TP_ARGS(dt, entrynum, desc, type),
>> +	    TP_STRUCT__entry(
>> +		    __field(struct desc_struct *, dt)
>> +		    __field(int, entrynum)
>> +		    __field(int, type)
>> +		    __field(u64, desc)
> The order here is different from the arguments.

Yeah, and not properly packed.

    J
