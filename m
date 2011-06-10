Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab1FJXBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:01:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44002 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab1FJXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:01:50 -0400
Message-ID: <4DF2A214.5080001@kernel.org>
Date: Fri, 10 Jun 2011 16:00:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com>
In-Reply-To: <4DF29E7E.50908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DF2A21D.0056,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 03:45 PM, Maarten Lankhorst wrote:
> Op 10-06-11 19:54, Matthew Garrett schreef:
>> On Fri, Jun 10, 2011 at 07:51:46PM +0200, Maarten Lankhorst wrote:
>>> Well,
>>>
>>> Op 10-06-11 18:47, Matthew Garrett schreef:
>>>> So this is obviously even more of a hack, but before you check whether 
>>>> the memblock has already been reserved could you __check_region it as 
>>>> well? That ought to avoid us touching the kernel. I've got a patch for 
>>>> grub that'll avoid the situation where we load the kernel on top of an 
>>>> existing resource and I'll port that to grub2, but that's still going to 
>>>> be awkward for existing bootloaders.
>>>>
>>> Erm, __check_region calls __requestion_region which does a kzalloc,
>>> if I call __check_region it doesn't boot, probably because of that.
>> Oh, bother.
>>
>>> Do you want me to manually run through iomem_resource? Is it even available up at that point?
>> Should be - we've already called insert_resource to set up the kernel at 
>> this point.
>>
> 
> Version with yinghai's free_bootmem_late_with_active_regions.
> 
> Still has an issue though, I'm getting 2 warnings from swapper:
> [    2.867034] BUG: Bad page state in process swapper  pfn:01900
> [    2.867303] page:ffffea0000057800 count:0 mapcount:-127 mapping:          (null) index:0x0
> [    2.867683] page flags: 0x100000000000000()
> [    2.867887] Pid: 1, comm: swapper Not tainted 2.6.39.1-patser+ #15
> [    2.867888] Call Trace:
> [    2.867893]  [<ffffffff810f349b>] ? dump_page+0x9b/0xd0
> [    2.867894]  [<ffffffff810f3599>] bad_page+0xc9/0x120
> [    2.867896]  [<ffffffff810f36af>] free_pages_prepare+0xbf/0x110
> [    2.867898]  [<ffffffff810f4fa9>] free_hot_cold_page+0x49/0x440
> [    2.867899]  [<ffffffff810f59fd>] __free_pages+0x2d/0x40
> [    2.867900]  [<ffffffff810f5a53>] free_pages+0x43/0x50
> [    2.867903]  [<ffffffff81029542>] free_init_pages+0x132/0x1c0
> [    2.867904]  [<ffffffff81029cd3>] mark_rodata_ro+0x143/0x150
> [    2.867906]  [<ffffffff810001d8>] init_post+0x18/0xd0
> [    2.867909]  [<ffffffff81ab7d45>] kernel_init+0x158/0x163
> [    2.867911]  [<ffffffff815688d4>] kernel_thread_helper+0x4/0x10
> [    2.867913]  [<ffffffff81ab7bed>] ? start_kernel+0x3dc/0x3dc
> [    2.867914]  [<ffffffff815688d0>] ? gs_change+0xb/0xb
> [    2.867915] Disabling lock debugging due to kernel taint
> [    2.867922] BUG: Bad page state in process swapper  pfn:01910
> [    2.868187] page:ffffea0000057b80 count:0 mapcount:-127 mapping:          (null) index:0x0
> [    2.868567] page flags: 0x100000000000000()
> [    2.868769] Pid: 1, comm: swapper Tainted: G    B       2.6.39.1-patser+ #15
> [    2.868770] Call Trace:
> [    2.868771]  [<ffffffff810f349b>] ? dump_page+0x9b/0xd0
> [    2.868773]  [<ffffffff810f3599>] bad_page+0xc9/0x120
> [    2.868774]  [<ffffffff810f36af>] free_pages_prepare+0xbf/0x110
> [    2.868775]  [<ffffffff810f4fa9>] free_hot_cold_page+0x49/0x440
> [    2.868777]  [<ffffffff810f59fd>] __free_pages+0x2d/0x40
> [    2.868778]  [<ffffffff810f5a53>] free_pages+0x43/0x50
> [    2.868779]  [<ffffffff81029542>] free_init_pages+0x132/0x1c0
> [    2.868781]  [<ffffffff81029cd3>] mark_rodata_ro+0x143/0x150
> [    2.868782]  [<ffffffff810001d8>] init_post+0x18/0xd0
> [    2.868784]  [<ffffffff81ab7d45>] kernel_init+0x158/0x163
> [    2.868785]  [<ffffffff815688d4>] kernel_thread_helper+0x4/0x10
> [    2.868787]  [<ffffffff81ab7bed>] ? start_kernel+0x3dc/0x3dc
> [    2.868788]  [<ffffffff815688d0>] ? gs_change+0xb/0xb
> 
> Also don't rate for style, that wasn't the scope of this patch. This is just to have something to test with ;)
> 

the problem is : overlapping between kernel code with boot services code.

now e820 table that is passed from bootloader do not include boot services code range. and also current boot/head_64.S will not
try to find usable range for decompressed kernel ( too early )...

So solution will be:
1. revert Matthew Garrett's patch, because it breaks known good platforms.

| commit 916f676f8dc016103f983c7ec54c18ecdbb6e349
| Author: Matthew Garrett <mjg@redhat.com>
| Date:   Wed May 25 09:53:13 2011 -0400
|
|    x86, efi: Retain boot service code until after switching to virtual mode

2. ask vendor of system that Matthew try to fix to go back fix their firmware. otherwise user have stay with CSM with it.

Thanks

Yinghai Lu
