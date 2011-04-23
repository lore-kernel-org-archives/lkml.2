Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1DWNI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:08:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45558 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1DWNIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oC56cChfLpsRoU2dBkRd3dEA6VuxLSkhu/+afpqQUgiC/baLn7YXqKWS+OoZB5RDfS
         TH6bE0gQPd4n1MTgagIA50EGS7HsPoXveQYDH4KAzi2o8FbEuSe7tnE6JT9RdaOAHbV3
         Le9wE9onPskYJ85w7c+PUr2FcMHnpdkvJ8lXQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTim_A-r4Khdx20tLKFU8ybtB+=wcyg@mail.gmail.com>
References: <BANLkTi=6T8SxqnsXTY5ceyikg2NTKLVSKw@mail.gmail.com>
	<BANLkTimN4vbAPJVKgH8iTZy7B5Fr8B+ibA@mail.gmail.com>
	<BANLkTikSRStQO6cyE+L2vHHe0TnkoBe8=A@mail.gmail.com>
	<BANLkTim_A-r4Khdx20tLKFU8ybtB+=wcyg@mail.gmail.com>
Date: Sat, 23 Apr 2011 15:08:23 +0200
X-Google-Sender-Auth: MQsM58M1k-d83X21_Oio-44KFqc
Message-ID: <BANLkTin4=QFyQUT95d7eoXXrdkNJc=T9Tw@mail.gmail.com>
Subject: Re: Fix for SLUB? (was: Fwd: [PATCH v3] mm: make expand_downwards
 symmetrical to expand_upwards)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@googlemail.com>
Cc: Thorsten Glaser <tg@mirbsd.de>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added some CCs]

