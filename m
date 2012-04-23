Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2DWRuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:50:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39902 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2DWRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:50:00 -0400
Date: Mon, 23 Apr 2012 19:49:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Message-ID: <20120423174955.GH6147@aftab.osrc.amd.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-7-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334607133-30039-7-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: "edac.h: Prepare to handle with generic layers"

what does that even mean?

Do you per chance mean

	"Add generic layers for describing a memory location"

or something similar?

On Mon, Apr 16, 2012 at 05:12:12PM -0300, Mauro Carvalho Chehab wrote:
> The edac core were written with the idea that memory controllers
> are able to directly access csrows, and that the channels are
> used inside a csrows select.
> 
> This is not true for FB-DIMM and RAMBUS memory controllers.
> 
> Also, some recent advanced memory controllers don't present a per-csrows
> view. Instead, they view memories as DIMM's, instead of ranks, accessed

				       DIMMs

> via csrow/channel.
> 
> So, changes are needed in order to allow the EDAC core to
> work with all types of architectures.
> 
> As a preparation for handling non-csrows based memory controllers,

 In preparation...

> adds some memory structs and a macro:

  add some...

> enum hw_event_mc_err_type: describes the type of error
> 			   (corrected, uncorrected, fatal)
> 
> To be used by the new edac_mc_handle_error function;
> 
> enum edac_mc_layer: describes the type of a given Memory

						    memory

> architecture layer (branch, channel, slot, csrow).
> 
> struct edac_mc_layer: describes the properties of a memory
> 		      layer (type, size, and if the layer
> 		      will be used on a virtual csrow.
> 
> GET_POS() - as the number of layers can vary from 1 to 3,
> this macro converts from an address with up to 3 layers into
> a linear address.
> 
> Cc: Doug Thompson <norsk5@yahoo.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  include/linux/edac.h |   83 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 82 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/edac.h b/include/linux/edac.h
> index 8b78bd0..0fdf6ba 100644
> --- a/include/linux/edac.h
> +++ b/include/linux/edac.h
> @@ -67,6 +67,25 @@ enum dev_type {
>  #define DEV_FLAG_X64		BIT(DEV_X64)
>  
>  /**
> + * enum hw_event_mc_err_type - type of the detected error
> + *
> + * @HW_EVENT_ERR_CORRECTED:	Corrected Error - Indicates that an ECC
> + *				corrected error was detected
> + * @HW_EVENT_ERR_UNCORRECTED:	Uncorrected Error - Indicates an error that
> + *				can't be corrected by ECC, but it is not
> + *				factal (maybe it is on an unused memory area,

				fatal

> + *				or the memory controller could recover from
> + *				it for example, by re-trying the operation).
> + * @HW_EVENT_ERR_FATAL:		Fatal Error - Uncorrected error that could not
> + *				be recovered.
> + */
> +enum hw_event_mc_err_type {
> +	HW_EVENT_ERR_CORRECTED,
> +	HW_EVENT_ERR_UNCORRECTED,
> +	HW_EVENT_ERR_FATAL,

Need a terminating elem here:
	HW_EVENT_ERR_NUM,

> +};
> +
> +/**
>   * enum mem_type - memory types. For a more detailed reference, please see
>   *			http://en.wikipedia.org/wiki/DRAM
>   *
> @@ -308,7 +327,69 @@ enum scrub_type {
>   * PS - I enjoyed writing all that about as much as you enjoyed reading it.
>   */
>  
> -/* FIXME: add a per-dimm ce error count */
> +/**
> + * enum edac_mc_layer - memory controller hierarchy layer
> + *
> + * @EDAC_MC_LAYER_BRANCH:	memory layer is named "branch"
> + * @EDAC_MC_LAYER_CHANNEL:	memory layer is named "channel"
> + * @EDAC_MC_LAYER_SLOT:		memory layer is named "slot"
> + * @EDAC_MC_LAYER_CHIP_SELECT:	memory layer is named "chip select"
> + *
> + * This enum is used by the drivers to tell edac_mc_sysfs what name should
> + * be used when describing a memory stick location.
> + */
> +enum edac_mc_layer_type {
> +	EDAC_MC_LAYER_BRANCH,
> +	EDAC_MC_LAYER_CHANNEL,
> +	EDAC_MC_LAYER_SLOT,
> +	EDAC_MC_LAYER_CHIP_SELECT,

ditto.

> +};
> +
> +/**
> + * struct edac_mc_layer - describes the memory controller hierarchy
> + * @layer:		layer type
> + * @size:maximum size of the layer
> + * @is_csrow:		This layer is part of the "csrow" when old API
> + *			compatibility mode is enabled. Otherwise, it is
> + *			a channel
> + */
> +struct edac_mc_layer {
> +	enum edac_mc_layer_type	type;
> +	unsigned		size;
> +	bool			is_csrow;
> +};

Huh, why do you need is_csrow? Can't do

	type = EDAC_MC_LAYER_CHIP_SELECT;

?

> +
> +/*
> + * Maximum number of layers used by the memory controller to uniquelly

								uniquely

> + * identify a single memory stick.
> + * NOTE: incrementing it would require changes at edac_mc_handle_error()
> + * and at the routines at edac_mc_sysfs that create layers

Maybe add their names here with a regex or so: edac_mc_blabla_*
?

> + */
> +#define EDAC_MAX_LAYERS		3
> +
> +/*
> + * A loop could be used here to make it more generic, but, as we only have
> + * 3 layers, this is a little faster. By design, layers can never be 0 or
> + * more than 3. If that ever happens, a NULL is returned, causing an OOPS
> + * during the memory allocation routine, with would point to the developer
> + * that he's doing something wrong.
> + */
> +#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\

This is returning size per layers so it cannot be GET_POS(), AFAICT.
EDAC_GET_SIZE or similar maybe?

> +	typeof(var) __p;						\
> +	if ((nlayers) == 1)						\
> +		__p = &var[lay0];					\
> +	else if ((nlayers) == 2)					\
> +		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
> +	else if ((nlayers) == 3)					\
> +		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
> +			    ((layers[1]).size * (lay0))))];		\
> +	else								\
> +		__p = NULL;						\
> +	__p;								\
> +})

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
