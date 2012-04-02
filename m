Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2DBNSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:18:51 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39286 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2DBNSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:18:49 -0400
Date: Mon, 2 Apr 2012 15:18:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/13] edac: move nr_pages to dimm struct
Message-ID: <20120402131840.GB24238@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-5-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039546-5590-5-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:45:37PM -0300, Mauro Carvalho Chehab wrote:
> The number of pages is a dimm property. Move it to the dimm struct.
> 
> After this change, it is possible to add sysfs nodes for the DIMM's that

							       DIMMs

> will properly represent the DIMM stick properties, including its size.
> 
> A TODO fix here is to properly represent dual-rank/quad-rank DIMMs when
> the memory controller represents the memory via chip select rows.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/amd64_edac.c      |   13 ++++------
>  drivers/edac/amd76x_edac.c     |    6 ++--
>  drivers/edac/cell_edac.c       |    8 ++++--
>  drivers/edac/cpc925_edac.c     |    8 ++++--
>  drivers/edac/e752x_edac.c      |    6 +++-
>  drivers/edac/e7xxx_edac.c      |    5 ++-
>  drivers/edac/edac_mc.c         |   28 ++++++++++++---------
>  drivers/edac/edac_mc_sysfs.c   |   52 ++++++++++++++++++++++++++++++----------
>  drivers/edac/i3000_edac.c      |    6 +++-
>  drivers/edac/i3200_edac.c      |    3 +-
>  drivers/edac/i5000_edac.c      |   14 ++++++----
>  drivers/edac/i5100_edac.c      |   22 ++++++++++-------
>  drivers/edac/i5400_edac.c      |    9 ++----
>  drivers/edac/i7300_edac.c      |   22 ++++------------
>  drivers/edac/i7core_edac.c     |   10 ++-----
>  drivers/edac/i82443bxgx_edac.c |    2 +-
>  drivers/edac/i82860_edac.c     |    2 +-
>  drivers/edac/i82875p_edac.c    |    5 ++-
>  drivers/edac/i82975x_edac.c    |   11 ++++++--
>  drivers/edac/mpc85xx_edac.c    |    3 +-
>  drivers/edac/mv64x60_edac.c    |    3 +-
>  drivers/edac/pasemi_edac.c     |   14 +++++-----
>  drivers/edac/ppc4xx_edac.c     |    5 ++-
>  drivers/edac/r82600_edac.c     |    3 +-
>  drivers/edac/sb_edac.c         |    8 +----
>  drivers/edac/tile_edac.c       |    2 +-
>  drivers/edac/x38_edac.c        |    4 +-
>  include/linux/edac.h           |   10 ++++---
>  28 files changed, 158 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index b1b1551..ad0376e 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2126,12 +2126,6 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
>  
>  	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
>  
> -	/*
> -	 * If dual channel then double the memory size of single channel.
> -	 * Channel count is 1 or 2
> -	 */
> -	nr_pages <<= (pvt->channel_count - 1);
> -
>  	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
>  	debugf0("    nr_pages= %u  channel-count = %d\n",
>  		nr_pages, pvt->channel_count);
> @@ -2152,6 +2146,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  	int i, j, empty = 1;
>  	enum mem_type mtype;
>  	enum edac_type edac_mode;
> +	int nr_pages;
>  
>  	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
>  
> @@ -2174,7 +2169,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  			i, pvt->mc_node_id);
>  
>  		empty = 0;
> -		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
> +		nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
>  		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
>  		/* 8 bytes of resolution */
>  
> @@ -2192,10 +2187,12 @@ static int init_csrows(struct mem_ctl_info *mci)
>  		for (j = 0; j < pvt->channel_count; j++) {
>  			csrow->channels[j].dimm->mtype = mtype;
>  			csrow->channels[j].dimm->edac_mode = edac_mode;
> +			csrow->channels[j].dimm->nr_pages = nr_pages;
> +

One newline too many.

>  		}
>  
>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
> -		debugf1("    nr_pages: %u\n", csrow->nr_pages);
> +		debugf1("    nr_pages: %u\n", nr_pages);
>  	}
>  
>  	return empty;


<snip>

> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 2430ddb..02263c3 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -43,22 +43,22 @@ static void edac_mc_dump_channel(struct rank_info *chan)
>  {
>  	debugf4("\tchannel = %p\n", chan);
>  	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
> -	debugf4("\tchannel->ce_count = %d\n", chan->dimm->ce_count);
> -	debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
>  	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
> +	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
> +	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
> +	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
>  }
>  
>  static void edac_mc_dump_csrow(struct csrow_info *csrow)
>  {
>  	debugf4("\tcsrow = %p\n", csrow);
>  	debugf4("\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
> -	debugf4("\tcsrow->first_page = 0x%lx\n", csrow->first_page);
> -	debugf4("\tcsrow->last_page = 0x%lx\n", csrow->last_page);
> -	debugf4("\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
> -	debugf4("\tcsrow->nr_pages = 0x%x\n", csrow->nr_pages);
>  	debugf4("\tcsrow->nr_channels = %d\n", csrow->nr_channels);
>  	debugf4("\tcsrow->channels = %p\n", csrow->channels);
>  	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
> +	debugf4("\tcsrow->first_page = 0x%lx\n", csrow->first_page);
> +	debugf4("\tcsrow->last_page = 0x%lx\n", csrow->last_page);
> +	debugf4("\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);

Useless code churn: simply remove the ->nr_pages line.

>  }
>  
>  static void edac_mc_dump_mci(struct mem_ctl_info *mci)
> @@ -655,15 +655,19 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
>  int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
>  {
>  	struct csrow_info *csrows = mci->csrows;
> -	int row, i;
> +	int row, i, j, n;
>  
>  	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
>  	row = -1;
>  
>  	for (i = 0; i < mci->nr_csrows; i++) {
>  		struct csrow_info *csrow = &csrows[i];
> -
> -		if (csrow->nr_pages == 0)
> +		n = 0;
> +		for (j = 0; j < csrow->nr_channels; j++) {
> +			struct dimm_info *dimm = csrow->channels[j].dimm;
> +			n += dimm->nr_pages;
> +		}
> +		if (n == 0)
>  			continue;
>  
>  		debugf3("MC%d: %s(): first(0x%lx) page(0x%lx) last(0x%lx) "
> @@ -672,9 +676,9 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
>  			csrow->page_mask);
>  
>  		if ((page >= csrow->first_page) &&
> -		    (page <= csrow->last_page) &&
> -		    ((page & csrow->page_mask) ==
> -		     (csrow->first_page & csrow->page_mask))) {
> +		(page <= csrow->last_page) &&
> +		((page & csrow->page_mask) ==
> +		(csrow->first_page & csrow->page_mask))) {

Useless and wrong formatting change, please retain the original formatting.

>  			row = i;
>  			break;
>  		}
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index d63904e..52c56cf 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -144,7 +144,13 @@ static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
>  static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
>  				int private)
>  {
> -	return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
> +	int i;
> +	u32 nr_pages = 0;
> +
> +	for (i = 0; i < csrow->nr_channels; i++)
> +		nr_pages += csrow->channels[i].dimm->nr_pages;
> +
> +	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
>  }
>  
>  static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
> @@ -519,16 +525,17 @@ static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
>  
>  static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
>  {
> -	int total_pages, csrow_idx;
> +	int total_pages, csrow_idx, j;
>  
>  	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
> -		csrow_idx++) {
> +	     csrow_idx++) {

You can do the total_pages initialization in the declaration above and
thus don't have to break the loop across two lines:

	int total_pages = 0;
	...

	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
	...

>  		struct csrow_info *csrow = &mci->csrows[csrow_idx];
>  
> -		if (!csrow->nr_pages)
> -			continue;
> +		for (j = 0; j < csrow->nr_channels; j++) {
> +			struct dimm_info *dimm = csrow->channels[j].dimm;
>  
> -		total_pages += csrow->nr_pages;
> +			total_pages += dimm->nr_pages;
> +		}
>  	}
>  
>  	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
> @@ -900,7 +907,7 @@ static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
>   */
>  int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  {
> -	int i;
> +	int i, j;
>  	int err;
>  	struct csrow_info *csrow;
>  	struct kobject *kobj_mci = &mci->edac_mci_kobj;
> @@ -934,10 +941,15 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  	/* Make directories for each CSROW object under the mc<id> kobject
>  	 */
>  	for (i = 0; i < mci->nr_csrows; i++) {
> +		int n = 0;

Let's call this variable with a bit more descriptive name like
'nr_pages' or 'pages_total' or whatever but not simply n.

> +
>  		csrow = &mci->csrows[i];
> +		for (j = 0; j < csrow->nr_channels; j++) {
> +			struct dimm_info *dimm = csrow->channels[j].dimm;
> +			n += dimm->nr_pages;
> +		}

Btw, you can make the loop a single-statement one and drop the curly
braces like so:

		for (j = 0; j < csrow->nr_channels; j++)
			nr_pages += csrow->channels[j].dimm->nr_pages;

The same applies for all the other occurrences of when you iterate over
the channels, accumulating the pages per dimm.

>  
> -		/* Only expose populated CSROWs */
> -		if (csrow->nr_pages > 0) {
> +		if (n > 0) {
>  			err = edac_create_csrow_object(mci, csrow, i);
>  			if (err) {
>  				debugf1("%s() failure: create csrow %d obj\n",
> @@ -949,10 +961,16 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
>  
>  	return 0;
>  
> -	/* CSROW error: backout what has already been registered,  */
>  fail1:
>  	for (i--; i >= 0; i--) {
> -		if (mci->csrows[i].nr_pages > 0)
> +		int n = 0;

ditto.

> +
> +		csrow = &mci->csrows[i];
> +		for (j = 0; j < csrow->nr_channels; j++) {
> +			struct dimm_info *dimm = csrow->channels[j].dimm;
> +			n += dimm->nr_pages;
> +		}
> +		if (n > 0)
>  			kobject_put(&mci->csrows[i].kobj);
>  	}
>  
> @@ -972,14 +990,22 @@ fail0:
>   */
>  void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
>  {
> -	int i;
> +	struct csrow_info *csrow;
> +	int i, j;
>  
>  	debugf0("%s()\n", __func__);
>  
>  	/* remove all csrow kobjects */
>  	debugf4("%s()  unregister this mci kobj\n", __func__);
>  	for (i = 0; i < mci->nr_csrows; i++) {
> -		if (mci->csrows[i].nr_pages > 0) {
> +		int n = 0;

ditto.

> +
> +		csrow = &mci->csrows[i];
> +		for (j = 0; j < csrow->nr_channels; j++) {
> +			struct dimm_info *dimm = csrow->channels[j].dimm;
> +			n += dimm->nr_pages;
> +		}
> +		if (n > 0) {
>  			debugf0("%s()  unreg csrow-%d\n", __func__, i);
>  			kobject_put(&mci->csrows[i].kobj);
>  		}

<snip>

> diff --git a/include/linux/edac.h b/include/linux/edac.h
> index 5244193..de22d4c 100644
> --- a/include/linux/edac.h
> +++ b/include/linux/edac.h
> @@ -320,6 +320,8 @@ struct dimm_info {
>  	enum mem_type mtype;	/* memory dimm type */
>  	enum edac_type edac_mode;	/* EDAC mode for this dimm */
>  
> +	u32 nr_pages;			/* number of pages in csrow */
> +
>  	u32 ce_count;		/* Correctable Errors for this dimm */
>  };
>  
> @@ -346,13 +348,13 @@ struct rank_info {
>  };
>  
>  struct csrow_info {
> +	int csrow_idx;			/* the chip-select row */
> +
> +	/* Used only by edac_mc_find_csrow_by_page() */
>  	unsigned long first_page;	/* first page number in csrow */
>  	unsigned long last_page;	/* last page number in csrow */
> -	u32 nr_pages;			/* number of pages in csrow */
>  	unsigned long page_mask;	/* used for interleaving -
> -					 * 0UL for non intlv
> -					 */
> -	int csrow_idx;			/* the chip-select row */
> +					 * 0UL for non intlv */

Useless moving of code around.

>  
>  	u32 ue_count;		/* Uncorrectable Errors for this csrow */
>  	u32 ce_count;		/* Correctable Errors for this csrow */
> -- 
> 1.7.8

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
