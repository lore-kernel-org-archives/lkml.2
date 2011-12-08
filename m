Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1LHQwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:52:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28897 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1LHQwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:52:49 -0500
Message-ID: <4EE0EB0A.2090506@oracle.com>
Date: Thu, 08 Dec 2011 08:51:22 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ibft: Fix finding ibft with ACPI tables
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net>
In-Reply-To: <20111208142958.GA4096@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EE0EB2B.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 06:29 AM, Konrad Rzeszutek Wilk wrote:

> On Thu, Dec 08, 2011 at 12:22:19AM -0800, Yinghai Lu wrote:
>> Found one system with UEFI/iBFT is not detected.
> 
> Excellent.
> 
> I have some comment in regards to the patch - it needs to be
> split in two: one part being _just_ the bug-fix, and the other
> being the cleanup/fixing printk.
> 
> Please fix the subject - it should say: "Fix finding IBFT ACPI tables
> on UEFI."

> 

>>
>> the root cause: for x86, We move calling of find_ibft_region() much earlier.
>> in setup_arch() before ACPI is enabled.
> 
> We move calling? When did the find_ibft_region() get moved?
> 
> I think you mean "find_ibft_region() gets called in setup_arch(), which
> is done before ACPI is enabled on UEFI. Hence it does not find the IBFT
> table' ?


it is called before
	acpi_boot_table_init();
that is too early.

> 

> What about the 'memblock_reserve' that find_ibft_region calls? Do
> we need to make a special call on UEFI to reserve that region? Or is
> that not neccessary since it is an ACPI table and has already
> been reserved?


yes, acpi table is reserved already.

>>
>> Try to all find_ibft_region() second times in ibft_init()
>          ^^^ - all?                    ^^^^ - time
> 
> How many iBFT tables are there? You can drop the 'all'.


will fix the typo.

> 
>>
>> at that time ACPI iBFT already get permanent mapped with ioremap.
>> So isa_virt_to_bus will get wrong phys from right virt address.
> 
> .. "will get wrong physical address from the virtual address."
> 
> 
>> We could just skip that printing.
> 
> That sounds like another patch - a cleanup patch actually.


I prefer to having them together. otherwise on uefi/acpi case.

isa_virt_to_bus() will find one strange phys addr from virt with ioremap()

that could cause confuse.

> 
>> For legacy one, print the found address early.
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>>
>> ---
>>  drivers/firmware/iscsi_ibft.c      |   18 +++++++++++++++---
>>  drivers/firmware/iscsi_ibft_find.c |    1 +
>>  2 files changed, 16 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/drivers/firmware/iscsi_ibft.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
>> +++ linux-2.6/drivers/firmware/iscsi_ibft.c
>> @@ -753,9 +753,21 @@ static int __init ibft_init(void)
>>  {
>>  	int rc = 0;
>>  
>> +	/* find that from acpi tables */
>> +	if (!ibft_addr) {
>> +		unsigned long size = 0;
>> +
>> +		find_ibft_region(&size);
>> +		barrier();
> 
> barrier? Please provide a comment detailing why you need it.


will remove that.

> 
>> +	}
>> +
>>  	if (ibft_addr) {
>> -		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
>> -		       (u64)isa_virt_to_bus(ibft_addr));
>> +		/*
>> +		 * Second try is from acpi permanent map with ioremap
>> +		 *  can not simply convert back to phys addr.
>> +		 *  and We don't need to print that table phys addr.
> 
> That comment makes sense in the git description but not in this
> code path (b/c when you look at the code you won't think of printing
> the "iBFT detected at XXX" comment.
> 
> You should move part of this comment to the "if (!ibft_addr)" and just
> say:
> "Retry as on UEFI systems the setup_arch is called before ACPI tables
> are parsed is setup
> so we never get the data."


ok.


will send out updated version.

Thanks

Yinghai
