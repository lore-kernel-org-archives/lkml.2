Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2GYAXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:23:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33497 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GYAXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:23:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <500F3B7C.70009@jp.fujitsu.com>
Date: Wed, 25 Jul 2012 09:19:08 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: amwang@redhat.com
CC: dyoung@redhat.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        xiyou.wangcong@gmail.com, hpa@zytor.com, rjw@sisk.pl,
        yinghai.lu@oracle.com, tiwai@suse.de, kexec@lists.infradead.org
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>  <5004D8BF.6050205@jp.fujitsu.com> <500D20A1.1030800@redhat.com>  <500D340F.5080801@jp.fujitsu.com> <1343145331.16290.45.camel@cr0>
In-Reply-To: <1343145331.16290.45.camel@cr0>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/25 0:55), Cong Wang wrote:
> On Mon, 2012-07-23 at 20:22 +0900, Takao Indoh wrote:
>> (2012/07/23 19:00), Dave Young wrote:
>>> On 07/17/2012 11:15 AM, Takao Indoh wrote:
>>>
>>>> Hi Cong,
>>>>
>>>> When I tested kdump with 3.5.0-rc6 kernel, I found a problem of kdump
>>>> kernel's panic in find_early_table_space().
>>>>
>>>> init_memory_mapping: [mem 0x00000000-0x36ffafff]
>>>> Kernel panic - not syncing: Cannot find space for the kernel page tables
>>>> Pid: 0, comm: swapper Not tainted 3.5.0-rc6 #17
>>>> Call Trace:
>>>>    [<ffffffff8158549b>] panic+0xb8/0x1c8
>>>>    [<ffffffff8158565d>] ? printk+0x48/0x4a
>>>>    [<ffffffff8157304c>] init_memory_mapping+0x46c/0x530
>>>>    [<ffffffff818a73c7>] setup_arch+0x669/0xb0e
>>>>    [<ffffffff8158565d>] ? printk+0x48/0x4a
>>>>    [<ffffffff818a3a1f>] start_kernel+0x9b/0x34a
>>>>    [<ffffffff818a332d>] x86_64_start_reservations+0x131/0x136
>>>>    [<ffffffff818a341f>] x86_64_start_kernel+0xed/0xf4
>>>>
>>>> In find_early_table_space(), a kernel tries to find free area below 512M
>>>> for pgtable using memblock_find_in_range, but it fails because kdump
>>>> kernel does not have enough free space below 512M due to the memmap
>>>> restriction. This is the memmap option specified against kdump kernel
>>>> when crashkernel=128M.
>>>>
>>>> memmap=560K@64K memmap=130492K@770608K
>>>>
>>>> Only 560KB area is available and it is not sufficient for pgtable (it
>>>> seems that about 1.8MB area is needed for pgtable). This problem is
>>>> fixed by your revert patch. I hope this patch gets merged.
>>>
>>>
>>> I can reproduce this issue as well, probably related to some x86 mm init
>>> commits, this alloc failure does not happen with reverting below commits:
>>>
>>> bd2753b2dda7bb43c7468826de75f49c6a7e8965
>>> 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>> Yeah, my result of bisect is as follows and at first I thought the
>> commit 722bc6 caused this regression.
>>
>> 722bc6b16771ed80871e1fd81c86d3627dda2ac8 is the first bad commit
>> commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8
>> Author: WANG Cong <xiyou.wangcong@gmail.com>
>> Date:   Mon Mar 5 15:05:13 2012 -0800
>>
>> IIUC, this commit just fixes a bug of counting pgtable entries. As the
>> result, another problem came up to the surface. In the case of my
>> machine(16GB memory), before applying 722bc6, find_early_table_space()
>> requests about 12KB free area and it can be got from 560K@64K area
>> luckily. I think the size find_early_table_space() requests was a bug.
>> After the bug is fixed by the commit 722bc6, find_early_table_space()
>> requires 1.8MB area and it fails as I wrote.
>
> Thanks for tracking this, Takao!
>
> I bet you are using x86_64 not x86 PAE? If so, could you try this patch
> https://patchwork.kernel.org/patch/1195751/
> ? I already reviewed it.

Great, I applied it and now kdump works. Thanks!

Thanks,
Takao Indoh

