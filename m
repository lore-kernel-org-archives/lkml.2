Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2EGNcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:32:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39349 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2EGNcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:32:17 -0400
Date: Mon, 7 May 2012 15:32:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
 with layers, second version
Message-ID: <20120507133204.GC11462@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

breaking thread because it grew too big.

On Fri, May 04, 2012 at 07:48:42AM -0300, Mauro Carvalho Chehab wrote:

[ … ]

> +	memset(&pos, 0, sizeof(pos));
> +	row = 0;
> +	chn = 0;
> +	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
> +		per_rank ? "ranks" : "dimms");
> +	for (i = 0; i < tot_dimms; i++) {
> +		chan = &csi[row].channels[chn];
> +		dimm = EDAC_DIMM_PTR(layer, mci->dimms, n_layers,
> +			       pos[0], pos[1], pos[2]);
> +		dimm->mci = mci;
> +
> +		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
> +			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
> +			pos[0], pos[1], pos[2], row, chn);
> +
> +		/* Copy DIMM location */
> +		for (j = 0; j < n_layers; j++)
> +			dimm->location[j] = pos[j];
> +
> +		/* Link it to the csrows old API data */
> +		chan->dimm = dimm;
> +		dimm->csrow = row;
> +		dimm->cschannel = chn;
> +
> +		/* Increment csrow location */
> +		for (j = n_layers - 1; j >= 0; j--)
> +			if (layers[j].is_virt_csrow)
> +				break;

This looks fishy: the for-loop above iterates over layers[j] to break on
the first ->is_virt_csrow.

> +		row++;

And row here gets incremented unconditionally, independent from the loop
above. And you're not using any results from the loop: j gets reset
below in the next loop.

What's going on?

> +		if (row == tot_csrows) {
> +			row = 0;
> +			chn++;
> +		}
> +
> +		/* Increment dimm location */
> +		for (j = n_layers - 1; j >= 0; j--) {
> +			pos[j]++;
> +			if (pos[j] < layers[j].size)
> +				break;
> +			pos[j] = 0;
>  		}
>  	}
>  
> @@ -263,6 +373,46 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>  	 */
>  	return mci;
>  }
> +EXPORT_SYMBOL_GPL(new_edac_mc_alloc);
> +
> +/**
> + * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
> + * @mc_num:		Memory controller number
> + * @n_layers:		Number of layers at the MC hierarchy
> + * layers:		Describes each layer as seen by the Memory Controller
> + * @size_pvt:		Size of private storage needed
> + *
> + *
> + * FIXME: drivers handle multi-rank memories in different ways: some
> + * drivers map multi-ranked DIMMs as one DIMM while others
> + * as several DIMMs.
> + *
> + * Everything is kmalloc'ed as one big chunk - more efficient.
> + * It can only be used if all structures have the same lifetime - otherwise
> + * you have to allocate and initialize your own structures.
> + *
> + * Use edac_mc_free() to free mc structures allocated by this function.
> + *
> + * Returns:
> + *	On failure: NULL
> + *	On success: struct mem_ctl_info pointer
> + */
> +

[ … ]

> +void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> +			  struct mem_ctl_info *mci,
> +			  const unsigned long page_frame_number,
> +			  const unsigned long offset_in_page,
> +			  const unsigned long syndrome,
> +			  const int layer0,
> +			  const int layer1,
> +			  const int layer2,
> +			  const char *msg,
> +			  const char *other_detail,
> +			  const void *mcelog)
>  {
> -	int len = EDAC_MC_LABEL_LEN * 4;
> -	char labels[len + 1];
> -	char *pos = labels;
> -	int chan;
> -	int chars;
> -	char *label = NULL;
> +	/* FIXME: too much for stack: move it to some pre-alocated area */

I'm assuming all those new FIXMEs are going to be addressed soonish :)

Rest looks ok,
thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
