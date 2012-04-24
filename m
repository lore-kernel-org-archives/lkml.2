Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2DXNW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2DXNWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:22:24 -0400
Message-ID: <4F96A901.6070100@redhat.com>
Date: Tue, 24 Apr 2012 10:22:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory location
References: <4F969FC4.9080307@redhat.com> <1335271799-6263-1-git-send-email-mchehab@redhat.com> <20120424130925.GD11559@aftab.osrc.amd.com>
In-Reply-To: <20120424130925.GD11559@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-04-2012 10:09, Borislav Petkov escreveu:
> On Tue, Apr 24, 2012 at 09:49:59AM -0300, Mauro Carvalho Chehab wrote:
>> + * EDAC_DIMM_PTR - Macro responsible to find a pointer inside a pointer array
>> + *		   for the element given by [lay0,lay1,lay2] position
>> + *
>> + * @layers:	a struct edac_mc_layer array, describing how many elements
>> + *		were allocated for each layer
>> + * @var:	name of the var where we want to get the pointer
>> + *		(like mci->dimms)
>> + * @n_layers:	Number of layers at the @layers array
>> + * @lay0:	layer0 position
>> + * @lay1:	layer1 position. Unused if n_layers < 2
>> + * @lay2:	layer2 position. Unused if n_layers < 3
> 
> Ok, just call them "layer", you're not saving anything by chomping
> off the last two letters. Besides, "layer" actually means what it is
> supposed to, versus "lay" which means something else.
> 
> :-)

True.
> 
>> + *
>> + * For 1 layer, this macro returns &var[lay0]
>> + * For 2 layers, this macro is similar to allocate a bi-dimensional array
>> + *		and to return "&var[lay0][lay1]"
>> + * For 3 layers, this macro is similar to allocate a tri-dimensional array
>> + *		and to return "&var[lay0][lay1][lay2]"
>> + *
>> + * A loop could be used here to make it more generic, but, as we only have
>> + * 3 layers, this is a little faster.
>> + * By design, layers can never be 0 or more than 3. If that ever happens,
>> + * a NULL is returned, causing an OOPS during the memory allocation routine,
>> + * with would point to the developer that he's doing something wrong.
>> + */
>> +#define EDAC_DIMM_PTR(layers, var, nlayers, lay0, lay1, lay2) ({	\
>> +	typeof(var) __p;						\
>> +	if ((nlayers) == 1)						\
>> +		__p = &var[lay0];					\
>> +	else if ((nlayers) == 2)					\
>> +		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
>> +	else if ((nlayers) == 3)					\
>> +		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
>> +			    ((layers[1]).size * (lay0))))];		\
>> +	else								\
>> +		__p = NULL;						\
>> +	__p;								\
> 
> Ok, I see it now,
> 
> @@ -2520,7 +2561,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
>                 goto err_siblings;
> 
>         ret = -ENOMEM;
> -       mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
> +       layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +       layers[0].size = pvt->csels[0].b_cnt;
> +       layers[0].is_csrow = true;
> +       layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +       layers[1].size = pvt->channel_count;
> +       layers[1].is_csrow = false;
> +       mci = new_edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, false, 0);
>         if (!mci)
>                 goto err_siblings;
> 
> size is not "size"! doh, but the _count_ _of_ _elements_ this layer can
> have. In the example above, layer0's size is actually the amount of chip
> selects you can have per channel. WTF don't you call it that way:

The count of elements of a layer is the size of the layer. The Kernel macro
that gets the number of elements of an array is called "ARRAY_SIZE", and not
"ARRAY_N_ELEMS".

layers->size is the dimension of the layer. So, the term "size" fits better.
For example, according with [1], size means:
	"the spatial dimensions, proportions, magnitude, or bulk of anything:
	 the size of a farm; the size of the fish you caught."

so, "size" fits better for a "dimension" measure.

I don't mind renaming it to n_elems, if this makes you happy.

> 
> Your diff says
> 
>> +/**
>> + * struct edac_mc_layer - describes the memory controller hierarchy
>> + * @layer:           layer type
>> + * @size:maximum size of the layer
>> + * @is_virt_csrow:   This layer is part of the "csrow" when old API
>> + *                   compatibility mode is enabled. Otherwise, it is
>> + *                   a channel
>> + */
>> +struct edac_mc_layer {
>> +     enum edac_mc_layer_type type;
>> +     unsigned                size;
>> +     bool                    is_virt_csrow;
>> +};
> 
> WTF am I, or anyone for that matter, to understand that with "size" you
> mean "num_elems" or something like that? The explanation of that struct
> member "maximum size of the layer" doesn't bring me any further either!
> 
> So call this thing properly and explain properly what it means - no one
> else can look in your brain and actually understand what you mean by
> this non-meaning-anything "size".
> 

