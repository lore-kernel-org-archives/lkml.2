Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2D1JQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:16:31 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34672 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2D1JQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:16:29 -0400
Date: Sat, 28 Apr 2012 11:16:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120428091621.GE26065@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
 <20120427133304.GE9626@aftab.osrc.amd.com>
 <4F9ADCE3.2030506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9ADCE3.2030506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:52:35PM -0300, Mauro Carvalho Chehab wrote:

[..]

> >> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> >> +				   unsigned n_layers,
> >> +				   struct edac_mc_layer *layers,
> >> +				   bool rev_order,
> >> +				   unsigned sz_pvt)
> > 
> > strange function argument vertical alignment
> > 
> >>  {
> >>  	void *ptr = NULL;
> >>  	struct mem_ctl_info *mci;
> >> -	struct csrow_info *csi, *csrow;
> >> +	struct edac_mc_layer *lay;
> > 
> > As before, call this "layers" pls.
> > 
> >> +	struct csrow_info *csi, *csr;
> >>  	struct rank_info *chi, *chp, *chan;
> >>  	struct dimm_info *dimm;
> >> +	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
> >>  	void *pvt;
> >> -	unsigned size;
> >> -	int row, chn;
> >> +	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
> >> +	unsigned tot_csrows, tot_cschannels;
> > 
> > No need to call this "tot_cschannels" - "tot_channels" should be enough.
> > 
> >> +	int i, j;
> >>  	int err;
> >> +	int row, chn;
> > 
> > All those local variables should be sorted in a reverse christmas tree
> > order:
> > 
> > 	u32 this_is_the_longest_array_name[LENGTH];
> > 	void *shorter_named_variable;
> > 	unsigned long size;
> > 	int i;
> > 
> > 	...
> 
> Why? There's nothing at the CodingStyle saying about how the vars should
> be ordered. If you want to enforce some particular order, please do it
> yourself, but apply it consistently among the entire subsystem.

First of all, this way it is more readable. Second of all, maybe we
should hold it down in CodingStyle. Third of all, you touch this code so you
could fix it up to be more readable while you're at it.

> >> +
> >> +	BUG_ON(n_layers > EDAC_MAX_LAYERS);
> > 
> > 
> > Push this BUG_ON up into edac_mc_alloc as the first thing this function
> > does.
> 
> It is already the first thing at the function.

Ah, that happens later in the patchset where you rename it back to
edac_mc_alloc, ok.

> > Also, is it valid to have n_layers == 0? The memcpy call below
> > will do nothing.
> 
> Changed to:
> 	BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);

Really? Look below.

> 
> >> +	/*
> >> +	 * Calculate the total amount of dimms and csrows/cschannels while
> >> +	 * in the old API emulation mode
> >> +	 */
> >> +	tot_dimms = 1;
> >> +	tot_cschannels = 1;
> >> +	tot_csrows = 1;
> > 
> > Those initializations can be done above at variable declaration time.
> 
> Yes, but the compiled code will be the same anyway, as gcc will optimize

Hey, are you looking at compiled code or at source code? Because I'm
looking at source code, and it is a pretty safe bet the majority of the
people here do that too.

> it, either by using registers for those vars or by moving the initialization
> to the top of the function.
> 
> This function is too complex, so it is better to initialize those vars
> just before the loops that are calculating those totals.

Simply initialize those variables at declaration time and that's it.
Initializing them before the loop doesn't make the function less complex
- splitting it and sanitizing it does.

> > 
> >> +	for (i = 0; i < n_layers; i++) {
> >> +		tot_dimms *= layers[i].size;
> >> +		if (layers[i].is_virt_csrow)
> >> +			tot_csrows *= layers[i].size;
> >> +		else
> >> +			tot_cschannels *= layers[i].size;
> >> +	}

[..]

> -struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> -				unsigned nr_chans, int edac_index)
> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> +				       unsigned n_layers,
> +				       struct edac_mc_layer *layers,
> +				       bool rev_order,
> +				       unsigned sz_pvt)
>  {
>  	void *ptr = NULL;
>  	struct mem_ctl_info *mci;
> -	struct csrow_info *csi, *csrow;
> +	struct edac_mc_layer *layer;
> +	struct csrow_info *csi, *csr;
>  	struct rank_info *chi, *chp, *chan;
>  	struct dimm_info *dimm;
> +	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
>  	void *pvt;
> -	unsigned size;
> -	int row, chn;
> +	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
> +	unsigned tot_csrows, tot_channels, tot_errcount = 0;
> +	int i, j;
>  	int err;
> +	int row, chn;
> +	bool per_rank = false;
> +
> +	BUG_ON(n_layers > EDAC_MAX_LAYERS);

	^^^^^^

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
