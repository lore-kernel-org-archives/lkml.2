Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2JaFXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:23:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39294 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2JaFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:23:43 -0400
Message-ID: <5090B5D8.3000209@numascale-asia.com>
Date: Wed, 31 Oct 2012 13:23:36 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@gmail.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com> <20121025110353.GA2623@aftab.osrc.amd.com> <508E1F64.3080806@numascale-asia.com> <508E4463.3080503@numascale-asia.com> <20121029103217.GD4326@liondog.tnic>
In-Reply-To: <20121029103217.GD4326@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/2012 18:32, Borislav Petkov wrote:
> + Andreas.
>
> Dude, look at this boot log below:
>
> http://quora.org/2012/16-server-boot-2.txt
>
> That's 192 F10h's!

We were booting 384 a while back, but I'll let you know when reach 4096!

> On Mon, Oct 29, 2012 at 04:54:59PM +0800, Daniel J Blueman wrote:
>>> A number of other callers lookup the PCI device based on index
>>> 0..amd_nb_num(), but we can't easily allocate contiguous northbridge IDs
>> >from the PCI device in the first place.
>>
>>> OTOH we can simply this code by changing amd_get_node_id to generate a
>>> linear northbridge ID from the index of the matching entry in the
>>> northbridge array.
>>>
>>> I'll get a patch together to see if there are any snags.
>
> I suspected that after we have this nice approach, you guys would come
> with non-contiguous node numbers. Maan, can't you build your systems so
> that software people can have it easy at least for once??!

It depends on the definition of node, of course. The only changes we're 
considering is compliance with the Intel x2apic spec with using the 
upper 16-bits of the APIC ID as the server ("cluster") ID, since there 
are optimisations in Linux for this.

>> This really is a lot less intrusive [1] and boots well on top of
>> 3.7-rc3 on one of our 16-server/192-core/512GB systems [2].
>>
>> If you're happy with this simpler approach for now, I'll present
>> this and a separate patch cleaning up the inconsistent use of
>> unsigned and u8 node ID variables to u16?
>
> Sure, bring it on.

Yes, I've prepared a patch series and it tests out well.

>> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
>> index b3341e9..b88fc7a 100644
>> --- a/arch/x86/include/asm/amd_nb.h
>> +++ b/arch/x86/include/asm/amd_nb.h
>> @@ -81,6 +81,18 @@ static inline struct amd_northbridge
>> *node_to_amd_nb(int node)
>>          return (node < amd_northbridges.num) ?
>> &amd_northbridges.nb[node] : NULL;
>>   }
>>
>> +static inline u8 get_node_id(struct pci_dev *pdev)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i != amd_nb_num(); i++)
>> +               if (pci_domain_nr(node_to_amd_nb(i)->misc->bus) ==
>> pci_domain_nr(pdev->bus) &&
>> +                   PCI_SLOT(node_to_amd_nb(i)->misc->devfn) ==
>> PCI_SLOT(pdev->devfn))
>> +                       return i;
>
> Looks ok, can you send the whole patch please?
>
>> +       BUG();
>
> I'm not sure about this - maybe WARN()? Are we absolutely sure we
> unconditionally should panic after not finding an NB descriptor?

It looks like the only way we could be looking up a non-existent NB 
descriptor is if the array or variable in hand was corrupted. Maybe 
better to panic immediately debugging to be elusive later.

I've tweaked this to warn and return the first Northbridge ID to avoid 
further issues, but even that isn't ideal.

> Btw, this shouldn't happen on those CPUs:
>
> [   39.279131] TSC synchronization [CPU#0 -> CPU#12]:
> [   39.287223] Measured 22750019569 cycles TSC warp between CPUs, turning off TSC clock.
> [    0.030000] tsc: Marking TSC unstable due to check_tsc_sync_source failed
>
> I guess TSCs are not starting at the same moment on all boards.

As these are physically separate servers (off-the-shelf servers in fact, 
a key benefit of NumaConnect), the TSC clocks diverge. Later, I'll be 
cooking up a patch series to keep them in sync, allowing fast TSC use.

> You definitely need ucode on those too:
>
> [  113.392460] microcode: CPU0: patch_level=0x00000000

Good tip!

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
