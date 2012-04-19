Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2DSNPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab2DSNPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:15:41 -0400
Message-ID: <4F900FB3.6000607@redhat.com>
Date: Thu, 19 Apr 2012 10:14:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [EDAC ABI v13 24/25] edac: change the mem allocation scheme to
 make Documentation/kobject.txt happy
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>  <1334608729-30803-25-git-send-email-mchehab@redhat.com> <1334697467.3920.5.camel@joe2Laptop>
In-Reply-To: <1334697467.3920.5.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Em 17-04-2012 18:17, Joe Perches escreveu:
> On Mon, 2012-04-16 at 17:38 -0300, Mauro Carvalho Chehab wrote:
>> Kernel kobjects have rigid rules: each container object should be
>> dynamically allocated, and can't be allocated into a single kmalloc.
>>
>> EDAC never obeyed this rule: it has a single malloc function that
>> allocates all needed data into a single kzalloc.
>>
>> As this is not accepted anymore, change the allocation schema of the
>> EDAC *_info structs to enforce this Kernel standard.
> []
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> []
>> @@ -2228,9 +2228,9 @@ static int init_csrows(struct mem_ctl_info *mci)
>>  			edac_mode = EDAC_NONE;
>>  
>>  		for (j = 0; j < pvt->channel_count; j++) {
>> -			csrow->channels[j].dimm->mtype = mtype;
>> -			csrow->channels[j].dimm->edac_mode = edac_mode;
>> -			csrow->channels[j].dimm->nr_pages = nr_pages;
>> +			csrow->channels[j]->dimm->mtype = mtype;
>> +			csrow->channels[j]->dimm->edac_mode = edac_mode;
>> +			csrow->channels[j]->dimm->nr_pages = nr_pages;
> 
> It might be better to use an automatic for
> 	typeof foo dimm = csrow->channels[j]->dimm;
> 	dimm->mtype = mtype;
> 	etc...
> []
>> @@ -293,39 +286,56 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>>  	mci->mem_is_per_rank = per_rank;
>>  
>>  	/*
>> -	 * Fills the csrow struct
>> +	 * Alocate and fill the csrow/channels structs
>>  	 */
>> +	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);
> 
> kcalloc
> 
> []
>> +		csr->channels = kzalloc(sizeof(*csr->channels) * tot_cschannels,
>> +					GFP_KERNEL);
> 
> here too
> 
>> @@ -391,7 +401,31 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>>  
>>  	trace_hw_event_init("edac", (unsigned)edac_index);
>>  
>> +	debugf1("EDAC MCI allocated\n");
>>  	return mci;

Agreed with all above. Fixed.

>> +
>> +error:
>> +	debugf1("Failed to allocate one or more EDAC MCI structs\n");
> 
> Generally, it's not necessary to have specific "OOM" messages
> as allocations without GFP_NOWARN do dump_stack()s

There is one error condition on the error path that might potentially happen
that it is not related directly to the kalloc stuff: if, there GET_POS() tries
to access something out of the allocated range, it bails out. I added this 
debug printk due to that, while testing the allocation changes. The check could
potentially be using a BUG_ON() call, but, as failing here, the edac drivers
will not load, I opted to not use BUG_ON, and, instead use the standard error
path for it.

That's said, it seems better to remove this debugf1 from this place, and add
some printk(KERN_ERR, ...) at this specific condition.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm folding the enclosed patch on this one, in order to address the comments
on your review.


Thanks!
Mauro

-

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 16510a3..08af66c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2180,6 +2180,7 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 static int init_csrows(struct mem_ctl_info *mci)
 {
 	struct csrow_info *csrow;
+	struct dimm_info *dimm;
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u64 base, mask;
 	u32 val;
@@ -2228,9 +2229,10 @@ static int init_csrows(struct mem_ctl_info *mci)
 			edac_mode = EDAC_NONE;
 
 		for (j = 0; j < pvt->channel_count; j++) {
-			csrow->channels[j]->dimm->mtype = mtype;
-			csrow->channels[j]->dimm->edac_mode = edac_mode;
-			csrow->channels[j]->dimm->nr_pages = nr_pages;
+			dimm = csrow->channels[j]->dimm;
+			dimm->mtype = mtype;
+			dimm->edac_mode = edac_mode;
+			dimm->nr_pages = nr_pages;
 		}
 	}
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index fe57684..16f2d3b 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -296,7 +296,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	/*
 	 * Alocate and fill the csrow/channels structs
 	 */
-	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);
+	mci->csrows = kcalloc(sizeof(*mci->csrows), tot_csrows, GFP_KERNEL);
 	if (!mci->csrows)
 		goto error;
 	for (row = 0; row < tot_csrows; row++) {
@@ -307,7 +307,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		csr->csrow_idx = row;
 		csr->mci = mci;
 		csr->nr_channels = tot_cschannels;
-		csr->channels = kzalloc(sizeof(*csr->channels) * tot_cschannels,
+		csr->channels = kcalloc(sizeof(*csr->channels), tot_cschannels,
 					GFP_KERNEL);
 
 		for (chn = 0; chn < tot_cschannels; chn++) {
@@ -323,7 +323,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	/*
 	 * Allocate and fill the dimm structs
 	 */
-	mci->dimms  = kzalloc(sizeof(*mci->dimms) * tot_dimms, GFP_KERNEL);
+	mci->dimms  = kcalloc(sizeof(*mci->dimms), tot_dimms, GFP_KERNEL);
 	if (!mci->dimms)
 		goto error;
 
@@ -335,8 +335,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
 		off = GET_OFFSET(lay, n_layers, pos[0], pos[1], pos[2]);
-		if (off < 0 || off >= tot_dimms)
+		if (off < 0 || off >= tot_dimms) {
+			edac_mc_printk(mci, KERN_ERR, "EDAC core bug: GET_OFFSET is trying to do an illegal data access\n");
 			goto error;
+		}
 
 		dimm = kzalloc(sizeof(**mci->dimms), GFP_KERNEL);
 		mci->dimms[off] = dimm;
@@ -409,11 +411,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 
 	trace_hw_event_init("edac", (unsigned)edac_index);
 
-	debugf1("EDAC MCI allocated\n");
 	return mci;
 
 error:
-	debugf1("Failed to allocate one or more EDAC MCI structs\n");
 	if (mci->dimms) {
 		for (i = 0; i < tot_dimms; i++)
 			kfree(mci->dimms[i]);
