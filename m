Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2KIUbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:31:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60828 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2KIUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:31:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU-k=V3qtH9z4+ou+NZFXfLp_7vqY+Axbj_4Xw1CyzHjw@mail.gmail.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
	<CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
	<20121030134442.GB27463@phenom.dumpdata.com>
	<CAE9FiQVXzOQG2XmA5Y_DX1JCGg_-LdM9tG3Chq7-7rNvUseRhg@mail.gmail.com>
	<CAE9FiQW+B8_vBT4A10ab4iOAQD9b-Ef84dsSX7p3nVQSN2w0=Q@mail.gmail.com>
	<a58d5329-a1db-418b-9caa-06b7a79051ec@email.android.com>
	<CAE9FiQWUiNqv-fd_4Y79eq+-w6wU34nEwn76+QJ7TWw7uCLaaQ@mail.gmail.com>
	<20121107161144.GA18353@phenom.dumpdata.com>
	<20121108014043.GA22057@phenom.dumpdata.com>
	<CAE9FiQU-k=V3qtH9z4+ou+NZFXfLp_7vqY+Axbj_4Xw1CyzHjw@mail.gmail.com>
Date: Fri, 9 Nov 2012 12:31:13 -0800
X-Google-Sender-Auth: E95GueqjS53EhELCZ2pcBT355lg
Message-ID: <CAE9FiQVmwXfQHKHWfXuJOXcgCB+z9gLDXbG26eze5T0QBOpBGQ@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 8:06 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Nov 7, 2012 at 5:40 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>>
>> I ran in a problem with launching an 8GB guest. When launching a 4GB it worked
>> fine, but with 8GB I get:
>>
>> .000000] init_memory_mapping: [mem 0x1f4000000-0x1f47fffff]
>> [    0.000000]  [mem 0x1f4000000-0x1f47fffff] page 4k
>> [    0.000000] memblock_reserve: [0x000001f311c000-0x000001f311d000] alloc_low_pages+0x103/0x130
>> [    0.000000] memblock_reserve: [0x000001f311b000-0x000001f311c000] alloc_low_pages+0x103/0x130
>> [    0.000000] memblock_reserve: [0x000001f311a000-0x000001f311b000] alloc_low_pages+0x103/0x130
>> [    0.000000] memblock_reserve: [0x000001f3119000-0x000001f311a000] alloc_low_pages+0x103/0x130
>> [    0.000000] Kernel panic - not syncing: initrd too large to handle, disabling initrd (348401664 needed, 524288 available)
>> [    0.000000]
>> [    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0-rc4upstream-00042-g1b66ccf #1
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff81633a5c>] panic+0xbf/0x1df
>> [    0.000000]  [<ffffffff81ac00e1>] setup_arch+0x728/0xb29
>> [    0.000000]  [<ffffffff81633c48>] ? printk+0x48/0x4a
>> [    0.000000]  [<ffffffff81aba897>] start_kernel+0x90/0x39e
>> [    0.000000]  [<ffffffff81aba356>] x86_64_start_reservations+0x131/0x136
>> [    0.000000]  [<ffffffff81abca38>] xen_start_kernel+0x546/0x548
>>
>
> xen memmap
>
> [    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
> [    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
> [    0.000000] Xen: [mem 0x0000000000100000-0x00000001f47fffff] usable
>
> there is no hole under 4G, trigger the bug about max_low_pfn_mapped updating in
> add_pfn_range_mapped().
>
> please check attached patch, that should fix the problem.
>
> then I will fold it into corresponding commit that instroduce
> add_pfn_range_mapped().
>

If you did not try the patch yet, please get for-x86-mm again.
I folded that patch into that commit about add_pfn_range_mapped.
