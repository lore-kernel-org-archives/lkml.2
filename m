Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2FNX5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:57:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2FNX5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <1339709672.3321.11.camel@lappy>
References: <1339623535.3321.4.camel@lappy>
	<20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
	<1339667440.3321.7.camel@lappy>
	<CAE9FiQVJ-q3gQxfBqfRnG+RvEh2bZ2-Ki=CRUATmCKjJp8MNuw@mail.gmail.com>
	<1339709672.3321.11.camel@lappy>
Date: Thu, 14 Jun 2012 16:57:18 -0700
X-Google-Sender-Auth: v_IpTUn_bx_0LXQYHTAcz3yA7qo
Message-ID: <CAE9FiQVXxnjccSErjrZ9B-APGf5ZpKNovJwr5vNBMr1G2f8Y4Q@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 2:34 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2012-06-14 at 13:56 -0700, Yinghai Lu wrote:
>> On Thu, Jun 14, 2012 at 2:50 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> > On Thu, 2012-06-14 at 12:20 +0900, Tejun Heo wrote:
>> >> On Wed, Jun 13, 2012 at 11:38:55PM +0200, Sasha Levin wrote:
>> >> > Hi all,
>> >> >
>> >> > I'm seeing the following when booting a KVM guest with 65gb of RAM, on latest linux-next.
>> >> >
>> >> > Note that it happens with numa=off.
>> >> >
>> >> > [    0.000000] BUG: unable to handle kernel paging request at ffff88102febd948
>> >> > [    0.000000] IP: [<ffffffff836a6f37>] __next_free_mem_range+0x9b/0x155
>> >>
>> >> Can you map it back to the source line please?
>> >
>> > mm/memblock.c:583
>> >
>> >                        phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
>> >  97:   85 d2                   test   %edx,%edx
>> >  99:   74 08                   je     a3 <__next_free_mem_range+0xa3>
>> >  9b:   49 8b 48 f0             mov    -0x10(%r8),%rcx
>> >  9f:   49 03 48 e8             add    -0x18(%r8),%rcx
>> >
>> > It's the deref on 9b (r8=ffff88102febd958).
>>
>> that reserved.region is allocated by memblock.
>>
>> can you boot with "memblock=debug debug ignore_loglevel" and post
>> whole boot log?
>
> Attached below. I've also noticed it doesn't always happen, but
> increasing the vcpu count (to something around 254) makes it happen
> almost every time.
>
...
[    0.000000] memblock: reserved array is doubled to 512 at
[0x102febc080-0x102febf07f]
[    0.000000]    memblock_free: [0x0000102febf080-0x0000102fec0880]
memblock_double_array+0x1b0/0x1e2
[    0.000000] memblock_reserve: [0x0000102febc080-0x0000102febf080]
memblock_double_array+0x1c5/0x1e2

the reserved regions get double two times to 512.
....
> [    0.000000]    memblock_free: [0x0000102febc080-0x0000102febf080] memblock_free_reserved_regions+0x37/0x39
> [    0.000000] BUG: unable to handle kernel paging request at ffff88102febd948
> [    0.000000] IP: [<ffffffff836a5774>] __next_free_mem_range+0x9b/0x155
> [    0.000000] PGD 4826063 PUD cf67a067 PMD cf7fa067 PTE 800000102febd160

that page table for them is

[    0.000000] kernel direct mapping tables up to 0x102fffffff @ [mem
0xc7e3e000-0xcfffffff]
[    0.000000] memblock_reserve: [0x000000c7e3e000-0x000000cf7fb000]
native_pagetable_reserve+0xc/0xe

only near by allocation is swiotlb.

[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] memblock_reserve: [0x000000c3e3e000-0x000000c7e3e000]
__alloc_memory_core_early+0x5c/0x73
...
[    0.000000] memblock_reserve: [0x000000cfff8000-0x000000d0000000]
__alloc_memory_core_early+0x5c/0x73
[    0.000000] Checking aperture...

so the memblock allocation is ok...

can you please boot with "memtest" to see if there is any memory problem?

Thanks

Yinghai
