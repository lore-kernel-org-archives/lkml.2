Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2DXKlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:41:08 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43014 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2DXKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:41:06 -0400
Date: Tue, 24 Apr 2012 12:40:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Message-ID: <20120424104059.GA11559@aftab.osrc.amd.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-7-git-send-email-mchehab@redhat.com>
 <20120423174955.GH6147@aftab.osrc.amd.com>
 <4F959FDE.2070304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F959FDE.2070304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 06:30:54PM +0000, Mauro Carvalho Chehab wrote:
> >> +};
> >> +
> >> +/**
> >> + * struct edac_mc_layer - describes the memory controller hierarchy
> >> + * @layer:		layer type
> >> + * @size:maximum size of the layer
> >> + * @is_csrow:		This layer is part of the "csrow" when old API
> >> + *			compatibility mode is enabled. Otherwise, it is
> >> + *			a channel
> >> + */
> >> +struct edac_mc_layer {
> >> +	enum edac_mc_layer_type	type;
> >> +	unsigned		size;
> >> +	bool			is_csrow;
> >> +};
> > 
> > Huh, why do you need is_csrow? Can't do
> > 
> > 	type = EDAC_MC_LAYER_CHIP_SELECT;
> > 
> > ?
> 
> No, that's different. For a csrow-based memory controller, is_csrow is equal to
> type == EDAC_MC_LAYER_CHIP_SELECT, but, for the other memory controllers, this
> is used to mark with layers will be used for the "fake csrow" exported by the
> EDAC core by the legacy API.

I don't understand this, do you mean: "this will be used to mark which
layer will be used to fake a csrow"...?

[..]

> With regards to the changes at edac_mc_sysfs,  it will likely affect all per-dimm
> routines, plus the counters reset logic. The problem of pointing to a set of
> routines that need changes is that this list can/will change with time.
> 
> So, the intention behind this note is not to give an exhaustive list of what should
> be changed, if EDAC_MAX_LAYERS is incremented. Instead, it is meant to give a
> clue that incrementing the number of layers is not as easy as just changing
> it: it would require to change the number of layers also at the code.

Then write that instead of adding a clueless note which only confuses readers.

> 
> > 
> >> + */
> >> +#define EDAC_MAX_LAYERS		3
> >> +
> >> +/*
> >> + * A loop could be used here to make it more generic, but, as we only have
> >> + * 3 layers, this is a little faster. By design, layers can never be 0 or
> >> + * more than 3. If that ever happens, a NULL is returned, causing an OOPS
> >> + * during the memory allocation routine, with would point to the developer
> >> + * that he's doing something wrong.
> >> + */
> >> +#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
> > 
> > This is returning size per layers so it cannot be GET_POS(), AFAICT.
> > EDAC_GET_SIZE or similar maybe?
> 
> This is not returning the size, per layers. It is returning a pointer to the
> structure that holds the dimm.
> 
> > 
> >> +	typeof(var) __p;						\
> >> +	if ((nlayers) == 1)						\
> >> +		__p = &var[lay0];					\
> >> +	else if ((nlayers) == 2)					\
> >> +		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
> >> +	else if ((nlayers) == 3)					\
> >> +		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
> >> +			    ((layers[1]).size * (lay0))))];		\
> >> +	else								\
> >> +		__p = NULL;						\
> >> +	__p;								\
> >> +})

Ok, I'm looking at your next patch trying to understand this thing:

+	/*
+	 * Fills the dimm struct
+	 */
+	memset(&pos, 0, sizeof(pos));
+	row = 0;
+	chn = 0;
+	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
+	for (i = 0; i < tot_dimms; i++) {
+		chan = &csi[row].channels[chn];
+		dimm = GET_POS(lay, mci->dimms, n_layers,
+			       pos[0], pos[1], pos[2]);

pos is an unsigned[3] array with all its elements set to 0 in the memset
above. Which means I need a run-variable like that all the time whenever
I iterate over the layers.

Now, say nlayers == 3, then your macro does this:

	__p = &var[(lay2) + ((layers[2]).size * ((lay1) + ((layers[1]).size * (lay0))))];

So I'm multiplying a loop variable with layers[i].size which is the
maximum size of the layer. What does that mean, where is this size
initialized?

I can imagine that I'll get an element in the mci->dimms array in the
end but this is very confusing.

So please explain what each argument of this macro exactly means.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
