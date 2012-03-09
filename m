Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650Ab2CIUYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030558Ab2CITrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:05 -0500
Message-ID: <4F5A5E2D.4090408@redhat.com>
Date: Fri, 09 Mar 2012 16:46:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120308215716.GA5925@aftab> <4F59DC38.5080104@redhat.com> <20120309143806.GA11962@aftab> <4F5A329A.70702@redhat.com> <20120309184733.GB13745@aftab>
In-Reply-To: <20120309184733.GB13745@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-03-2012 15:47, Borislav Petkov escreveu:
> On Fri, Mar 09, 2012 at 01:40:58PM -0300, Mauro Carvalho Chehab wrote:


[..]

>>> which splits the ch0 and ch1 of the csrow? dir above into ranks. All
>>> fine and dandy but that doesn't change the whole situation - we simply
>>> talk about ranks and not chip select rows anymore. Oh well...
>>
>> Yes, it won't bring anything new there for rank-based hierarchy.
>> The only benefit in this case is that newer userspace programs/versions
>> would use the same struct as the one shown with DIMMs:
>>
>> dimm0
>> ├── dimm_dev_type
>> ├── dimm_edac_mode
>> ├── dimm_label
>> ├── dimm_location
>> ├── dimm_mem_type
>> └── dimm_size
>> dimm4
>> ├── dimm_dev_type
>> ├── dimm_edac_mode
>> ├── dimm_label
>> ├── dimm_location
>> ├── dimm_mem_type
>> └── dimm_size
>> dimm8
>> ├── dimm_dev_type
>> ├── dimm_edac_mode
>> ├── dimm_label
>> ├── dimm_location
>> ├── dimm_mem_type
>> └── dimm_size
> 
> Just to make sure I understand you correctly: are you saying the
> topnodes dimm{0,4,8} are called ranks on the CS-based hw? If so, yes, I
> agree.

Yes. 

>>
>>
>>> Also, the following hierarchy looks ugly:
>>>
>>>  ce_csrow0
>>>  ce_csrow0_channel0
>>>  ce_csrow0_channel1
>>>  ce_csrow1
>>>  ce_csrow1_channel0
>>>  ce_csrow1_channel1
>>>  ce_csrow2
>>>  ce_csrow2_channel0
>>>  ce_csrow2_channel1
>>>  ce_csrow3
>>>  ce_csrow3_channel0
>>>  ce_csrow3_channel1
>>
>> The actual error count node names depend on how the hierarchy is 
>> organized. This is how it looks like at the i5000 machine:
>>
>> mc0
>> ├── ce_branch0
>> ├── ce_branch0_channel0
>> ├── ce_branch0_channel0_slot0
>> ├── ce_branch0_channel1
>> ├── ce_branch0_channel1_slot0
> 
> Yes, but this names have subdirectories written all over them, don't you
> see that in redundant substrings in every filename?
> 
> IOW, it is much nicer to have:
> 
> mc0
> |-> CE
>     |-> branch0
>         |-> ch0
> 	    |-> slot0
> 	    |-> slot1
> 	    |-> ...
> 	|-> ch1
> 	    |-> slot0
> 	    |-> slot1
> 	    ...
>     |-> branch1
>     ...
> |-> UE
> ...

Well, that works for me.

> 
> 
> On CS-based controllers we simply skip "branch".

Maybe we could call the last directory as "row" instead of "slot",
in the case of CS-based controllers, in order to differentiate from
the ones that aren't CS-based and don't have branches.

There are currently one FB-DIMM memory controller like that, plus
Sandy Bridge/Nehalem and i5100 MC's that maps memory per channel/slot.

Btw, i5100 is an interesting driver... it is for DDR2 memories.
Internally, it has a table that maps from csrow to ranks (dimm_csmap).

The dimm_csmap table depends on the memory space mode: if the max allowed
memory is 24 GB, it uses one map table; if the max allowed memory is 48GB,
it uses another table.

The memory controller works just like any other CS-based memory
controller, but the driver itself takes care of not exposing the rank
complexity to the EDAC core. This driver is now properly reported as
having the minimal location "grain" as "dimms".

> 
> [..]
> 
>>> Much better would it be if you put the ch0 and ch1 CE error count into
>>> the csrow?/ directory, i.e. something like:
>>>
>>> csrow?/ce/ch{0,1}
>>> csrow?/ue/ch{0,1}
>>
>> There is a strong technical reason for not doing it. Now, the rank or
>> dimm information is not stored anymore at the legacy structures.
>> The "csrow?" sysfs nodes are created from the struct csrow_info,
>> while the rank/dimm nodes, are created from struct dimm_info.
>>
>> A csrow? node only makes sense if the hierarchy is csrow/channel.
>> As the code should work with all kinds of hierarchy, it would require
>> two different implementations, one for each case.
>>
>> It would also mix the old representation with the new one, creating
>> a complex code for the csrow-based sysfs nodes. After having
>> the new way adopted from some kernel versions, we may think on remove
>> the old nodes,
> 
> yeah, we already talked about this - we need to know that no userspace
> uses them before we do that.

