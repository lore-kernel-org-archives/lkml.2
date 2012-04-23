Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2DWS41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2DWS40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:56:26 -0400
Message-ID: <4F95A5CE.7010804@redhat.com>
Date: Mon, 23 Apr 2012 18:56:14 +0000
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607133-30039-7-git-send-email-mchehab@redhat.com> <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com>
In-Reply-To: <4F959FDE.2070304@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-04-2012 18:30, Mauro Carvalho Chehab escreveu:
> Em 23-04-2012 17:49, Borislav Petkov escreveu:
>> Subject: "edac.h: Prepare to handle with generic layers"
>>
>> what does that even mean?
>>
>> Do you per chance mean
>>
>> 	"Add generic layers for describing a memory location"
>>
>> or something similar?
>>
>> On Mon, Apr 16, 2012 at 05:12:12PM -0300, Mauro Carvalho Chehab wrote:
>>> The edac core were written with the idea that memory controllers
>>> are able to directly access csrows, and that the channels are
>>> used inside a csrows select.
>>>
>>> This is not true for FB-DIMM and RAMBUS memory controllers.
>>>
>>> Also, some recent advanced memory controllers don't present a per-csrows
>>> view. Instead, they view memories as DIMM's, instead of ranks, accessed
>>
>> 				       DIMMs
>>
>>> via csrow/channel.
>>>
>>> So, changes are needed in order to allow the EDAC core to
>>> work with all types of architectures.
>>>
>>> As a preparation for handling non-csrows based memory controllers,
>>
>>  In preparation...
>>
>>> adds some memory structs and a macro:
>>
>>   add some...
>>
>>> enum hw_event_mc_err_type: describes the type of error
>>> 			   (corrected, uncorrected, fatal)
>>>
>>> To be used by the new edac_mc_handle_error function;
>>>
>>> enum edac_mc_layer: describes the type of a given Memory
>>
>> 						    memory
>>
>>> architecture layer (branch, channel, slot, csrow).
>>>
>>> struct edac_mc_layer: describes the properties of a memory
>>> 		      layer (type, size, and if the layer
>>> 		      will be used on a virtual csrow.
>>>
>>> GET_POS() - as the number of layers can vary from 1 to 3,
>>> this macro converts from an address with up to 3 layers into
>>> a linear address.
>>>
>>> Cc: Doug Thompson <norsk5@yahoo.com>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> ---
>>>  include/linux/edac.h |   83 +++++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 files changed, 82 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/linux/edac.h b/include/linux/edac.h
>>> index 8b78bd0..0fdf6ba 100644
>>> --- a/include/linux/edac.h
>>> +++ b/include/linux/edac.h
>>> @@ -67,6 +67,25 @@ enum dev_type {
>>>  #define DEV_FLAG_X64		BIT(DEV_X64)
>>>  
>>>  /**
>>> + * enum hw_event_mc_err_type - type of the detected error
>>> + *
>>> + * @HW_EVENT_ERR_CORRECTED:	Corrected Error - Indicates that an ECC
>>> + *				corrected error was detected
>>> + * @HW_EVENT_ERR_UNCORRECTED:	Uncorrected Error - Indicates an error that
>>> + *				can't be corrected by ECC, but it is not
>>> + *				factal (maybe it is on an unused memory area,
>>
>> 				fatal
>>
> 
> Fixed all the above.
> 
>>> + *				or the memory controller could recover from
>>> + *				it for example, by re-trying the operation).
>>> + * @HW_EVENT_ERR_FATAL:		Fatal Error - Uncorrected error that could not
>>> + *				be recovered.
>>> + */
>>> +enum hw_event_mc_err_type {
>>> +	HW_EVENT_ERR_CORRECTED,
>>> +	HW_EVENT_ERR_UNCORRECTED,
>>> +	HW_EVENT_ERR_FATAL,
>>
>> Need a terminating elem here:
>> 	HW_EVENT_ERR_NUM,
> 
> Why? There's no place where the number of types is needed. It should be noticed
> no other EDAC enum's have an element for the count.
> 
> IMHO, we should't add any code there that won't be used. If latter needed, such
> change can be added anytime.
> 
>>
>>> +};
>>> +
>>> +/**
>>>   * enum mem_type - memory types. For a more detailed reference, please see
>>>   *			http://en.wikipedia.org/wiki/DRAM
>>>   *
>>> @@ -308,7 +327,69 @@ enum scrub_type {
>>>   * PS - I enjoyed writing all that about as much as you enjoyed reading it.
>>>   */
>>>  
>>> -/* FIXME: add a per-dimm ce error count */
>>> +/**
>>> + * enum edac_mc_layer - memory controller hierarchy layer
>>> + *
>>> + * @EDAC_MC_LAYER_BRANCH:	memory layer is named "branch"
>>> + * @EDAC_MC_LAYER_CHANNEL:	memory layer is named "channel"
>>> + * @EDAC_MC_LAYER_SLOT:		memory layer is named "slot"
>>> + * @EDAC_MC_LAYER_CHIP_SELECT:	memory layer is named "chip select"
>>> + *
>>> + * This enum is used by the drivers to tell edac_mc_sysfs what name should
>>> + * be used when describing a memory stick location.
>>> + */
>>> +enum edac_mc_layer_type {
>>> +	EDAC_MC_LAYER_BRANCH,
>>> +	EDAC_MC_LAYER_CHANNEL,
>>> +	EDAC_MC_LAYER_SLOT,
>>> +	EDAC_MC_LAYER_CHIP_SELECT,
>>
>> ditto.
> 
> ditto.
> 
>>
>>> +};
>>> +
>>> +/**
>>> + * struct edac_mc_layer - describes the memory controller hierarchy
>>> + * @layer:		layer type
>>> + * @size:maximum size of the layer
>>> + * @is_csrow:		This layer is part of the "csrow" when old API
>>> + *			compatibility mode is enabled. Otherwise, it is
>>> + *			a channel
>>> + */
>>> +struct edac_mc_layer {
>>> +	enum edac_mc_layer_type	type;
>>> +	unsigned		size;
>>> +	bool			is_csrow;
>>> +};
>>
>> Huh, why do you need is_csrow? Can't do
>>
>> 	type = EDAC_MC_LAYER_CHIP_SELECT;
>>
>> ?
> 
> No, that's different. For a csrow-based memory controller, is_csrow is equal to
> type == EDAC_MC_LAYER_CHIP_SELECT, but, for the other memory controllers, this
> is used to mark with layers will be used for the "fake csrow" exported by the
> EDAC core by the legacy API.
> 
> This field will be dropped together with the legacy API on some future Kernel,
> but, for now, it is needed, in order to avoid breaking the userspace API.

I don't like big var names, but, if you're not comfortable with is_csrow, then
we can call it as "is_virtual_csrow".
> 
>>
>>> +
>>> +/*
>>> + * Maximum number of layers used by the memory controller to uniquelly
>>
>> 								uniquely
> 
> Fixed.
> 
>>
>>> + * identify a single memory stick.
>>> + * NOTE: incrementing it would require changes at edac_mc_handle_error()
>>> + * and at the routines at edac_mc_sysfs that create layers
>>
>> Maybe add their names here with a regex or so: edac_mc_blabla_*
>> ?
> 
> With regards to the changes at edac_mc_sysfs,  it will likely affect all per-dimm
> routines, plus the counters reset logic. The problem of pointing to a set of
> routines that need changes is that this list can/will change with time.
> 
> So, the intention behind this note is not to give an exhaustive list of what should
> be changed, if EDAC_MAX_LAYERS is incremented. Instead, it is meant to give a
> clue that incrementing the number of layers is not as easy as just changing
> it: it would require to change the number of layers also at the code.
> 
>>
>>> + */
>>> +#define EDAC_MAX_LAYERS		3
>>> +
>>> +/*
>>> + * A loop could be used here to make it more generic, but, as we only have
>>> + * 3 layers, this is a little faster. By design, layers can never be 0 or
>>> + * more than 3. If that ever happens, a NULL is returned, causing an OOPS
>>> + * during the memory allocation routine, with would point to the developer
>>> + * that he's doing something wrong.
>>> + */
>>> +#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
>>
>> This is returning size per layers so it cannot be GET_POS(), AFAICT.
>> EDAC_GET_SIZE or similar maybe?
> 
> This is not returning the size, per layers. It is returning a pointer to the
> structure that holds the dimm.

Maybe it can be called, instead: EDAC_DIMM_PTR().

> 
>>
>>> +	typeof(var) __p;						\
>>> +	if ((nlayers) == 1)						\
>>> +		__p = &var[lay0];					\
>>> +	else if ((nlayers) == 2)					\
>>> +		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
>>> +	else if ((nlayers) == 3)					\
>>> +		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
>>> +			    ((layers[1]).size * (lay0))))];		\
>>> +	else								\
>>> +		__p = NULL;						\
>>> +	__p;								\
>>> +})
>>
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

