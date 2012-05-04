Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2EDKQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:16:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:57354 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2EDKQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:16:48 -0400
Date: Fri, 4 May 2012 12:16:36 +0200
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
Message-ID: <20120504101636.GB18459@aftab.osrc.amd.com>
References: <20120502133052.GE12914@aftab.osrc.amd.com>
 <4FA29356.3040601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA29356.3040601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:16:54AM -0300, Mauro Carvalho Chehab wrote:
> edac: Change internal representation to work with layers
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Change the EDAC internal representation to work with non-csrow
> based memory controllers.
> 
> There are lots of those memory controllers nowadays, and more
> are coming. So, the EDAC internal representation needs to be
> changed, in order to work with those memory controllers, while
> preserving backward compatibility with the old ones.
> 
> The edac core was written with the idea that memory controllers
> are able to directly access csrows.
> 
> This is not true for FB-DIMM and RAMBUS memory controllers.
> 
> Also, some recent advanced memory controllers don't present a per-csrows
> view. Instead, they view memories as DIMMs, instead of ranks.
> 
> So, change the allocation and error report routines to allow
> them to work with all types of architectures.
> 
> This will allow the removal of several hacks with FB-DIMM and RAMBUS
> memory controllers.
> 
> Also, several tests were done on different platforms using different
> x86 drivers.
> 
> TODO: a multi-rank DIMMs are currently represented by multiple DIMM
> entries in struct dimm_info. That means that changing a label for one
> rank won't change the same label for the other ranks at the same DIMM.
> This bug is present since the beginning of the EDAC, so it is not a big
> deal. However, on several drivers, it is possible to fix this issue, but
> it should be a per-driver fix, as the csrow => DIMM arrangement may not
> be equal for all. So, don't try to fix it here yet.
> 
> I tried to make this patch as short as possible, preceding it with
> several other patches that simplified the logic here. Yet, as the
> internal API changes, all drivers need changes. The changes are
> generally bigger in the drivers for FB-DIMMs.
> 
> Cc: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Mark Gross <mark.gross@intel.com>
> Cc: Jason Uhlenkott <juhlenko@akamai.com>
> Cc: Tim Small <tim@buttersideup.com>
> Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
> Cc: "Arvind R." <arvino55@gmail.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Egor Martovetsky <egor@pasemi.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Joe Perches <joe@perches.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hitoshi Mitake <h.mitake@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
> Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
> Cc: Josh Boyer <jwboyer@gmail.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> ---
> v18: Addresses the pointed issues on v17 review
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index e48ab31..1286c5e 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -447,8 +447,12 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
>  
>  #endif				/* CONFIG_PCI */
>  
> -extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> -					  unsigned nr_chans, int edac_index);
> +struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> +				   unsigned nr_chans, int edac_index);
> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> +				   unsigned n_layers,
> +				   struct edac_mc_layer *layers,
> +				   unsigned sz_pvt);
>  extern int edac_mc_add_mc(struct mem_ctl_info *mci);
>  extern void edac_mc_free(struct mem_ctl_info *mci);
>  extern struct mem_ctl_info *edac_mc_find(int idx);
> @@ -467,24 +471,78 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
>   * reporting logic and function interface - reduces conditional
>   * statement clutter and extra function arguments.
>   */
> -extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
> -			      unsigned long page_frame_number,
> -			      unsigned long offset_in_page,
> -			      unsigned long syndrome, int row, int channel,
> -			      const char *msg);
> -extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
> -				      const char *msg);
> -extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
> -			      unsigned long page_frame_number,
> -			      unsigned long offset_in_page, int row,
> -			      const char *msg);
> -extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
> -				      const char *msg);
> -extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci, unsigned int csrow,
> -				  unsigned int channel0, unsigned int channel1,
> -				  char *msg);
> -extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci, unsigned int csrow,
> -				  unsigned int channel, char *msg);
> +
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
> +			  const void *mcelog);
> +
> +static inline void edac_mc_handle_ce(struct mem_ctl_info *mci,
> +				     unsigned long page_frame_number,
> +				     unsigned long offset_in_page,
> +				     unsigned long syndrome, int row, int channel,
> +				     const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      page_frame_number, offset_in_page, syndrome,
> +			      row, channel, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
> +					     const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ue(struct mem_ctl_info *mci,
> +				     unsigned long page_frame_number,
> +				     unsigned long offset_in_page, int row,
> +				     const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      page_frame_number, offset_in_page, 0,
> +			      row, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
> +					     const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
> +					 unsigned int csrow,
> +					 unsigned int channel0,
> +					 unsigned int channel1,
> +					 char *msg)
> +{
> +	/*
> +	 *FIXME: The error can also be at channel1 (e. g. at the second
> +	 *	  channel of the same branch). The fix is to push
> +	 *	  edac_mc_handle_error() call into each driver
> +	 */
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      0, 0, 0,
> +			      csrow, channel0, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
> +					 unsigned int csrow,
> +					 unsigned int channel, char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      0, 0, 0,
> +			      csrow, channel, -1, msg, NULL, NULL);
> +}
>  
>  /*
>   * edac_device APIs
> @@ -496,6 +554,7 @@ extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
>  extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
>  				int inst_nr, int block_nr, const char *msg);
>  extern int edac_device_alloc_index(void);
> +extern const char *edac_layer_name[];
>  
>  /*
>   * edac_pci APIs
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 6ec967a..10cebb8 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -44,9 +44,25 @@ static void edac_mc_dump_channel(struct rank_info *chan)
>  	debugf4("\tchannel = %p\n", chan);
>  	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
>  	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
> -	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
> -	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
> -	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
> +	debugf4("\tchannel->dimm = %p\n", chan->dimm);
> +}
> +
> +static void edac_mc_dump_dimm(struct dimm_info *dimm)
> +{
> +	int i;
> +
> +	debugf4("\tdimm = %p\n", dimm);
> +	debugf4("\tdimm->label = '%s'\n", dimm->label);
> +	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
> +	debugf4("\tdimm location ");
> +	for (i = 0; i < dimm->mci->n_layers; i++) {
> +		printk(KERN_CONT "%d", dimm->location[i]);
> +		if (i < dimm->mci->n_layers - 1)
> +			printk(KERN_CONT ".");
> +	}
> +	printk(KERN_CONT "\n");
> +	debugf4("\tdimm->grain = %d\n", dimm->grain);
> +	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
>  }
>  
>  static void edac_mc_dump_csrow(struct csrow_info *csrow)
> @@ -70,6 +86,8 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
>  	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
>  	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
>  		mci->nr_csrows, mci->csrows);
> +	debugf3("\tmci->nr_dimms = %d, dimms = %p\n",
> +		mci->tot_dimms, mci->dimms);
>  	debugf3("\tdev = %p\n", mci->dev);
>  	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
>  	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
> @@ -157,10 +175,20 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>  }
>  
>  /**
> - * edac_mc_alloc: Allocate a struct mem_ctl_info structure
> - * @size_pvt:	size of private storage needed
> - * @nr_csrows:	Number of CWROWS needed for this MC
> - * @nr_chans:	Number of channels for the MC
> + * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
> + * @mc_num:		Memory controller number
> + * @n_layers:		Number of MC hierarchy layers
> + * layers:		Describes each layer as seen by the Memory Controller
> + * @size_pvt:		size of private storage needed
> + *
> + *
> + * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
> + * such DIMMS properly, but the CSROWS-based ones will likely do the wrong

	   DIMMs		   csrow-based

> + * thing, as two chip select values are used for dual-rank memories (and 4, for
> + * quad-rank ones). I suspect that this issue could be solved inside the EDAC
> + * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.

The paragraph above is still in, let me repeat my last note:

"This last paragraph sounds innacurately, especially the "likely"
adverbs make it even more confusing. The gist of what you're saying is
already present in the commit message anyway, so drop it here pls."

> + *
> + * In summary, solving this issue is not easy, as it requires a lot of testing.

As before:

"Also superfluous and has nothing to do with edac_mc_alloc()."

Pls remove it.

>   * Everything is kmalloc'ed as one big chunk - more efficient.
>   * Only can be used if all structures have the same lifetime - otherwise
> @@ -168,22 +196,49 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>   *
>   * Use edac_mc_free() to free mc structures allocated by this function.
>   *
> + * NOTE: drivers handle multi-rank memories in different ways: in some
> + * drivers, one multi-rank memory stick is mapped as one entry, while, in
> + * others, a single multi-rank memory stick would be mapped into several
> + * entries. Currently, this function will allocate multiple struct dimm_info
> + * on such scenarios, as grouping the multiple ranks require drivers change.
> + *
>   * Returns:
>   *	NULL allocation failed
>   *	struct mem_ctl_info pointer

Ok, this patch still doesn't contain all the changes I requested for
although you said you did them. Is this not the latest version? I'll
wait for you to sort it out before I continue reviewing...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
