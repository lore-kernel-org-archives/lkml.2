Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0D0RJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0D0RJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:09:37 -0400
Message-ID: <4BD71A2D.6050309@redhat.com>
Date: Tue, 27 Apr 2010 13:09:01 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com>
In-Reply-To: <20100427165816.GA24707@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/27/2010 12:58 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 27, 2010 at 11:24:42AM -0400, Prarit Bhargava wrote:
>    
>> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
>> xen guests have irq_desc->chip_data = NULL.
>>      
> Can you provide a short example of test scenario? As in what I should do
> to reproduce this problem?
>    

Take the latest upstream (well ... to be honest, a bit older than that 
because of some other bugs) -- take 2.6.33 and try to boot it as a PV 
guest.  I'm using a RHEL5 Xen HV fwiw ...

P.

>> Test for NULL chip_data pointer before attempting to complete an irq move.
>>
>> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
>> Acked-by: Suresh Siddha<suresh.b.siddha@intel.com>
>>
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 127b871..eb2789c 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
>>   	struct irq_desc *desc = irq_to_desc(irq);
>>   	struct irq_cfg *cfg = desc->chip_data;
>>
>> +	if (!cfg)
>> +		return;
>> +
>>   	__irq_complete_move(&desc, cfg->vector);
>>   }
>>   #else
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>      
