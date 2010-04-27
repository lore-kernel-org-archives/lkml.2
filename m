Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0D0SAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:00:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0D0R7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:59:48 -0400
Message-ID: <4BD725F5.1040100@redhat.com>
Date: Tue, 27 Apr 2010 19:59:17 +0200
From: Andrew Jones <drjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com>
In-Reply-To: <4BD71A2D.6050309@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 07:09 PM, Prarit Bhargava wrote:
> 
> 
> On 04/27/2010 12:58 PM, Konrad Rzeszutek Wilk wrote:
>> On Tue, Apr 27, 2010 at 11:24:42AM -0400, Prarit Bhargava wrote:
>>   
>>> Upstream PV guests fail to boot because of a NULL pointer.  It is
>>> possible that
>>> xen guests have irq_desc->chip_data = NULL.
>>>      
>> Can you provide a short example of test scenario? As in what I should do
>> to reproduce this problem?
>>    
> 
> Take the latest upstream (well ... to be honest, a bit older than that
> because of some other bugs) -- take 2.6.33 and try to boot it as a PV
> guest.  I'm using a RHEL5 Xen HV fwiw ...
> 
> P.

Another ingredient is to boot the guest with a configuration where its
maxvcpus is greater than its vcpus. If you have RHEL 5.5 userspace then
you can create a config with lines like this

maxvcpus = 4
vcpus = 2

with that you'll crash on boot. Then you can check that
irq_force_complete_move is on the stack if you have "preserve" for
on_crash and use xenctx to look at the state of the vcpus.

If the Xen you're using doesn't support the maxvcpus var, then I believe
you can do the same principle, but in a different way, using the
vcpus_avail var. Or, you can boot with > 1 vcpus and then attempt to
remove one with 'xm vcpu-set'.

Andrew

> 
>>> Test for NULL chip_data pointer before attempting to complete an irq
>>> move.
>>>
>>> Signed-off-by: Prarit Bhargava<prarit@redhat.com>
>>> Acked-by: Suresh Siddha<suresh.b.siddha@intel.com>
>>>
>>> diff --git a/arch/x86/kernel/apic/io_apic.c
>>> b/arch/x86/kernel/apic/io_apic.c
>>> index 127b871..eb2789c 100644
>>> --- a/arch/x86/kernel/apic/io_apic.c
>>> +++ b/arch/x86/kernel/apic/io_apic.c
>>> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
>>>       struct irq_desc *desc = irq_to_desc(irq);
>>>       struct irq_cfg *cfg = desc->chip_data;
>>>
>>> +    if (!cfg)
>>> +        return;
>>> +
>>>       __irq_complete_move(&desc, cfg->vector);
>>>   }
>>>   #else
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>      

