Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1B1Tlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:41:46 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50971 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1B1Tlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:41:45 -0500
Message-ID: <4D6BFA76.2060208@sgi.com>
Date: Mon, 28 Feb 2011 11:41:42 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Minimize SRAT messages
References: <20110225180633.857892225@gulag1.americas.sgi.com> <20110225180634.422972243@gulag1.americas.sgi.com> <20110227120348.GE16453@elte.hu>
In-Reply-To: <20110227120348.GE16453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Condense the SRAT: messages to show all the APIC id's on one line for
>> each Node.  This not only saves space in the log buf, it also makes
>> it easier to spot inconsistencies in core to node placement.
>>
>> On a system with 2368 cores on 248 nodes the change will be...
>>
>> Was 2368 lines (for 2368 cores):
>>
>>  779 [0] SRAT: PXM 0 -> APIC 0x0000 -> Node 0
>>  780 [0] SRAT: PXM 0 -> APIC 0x0002 -> Node 0
>>  781 [0] SRAT: PXM 0 -> APIC 0x0004 -> Node 0
>>  ...
>>  3145 [0] SRAT: PXM 247 -> APIC 0x3df0 -> Node 247
>>  3146 [0] SRAT: PXM 247 -> APIC 0x3df2 -> Node 247
>>
>> Now it's 248 lines (for 248 Nodes):
>>
>>  821 [0] SRAT: Node 0: PXM:APIC 0:0x0 :0x2 :0x4 :0x10 :0x12 ...
>>  822 [0] SRAT: Node 1: PXM:APIC 1:0x40 :0x42 :0x44 :0x50 :0x52 ...
>>  823 [0] SRAT: Node 2: PXM:APIC 2:0x80 :0x82 :0x84 :0x90 :0x92 ...
>>  ...
>>  1067 [0] SRAT: Node 246: PXM:APIC 246:0x3d80 :0x3d82 :0x3d84 :0x3d90 ...
>>  1068 [0] SRAT: Node 247: PXM:APIC 247:0x3dc0 :0x3dc2 :0x3dc4 :0x3dd2 ...
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Jack Steiner <steiner@sgi.com>
>> Reviewed-by: Robin Holt <holt@sgi.com>
>> ---
>>  arch/x86/mm/srat_64.c |   19 +++++++++++++++++--
>>  drivers/acpi/numa.c   |    7 +++++++
>>  2 files changed, 24 insertions(+), 2 deletions(-)
>>
>> --- linux.orig/arch/x86/mm/srat_64.c
>> +++ linux/arch/x86/mm/srat_64.c
>> @@ -110,6 +110,12 @@ void __init acpi_numa_slit_init(struct a
>>  	memblock_x86_reserve_range(phys, phys + length, "ACPI SLIT");
>>  }
>>  
>> +/*
>> + * Keep track of previous node and PXM values so we can combine
>> + * same ones onto a single line.
>> + */
>> +static int __initdata last_node = NUMA_NO_NODE, last_pxm =  PXM_INVAL;
>> +
>>  /* Callback for Proximity Domain -> x2APIC mapping */
>>  void __init
>>  acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>> @@ -141,8 +147,17 @@ acpi_numa_x2apic_affinity_init(struct ac
>>  	set_apicid_to_node(apic_id, node);
>>  	node_set(node, cpu_nodes_parsed);
>>  	acpi_numa = 1;
>> -	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
>> -	       pxm, apic_id, node);
>> +	if (node != last_node) {
>> +		pr_info("SRAT: Node %u: PXM:APIC %u:0x%x",
>> +		       node, pxm, apic_id);
>> +		last_node = node;
>> +		last_pxm = pxm;
>> +	} else if (pxm != last_pxm) {
>> +		pr_cont(" %u:0x%x", pxm, apic_id);
>> +		last_pxm = pxm;
>> +	} else {
>> +		pr_cont(" :0x%x", apic_id);
>> +	}
>>  }
>>  
>>  /* Callback for Proximity Domain -> LAPIC mapping */
>> --- linux.orig/drivers/acpi/numa.c
>> +++ linux/drivers/acpi/numa.c
>> @@ -286,6 +286,13 @@ int __init acpi_numa_init(void)
>>  	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
>>  		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
>>  				     acpi_parse_x2apic_affinity, 0);
>> +		/*
>> +		 * Parsing ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY entries place
>> +		 * multiple CPU's on the same Node line.  This can leave the
>> +		 * last entry "dangling" without a newline.  Insert it here.
>> +		 */
>> +		pr_cont("\n");
> 
> This is quite ugly as it breaks the genericity of the ACPI parsing here. Is there no 
> cleaner method that keeps this deinit \n printing somehow within the realm of x86?
> 
> Also, can there be cases where there's no 'dangling' line pending? In that case the 
> \n will be superfluous here.
> 
> Thanks,
> 
> 	Ingo

Yes, David brought up the same point a couple of weeks ago.  I've tried and
failed to find a solution, except that the printk function seems to add the
newline if there is not one.  I asked if this was sufficient to rely on,
and no one spoke up.  (Everyone is quick to object, but seemingly very slow
to agree.)

And yes, there will always be a dangling line.  If the ACPI guys could tell
me how to predict when this is the last entry, I would gladly change it.

Thanks,
Mike