Sure.

> 
>> as removing the csrow/ch hierarchy means to simplify
>> the EDAC code by removing the compatibility logic and data. 
>>
>> So, keeping it on a separate hierarchy helps to have a sane implementation.
> 
> Ok.
> 
>> From userspace POV, creating a node tree may make it  harder to parse, as 
>> there would be, currently, at least 3 different ways for them with the 
>> current hierarchies:
>> 	csrow?/channel?/ce?
>> 	branch?/channel?/slot?/ce?
>> 	channel?/slot?/ce?
>>
>> (and more could be added, as new memory technologies/arrangements
>> may be created).
>>
>> I considered two other alternatives, before adopting this one on my patches:
>>
>> 1) remove the layer name from the name. So, the nodes could be called instead:
>>
>> 	ce_count_0:0:0
>> 	ce_count_0:0:1
>> 	ce_count_0:0
>> 	ce_count_0
>> 	ce_count_0:1:0
>> 	ce_count_0:1:1
>> 	ce_count_0:1
>> 	ce_count_1
>> 	...
>>
>> It shouldn't be hard to change the code to use this way, but it is a little
>> more confusing for users to understand.
>>
>> 2) Put all error counters into a single sub-directory, like:
>> 	error_counters
>> 	├── ce_branch0
>> 	├── ce_branch0_channel0
>> 	├── ce_branch0_channel0_slot0
>> 	├── ce_branch0_channel1
>> 	├── ce_branch0_channel1_slot0	
>> 	├── ce_branch1
>> 	├── ce_branch1_channel0
>> 	├── ce_branch1_channel0_slot0
>> 	├── ce_branch1_channel1
>> 	├── ce_branch1_channel1_slot0
>> 	├── ce_count
>> 	├── ce_noinfo_count
>> 	├── ue_branch0
>> 	├── ue_branch0_channel0
>> 	├── ue_branch0_channel0_slot0
>> 	├── ue_branch0_channel1
>> 	├── ue_branch0_channel1_slot0
>> 	├── ue_branch1
>> 	├── ue_branch1_channel0
>> 	├── ue_branch1_channel0_slot0
>> 	├── ue_branch1_channel1
>> 	├── ue_branch1_channel1_slot0
>> 	├── ue_count
>> 	└── ue_noinfo_count
>>
>> In the last case, the EDAC core would need to keep the 4
>> "general" error counters also under the mc? level (ce_count & friends).
>>
>>>
>>> so that all is clear just from looking at the directory structure. Or
>>> put it into the rank?/ hierarchy and have all per-rank info in one
>>> concentrated, self-describing location.
>>
>> Not sure if I understood what you're meaning here. Could you give an
>> example about what kind of tree are you imagining in this case?
> 
> Right, what I mean is that the rank?/ already contains some info:
> 
> rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> 
> Now, we do the CE/UE error counting on a per-rank granularity anyway, so
> the most natural way to have that is to add those counts to the ranks:
> 
> rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> |-- CE
> |-- UE
> `-- dimm_size
> 
> And this has to be _very_ easy to do without any adding additional
> sysfs nodes with ugly names to /sys/devices/system/edac etc. This is
> even better grouping than the mc?/-based hierarchy I suggested above,
> actually.

Agreed. Yeah, it is easy to add CE/UE there. I actually implemented it
on one of my internal patches, but there's an issue:

The typical case for UE is to report errors by cacheline (128 bits), and
not by DIMM. This happens on all FB-DIMM memory controllers, and also on
several CS-based ones.

For example, this is how (currently) the amd64_handle_ue() handles an
Uncorrected Error:

		error_address_to_page_and_offset(sys_addr, &page, &offset);
		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);

There's no channel info there.

Maybe this is there just due to the current ABI limits. If so, with the new ABI,
it will be possible to report on what channel the error occurred, where supported,
but, at least on the FB-DIMM drivers I wrote, UE errors are reported by cacheline, 
as the ECC code used by those memory controllers now use the Chipkill algorithm,
with takes 128+16 bits, instead of 64+8 bits, in order to enhance the capability
of correcting errors. So, while they can detect where a single error is, for
double errors, it may not be able to correct the error, and be unable to point 
what of the 144 bits are wrong. So, the location should point to two DIMMs instead
of one.

So, except the ECC is calculated over 64+8 bits, the UE error counters for the
rank/dimm won't be incremented. instead, it will increment the "dual rank" or
"dual dimm" error counter.

In the case of CS-based MC's, this is the "per-csrow" UE counter. For FB-DIMMs,
the counter will be the branch one, as the errors will affect two dimms at the
same branch.

Hm... maybe we should map it then as "channel/branch/slot",
instead of "branch/channel/slot".

One alternative would simply to remove all those intermediate counters, letting
userspace to count the errors via perf (provided that we have a proper location
field).

Regards,
Mauro
