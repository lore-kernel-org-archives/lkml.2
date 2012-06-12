Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2FLLa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:30:57 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51405 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2FLLa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <4FD6E1DA.2090700@cn.fujitsu.com>
References: <4FD5AFF2.3040306@cn.fujitsu.com> <CAErSpo6EnHFFPwcPhWy=ACTn5+7i72fUR+1jjZrpfEMQp1zv0A@mail.gmail.com>
 <4FD6E1DA.2090700@cn.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jun 2012 04:30:33 -0700
Message-ID: <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 11:29 PM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 06/12/2012 01:35 AM, Bjorn Helgaas Wrote:
>> On Mon, Jun 11, 2012 at 1:44 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
>>> Currently, the boot option max_addr is only supported on ia64 platform.
>>> We also need it on x86 platform.
>>> For example:
>>> There are two nodes:
>>>  NODE#0  address range 0x00000000 00000000 - 0x00010000 00000000
>>>  NODE#1  address range 0x00010000 00000000 - 0x00020000 00000000
>>> If we only want to use node0, we can specify the max_addr. The boot
>>> option "mem=" can do the same thing now. But the boot option "mem="
>>> means the total memory used by the system. If we tell the user
>>> that the boot option "mem=" can do this, it will confuse the user.
>>> So we need an new boot option "max_addr" on x86 platform.
>>
>> I don't object to this patch (and thanks for tweaking the mem range printk).
>>
>> I don't know what your use case is, but from a user interface
>> perspective, the "max_addr=" option feels like a bit of a hack.  If
>> you're trying to avoid use of other nodes, "max_addr" is an awkward
>> way to do it.  It requires the user to know the physical address ->
>> node mappings, and it doesn't affect the CPUs and I/O resources on
>> other nodes.  You could implement a "numa_node=" or similar parameter
>> that would allow you to ignore remote memory, CPUs, and I/O.
>
> Currently, I only need to ignore the memory. If we need to ignore a node,
> "numa_node=" or similar parameter is a better choice.

Doesn't the end user have to know the memory map of the system to use
"max_addr="?  How do you know what value to supply?  Do you have to
attempt a boot once to discover the highest address on node 0?  What
if node 0 and node 1 memory are interleaved, so there's some node 1
memory below the highest node 0 address?

>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>> ---
>>>  Documentation/kernel-parameters.txt |    2 +-
>>>  arch/x86/kernel/e820.c              |   36 +++++++++++++++++++++++++++++++++++
>>>  2 files changed, 37 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index a92c5eb..034609d 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -1441,7 +1441,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>                         yeeloong laptop.
>>>                        Example: machtype=lemote-yeeloong-2f-7inch
>>>
>>> -       max_addr=nn[KMG]        [KNL,BOOT,ia64] All physical memory greater
>>> +       max_addr=nn[KMG]        [KNL,BOOT,ia64,X86] All physical memory greater
>>>                        than or equal to this physical address is ignored.
>>>
>>>        maxcpus=        [SMP] Maximum number of processors that an SMP kernel
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index 4185797..cd07226 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
>>>  #ifdef CONFIG_PCI
>>>  EXPORT_SYMBOL(pci_mem_start);
>>>  #endif
>>> +static u64 max_addr = ~0ULL;
>>>
>>>  /*
>>>  * This function checks if any part of the range <start,end> is mapped
>>> @@ -119,6 +120,20 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
>>>                return;
>>>        }
>>>
>>> +       if (start >= max_addr) {
>>> +               printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
>>> +                      (unsigned long long)start,
>>> +                      (unsigned long long)(start + size - 1));
>>> +               return;
>>> +       }
>>> +
>>> +       if (max_addr - start < size) {
>>> +               printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
>>> +                      (unsigned long long)max_addr,
>>> +                      (unsigned long long)(start + size - 1));
>>> +               size = max_addr - start;
>>> +       }
>>> +
>>>        e820x->map[x].addr = start;
>>>        e820x->map[x].size = size;
>>>        e820x->map[x].type = type;
>>> @@ -835,6 +850,22 @@ static int __init parse_memopt(char *p)
>>>  }
>>>  early_param("mem", parse_memopt);
>>>
>>> +static int __init parse_memmax_opt(char *p)
>>> +{
>>> +       char *oldp;
>>> +
>>> +       if (!p)
>>> +               return -EINVAL;
>>> +
>>> +       oldp = p;
>>> +       max_addr = memparse(p, &p);
>>> +       if (p == oldp)
>>> +               return -EINVAL;
>>> +
>>> +       return 0;
>>> +}
>>> +early_param("max_addr", parse_memmax_opt);
>>> +
>>>  static int __init parse_memmap_opt(char *p)
>>>  {
>>>        char *oldp;
>>> @@ -881,6 +912,11 @@ early_param("memmap", parse_memmap_opt);
>>>
>>>  void __init finish_e820_parsing(void)
>>>  {
>>> +       if (max_addr != ~0ULL) {
>>> +               userdef = 1;
>>> +               e820_remove_range(max_addr, ULLONG_MAX - max_addr, E820_RAM, 1);
>>> +       }
>>> +
>>>        if (userdef) {
>>>                u32 nr = e820.nr_map;
>>>
>>> --
>>> 1.7.1
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
