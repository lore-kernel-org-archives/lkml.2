Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2DPIlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2DPIlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:41:45 -0400
Message-ID: <4F8BDB3D.2020808@redhat.com>
Date: Mon, 16 Apr 2012 05:41:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] edac: Create a dimm struct and move the labels
 into it
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1333039546-5590-2-git-send-email-mchehab@redhat.com> <20120330105048.GA30876@aftab>
In-Reply-To: <20120330105048.GA30876@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-03-2012 07:50, Borislav Petkov escreveu:
> On Thu, Mar 29, 2012 at 01:45:34PM -0300, Mauro Carvalho Chehab wrote:
>> The way a DIMM is currently represented implies that they're
>> linked into a per-csrow struct. However, some drivers don't see
>> csrows, as they're ridden behind some chip like the AMB's
>> on FBDIMM's, for example.
>>
>> This forced drivers to fake a csrow struct, and to create
>> a mess under csrow/channel original's concept.
>>
>> Move the DIMM labels into a per-DIMM struct, and add there
>> the real location of the socket, in terms of csrow/channel.
>> Latter patches will modify the location to properly represent the
>> memory architecture.
>>
>> All other drivers will use a per-csrow type of location.
>> Some of those drivers will require a latter conversion, as
>> they also fake the csrows internally.
>>
>> TODO: While this patch doesn't change the existing behavior, on
>> csrows-based memory controllers, a csrow/channel pair points to a memory
>> rank. There's a known bug at the EDAC core that allows having different
>> labels for the same DIMM, if it has more than one rank. A latter patch
>> is need to merge the several ranks for a DIMM into the same dimm_info
>> struct, in order to avoid having different labels for the same DIMM.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/edac/edac_mc.c       |   50 +++++++++++++++++++++++++++++++----------
>>  drivers/edac/edac_mc_sysfs.c |   11 ++++-----
>>  drivers/edac/i5100_edac.c    |    8 +++---
>>  drivers/edac/i7core_edac.c   |    4 +-
>>  drivers/edac/i82975x_edac.c  |    2 +-
>>  drivers/edac/sb_edac.c       |    4 +-
>>  include/linux/edac.h         |   28 +++++++++++++++++++----
>>  7 files changed, 75 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
>> index 690cbf1..c03bfe7 100644
>> --- a/drivers/edac/edac_mc.c
>> +++ b/drivers/edac/edac_mc.c
>> @@ -44,7 +44,7 @@ static void edac_mc_dump_channel(struct rank_info *chan)
>>  	debugf4("\tchannel = %p\n", chan);
>>  	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
>>  	debugf4("\tchannel->ce_count = %d\n", chan->ce_count);
>> -	debugf4("\tchannel->label = '%s'\n", chan->label);
>> +	debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
>>  	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
>>  }
>>  
>> @@ -157,6 +157,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>  	struct mem_ctl_info *mci;
>>  	struct csrow_info *csi, *csrow;
>>  	struct rank_info *chi, *chp, *chan;
>> +	struct dimm_info *dimm;
>>  	void *pvt;
>>  	unsigned size;
>>  	int row, chn;
>> @@ -170,7 +171,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>  	mci = (struct mem_ctl_info *)0;
>>  	csi = edac_align_ptr(&mci[1], sizeof(*csi));
>>  	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
>> -	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
>> +	dimm = edac_align_ptr(&chi[nr_chans * nr_csrows], sizeof(*dimm));
>> +	pvt = edac_align_ptr(&dimm[nr_chans * nr_csrows], sz_pvt);
>>  	size = ((unsigned long)pvt) + sz_pvt;
>>  
>>  	mci = kzalloc(size, GFP_KERNEL);
>> @@ -182,11 +184,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>  	 */
>>  	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
>>  	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
>> +	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
>>  	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
>>  
>>  	/* setup index and various internal pointers */
>>  	mci->mc_idx = edac_index;
>>  	mci->csrows = csi;
>> +	mci->dimms  = dimm;
>>  	mci->pvt_info = pvt;
>>  	mci->nr_csrows = nr_csrows;
>>  
>> @@ -205,6 +209,21 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>>  		}
>>  	}
>>  
>> +	/*
>> +	 * By default, assumes that a per-csrow arrangement will be used,
>> +	 * as most drivers are based on such assumption.
>> +	 */
>> +	dimm = mci->dimms;
>> +	for (row = 0; row < mci->nr_csrows; row++) {
>> +		for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {
>> +			mci->csrows[row].channels[chn].dimm = dimm;
>> +			dimm->csrow = row;
>> +			dimm->csrow_channel = chn;
>> +			dimm++;
>> +			mci->nr_dimms++;
>> +		}
>> +	}
> 
> There's a double loop above this one which iterates over the same
> things: rows and then channels in each row. So merge that loop with the
> one above instead of repeating it here.

This is not a double loop. Instead, this is a preparation step made to simplify
the following patches.

This loop initializes the dimm structs, while the first one initializes the
(virtual) csrows/channels.

On this point on the series, dimms and ranks are still equal because the patches
that add the capability of handling different memory hierarchies weren't added yet,
as there are more changes to be done.

In the following patches, this loop will be transformed to:

	for (i = 0; i < tot_dimms; i++) {
...
	}

while the first loop will keep the per csrows/nr_channels range.

So, there's nothing here to be changed.

Regards,
Mauro
