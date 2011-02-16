Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1BPPcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:32:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63552 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1BPPcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hwlD8DJLA6ktOr6EfFw+a4BMBKuMnmtJgONwp71yhjs+3jEs9dC3LA7JpDq6Elv8o5
         h2wxQ9yEkNL90jSsBYOUxZ5qQHEypViTOeg9u77k2L9lSlrdMmbElFS/KffFCKZwiCf9
         ufiwlDXyeJM05IvMdfgFMSw301vH2PCvHKGWc=
MIME-Version: 1.0
In-Reply-To: <AANLkTinEuS-TgtxE7tGdL=XbJ2UUqqdqji1UA3F_BH2R@mail.gmail.com>
References: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
	<20110215055426.GA468@in.ibm.com>
	<AANLkTikkLuCeWpHBU5HO=39vO_DjhQkFMmnpB4kqtEmD@mail.gmail.com>
	<AANLkTi=VSEo47WnenaiET5NksdWxtj4osRn8kv3UqyG+@mail.gmail.com>
	<AANLkTinEuS-TgtxE7tGdL=XbJ2UUqqdqji1UA3F_BH2R@mail.gmail.com>
Date: Wed, 16 Feb 2011 21:02:29 +0530
Message-ID: <AANLkTikYk3orkn6YfP4aBXfo2e+Ca3m=VcR_HLvb_THi@mail.gmail.com>
Subject: Re: Mapping memory between kernel and user space
From: Rajat Sharma <fs.rajat@gmail.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So virtual address allocated to processes in user space is mapped to kernel
> virtual address(3g-4g range)  using page tables?

there are two types of virtual address - user mode virtual address,
which is mapped between 0-3G and kernel mode virtual address which are
mapped from 3G-4G.

kernel mode virtual addresses page table entries are taken from a
reference master kernel page-table. Basically any function which
establishes a kernel virtual address -> page frame mapping (e.g.
vmalloc() returns kernel virtual address) makes an entry into Master
kernel page table. If a process tries to access same virtual address,
the page fault handler tries to lookup same address mapping into the
Master page table before giving up. If an entry is found, process page
table is updated with this entry. You can say a user process' kernel
mode virtual address range mapping is established only on access.

This scheme allows each process, kernel thread, interrupt handler,
basically all possible kernel mode context to share same kernel
virtual addresses, because all mappings are coming from Master page
table entries.

Thanks,
Rajat

On Wed, Feb 16, 2011 at 1:32 PM, anish singh
<anish198519851985@gmail.com> wrote:
>
> On Wed, Feb 16, 2011 at 11:22 AM, Rajat Sharma <fs.rajat@gmail.com> wrote:
>>
>> > But coming to kernel they distinguish logical address from virtual
>> > address. What is the main difference.
>>
>> kernel logical address has linear (one-to-one) mapping of physical
>> address to virtual address range. e.g. kernel logical address (linear
>> address) from 3G to 4G (on x86) can map physical memory of 0-1G, so it
>> is intutive to get physical address from a logical address by
>> subtrating 3G from logical address.
>>
>> while kernel virtual address can be though of as logical address with
>> no restriction of linear mapping. Then how they map to physical pages?
>> Well this is achieved through page tables mapping like user space
>> address, however the virtual address range falls in 3G-4G (on x86)
>> range only. Basically you can say it is the process mapping of kernel
>> virtual address range (3G-4G) in its page tables. CPU works through
>> page-tables hence requires kernel virtual address in code
>> instructions. So, it is possible thats a kernel page has kernel
>> virtual address as well as logical address.
>
> So virtual address allocated to processes in user space is mapped to kernel
> virtual address(3g-4g range)  using page tables?
>>
>> > Also, they emphasize on high memory and low memory. Why can not high
>> > memory can be mapped in to kernel completely.
>> > Why is that kernel has less visibility of complete space available on
>> > RAM.
>>
>> For a limited address space range of linear mapping, physical memory
>> has to be limited (one-to-one mapping). So, if your system (x86) has
>> more than 1G physical RAM, Linux provides some mechanism releasing
>> some small slot between (3G + 896M) to 4G for dynamically mapping High
>> phyical memory page frames (>896M physical address), since you can't
>> always map the complete physical RAM all the time. This dynamic
>> mapping is done through kmap().
>>
>> > what is very minimal implementation of MMU for real time systems.
>> # CONFIG_MMU is not set
>> means linear mapping of all physical address to virtual address. Not
>> sure, but seems it requires processor support to work on linear
>> address bypassing page-tables conversion.
>>
>> Rajat
>>
>> On Tue, Feb 15, 2011 at 10:45 PM, Sri Ram Vemulpali
>> <sri.ram.gmu06@gmail.com> wrote:
>> > As was suggested I started reading chap 15v from LDD. I ran more into
>> > confusion state.
>> >
>> > I know that virtual address(process space), linear address
>> > (segmentation) and physical address. And how are they resolved from
>> > virtual to physical.
>> > But coming to kernel they distinguish logical address from virtual
>> > address. What is the main difference.
>> > Also, they emphasize on high memory and low memory. Why can not high
>> > memory can be mapped in to kernel completely.
>> > Why is that kernel has less visibility of complete space available on
>> > RAM.
>> > Linux MM is it a very specific implementation of linux, or Is that a
>> > traditional implementation.
>> >
>> > what is very minimal implementation of MMU for real time systems.
>> >
>> > Thanks in advance.
>> >
>> > --Sri.
>> >
>> > On Tue, Feb 15, 2011 at 12:54 AM, Ankita Garg <ankita@in.ibm.com> wrote:
>> >> On Wed, Feb 09, 2011 at 06:45:42PM -0500, Sri Ram Vemulpali wrote:
>> >>> Hi all,
>> >>>
>> >>>   How do I map some space between kernel and user space. Can anyone
>> >>> point me in to right direction. I was trying to map the packets from
>> >>> my netfilter function to kernel user space, to avoid over head of
>> >>> copying. Thanks in advance.
>> >>>
>> >>
>> >> You can take a look at remap_pfn_range() routine when implementing mmap
>> >> in your driver.
>> >>
>> >> --
>> >> Regards,
>> >> Ankita Garg (ankita@in.ibm.com)
>> >> Linux Technology Center
>> >> IBM India Systems & Technology Labs,
>> >> Bangalore, India
>> >>
>> >
>> >
>> >
>> > --
>> > Regards,
>> > Sri.
>> >
>> > _______________________________________________
>> > Kernelnewbies mailing list
>> > Kernelnewbies@kernelnewbies.org
>> > http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
