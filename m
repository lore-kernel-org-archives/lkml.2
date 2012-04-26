Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab2DZOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801Ab2DZOZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:25:30 -0400
Message-ID: <4F995ACA.2010701@redhat.com>
Date: Thu, 26 Apr 2012 11:25:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com> <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com> <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com> <4F96E1EB.1030407@redhat.com> <20120425171904.GM18882@aftab.osrc.amd.com> <4F9838BB.5010209@redhat.com> <20120426141149.GC28653@aftab.osrc.amd.com>
In-Reply-To: <20120426141149.GC28653@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-04-2012 11:11, Borislav Petkov escreveu:
> On Wed, Apr 25, 2012 at 02:47:39PM -0300, Mauro Carvalho Chehab wrote:
>>> Now let's look at your output from earlier:
>>>
>>>> $ ./edac-ctl --layout
>>>>        +-----------------------------------+
>>>>        |                mc0                |
>>>>        | channel0  | channel1  | channel2  |
>>>> -------+-----------------------------------+
>>>> slot2: |     0 MB  |     0 MB  |     0 MB  |
>>>> slot1: |  1024 MB  |     0 MB  |     0 MB  |
>>>> slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
>>>> -------+-----------------------------------+
>>>>
>>>> Those are the logs that dump the Memory Controller registers:
>>>>
>>>> [  115.818947] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 2 ranks, UDIMMs
>>>
>>> it says here 2 ranks
>>
>> The above output is for the Nehalem machine, with 4 dimms, all single ranked.
>>
>>>> [  115.818950] EDAC DEBUG: get_dimm_config:   dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
>>>> [  115.818955] EDAC DEBUG: get_dimm_config:   dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400
>>>> [  115.818982] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f4031): 2 ranks, UDIMMs
>>>
>>> and here 2 too although there's only one single-ranked DIMM here. So
>>> which is it?
>>
>> The # of ranks there is the total amount of ranks at the channel.
> 
> The total amount of ranks what? The channel supports, are present on the
> channel, the number of physical slots?
> 
> I'm just saying it is puzzling because your output says "2 ranks" whent
> there are 2 single-ranked DIMMs connected to ch0 and also "2 ranks" when
> there's only one DIMM connected to ch1.

Ah, ok, now I understood what you meant: yeah, channel 1 and 2 also says
that there are two ranks.

I'll double check what's happening there.

> 
> [..]
> 
>> In the case of the EDAC driver, we're relying at the per-DIMM
>> information, that is reported via the MCE misc register. Also, there
>> are per-DIMM error counters out there. So, while it could, in thesis,
>> be possible to use the per-RANK registers and do the error decoding
>> without MCA, this can have troubles, in practice, as some BIOSes
>> can also be accessing the same registers, which would cause race
>> conditions between BIOS and Linux.
> 
> BIOS accessing those registers while OS is running, what is that SMM?
> APEI?

I was thinking in preventing against races with SMM when I was writing 
the code for using the MCA registers instead of accessing the registers 
directly.

> 
> [..]
> 
>>>>>> At Sandy Bridge-EP (E. g. Intel E5 CPUs), we have one machine fully equipped
>>>>>> with dual rank memories. The number of ranks there is just a DIMM property.
>>>>>>
>>>>>> # ./edac-ctl --layout
>>>>>>        +-----------------------------------------------------------------------------------------------+
>>>>>>        |                      mc0                      |                      mc1                      |
>>>>>>        | channel0  | channel1  | channel2  | channel3  | channel0  | channel1  | channel2  | channel3  |
>>>>>> -------+-----------------------------------------------------------------------------------------------+
>>>>>> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
>>>>>> slot1: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
>>>>>> slot0: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
>>>>>> -------+-----------------------------------------------------------------------------------------------+
>>>>>>
>>>>>> (this machine doesn't have physical DIMM sockets for slot#2)
>>>
>>> This looks like a 4-channel memory controller with 3 physical slots per
>>> channel.
>>
>> Yes, except that this specific motherboard has only 16 physical slots. In
>> thesis, it is possible to have a motherboard with 24 physical slots.
> 
> Ok, this probably means the memory controller supports 3 slots per
> channel but the mobo designer laid out only 2 per channel.

Yes.

Regards,
Mauro.
