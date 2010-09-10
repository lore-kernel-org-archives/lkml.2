Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0IJTWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 15:22:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38617 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0IJTWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 15:22:06 -0400
Message-ID: <4C8A8504.9000606@kernel.org>
Date: Fri, 10 Sep 2010 12:20:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
References: <4C89906B.1050406@kernel.org> <201009101210.31942.bjorn.helgaas@hp.com>
In-Reply-To: <201009101210.31942.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 11:10 AM, Bjorn Helgaas wrote:
> On Thursday, September 09, 2010 07:56:59 pm Yinghai Lu wrote:
>>
>> When bios switch to use Device object instead of Processor statement.
>>
>> the SSDT for Pstate/Cstate/Tstate can not be loaded dynamically.
>>
>> So try to scan ACPI0007 in addition to Processor.
>>
>> this fix regression: 2.6.32 is ok.
> 
> Can you include the URL of the regression bug report?  And maybe
> the commit that introduced the regression?

the commit should be

commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
Author: Alex Chiang <achiang@hp.com>
Date:   Mon Feb 22 12:11:39 2010 -0700

    ACPI: processor: driver doesn't need to evaluate _PDC
    
    Now that the early _PDC evaluation path knows how to correctly
    evaluate _PDC on only physically present processors, there's no
    need for the processor driver to evaluate it later when it loads.
    
    To cover the hotplug case, push _PDC evaluation down into the
    hotplug paths.
    
    Cc: x86@kernel.org
    Cc: Tony Luck <tony.luck@intel.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

that is between 2.6.34-rc1 and 2.6.34-rc2.

So we need put this patch in stable tree for 2.6.34, .35, .36

Yinghai

> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/acpi/processor_core.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Index: linux-2.6/drivers/acpi/processor_core.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/acpi/processor_core.c
>> +++ linux-2.6/drivers/acpi/processor_core.c
>> @@ -352,4 +352,5 @@ void __init acpi_early_processor_set_pdc
>>  	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>>  			    ACPI_UINT32_MAX,
>>  			    early_init_pdc, NULL, NULL, NULL);
>> +	acpi_get_devices("ACPI0007", early_init_pdc, NULL, NULL);
> 
> I hate having to walk the namespace.  Usually that's a clue that
> there's something wrong with our ACPI device model, because it'd
> be better to handle everything in a driver .add() method.  But
> maybe this early _PDC thing is so special that it can't be helped
> in this case.
> 
> But I do think you could probably fix this to walk the namespace
> once rather than twice.  Maybe you could use something like
> acpi_walk_namespace(ACPI_TYPE_ANY, ...) with a callback that
> recognizes both ACPI_TYPE_PROCESSOR and "ACPI_TYPE_DEVICE with
> HID ACPI0007".
> 
> Bjorn

