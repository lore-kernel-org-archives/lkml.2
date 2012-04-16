Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2DPI5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2DPI46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:56:58 -0400
Message-ID: <4F8BDECE.50801@redhat.com>
Date: Mon, 16 Apr 2012 05:56:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] edac: move dimm properties to struct memset_info
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1333039546-5590-3-git-send-email-mchehab@redhat.com> <20120330170305.GG30876@aftab>
In-Reply-To: <20120330170305.GG30876@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-03-2012 14:03, Borislav Petkov escreveu:
> On Thu, Mar 29, 2012 at 01:45:35PM -0300, Mauro Carvalho Chehab wrote:
>> On systems based on chip select rows, all channels need to use memories
>> with the same properties, otherwise the memories on channels A and B
>> won't be recognized.
>>
>> However, such assumption is not true for all types of memory
>> controllers.
>>
>> Controllers for FB-DIMM's don't have such requirements.
>>
>> Also, modern Intel controllers seem to be capable of handling such
>> differences.
>>
>> So, we need to get rid of storing the DIMM information into a per-csrow
>> data, storing it, instead at the right place.
>>
>> The first step is to move grain, mtype, dtype and edac_mode to the
>> per-dimm struct.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/edac/amd64_edac.c      |   30 +++++++++++--------
>>  drivers/edac/amd76x_edac.c     |   10 ++++--
>>  drivers/edac/cell_edac.c       |   10 +++++-
>>  drivers/edac/cpc925_edac.c     |   62 +++++++++++++++++++++------------------
>>  drivers/edac/e752x_edac.c      |   44 +++++++++++++++-------------
>>  drivers/edac/e7xxx_edac.c      |   44 ++++++++++++++++------------
>>  drivers/edac/edac_mc.c         |   19 ++++++++----
>>  drivers/edac/edac_mc_sysfs.c   |    6 ++--
>>  drivers/edac/i3000_edac.c      |   18 ++++++-----
>>  drivers/edac/i3200_edac.c      |   18 ++++++-----
>>  drivers/edac/i5000_edac.c      |   24 +++++++--------
>>  drivers/edac/i5100_edac.c      |   38 +++++++++++++-----------
>>  drivers/edac/i5400_edac.c      |   24 ++++++---------
>>  drivers/edac/i7300_edac.c      |   25 +++++++++------
>>  drivers/edac/i7core_edac.c     |   27 ++++++++---------
>>  drivers/edac/i82443bxgx_edac.c |   13 +++++---
>>  drivers/edac/i82860_edac.c     |   11 ++++--
>>  drivers/edac/i82875p_edac.c    |   17 ++++++++---
>>  drivers/edac/i82975x_edac.c    |   17 +++++++----
>>  drivers/edac/mpc85xx_edac.c    |   13 +++++---
>>  drivers/edac/mv64x60_edac.c    |   18 ++++++-----
>>  drivers/edac/pasemi_edac.c     |   10 ++++--
>>  drivers/edac/ppc4xx_edac.c     |   13 +++++---
>>  drivers/edac/r82600_edac.c     |   10 ++++--
>>  drivers/edac/sb_edac.c         |   31 +++++++++++---------
>>  drivers/edac/tile_edac.c       |   13 ++++----
>>  drivers/edac/x38_edac.c        |   17 ++++++-----
>>  include/linux/edac.h           |   21 ++++++++-----
>>  28 files changed, 340 insertions(+), 263 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index c9eee6d..3e7bddc 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -2168,7 +2168,9 @@ static int init_csrows(struct mem_ctl_info *mci)
>>  	struct amd64_pvt *pvt = mci->pvt_info;
>>  	u64 input_addr_min, input_addr_max, sys_addr, base, mask;
>>  	u32 val;
>> -	int i, empty = 1;
>> +	int i, j, empty = 1;
>> +	enum mem_type mtype;
>> +	enum edac_type edac_mode;
>>  
>>  	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
>>  
>> @@ -2202,7 +2204,21 @@ static int init_csrows(struct mem_ctl_info *mci)
>>  		csrow->page_mask = ~mask;
>>  		/* 8 bytes of resolution */
>>  
>> -		csrow->mtype = amd64_determine_memory_type(pvt, i);
>> +		mtype = amd64_determine_memory_type(pvt, i);
>> +
>> +		/*
>> +		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
>> +		 */
>> +		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
>> +			edac_mode = (pvt->nbcfg & NBCFG_CHIPKILL) ?
>> +				    EDAC_S4ECD4ED : EDAC_SECDED;
>> +		else
>> +			edac_mode = EDAC_NONE;
>> +
>> +		for (j = 0; j < pvt->channel_count; j++) {
>> +			csrow->channels[j].dimm->mtype = mtype;
>> +			csrow->channels[j].dimm->edac_mode = edac_mode;
>> +		}
>>  
>>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
>>  		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
>> @@ -2214,16 +2230,6 @@ static int init_csrows(struct mem_ctl_info *mci)
>>  			"last_page: 0x%lx\n",
>>  			(unsigned)csrow->nr_pages,
>>  			csrow->first_page, csrow->last_page);
>> -
>> -		/*
>> -		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
>> -		 */
>> -		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
>> -			csrow->edac_mode =
>> -			    (pvt->nbcfg & NBCFG_CHIPKILL) ?
>> -			    EDAC_S4ECD4ED : EDAC_SECDED;
>> -		else
>> -			csrow->edac_mode = EDAC_NONE;
> 
> This looks like a useless code movement, please leave it where it is
> now and add the for-loop after it instead of pulling it up and causing
> needless churn.

