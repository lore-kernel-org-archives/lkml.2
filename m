Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2DXNMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:12:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab2DXNML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:12:11 -0400
Message-ID: <4F96A696.40308@redhat.com>
Date: Tue, 24 Apr 2012 10:11:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607133-30039-7-git-send-email-mchehab@redhat.com> <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com>
In-Reply-To: <20120424125538.GC11559@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-04-2012 09:55, Borislav Petkov escreveu:
> On Tue, Apr 24, 2012 at 08:46:53AM -0300, Mauro Carvalho Chehab wrote:
>> Em 24-04-2012 07:40, Borislav Petkov escreveu:
>>> On Mon, Apr 23, 2012 at 06:30:54PM +0000, Mauro Carvalho Chehab wrote:
>>>>>> +};
>>>>>> +
>>>>>> +/**
>>>>>> + * struct edac_mc_layer - describes the memory controller hierarchy
>>>>>> + * @layer:		layer type
>>>>>> + * @size:maximum size of the layer
>>>>>> + * @is_csrow:		This layer is part of the "csrow" when old API
>>>>>> + *			compatibility mode is enabled. Otherwise, it is
>>>>>> + *			a channel
>>>>>> + */
>>>>>> +struct edac_mc_layer {
>>>>>> +	enum edac_mc_layer_type	type;
>>>>>> +	unsigned		size;
>>>>>> +	bool			is_csrow;
>>>>>> +};
>>>>>
>>>>> Huh, why do you need is_csrow? Can't do
>>>>>
>>>>> 	type = EDAC_MC_LAYER_CHIP_SELECT;
>>>>>
>>>>> ?
>>>>
>>>> No, that's different. For a csrow-based memory controller, is_csrow is equal to
>>>> type == EDAC_MC_LAYER_CHIP_SELECT, but, for the other memory controllers, this
>>>> is used to mark with layers will be used for the "fake csrow" exported by the
>>>> EDAC core by the legacy API.
>>>
>>> I don't understand this, do you mean: "this will be used to mark which
>>> layer will be used to fake a csrow"...?
>>
>> I've already explained this dozens of times: on x86, except for amd64_edac and
>> the drivers for legacy hardware (+7 years old), the information filled at struct 
>> csrow_info is FAKE. That's basically one of the main reasons for this patchset.
>>
>> There's no csrow signals accessed by the memory controller on FB-DIMM/RAMBUS, and on DDR3
>> Intel memory controllers, it is possible to fill memories on different channels with
>> different sizes. For example, this is how the 4 DIMM banks are filled on an HP Z400
>> with a Intel W3505 CPU:
>>
>> $ ./edac-ctl --layout
>>        +-----------------------------------+
>>        |                mc0                |
>>        | channel0  | channel1  | channel2  |
>> -------+-----------------------------------+
>> slot2: |     0 MB  |     0 MB  |     0 MB  |
>> slot1: |  1024 MB  |     0 MB  |     0 MB  |
>> slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
>> -------+-----------------------------------+
>>
>> Those are the logs that dump the Memory Controller registers: 
>>
>> [  115.818947] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 2 ranks, UDIMMs
>> [  115.818950] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
>> [  115.818955] EDAC DEBUG: get_dimm_config: 	dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400
>> [  115.818982] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f4031): 2 ranks, UDIMMs
>> [  115.818985] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
>> [  115.819012] EDAC DEBUG: get_dimm_config: Ch2 phy rd3, wr3 (0x063f4031): 2 ranks, UDIMMs
>> [  115.819016] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
>>
>> The Nehalem memory controllers allow up to 3 DIMMs per channel, and has 3 channels (so,
>> a total of 9 DIMMs). Most motherboards, however, expose either 4 or 8 DIMMs per CPU,
>> so it isn't possible to have all channels and dimms filled on them.
>>
>> On this motherboard, DIMM1 to DIMM3 are mapped to the the first dimm# at channels 0 to 2, and
>> DIMM4 goes to the second dimm# at channel 0.
>>
>> See? On slot 1, only channel 0 is filled.
> 
> Ok, wait a second, wait a second.
> 
> It's good that you brought up an example, that will probably help
> clarify things better.
> 
> So, how many physical DIMMs are we talking in the example above? 4, and
> all of them single-ranked? They must be because it says "rank: 1" above.
> 
> How would the table look if you had dual-ranked or quad-ranked DIMMs on
> the motherboard?

It won't change. The only changes will be at the debug logs. It would print
something like:

EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 4 ranks, UDIMMs
EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 2, row: 0x4000, col: 0x400
EDAC DEBUG: get_dimm_config: 	dimm 1 1024 Mb offset: 4, bank: 8, rank: 2, row: 0x4000, col: 0x400

> I understand channel{0,1,2} so what is slot now, is that the physical
> DIMM slot on the motherboard?

physical slots:
	DIMM1 - at MCU channel 0, dimm slot#0
	DIMM2 - at MCU channel 1, dimm slot#0
	DIMM3 - at MCU channel 2, dimm slot#0
	DIMM4 - at MCU channel 0, dimm slot#1

This motherboard has only 4 slots.

The i7core_edac driver is not able to discover how many physical DIMM slots
are there at the motherboard.

> If so, why are there 9 slots (3x3) when you say that most motherboards
> support 4 or 8 DIMMs per socket? Are the "slot{0,1,2}" things the
> view from the memory controller or what you physically have on the
> motherboard?

slot{0,1,2} channel{0,1,2} are the addresses given by the memory controller.
Not all motherboards add 9 DIMM physical slots though. Only high-end
motherboards provide 9 slots per MCU.

We have one Nehalem motherboard with 18 DIMM slots, and 2 CPUs. On that
machine, it is possible to use the maximum supported range of DIMMs.

> 
>> Even if this memory controller would be rank-based[1], the channel
>> information can't be mapped using the legacy EDAC API, as, on the old
>> API, all channels need to be filled with memories with the same size.
>> So, this driver uses both the slot layer and the channel layer as the
>> fake csrow.
> 
> So what is the slot layer, is it something you've come up with or is it
> a real DIMM slot on the motherboard?

It is the slot# inside each channel.

>> [1] As you can see from the logs and from the source code, the MC
>> registers aren't per rank, they are per DIMM. The number of ranks
>> is just one attribute of the register that describes a DIMM. The
>> MCA Error registers, however, don't map the rank when reporting an
>> errors, nor the error counters are per rank. So, while it is possible
>> to enumerate information per rank, the error detection is always per
>> DIMM.
> 
> Ok.
> 
> [..]
> 