On Sat, Apr 23, 2011 at 05:47, Michael Schmitz
<schmitzmic@googlemail.com> wrote:
> Hi,
>
> node_present_pages(node) returns false:
>
> m68k_setup_node: node 0 addr 0 size 14680064
> m68k_setup_node: node 0 not present!
> m68k_setup_node: node 1 addr 16777216 size 268435456
> m68k_setup_node: node 1 not present!
>
> Changing the patch to
>
> diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
> --- a/arch/m68k/mm/init_mm.c
> +++ b/arch/m68k/mm/init_mm.c
> @@ -59,6 +59,7 @@ void __init m68k_setup_node(int node)
>       }
>  #endif
>       pg_data_map[node].bdata = bootmem_node_data + node;
> +       node_set_state(node, N_NORMAL_MEMORY);
>       node_set_online(node);
>  }
>
> i.e. ignoring the node_present_pages return value does result in a
> booting kernel even with the problematic commit included.
>
> I'll leave it to the mm experts to explain why node_present_pages
> returns zero here.
>
> Cheers,
>
>  Michael
>
>
>
> On Sat, Apr 23, 2011 at 2:14 PM, Michael Schmitz
> <schmitzmic@googlemail.com> wrote:
>> Looks like that wasn't helping after all. I still need to revert said
>> commit. Guess I'll have to check what node_present_pages(node) returns
>> in each case ...
>>
>> Cheers,
>>
>>  MIchael
>>
>>
>> On Sat, Apr 23, 2011 at 1:31 PM, Michael Schmitz
>> <schmitzmic@googlemail.com> wrote:
>>> I'll check this out - might well be the correct fix for our problems.
>>>
>>> Cheers,
>>>
>>>  Michael
>>>
>>>
>>> On Thu, Apr 21, 2011 at 8:19 PM, Geert Uytterhoeven
>>> <geert@linux-m68k.org> wrote:
>>>> ---------- Forwarded message ----------
>>>> From: David Rientjes <rientjes@google.com>
>>>> Date: Thu, Apr 21, 2011 at 01:12
>>>> Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
>>>> To: James Bottomley <James.Bottomley@hansenpartnership.com>
>>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Pekka Enberg
>>>> <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, Michal Hocko
>>>> <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Hugh
>>>> Dickins <hughd@google.com>, linux-mm@kvack.org, LKML
>>>> <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org, Ingo
>>>> Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
>>>>
>>>>
>>>> On Wed, 20 Apr 2011, James Bottomley wrote:
>>>>
>>>>> > This is probably because the parisc's DISCONTIGMEM memory ranges don't
>>>>> > have bits set in N_NORMAL_MEMORY.
>>>>> >
>>>>> > diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
>>>>> > --- a/arch/parisc/mm/init.c
>>>>> > +++ b/arch/parisc/mm/init.c
>>>>> > @@ -266,8 +266,10 @@ static void __init setup_bootmem(void)
>>>>> >     }
>>>>> >     memset(pfnnid_map, 0xff, sizeof(pfnnid_map));
>>>>> >
>>>>> > -   for (i = 0; i < npmem_ranges; i++)
>>>>> > +   for (i = 0; i < npmem_ranges; i++) {
>>>>> > +           node_set_state(i, N_NORMAL_MEMORY);
>>>>> >             node_set_online(i);
>>>>> > +   }
>>>>> >  #endif
>>>>>
>>>>> Yes, this seems to be the missing piece that gets it to boot.  We really
>>>>> need this in generic code, unless someone wants to run through all the
>>>>> other arch's doing it ...
>>>>>
>>>>
>>>> Looking at all other architectures that allow ARCH_DISCONTIGMEM_ENABLE, we
>>>> already know x86 is fine, avr32 disables ARCH_DISCONTIGMEM_ENABLE entirely
>>>> because its code only brings online node 0, and tile already sets the bit
>>>> in N_NORMAL_MEMORY correctly when bringing a node online, probably because
>>>> it was introduced after the various node state masks were added in
>>>> 7ea1530ab3fd back in October 2007.
>>>>
>>>> So we're really only talking about alpha, ia64, m32r, m68k, and mips and
>>>> it only seems to matter when using CONFIG_SLUB, which isn't surprising
>>>> when greping for it:
>>>>
>>>>        $ grep -r N_NORMAL_MEMORY mm/*
>>>>        mm/memcontrol.c:        if (!node_state(node, N_NORMAL_MEMORY))
>>>>        mm/memcontrol.c:                if (!node_state(node, N_NORMAL_MEMORY))
>>>>        mm/page_alloc.c:        [N_NORMAL_MEMORY] = { { [0] = 1UL } },
>>>>        mm/page_alloc.c:
>>>> node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:              for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:              for_each_node_state(node, N_NORMAL_MEMORY) {
>>>>        mm/slub.c:      for_each_node_state(node, N_NORMAL_MEMORY)
>>>>
>>>> Those memory controller occurrences only result in it passing a node id of
>>>> -1 to kmalloc_node() which means no specific node target, and that's fine
>>>> for DISCONTIGMEM since we don't care about any proximity between memory
>>>> ranges.
>>>>
>>>> This should fix the remaining architectures so they can use CONFIG_SLUB,
>>>> but I hope it can be tested by the individual arch maintainers like you
>>>> did for parisc.
>>>>
>>>> diff --git a/arch/alpha/mm/numa.c b/arch/alpha/mm/numa.c
>>>> --- a/arch/alpha/mm/numa.c
>>>> +++ b/arch/alpha/mm/numa.c
>>>> @@ -245,6 +245,7 @@ setup_memory_node(int nid, void *kernel_end)
>>>>                        bootmap_size, BOOTMEM_DEFAULT);
>>>>        printk(" reserving pages %ld:%ld\n", bootmap_start,
>>>> bootmap_start+PFN_UP(bootmap_size));
>>>>
>>>> +       node_set_state(nid, N_NORMAL_MEMORY);
>>>>        node_set_online(nid);
>>>>  }
>>>>
>>>> diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
>>>> --- a/arch/ia64/mm/discontig.c
>>>> +++ b/arch/ia64/mm/discontig.c
>>>> @@ -573,6 +573,8 @@ void __init find_memory(void)
>>>>                                  map>>PAGE_SHIFT,
>>>>                                  bdp->node_min_pfn,
>>>>                                  bdp->node_low_pfn);
>>>> +               if (node_present_pages(node))
>>>> +                       node_set_state(node, N_NORMAL_MEMORY);
>>>>        }
>>>>
>>>>        efi_memmap_walk(filter_rsvd_memory, free_node_bootmem);
>>>> diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
>>>> --- a/arch/m32r/kernel/setup.c
>>>> +++ b/arch/m32r/kernel/setup.c
>>>> @@ -247,7 +247,9 @@ void __init setup_arch(char **cmdline_p)
>>>>
>>>>  #ifdef CONFIG_DISCONTIGMEM
>>>>        nodes_clear(node_online_map);
>>>> +       node_set_state(0, N_NORMAL_MEMORY);     /* always has memory */
>>>>        node_set_online(0);
>>>> +       node_set_state(1, N_NORMAL_MEMORY);     /* always has memory */
>>>>        node_set_online(1);
>>>>  #endif /* CONFIG_DISCONTIGMEM */
>>>>
>>>> diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
>>>> --- a/arch/m68k/mm/init_mm.c
>>>> +++ b/arch/m68k/mm/init_mm.c
>>>> @@ -59,6 +59,8 @@ void __init m68k_setup_node(int node)
>>>>        }
>>>>  #endif
>>>>        pg_data_map[node].bdata = bootmem_node_data + node;
>>>> +       if (node_present_pages(node))
>>>> +               node_set_state(node, N_NORMAL_MEMORY);
>>>>        node_set_online(node);
>>>>  }
>>>>
>>>> diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
>>>> --- a/arch/mips/sgi-ip27/ip27-memory.c
>>>> +++ b/arch/mips/sgi-ip27/ip27-memory.c
>>>> @@ -471,6 +471,8 @@ void __init paging_init(void)
>>>>
>>>>                if (end_pfn > max_low_pfn)
>>>>                        max_low_pfn = end_pfn;
>>>> +               if (end_pfn > start_pfn)
>>>> +                       node_set_state(node, N_NORMAL_MEMORY);
>>>>        }
>>>>        zones_size[ZONE_NORMAL] = max_low_pfn;
>>>>        free_area_init_nodes(zones_size);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