This is needed, as now mtype/edac_mode is per DIMM, and not per channel.
In the specific case of amd64 (and all per-csrow/channel memory controllers),
all channels use the same mtype/edac_mode, but this is not true for other
memory controllers.

So, what the logic there does is to first retrieve the mtype/edac_mode, and
then fill it for each dimm struct (the for loop).

> < snip drivers I'm not maintaining >
> 
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
>> index c03bfe7..2430ddb 100644
>> --- a/drivers/edac/edac_mc.c
>> +++ b/drivers/edac/edac_mc.c
>> @@ -43,7 +43,7 @@ static void edac_mc_dump_channel(struct rank_info *chan)
>>  {
>>  	debugf4("\tchannel = %p\n", chan);
>>  	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
>> -	debugf4("\tchannel->ce_count = %d\n", chan->ce_count);
>> +	debugf4("\tchannel->ce_count = %d\n", chan->dimm->ce_count);
>>  	debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
>>  	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
>>  }
>> @@ -698,6 +698,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>>  {
>>  	unsigned long remapped_page;
>>  	char *label = NULL;
>> +	u32 grain;
>>  
>>  	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
>>  
>> @@ -722,6 +723,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>>  	}
>>  
>>  	label = mci->csrows[row].channels[channel].dimm->label;
>> +	grain = mci->csrows[row].channels[channel].dimm->grain;
>>  
>>  	if (edac_mc_get_log_ce())
>>  		/* FIXME - put in DIMM location */
>> @@ -729,11 +731,12 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>>  			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
>>  			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
>>  			page_frame_number, offset_in_page,
>> -			mci->csrows[row].grain, syndrome, row, channel,
>> +			grain, syndrome, row, channel,
>>  			label, msg);
>>  
>>  	mci->ce_count++;
>>  	mci->csrows[row].ce_count++;
>> +	mci->csrows[row].channels[channel].dimm->ce_count++;
>>  	mci->csrows[row].channels[channel].ce_count++;
>>  
>>  	if (mci->scrub_mode & SCRUB_SW_SRC) {
>> @@ -750,8 +753,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
>>  			mci->ctl_page_to_phys(mci, page_frame_number) :
>>  			page_frame_number;
>>  
>> -		edac_mc_scrub_block(remapped_page, offset_in_page,
>> -				mci->csrows[row].grain);
>> +		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
>>  	}
>>  }
>>  EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
>> @@ -777,6 +779,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
>>  	int chan;
>>  	int chars;
>>  	char *label = NULL;
>> +	u32 grain;
>>  
>>  	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
>>  
>> @@ -790,6 +793,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
>>  		return;
>>  	}
>>  
>> +	grain = mci->csrows[row].channels[0].dimm->grain;
>>  	label = mci->csrows[row].channels[0].dimm->label;
>>  	chars = snprintf(pos, len + 1, "%s", label);
>>  	len -= chars;
>> @@ -807,14 +811,13 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
>>  		edac_mc_printk(mci, KERN_EMERG,
>>  			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
>>  			"labels \"%s\": %s\n", page_frame_number,
>> -			offset_in_page, mci->csrows[row].grain, row,
>> -			labels, msg);
>> +			offset_in_page, grain, row, labels, msg);
>>  
>>  	if (edac_mc_get_panic_on_ue())
>>  		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
>>  			"row %d, labels \"%s\": %s\n", mci->mc_idx,
>>  			page_frame_number, offset_in_page,
>> -			mci->csrows[row].grain, row, labels, msg);
>> +			grain, row, labels, msg);
>>  
>>  	mci->ue_count++;
>>  	mci->csrows[row].ue_count++;
>> @@ -886,6 +889,7 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
>>  	chars = snprintf(pos, len + 1, "%s", label);
>>  	len -= chars;
>>  	pos += chars;
>> +
> 
> Useless \n.
> 
>>  	chars = snprintf(pos, len + 1, "-%s",
>>  			mci->csrows[csrow].channels[channelb].dimm->label);
>>  
>> @@ -939,6 +943,7 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
>>  
>>  	mci->ce_count++;
>>  	mci->csrows[csrow].ce_count++;
>> +	mci->csrows[csrow].channels[channel].dimm->ce_count++;
>>  	mci->csrows[csrow].channels[channel].ce_count++;
>>  }
>>  EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
>> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
>> index c83697c..d63904e 100644
>> --- a/drivers/edac/edac_mc_sysfs.c
>> +++ b/drivers/edac/edac_mc_sysfs.c
>> @@ -150,19 +150,19 @@ static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
>>  static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
>>  				int private)
>>  {
>> -	return sprintf(data, "%s\n", mem_types[csrow->mtype]);
>> +	return sprintf(data, "%s\n", mem_types[csrow->channels[0].dimm->mtype]);
> 
> 							       ^^^
> 
> This looks strange, why always channel 0, because it is always defined?

This is due to the broken API: with the legacy API, all channels need to be
filled with the same memory types. So, the information on channel 0 is identical
to the ones at the other channels. So, for csrows-based memory controllers, the
above logic works just fine.

This is obviously wrong with FB-DIMMs/Nehalem/Sandy Bridge, as the memories on
each channel can be different. Due to this broken API limitation, almost all of 
those drivers just tell the EDAC core that there's just one channel, and maps the
different channels as different csrows.

The very few FB-DIMM drivers that maps their 2 or 4 channels at csrow->channels
currently reports fake information there, filling it with the properties of either
the first channel or the last one, due to the API limitation.

Anyway, using a code like that preserves API backward compatibility.

> 
>>  }
>>  
>>  static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
>>  				int private)
>>  {
>> -	return sprintf(data, "%s\n", dev_types[csrow->dtype]);
>> +	return sprintf(data, "%s\n", dev_types[csrow->channels[0].dimm->dtype]);
> 
> ditto.

ditto.

> 
>>  }
>>  
>>  static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
>>  				int private)
>>  {
>> -	return sprintf(data, "%s\n", edac_caps[csrow->edac_mode]);
>> +	return sprintf(data, "%s\n", edac_caps[csrow->channels[0].dimm->edac_mode]);
> 
> ditto.

ditto.

> 
> <snip more drivers I don't maintain >
> 
> Reminder: you need to get yourself Acks at least from the drivers'
> maintainers which are still active, at least.
> 
>> diff --git a/include/linux/edac.h b/include/linux/edac.h
>> index f40b835..5244193 100644
>> --- a/include/linux/edac.h
>> +++ b/include/linux/edac.h
>> @@ -314,6 +314,13 @@ struct dimm_info {
>>  	unsigned memory_controller;
>>  	unsigned csrow;
>>  	unsigned csrow_channel;
>> +
>> +	u32 grain;		/* granularity of reported error in bytes */
>> +	enum dev_type dtype;	/* memory device type */
>> +	enum mem_type mtype;	/* memory dimm type */
>> +	enum edac_type edac_mode;	/* EDAC mode for this dimm */
>> +
>> +	u32 ce_count;		/* Correctable Errors for this dimm */
>>  };
>>  
>>  /**
>> @@ -339,19 +346,17 @@ struct rank_info {
>>  };
>>  
>>  struct csrow_info {
>> -	unsigned long first_page;	/* first page number in dimm */
>> -	unsigned long last_page;	/* last page number in dimm */
>> +	unsigned long first_page;	/* first page number in csrow */
>> +	unsigned long last_page;	/* last page number in csrow */
>> +	u32 nr_pages;			/* number of pages in csrow */
>>  	unsigned long page_mask;	/* used for interleaving -
>>  					 * 0UL for non intlv
>>  					 */
>> -	u32 nr_pages;		/* number of pages in csrow */
>> -	u32 grain;		/* granularity of reported error in bytes */
>> -	int csrow_idx;		/* the chip-select row */
>> -	enum dev_type dtype;	/* memory device type */
>> +	int csrow_idx;			/* the chip-select row */
>> +
>>  	u32 ue_count;		/* Uncorrectable Errors for this csrow */
>>  	u32 ce_count;		/* Correctable Errors for this csrow */
>> -	enum mem_type mtype;	/* memory csrow type */
>> -	enum edac_type edac_mode;	/* EDAC mode for this csrow */
>> +
>>  	struct mem_ctl_info *mci;	/* the parent */
>>  
>>  	struct kobject kobj;	/* sysfs kobject for this csrow */
>> -- 
>> 1.7.8
> 
> 

