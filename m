Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1KQD2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1KQD2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:28:19 -0500
Message-ID: <4EC47FCA.5090908@redhat.com>
Date: Thu, 17 Nov 2011 11:30:18 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: tim@edgecast.com
CC: tj@kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Crash during vmcore_init
References: <1318376345.2050.20.camel@boudreau>	 <j9r5m5$b18$1@dough.gmane.org> <1321296650.2066.17.camel@boudreau>	 <4EC21F67.10905@redhat.com> <1321396371.4198.5.camel@boudreau>	 <4EC31E55.6040809@redhat.com> <1321467647.2137.4.camel@boudreau>
In-Reply-To: <1321467647.2137.4.camel@boudreau>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 02:20 AM, Tim Hartrick wrote:

> 
> Dave,
> 
> On Wed, 2011-11-16 at 10:22 +0800, Dave Young wrote:
>> On 11/16/2011 06:32 AM, Tim Hartrick wrote:
>>
>>>
>>> Dave,
>>>
>>> I tested with
>>>
>>> linux-image-3.1.1-030101-generic_3.1.1-030101.201111111651_amd64.deb
>>>
>>> which, as far as I know, is the Ubuntu build of the latest stable.
>>> Below are the results.
>>>
>>> [    1.427457] ioremap: invalid physical address 5800000000000
>>
>>
>> Hi, thanks for the testing
>>
>> Can you applied the debug patch to see if it's per cpu problem?
>>
>> Don't need test kdump, just
>> cd /sys/devices/system/cpu
>> cat cpu[x]/crash_notes
>>
>> probably cat crash notes of cpu number other than 0 will get the invalid
>> address
>>
> 
> Using 3.1.1 stable with your patch.  See below.
> 
> 
> tim
> 
> # for i in /sys/devices/system/cpu/cpu[0-9]*/crash_notes; do cat $i; done
> 5800000000000
> 5800000000000
> 5800000000000
> 5800000000000
> 5800000000000
> 5800000000000
> 5800000000000
> 5800000000000
> 
> dmesg:
> 
> [  277.276349] per cpu addr ffff880c7fc19ad0

> [  277.276352] addr is not in vmalloc area


This addr is converted to an invalid phys address,

looking the code below:
       if (in_first_chunk) {
                if (!is_vmalloc_addr(addr))
                        return __pa(addr);
                else
                        return page_to_phys(vmalloc_to_page(addr));
        } else
                return page_to_phys(pcpu_addr_to_page(addr));

I dont understand per cpu allocation well, if addr is not in first chunk
then it should be in vmalloc area?

Tejun, do you have any idea about this?


> [  277.277545] per cpu addr ffff880667c19ad0
> [  277.277548] addr is not in vmalloc area
> [  277.278832] per cpu addr ffff880c7fc39ad0
> [  277.278835] addr is not in vmalloc area
> [  277.280175] per cpu addr ffff880667c39ad0
> [  277.280178] addr is not in vmalloc area
> [  277.281406] per cpu addr ffff880c7fc59ad0
> [  277.281409] addr is not in vmalloc area
> [  277.282592] per cpu addr ffff880667c59ad0
> [  277.282594] addr is not in vmalloc area
> [  277.284019] per cpu addr ffff880c7fc79ad0
> [  277.284022] addr is not in vmalloc area
> [  277.285251] per cpu addr ffff880667c79ad0
> [  277.285254] addr is not in vmalloc area
> 
> 
> 
> 
> 
> 
> 
> 



-- 
Thanks
Dave
