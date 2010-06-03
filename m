Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0FCVB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:01:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45671 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab0FCVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:01:51 -0400
Message-ID: <4C0817CE.6050006@oracle.com>
Date: Thu, 03 Jun 2010 13:59:58 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, mjg@redhat.com, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH]: x86: use acpi flags for apic mapping
References: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com> <20100602194956.GB5264@lenovo> <4C06D91F.2060105@redhat.com> <20100603172126.GA5502@lenovo> <4C07EF69.6050301@redhat.com>
In-Reply-To: <4C07EF69.6050301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C081827.0144:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 11:07 AM, Prarit Bhargava wrote:
> 
> 
> On 06/03/2010 01:21 PM, Cyrill Gorcunov wrote:
>> On Wed, Jun 02, 2010 at 06:20:15PM -0400, Prarit Bhargava wrote:
>>   
>>>     
>>>>> +#ifdef CONFIG_ACPI
>>>>> +enum apic_acpi_map_status apic_is_acpi_clustered_box(void)
>>>>> +{
>>>>>         
>>>> It's a bit strange that function is "is" prefixed and returns not true or false
>>>> but enum, perhaps we may name it apic_acpi_dst_model() or something like
>>>> that?
>>>>
>>>>       
>>> Sure, np -- new patch.
>>>
>>> P.
>>>     
>> Hi Prarit,
>>
>> just have reviewed it again and got some questions:
>>
>>   
>>> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
>>> index 1fa03e0..6b63f95 100644
>>> --- a/arch/x86/include/asm/apic.h
>>> +++ b/arch/x86/include/asm/apic.h
>>> @@ -252,6 +252,14 @@ static inline int apic_is_clustered_box(void)
>>>  }
>>>  #endif
>>>  
>>> +enum apic_acpi_map_status {
>>> +	APIC_ACPI_BOTH,
>>> +	APIC_ACPI_CLUSTER,
>>> +	APIC_ACPI_PHYSICAL,
>>> +	APIC_ACPI_NONE
>>> +};
>>> +extern enum apic_acpi_map_status apic_acpi_dst_model(void);
>>> +
>>>  extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
>>>  extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
>>>  
>>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>>> index e5a4a1e..e94a189 100644
>>> --- a/arch/x86/kernel/apic/apic.c
>>> +++ b/arch/x86/kernel/apic/apic.c
>>> @@ -2189,6 +2189,30 @@ static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
>>>  	{}
>>>  };
>>>  
>>> +#ifdef CONFIG_ACPI
>>> +enum apic_acpi_map_status apic_acpi_dst_model(void)
>>> +{
>>> +	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) {
>>> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL &&
>>> +		    acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER) {
>>> +			/*
>>> +			 * The rest of the code assumes physical flat
>>> +			 * in this case.
>>> +			 */
>>> +			return APIC_ACPI_BOTH;
>>> +		}
>>>     
>> Havin both flags set in ACPI FADT make me worry -- I suspect this means
>> acpi is screwed (this is ok, who doubt :) but the problem is HOW should
>> we treat TSC instability in such case? The current code assumes (tsc.c)
>>   
> 
> In the case of BOTH the code will assume physical_flat everywhere --
> therefore tsc is is stable.   Since the number of cluster systems is low
> it is unlikely that BOTH & cluster actually occur.   I suppose I could
> add (yet another) boot parameter to force cluster/flat/phys_flat if one
> doesn't already exist.... but I think that the likelihood of anyone
> hitting BOTH & wanting cluster is 0.
> 
>> that cluster mode has TSC unstable and if we had both bits set which
>> tsc mode we should choose? I suspect we have to assume that TSC unstable
>> then.

It seems we don't need this patch.

so all system should support phys apic mode, but system with less 8 cpus is supposed to support cluster mode for better performance.

current kernel will try to use cluster mode if nr_cpus is less than 8.

some system have problem like IBM and NCR only support phys apic mode even cpus < 8 ...

Thanks

Yinghai

