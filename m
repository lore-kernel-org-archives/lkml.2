Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2DXMm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:42:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2DXMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:42:58 -0400
Message-ID: <4F969FC4.9080307@redhat.com>
Date: Tue, 24 Apr 2012 09:42:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607133-30039-7-git-send-email-mchehab@redhat.com> <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com>
In-Reply-To: <4F9692AD.8090000@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-04-2012 08:46, Mauro Carvalho Chehab escreveu:
> Em 24-04-2012 07:40, Borislav Petkov escreveu:
>> On Mon, Apr 23, 2012 at 06:30:54PM +0000, Mauro Carvalho Chehab wrote:
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * struct edac_mc_layer - describes the memory controller hierarchy
>>>>> + * @layer:		layer type
>>>>> + * @size:maximum size of the layer
>>>>> + * @is_csrow:		This layer is part of the "csrow" when old API
>>>>> + *			compatibility mode is enabled. Otherwise, it is
>>>>> + *			a channel
>>>>> + */
>>>>> +struct edac_mc_layer {
>>>>> +	enum edac_mc_layer_type	type;
>>>>> +	unsigned		size;
>>>>> +	bool			is_csrow;
>>>>> +};
>>>>
>>>> Huh, why do you need is_csrow? Can't do
>>>>
>>>> 	type = EDAC_MC_LAYER_CHIP_SELECT;
>>>>
>>>> ?
>>>
>>> No, that's different. For a csrow-based memory controller, is_csrow is equal to
>>> type == EDAC_MC_LAYER_CHIP_SELECT, but, for the other memory controllers, this
>>> is used to mark with layers will be used for the "fake csrow" exported by the
>>> EDAC core by the legacy API.
>>
>> I don't understand this, do you mean: "this will be used to mark which
>> layer will be used to fake a csrow"...?
> 
> I've already explained this dozens of times: on x86, except for amd64_edac and
> the drivers for legacy hardware (+7 years old), the information filled at struct 
> csrow_info is FAKE. That's basically one of the main reasons for this patchset.
> 
> There's no csrow signals accessed by the memory controller on FB-DIMM/RAMBUS, and on DDR3
> Intel memory controllers, it is possible to fill memories on different channels with
> different sizes. For example, this is how the 4 DIMM banks are filled on an HP Z400
> with a Intel W3505 CPU:
> 
> $ ./edac-ctl --layout
>        +-----------------------------------+
>        |                mc0                |
>        | channel0  | channel1  | channel2  |
> -------+-----------------------------------+
> slot2: |     0 MB  |     0 MB  |     0 MB  |
> slot1: |  1024 MB  |     0 MB  |     0 MB  |
> slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
> -------+-----------------------------------+
> 
> Those are the logs that dump the Memory Controller registers: 
> 
> [  115.818947] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 2 ranks, UDIMMs
> [  115.818950] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.818955] EDAC DEBUG: get_dimm_config: 	dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.818982] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f4031): 2 ranks, UDIMMs
> [  115.818985] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.819012] EDAC DEBUG: get_dimm_config: Ch2 phy rd3, wr3 (0x063f4031): 2 ranks, UDIMMs
> [  115.819016] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
> 
> The Nehalem memory controllers allow up to 3 DIMMs per channel, and has 3 channels (so,
> a total of 9 DIMMs). Most motherboards, however, expose either 4 or 8 DIMMs per CPU,
> so it isn't possible to have all channels and dimms filled on them.
> 
> On this motherboard, DIMM1 to DIMM3 are mapped to the the first dimm# at channels 0 to 2, and
> DIMM4 goes to the second dimm# at channel 0.
> 
> See? On slot 1, only channel 0 is filled.
> 
> Even if this memory controller would be rank-based[1], the channel information
> can't be mapped using the legacy EDAC API, as, on the old API, all channels need to be
> filled with memories with the same size. So, this driver uses both the slot layer and
> the channel layer as the fake csrow.
> 
> [1] As you can see from the logs and from the source code, the MC registers aren't per rank,
> they are per DIMM. The number of ranks is just one attribute of the register that describes
> a DIMM. The MCA Error registers, however, don't map the rank when reporting an errors,
> nor the error counters are per rank. So, while it is possible to enumerate information
> per rank, the error detection is always per DIMM.
> 
> the "is_csrow" property (or "is_virt_csrow" after the renaming patch) is there to indicate
> what memory layer will compose the "csrow" when using the legacy API. 
> 
>> [..]
>>
>>> With regards to the changes at edac_mc_sysfs,  it will likely affect all per-dimm
>>> routines, plus the counters reset logic. The problem of pointing to a set of
>>> routines that need changes is that this list can/will change with time.
>>>
>>> So, the intention behind this note is not to give an exhaustive list of what should
>>> be changed, if EDAC_MAX_LAYERS is incremented. Instead, it is meant to give a
>>> clue that incrementing the number of layers is not as easy as just changing
>>> it: it would require to change the number of layers also at the code.
>>
>> Then write that instead of adding a clueless note which only confuses readers.
>>
>>>
>>>>
>>>>> + */
>>>>> +#define EDAC_MAX_LAYERS		3
>>>>> +
>>>>> +/*
>>>>> + * A loop could be used here to make it more generic, but, as we only have
>>>>> + * 3 layers, this is a little faster. By design, layers can never be 0 or
>>>>> + * more than 3. If that ever happens, a NULL is returned, causing an OOPS
>>>>> + * during the memory allocation routine, with would point to the developer
>>>>> + * that he's doing something wrong.
>>>>> + */
>>>>> +#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
>>>>
>>>> This is returning size per layers so it cannot be GET_POS(), AFAICT.
>>>> EDAC_GET_SIZE or similar maybe?
>>>
>>> This is not returning the size, per layers. It is returning a pointer to the
>>> structure that holds the dimm.
>>>
>>>>
>>>>> +	typeof(var) __p;						\
>>>>> +	if ((nlayers) == 1)						\
>>>>> +		__p = &var[lay0];					\
>>>>> +	else if ((nlayers) == 2)					\
>>>>> +		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
>>>>> +	else if ((nlayers) == 3)					\
>>>>> +		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
>>>>> +			    ((layers[1]).size * (lay0))))];		\
>>>>> +	else								\
>>>>> +		__p = NULL;						\
>>>>> +	__p;								\
>>>>> +})
>>
>> Ok, I'm looking at your next patch trying to understand this thing:
> 
> (That's why this were merged with the big patch. The meaning of this
> patch and the next one is explained by the changes that happened at the
> drivers. Those two patches, plus the 26 patches are part of a single logical
> change)
>>
>> +	/*
>> +	 * Fills the dimm struct
>> +	 */
>> +	memset(&pos, 0, sizeof(pos));
>> +	row = 0;
>> +	chn = 0;
>> +	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
>> +	for (i = 0; i < tot_dimms; i++) {
>> +		chan = &csi[row].channels[chn];
>> +		dimm = GET_POS(lay, mci->dimms, n_layers,
>> +			       pos[0], pos[1], pos[2]);
>>
>> pos is an unsigned[3] array with all its elements set to 0 in the memset
>> above. Which means I need a run-variable like that all the time whenever
>> I iterate over the layers.
> 
> Yes. 
> 
>>
>> Now, say nlayers == 3, then your macro does this:
>>
>> 	__p = &var[(lay2) + ((layers[2]).size * ((lay1) + ((layers[1]).size * (lay0))))];
>>
>> So I'm multiplying a loop variable with layers[i].size which is the
>> maximum size of the layer. What does that mean, where is this size
>> initialized?
> 
> The layers array is initialized by the drivers.  For example, at amd664_edac (see
> patch 01/26):
> 
> @@ -2520,7 +2561,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
>  		goto err_siblings;
>  
>  	ret = -ENOMEM;
> -	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +	layers[0].size = pvt->csels[0].b_cnt;
> +	layers[0].is_csrow = true;
> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +	layers[1].size = pvt->channel_count;
> +	layers[1].is_csrow = false;
> +	mci = new_edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
>  	if (!mci)
>  		goto err_siblings;
> 
>>
>> I can imagine that I'll get an element in the mci->dimms array in the
>> end 
> 
> Yes. In the case of a 2 layer MC, this would be similar to create a
> bi-dimensional array and use:
> 	dimm = mci->dimm[x][y]
> 
>> but this is very confusing.
>>
>> So please explain what each argument of this macro exactly means.
>>
> I'll.

See the enclosed changes. They improve the comments as requested.

I'll fold them to the main patch and send the complete patch on a separate
email.

Regards,
Mauro


diff --git a/include/linux/edac.h b/include/linux/edac.h
index 243a92b..671b27b 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -362,19 +362,38 @@ struct edac_mc_layer {
 /*
  * Maximum number of layers used by the memory controller to uniquely
  * identify a single memory stick.
- * NOTE: incrementing it would require changes at edac_mc_handle_error()
- * and at the routines at edac_mc_sysfs that create layers
+ * NOTE: Changing this constant requires not only to change the constant
+ * below, but also to change the existing code at the core, as there are
+ * some code there that are optimized for 3 layers.
  */
 #define EDAC_MAX_LAYERS		3
 
-/*
+/**
+ * EDAC_DIMM_PTR - Macro responsible to find a pointer inside a pointer array
+ *		   for the element given by [lay0,lay1,lay2] position
+ *
+ * @layers:	a struct edac_mc_layer array, describing how many elements
+ *		were allocated for each layer
+ * @var:	name of the var where we want to get the pointer
+ *		(like mci->dimms)
+ * @n_layers:	Number of layers at the @layers array
+ * @lay0:	layer0 position
+ * @lay1:	layer1 position. Unused if n_layers < 2
+ * @lay2:	layer2 position. Unused if n_layers < 3
+ *
+ * For 1 layer, this macro returns &var[lay0]
+ * For 2 layers, this macro is similar to allocate a bi-dimensional array
+ *		and to return "&var[lay0][lay1]"
+ * For 3 layers, this macro is similar to allocate a tri-dimensional array
+ *		and to return "&var[lay0][lay1][lay2]"
+ *
  * A loop could be used here to make it more generic, but, as we only have
- * 3 layers, this is a little faster. By design, layers can never be 0 or
- * more than 3. If that ever happens, a NULL is returned, causing an OOPS
- * during the memory allocation routine, with would point to the developer
- * that he's doing something wrong.
+ * 3 layers, this is a little faster.
+ * By design, layers can never be 0 or more than 3. If that ever happens,
+ * a NULL is returned, causing an OOPS during the memory allocation routine,
+ * with would point to the developer that he's doing something wrong.
  */
-#define EDAC_DIMM_PTR(layers, var, nlayers, lay0, lay1, lay2) ({		\
+#define EDAC_DIMM_PTR(layers, var, nlayers, lay0, lay1, lay2) ({	\
 	typeof(var) __p;						\
 	if ((nlayers) == 1)						\
 		__p = &var[lay0];					\
