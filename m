Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab0JXJpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:45:45 -0400
Received: from www.tglx.de ([62.245.132.106]:52760 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0JXJpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:45:44 -0400
Date: Sun, 24 Oct 2010 11:44:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] x86, apic, acpi: Handle xapic/x2apic entries in
 MADT at same time
In-Reply-To: <1287882149-29275-14-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241123490.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-14-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> One system have mixing xapic and x2apic entries in MADT and SRAT.
> 
> Need to handle every entry in MADT at same time with xapic and x2apic.
> so we can honor sequence in MADT.
> 
> We can use max_cpus= command line to use thread0 in every core,
> because recent MADT always have all thread0 at first.

That's a completely bogus argument. Just because you have access to
MADTs which have that first, does not prove anything.

These damned tables are not what we expect often enough, so we have to
deal with it and not making stupid assumptions which will blow up in
no time.

> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index f9f1bc5..8e13ec8 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -850,6 +850,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
>  {
>  	int count;
>  	int x2count = 0;
> +	struct acpi_subtable_proc madt_proc;

You titled this patch series cleanup. So what about doing

	struct acpi_subtable_proc madt_proc;
	int count, x2count = 0;

instead of blindly slapping your new stuff in ?

>  	if (!cpu_has_apic)
>  		return -ENODEV;
> @@ -874,10 +875,19 @@ static int __init acpi_parse_madt_lapic_entries(void)
>  				      acpi_parse_sapic, MAX_APICS);
>  
>  	if (!count) {
> -		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
> -						acpi_parse_x2apic, MAX_APICS);
> -		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
> -					      acpi_parse_lapic, MAX_APICS);
> +
> +		memset(&madt_proc, 0, sizeof(madt_proc));
> +		madt_proc.id[0] = ACPI_MADT_TYPE_LOCAL_APIC;
> +		madt_proc.handler[0] = acpi_parse_lapic;
> +		madt_proc.num++;
> +		madt_proc.id[1] = ACPI_MADT_TYPE_LOCAL_X2APIC;
> +		madt_proc.handler[1] = acpi_parse_x2apic;
> +		madt_proc.num++;
> +		acpi_table_parse_entries_x(ACPI_SIG_MADT,

What the hell is acpi_table_parse_entries_x? 

I tell you: Just slapping an _x at an existing function name is
sloppy, lazy and disgusting CRAP. Period.

I just removed a bunch of these complete misnomers and you have been
told to use sensible function names several times before.

Don't do that ever again, really. It's just a prove of complete and
wilful ignorance of reviewers comments.

> +					    sizeof(struct acpi_table_madt),
> +					    &madt_proc, MAX_APICS);
> +		count = madt_proc.count[0];
> +		x2count = madt_proc.count[1];
>  	}
>  	if (!count && !x2count) {

 Does anything check here for count < 0 or x2count < 0 ?		

> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index 5718566..0891071 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -278,10 +278,20 @@ int __init acpi_numa_init(void)
>  
>  	/* SRAT: Static Resource Affinity Table */
>  	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
> -		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
> -				     acpi_parse_x2apic_affinity, nr_cpu_ids);
> -		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
> -				     acpi_parse_processor_affinity, nr_cpu_ids);
> +		struct acpi_subtable_proc srat_proc;
> +
> +		memset(&srat_proc, 0, sizeof(srat_proc));
> +		srat_proc.id[0] = ACPI_SRAT_TYPE_CPU_AFFINITY;
> +		srat_proc.handler[0] = acpi_parse_processor_affinity;
> +		srat_proc.num++;
> +		srat_proc.id[1] = ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY;
> +		srat_proc.handler[1] = acpi_parse_x2apic_affinity;
> +		srat_proc.num++;
> +
> +		acpi_table_parse_entries_x(ACPI_SIG_SRAT,
> +					    sizeof(struct acpi_table_srat),
> +					    &srat_proc, nr_cpu_ids);

  What happens with the return value of this function ?

> +
>  		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
>  					    acpi_parse_memory_affinity,
>  					    NR_NODE_MEMBLKS);
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index f336bca..3e4a60e 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -201,10 +201,9 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>  
>  
>  int __init
> -acpi_table_parse_entries(char *id,
> +acpi_table_parse_entries_x(char *id,
>  			     unsigned long table_size,
> -			     int entry_id,
> -			     acpi_table_entry_handler handler,
> +			     struct acpi_subtable_proc *proc,
>  			     unsigned int max_entries)
>  {
>  	struct acpi_table_header *table_header = NULL;
> @@ -212,12 +211,12 @@ acpi_table_parse_entries(char *id,
>  	unsigned int count = 0;
>  	unsigned long table_end;
>  	acpi_size tbl_size;
> +	int i;
>  
> -	if (acpi_disabled)
> +	if (acpi_disabled) {
> +		proc->count[0] = -ENODEV;

  Why isn't it sufficient to return -ENODEV and check the return value
  of the function ?

>  		return -ENODEV;
> -
> -	if (!handler)
> -		return -EINVAL;

  Wat makes sure that all subtable entries have a handler set ?

> +	}
>  
>  	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
>  		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
> @@ -226,6 +225,7 @@ acpi_table_parse_entries(char *id,
>  
>  	if (!table_header) {
>  		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
> +		proc->count[0] = -ENODEV;

  See above

>  		return -ENODEV;
>  	}
>  
> @@ -238,19 +238,25 @@ acpi_table_parse_entries(char *id,
>  
>  	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
>  	       table_end) {
> -		if (entry->type == entry_id
> -		    && (!max_entries || count++ < max_entries))
> -			if (handler(entry, table_end)) {
> -				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> -				return -EINVAL;
> -			}
> +		for (i = 0; i < proc->num; i++) {
> +			if (entry->type != proc->id[i])
> +				continue;
> +			if (!max_entries || count++ < max_entries)
> +				if (proc->handler[i](entry, table_end)) {
> +					early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> +					proc->count[i] = -EINVAL;
> +					return -EINVAL;

  See above

> +				}
> +			proc->count[i]++;
> +			break;
> +		}
>  
>  		entry = (struct acpi_subtable_header *)
>  		    ((unsigned long)entry + entry->length);
>  	}
>  	if (max_entries && count > max_entries) {
> -		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i entries of "
> -		       "%i found\n", id, entry_id, count - max_entries, count);
> +		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x 0x%02x] ignored %i entries of "
> +		       "%i found\n", id, proc->id[0], proc->id[1], count - max_entries, count);
>  	}
>  
>  	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> @@ -258,6 +264,26 @@ acpi_table_parse_entries(char *id,
>  }
>  
>  int __init
> +acpi_table_parse_entries(char *id,
> +			     unsigned long table_size,
> +			     int entry_id,
> +			     acpi_table_entry_handler handler,
> +			     unsigned int max_entries)
> +{
> +	struct acpi_subtable_proc proc;
> +
> +	if (!handler)
> +		return -EINVAL;
> +
> +	memset(&proc, 0, sizeof(proc));
> +	proc.id[0] = entry_id;
> +	proc.handler[0] = handler;
> +	proc.num++;
> +
> +	return acpi_table_parse_entries_x(id, table_size, &proc, max_entries);
> +}

And this needs to be split into two patches. One introducing the new
function and one making use of it.

Thanks,

	tglx
