Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0FCSNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:13:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0FCSNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:13:38 -0400
Message-ID: <4C07EF69.6050301@redhat.com>
Date: Thu, 03 Jun 2010 14:07:37 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, mjg@redhat.com,
       x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH]: x86: use acpi flags for apic mapping
References: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com> <20100602194956.GB5264@lenovo> <4C06D91F.2060105@redhat.com> <20100603172126.GA5502@lenovo>
In-Reply-To: <20100603172126.GA5502@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/03/2010 01:21 PM, Cyrill Gorcunov wrote:
> On Wed, Jun 02, 2010 at 06:20:15PM -0400, Prarit Bhargava wrote:
>   
>>     
>>>> +#ifdef CONFIG_ACPI
>>>> +enum apic_acpi_map_status apic_is_acpi_clustered_box(void)
>>>> +{
>>>>         
>>> It's a bit strange that function is "is" prefixed and returns not true or false
>>> but enum, perhaps we may name it apic_acpi_dst_model() or something like
>>> that?
>>>
>>>       
>> Sure, np -- new patch.
>>
>> P.
>>     
> Hi Prarit,
>
> just have reviewed it again and got some questions:
>
>   
>> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
>> index 1fa03e0..6b63f95 100644
>> --- a/arch/x86/include/asm/apic.h
>> +++ b/arch/x86/include/asm/apic.h
>> @@ -252,6 +252,14 @@ static inline int apic_is_clustered_box(void)
>>  }
>>  #endif
>>  
>> +enum apic_acpi_map_status {
>> +	APIC_ACPI_BOTH,
>> +	APIC_ACPI_CLUSTER,
>> +	APIC_ACPI_PHYSICAL,
>> +	APIC_ACPI_NONE
>> +};
>> +extern enum apic_acpi_map_status apic_acpi_dst_model(void);
>> +
>>  extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
>>  extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
>>  
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index e5a4a1e..e94a189 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -2189,6 +2189,30 @@ static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
>>  	{}
>>  };
>>  
>> +#ifdef CONFIG_ACPI
>> +enum apic_acpi_map_status apic_acpi_dst_model(void)
>> +{
>> +	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) {
>> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL &&
>> +		    acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER) {
>> +			/*
>> +			 * The rest of the code assumes physical flat
>> +			 * in this case.
>> +			 */
>> +			return APIC_ACPI_BOTH;
>> +		}
>>     
> Havin both flags set in ACPI FADT make me worry -- I suspect this means
> acpi is screwed (this is ok, who doubt :) but the problem is HOW should
> we treat TSC instability in such case? The current code assumes (tsc.c)
>   

In the case of BOTH the code will assume physical_flat everywhere --
therefore tsc is is stable.   Since the number of cluster systems is low
it is unlikely that BOTH & cluster actually occur.   I suppose I could
add (yet another) boot parameter to force cluster/flat/phys_flat if one
doesn't already exist.... but I think that the likelihood of anyone
hitting BOTH & wanting cluster is 0.

> that cluster mode has TSC unstable and if we had both bits set which
> tsc mode we should choose? I suspect we have to assume that TSC unstable
> then.
>
>   
>> +
>> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER)
>> +			return APIC_ACPI_CLUSTER;
>> +
>> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)
>> +			return APIC_ACPI_PHYSICAL;
>> +	}
>> +
>> +	return APIC_ACPI_NONE;
>> +}
>> +#endif
>> +
>>  static void __cpuinit dmi_check_multi(void)
>>  {
>>  	if (multi_checked)
>> @@ -2208,6 +2232,20 @@ static void __cpuinit dmi_check_multi(void)
>>   */
>>  __cpuinit int apic_is_clustered_box(void)
>>  {
>> +#ifdef CONFIG_ACPI
>> +	switch (apic_acpi_dst_model()) {
>> +		case APIC_ACPI_PHYSICAL:
>> +		case APIC_ACPI_BOTH: /* assume physical flat in this case */
>> +			return 0;
>> +			break;
>> +		case APIC_ACPI_CLUSTER:
>> +			return 1;
>> +			break;
>> +		default:
>> +			break;
>> +	}
>> +#endif
>> +
>>  	dmi_check_multi();
>>  	if (multi)
>>  		return 1;
>> diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
>> index 09d3b17..c2318ac 100644
>> --- a/arch/x86/kernel/apic/apic_flat_64.c
>> +++ b/arch/x86/kernel/apic/apic_flat_64.c
>> @@ -231,14 +231,32 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>>  {
>>  #ifdef CONFIG_ACPI
>>  	/*
>> -	 * Quirk: some x86_64 machines can only use physical APIC mode
>> -	 * regardless of how many processors are present (x86_64 ES7000
>> -	 * is an example).
>> +	 * Some x86_64 machines can only use clustered or physical APIC
>> +	 * mode regardless of how many processors are present.
>>  	 */
>> -	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
>> -		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
>> -		printk(KERN_DEBUG "system APIC only can use physical flat");
>> -		return 1;
>> +	switch (apic_acpi_dst_model()) {
>> +		case APIC_ACPI_BOTH:
>> +			printk(KERN_WARNING FW_BUG "ACPI has set apic mode to "
>> +			       "both clustered and physical flat.  Please "
>> +			       "contact your firmware vendor for an update.\n");
>> +			/*
>> +			 * In this case assume physical flat as only a very
>> +			 * limited number of systems use cluster
>> +			 */
>> +			printk(KERN_DEBUG "system APIC using physical flat\n");
>> +			return 1;
>> +			break;
>> +		case APIC_ACPI_CLUSTER:
>> +			printk(KERN_DEBUG "system APIC can only use cluster\n");
>> +			return 0;
>> +			break;
>> +		case APIC_ACPI_PHYSICAL:
>> +			printk(KERN_DEBUG "system APIC can only use physical"
>> +			       " flat\n");
>> +			return 1;
>> +			break;
>> +		default:
>> +			break;
>>  	}
>>     
> Not sure, but it seems this may broke IBM and EXA machines which should
> use physical destination mode, hmm?
>   

Oh -- good point!  That's easy to fix though.  The acpi check should be
after the IBM & EXA check.

I'll wait for more feedback before reposting ...

P.

>   
>>  
>>  	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {
>>     
> Has this patch been tested on real hardware? Asking so since I don't
> have neither IBM nor EXA machine.
>   

I have not tested on an IBM or EXA system.  However, I have not changed
the existing code -- I'm only adding the ACPI apic mapping which are
currently ignored.

P.
> I'm CC'ing experts I know were involved.
>
> 	-- Cyrill
>   
