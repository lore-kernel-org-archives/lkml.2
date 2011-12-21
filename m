Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1LUBfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:35:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:51949 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1LUBfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:35:45 -0500
Message-ID: <4EF1377D.8080405@oracle.com>
Date: Tue, 20 Dec 2011 17:33:49 -0800
From: Maxim Uvarov <maxim.uvarov@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be
Subject: Re: [PATCH] hpwd watchdog mark page executable
References: <1323131139-32451-1-git-send-email-maxim.uvarov@oracle.com>	<1323131139-32451-2-git-send-email-maxim.uvarov@oracle.com> <20111220165059.4e79a416.akpm@linux-foundation.org>
In-Reply-To: <20111220165059.4e79a416.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4EF137ED.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 04:50 PM, Andrew Morton wrote:
> On Mon,  5 Dec 2011 16:25:39 -0800
> Maxim Uvarov<maxim.uvarov@oracle.com>  wrote:
>
>> Mark hpwdt watchdog pages executable to prevent failing:
>> BUG: unable to handle kernel paging request at c00f0000
>>   IP: [<c00f0000>] 0xc00effff
>>   *pdpt = 0000000000b7c001 *pde = 0000000000cf5067 *pte = 80000000000f0163
>>   Oops: 0011 [#1] SMP
>>
>> ...
>>
>> --- a/drivers/watchdog/hpwdt.c
>> +++ b/drivers/watchdog/hpwdt.c
>> @@ -335,6 +335,8 @@ static int __devinit detect_cru_service(void)
>>   	if (p == NULL)
>>   		return -ENOMEM;
>>
>> +	set_memory_x((unsigned long)p&  PAGE_MASK, ROM_SIZE>>  PAGE_SHIFT);
>> +
>>   	for (q = p; q<  p + ROM_SIZE; q += 16) {
>>   		rc = bios32_present(q);
>>   		if (!rc)
>
> Odd.  Either nobody else is using this driver, or there's something
> special about your setup.  Are you able to explain this?
>

Code drivers/watchdog/hpwdt.c is ifdefed on 2 branches for 32 and 64 bit 
accordingly. For 64 bit address for watchdog handler is used from 
smbios, for 32 bit - from ioremap(0x000F0000, ). Accordingly 64 kernel 
unsets  _PAGE_NX flag to pages. I.e. calls set_memory_x(). But 32 bit 
did not do so. It worked on 2.6.32 and since 3.0 looks like additional 
page protection code was added. I can't find the right commit which 
changed it right now.

> Also, do you believe that this fix should be backported into earlier
> stable kernels and if so, why?
>
Andrew, I found this problem in 3.0 than checked that it exist in 
linux-next when it was 3.1+. Because it's panic on module loading,  yes 
this is critical bug and it's needs to be back-ported. (Actually this 
driver was not changed so simple cherry-pick one line patch will work.).

Maxim.
  > Thanks.

