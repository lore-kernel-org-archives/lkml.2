Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2J2GRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:17:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57890 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2J2GRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:17:15 -0400
Message-ID: <508E1F64.3080806@numascale-asia.com>
Date: Mon, 29 Oct 2012 14:17:08 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
References: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com> <20121025110353.GA2623@aftab.osrc.amd.com>
In-Reply-To: <20121025110353.GA2623@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2012 19:03, Borislav Petkov wrote:
> On Thu, Oct 25, 2012 at 04:32:52PM +0800, Daniel J Blueman wrote:
>> The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
>> are contiguous, which no longer holds on federated systems with multiple
>> HyperTransport fabrics and multiple PCI domains, eg on Numascale's
>> Numaconnect systems with NumaChip.
>>
>> Address this assumption by searching the Northbridge ID array, rather than
>> directly indexing it, using the upper bits for the PCI domain.
>>
>> RFC->v2: Correct array initialisation
>> v2->v3: Add Boris's neater linked list approach
>>
>> Todo:
>> 1. fix kobject/sysfs oops (see http://quora.org/2012/16-server-boot.txt later)
>> 2. reorder amd64_edac.c or add amd64_per_family_init/pci_get_related_function
>>     forward declarations, based on feedback
>>
>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>
> This patch contains code from both of us and thus needs both our SOBs:
>
> Signed-off-by: Borislav Petkov <bp@alien8.de>

I'll use "Based-on-patch-from: Borislav Petkov <bp@alien8.de>", great.

>> ---
>>   arch/x86/include/asm/amd_nb.h            |   63 +++++++++++++++-
>>   arch/x86/include/asm/numachip/numachip.h |   22 ++++++
>>   arch/x86/kernel/amd_gart_64.c            |    8 +-
>>   arch/x86/kernel/amd_nb.c                 |   85 ++++++++++++---------
>>   arch/x86/pci/numachip.c                  |  121 ++++++++++++++++++++++++++++++
>>   drivers/char/agp/amd64-agp.c             |   12 +--
>>   drivers/edac/amd64_edac.c                |   34 +++++----
>>   drivers/edac/amd64_edac.h                |    6 --
>>   8 files changed, 283 insertions(+), 68 deletions(-)
>>   create mode 100644 arch/x86/include/asm/numachip/numachip.h
>>   create mode 100644 arch/x86/pci/numachip.c
>>
>> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
>> index b3341e9..6a27226 100644
>> --- a/arch/x86/include/asm/amd_nb.h
>> +++ b/arch/x86/include/asm/amd_nb.h
>> @@ -4,6 +4,8 @@
>>   #include <linux/ioport.h>
>>   #include <linux/pci.h>
>>
>> +#define NUM_POSSIBLE_NBS	8
>> +
>>   struct amd_nb_bus_dev_range {
>>   	u8 bus;
>>   	u8 dev_base;
>> @@ -51,12 +53,22 @@ struct amd_northbridge {
>>   	struct pci_dev *link;
>>   	struct amd_l3_cache l3_cache;
>>   	struct threshold_bank *bank4;
>> +	u16 node;
>> +	struct list_head nbl;
>>   };
>>
>>   struct amd_northbridge_info {
>>   	u16 num;
>>   	u64 flags;
>> -	struct amd_northbridge *nb;
>> +
>> +	/*
>> +	 * The first 8 elems are for fast lookup of NB descriptors on single-
>> +	 * system setups, i.e. "normal" boxes. The nb_list, OTOH, is list of
>> +	 * additional NB descriptors which exist on confederate systems
>> +	 * like using Numascale's Numaconnect/NumaChip.
>> +	 */
>> +	struct amd_northbridge *nbs[NUM_POSSIBLE_NBS];
>> +	struct list_head nb_list;
>>   };
>>   extern struct amd_northbridge_info amd_northbridges;
>>
>> @@ -78,7 +90,54 @@ static inline bool amd_nb_has_feature(unsigned feature)
>>
>>   static inline struct amd_northbridge *node_to_amd_nb(int node)
>>   {
>> -	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
>> +	struct amd_northbridge_info *nbi = &amd_northbridges;
>> +	struct amd_northbridge *nb;
>> +	int i;
>> +
>> +	/* Quick search for first domain */
>> +	if (node < NUM_POSSIBLE_NBS) {
>> +		if (node < nbi->num)
>> +			return nbi->nbs[node];
>> +		else
>> +			return NULL;
>> +	}
>
> Why change that here from what I had before?
>
> nbi->nbs[node] will either return a valid descriptor or NULL because it
> is statically allocated in amd_northbridge_info.
>
> So why add a conditional where you clearly don't need it?

True; fixed up.

>> +	/* Search for NBs from later domains in array */
>> +	for (i = 0; i < NUM_POSSIBLE_NBS; i++)
>> +		if (nbi->nbs[i]->node == node)
>> +			return nbi->nbs[i];
>
> And then this is not needed.

Eg with two servers with two Northbridges per server, interconnected, 
Linux sees two PCI domains (bits 15:3) and the nbs array would have node 
IDs:

[0x00]
[0x01]
[0x08]
[0x09]

Without that check, searching for node 0x08 would only hit the linked 
list, though this doesn't affect the fast-path (id < 0x8) of course.

We can use the static array for only the first PCI domain by changing 
_alloc_nb_desc to use the list when nbi->node > NUM_POSSIBLE_NBS, rather 
than nbi->num; we'd then need to introduce a variable to struct 
amd_northbridge_info to keep track of how many static array entries are 
used, for a linear lookup in index_to_amd_nb.

>> +
>> +	list_for_each_entry(nb, &nbi->nb_list, nbl)
>> +		if (node == nb->node)
>> +			return nb;
>
> And why change the list_for_each_entry_safe variant? It is not needed
> now but who knows what code changes where in the future.

Changed also.

>> +
>> +	return NULL;
>> +}
>> +
>> +static inline struct amd_northbridge *index_to_amd_nb(int index)
>> +{
>> +	struct amd_northbridge_info *nbi = &amd_northbridges;
>> +	struct amd_northbridge *nb;
>> +	int count = NUM_POSSIBLE_NBS;
>> +
>> +	if (index < NUM_POSSIBLE_NBS) {
>> +		if (index < nbi->num)
>> +			return nbi->nbs[index];
>> +		else
>> +			return NULL;
>> +	}
>> +
>> +	list_for_each_entry(nb, &nbi->nb_list, nbl) {
>> +		if (count++ == index)
>> +			return nb;
>> +	}
>> +
>> +	return NULL;
>> +}
>
> Huh, what do we need that function for? node should be equal to index
> for the first 8 and then we use the linked list. What's up?

A number of other callers lookup the PCI device based on index 
0..amd_nb_num(), but we can't easily allocate contiguous northbridge IDs 
from the PCI device in the first place.

OTOH we can simply this code by changing amd_get_node_id to generate a 
linear northbridge ID from the index of the matching entry in the 
northbridge array.

I'll get a patch together to see if there are any snags.

Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
