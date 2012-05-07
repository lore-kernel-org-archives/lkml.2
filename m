Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2EGQMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab2EGQMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:12:43 -0400
Message-ID: <4FA7F468.8070101@redhat.com>
Date: Mon, 07 May 2012 13:12:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [EDAC_ABI PATCH v13 01/26] amd64_edac: convert driver to use
 the new edac ABI
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607705-30320-1-git-send-email-mchehab@redhat.com> <1334607705-30320-2-git-send-email-mchehab@redhat.com> <20120507143143.GD11462@aftab.osrc.amd.com>
In-Reply-To: <20120507143143.GD11462@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-05-2012 11:31, Borislav Petkov escreveu:
> Pasting latest version here:
> 
>> From bdd1d4a73e48676e1aaab0dc41fca81e42d5e644 Mon Sep 17 00:00:00 2001
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date: Mon, 16 Apr 2012 15:03:50 -0300
>> Subject: [PATCH] amd64_edac: convert driver to use the new edac ABI
>>
>> The legacy edac ABI is going to be removed. Port the driver to use
>> and benefit from the new API functionality.
>>
>> Cc: Doug Thompson <norsk5@yahoo.com>
>> Cc: Borislav Petkov <borislav.petkov@amd.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Btw,
> 
> now when I inject a correctable ECC error, I get:
> 
> [ 2377.733708] [Hardware Error]: CPU:0     MC4_STATUS[-|CE|-|-|AddrV|CECC]: 0x945f4000b1080a13
> [ 2377.742143] [Hardware Error]:        MC4_ADDR: 0x000000005bac7388
> [ 2377.742151] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
> [ 2377.742164] EDAC amd64 MC0: CE ERROR_ADDRESS= 0x5bac7388
> [ 2377.742172] EDAC DEBUG: f1x_match_to_this_node: (range 0) SystemAddr= 0x5bac7388 Limit=0x437ffffff
> [ 2377.742183] EDAC DEBUG: f1x_match_to_this_node:    Normalized DCT addr: 0x2dd63980
> [ 2377.742190] EDAC DEBUG: f1x_lookup_addr_in_dct: input addr: 0x2dd63980, DCT: 1
> [ 2377.742199] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=0 CSBase=0x0 CSMask=0xffffffe1fff9ffff
> [ 2377.742206] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x0
> [ 2377.742215] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=1 CSBase=0x20000 CSMask=0xffffffe1fff9ffff
> [ 2377.742223] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x20000
> [ 2377.742231] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=2 CSBase=0x40000 CSMask=0xffffffe1fff9ffff
> [ 2377.742239] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x40000
> [ 2377.742247] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=3 CSBase=0x60000 CSMask=0xffffffe1fff9ffff
> [ 2377.742255] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x60000
> [ 2377.742262] EDAC DEBUG: f1x_lookup_addr_in_dct:  MATCH csrow=3
> [ 2377.742279] EDAC MC0: CE amd64_edac on unknown memory (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )
> 					  ^^^^^^^^^^^^^^
> 
> which is misleading. I think that removing the line from
> edac_mc_handle_error() is better:
> 
> -		if (p == label)
> -			strcpy(label, "unknown memory");
> 
> because this way we don't puzzle the user even more with EDAC-internal
> details of how we represent DIMMs and ranks etc.

That happens because the EDAC core couldn't find any EDAC labels for the affected
memory.

There are two reasons for seeing a "unknown memory":
	1) there's no label information. This is fixed by:
	   http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=b14dbb9b8220f8e07634125bf0e315f739cbf501
	2) there's no info about the label e. g. something like the old 
	   edac_mc_handle_ce_no_info().

As csrow and channel info is filled on your log, it is very likely to be
caused by (1) and that you didn't load the labels for this system with edac-ctl.

If you had a table with the labels for your motherboard at /etc/edac/labels.db
and run "edac-ctl --load" during your system init (that's the default on RHEL/Fedora,
not sure what other distros do), the message would be like:

EDAC MC0: CE amd64_edac on DIMM_4B (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )

> IOW, simply having:
> 
> [ 2377.742279] EDAC MC0: CE amd64_edac (csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xb1be)
> 
> is much better IMO.
> 
> Also, formatting that info with ":" makes the data even easily
> understandable and parseable.

Ok. I'll write a patch to replace it at the end of the series.

> Also, you have a trailing space at the end: "... syndrome 0xb1be <---HERE)
> 
> which needs to be removed.

I'll do it also at the printk cleanup patch at the end of the series.

> 
> [ 2377.742288] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: RES (no timeout)
> 
> 
> Other than that, I have only a minor nitpick below.
> 
> 
>> ---
>>  drivers/edac/amd64_edac.c |  137 ++++++++++++++++++++++++++++++---------------
>>  1 file changed, 92 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index 6d6ec6814a98..d00d75a602c1 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -1039,6 +1039,37 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
>>  	int channel, csrow;
>>  	u32 page, offset;
>>  
>> +	error_address_to_page_and_offset(sys_addr, &page, &offset);
>> +
>> +	/*
>> +	 * Find out which node the error address belongs to. This may be
>> +	 * different from the node that detected the error.
>> +	 */
>> +	src_mci = find_mc_by_sys_addr(mci, sys_addr);
>> +	if (!src_mci) {
>> +		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
>> +			     (unsigned long)sys_addr);
>> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +				     page, offset, syndrome,
>> +				     -1, -1, -1,
>> +				     EDAC_MOD_STR,
>> +				     "failed to map error addr to a node",
>> +				     NULL);
>> +		return;
>> +	}
>> +
>> +	/* Now map the sys_addr to a CSROW */
>> +	csrow = sys_addr_to_csrow(src_mci, sys_addr);
>> +	if (csrow < 0) {
>> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +				     page, offset, syndrome,
>> +				     -1, -1, -1,
>> +				     EDAC_MOD_STR,
>> +				     "failed to map error addr to a csrow",
>> +				     NULL);
>> +		return;
>> +	}
>> +
>>  	/* CHIPKILL enabled */
>>  	if (pvt->nbcfg & NBCFG_CHIPKILL) {
>>  		channel = get_channel_from_ecc_syndrome(mci, syndrome);
>> @@ -1048,9 +1079,15 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
>>  			 * 2 DIMMs is in error. So we need to ID 'both' of them
>>  			 * as suspect.
>>  			 */
>> -			amd64_mc_warn(mci, "unknown syndrome 0x%04x - possible "
>> -					   "error reporting race\n", syndrome);
>> -			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
>> +			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
>> +				      "possible error reporting race\n",
>> +				      syndrome);
>> +			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +					     page, offset, syndrome,
>> +					     csrow, -1, -1,
>> +					     EDAC_MOD_STR,
>> +					     "unknown syndrome - possible error reporting race",
>> +					     NULL);
>>  			return;
>>  		}
>>  	} else {
>> @@ -1065,28 +1102,10 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
>>  		channel = ((sys_addr & BIT(3)) != 0);
>>  	}
>>  
>> -	/*
>> -	 * Find out which node the error address belongs to. This may be
>> -	 * different from the node that detected the error.
>> -	 */
>> -	src_mci = find_mc_by_sys_addr(mci, sys_addr);
>> -	if (!src_mci) {
>> -		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
>> -			     (unsigned long)sys_addr);
>> -		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
>> -		return;
>> -	}
>> -
>> -	/* Now map the sys_addr to a CSROW */
>> -	csrow = sys_addr_to_csrow(src_mci, sys_addr);
>> -	if (csrow < 0) {
>> -		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
>> -	} else {
>> -		error_address_to_page_and_offset(sys_addr, &page, &offset);
>> -
>> -		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
>> -				  channel, EDAC_MOD_STR);
>> -	}
>> +	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
>> +			     page, offset, syndrome,
>> +			     csrow, channel, -1,
>> +			     EDAC_MOD_STR, "", NULL);
>>  }
>>  
>>  static int ddr2_cs_size(unsigned i, bool dct_width)
>> @@ -1568,15 +1587,20 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
>>  	u32 page, offset;
>>  	int nid, csrow, chan = 0;
>>  
>> +	error_address_to_page_and_offset(sys_addr, &page, &offset);
>> +
>>  	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
>>  
>>  	if (csrow < 0) {
>> -		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
>> +		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +				     page, offset, syndrome,
>> +				     -1, -1, -1,
>> +				     EDAC_MOD_STR,
>> +				     "failed to map error addr to a csrow",
>> +				     NULL);
>>  		return;
>>  	}
>>  
>> -	error_address_to_page_and_offset(sys_addr, &page, &offset);
>> -
>>  	/*
>>  	 * We need the syndromes for channel detection only when we're
>>  	 * ganged. Otherwise @chan should already contain the channel at
>> @@ -1585,16 +1609,10 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
>>  	if (dct_ganging_enabled(pvt))
>>  		chan = get_channel_from_ecc_syndrome(mci, syndrome);
>>  
>> -	if (chan >= 0)
>> -		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
>> -				  EDAC_MOD_STR);
>> -	else
>> -		/*
>> -		 * Channel unknown, report all channels on this CSROW as failed.
>> -		 */
>> -		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
>> -			edac_mc_handle_ce(mci, page, offset, syndrome,
>> -					  csrow, chan, EDAC_MOD_STR);
>> +	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> +				page, offset, syndrome,
>> +				csrow, chan, -1,
>> +				EDAC_MOD_STR, "", NULL);
> 
> Strange alignement.

Alignment fixed below. Infradead tree updated.

Thanks,
Mauro

-

amd64_edac: convert driver to use the new edac ABI

From: Mauro Carvalho Chehab <mchehab@redhat.com>

The legacy edac ABI is going to be removed. Port the driver to use
and benefit from the new API functionality.

Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6d6ec68..ede3895 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1039,6 +1039,37 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	int channel, csrow;
 	u32 page, offset;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
+	/*
+	 * Find out which node the error address belongs to. This may be
+	 * different from the node that detected the error.
+	 */
+	src_mci = find_mc_by_sys_addr(mci, sys_addr);
+	if (!src_mci) {
+		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
+			     (unsigned long)sys_addr);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a node",
+				     NULL);
+		return;
+	}
+
+	/* Now map the sys_addr to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, sys_addr);
+	if (csrow < 0) {
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
+		return;
+	}
+
 	/* CHIPKILL enabled */
 	if (pvt->nbcfg & NBCFG_CHIPKILL) {
 		channel = get_channel_from_ecc_syndrome(mci, syndrome);
@@ -1048,9 +1079,15 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			 * 2 DIMMs is in error. So we need to ID 'both' of them
 			 * as suspect.
 			 */
-			amd64_mc_warn(mci, "unknown syndrome 0x%04x - possible "
-					   "error reporting race\n", syndrome);
-			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+			amd64_mc_warn(src_mci, "unknown syndrome 0x%04x - "
+				      "possible error reporting race\n",
+				      syndrome);
+			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+					     page, offset, syndrome,
+					     csrow, -1, -1,
+					     EDAC_MOD_STR,
+					     "unknown syndrome - possible error reporting race",
+					     NULL);
 			return;
 		}
 	} else {
@@ -1065,28 +1102,10 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
-	/*
-	 * Find out which node the error address belongs to. This may be
-	 * different from the node that detected the error.
-	 */
-	src_mci = find_mc_by_sys_addr(mci, sys_addr);
-	if (!src_mci) {
-		amd64_mc_err(mci, "failed to map error addr 0x%lx to a node\n",
-			     (unsigned long)sys_addr);
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
-		return;
-	}
-
-	/* Now map the sys_addr to a CSROW */
-	csrow = sys_addr_to_csrow(src_mci, sys_addr);
-	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
-	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-
-		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
-				  channel, EDAC_MOD_STR);
-	}
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
+			     page, offset, syndrome,
+			     csrow, channel, -1,
+			     EDAC_MOD_STR, "", NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1568,15 +1587,20 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	u32 page, offset;
 	int nid, csrow, chan = 0;
 
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
+
 	csrow = f1x_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
 
 	if (csrow < 0) {
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     page, offset, syndrome,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "failed to map error addr to a csrow",
+				     NULL);
 		return;
 	}
 
-	error_address_to_page_and_offset(sys_addr, &page, &offset);
-
 	/*
 	 * We need the syndromes for channel detection only when we're
 	 * ganged. Otherwise @chan should already contain the channel at
@@ -1585,16 +1609,10 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	if (dct_ganging_enabled(pvt))
 		chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-	if (chan >= 0)
-		edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
-				  EDAC_MOD_STR);
-	else
-		/*
-		 * Channel unknown, report all channels on this CSROW as failed.
-		 */
-		for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
-			edac_mc_handle_ce(mci, page, offset, syndrome,
-					  csrow, chan, EDAC_MOD_STR);
+	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			     page, offset, syndrome,
+			     csrow, chan, -1,
+			     EDAC_MOD_STR, "", NULL);
 }
 
 /*
@@ -1875,7 +1893,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	/* Ensure that the Error Address is VALID */
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
@@ -1899,11 +1922,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 
 	if (!(m->status & MCI_STATUS_ADDRV)) {
 		amd64_mc_err(mci, "HW has no ERROR_ADDRESS available\n");
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     0, 0, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "HW has no ERROR_ADDRESS available",
+				     NULL);
 		return;
 	}
 
 	sys_addr = get_error_address(m);
+	error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
@@ -1913,7 +1942,11 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (!src_mci) {
 		amd64_mc_err(mci, "ERROR ADDRESS (0x%lx) NOT mapped to a MC\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to a MC", NULL);
 		return;
 	}
 
@@ -1923,10 +1956,17 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 	if (csrow < 0) {
 		amd64_mc_err(mci, "ERROR_ADDRESS (0x%lx) NOT mapped to CS\n",
 				  (unsigned long)sys_addr);
-		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     -1, -1, -1,
+				     EDAC_MOD_STR,
+				     "ERROR ADDRESS NOT mapped to CS",
+				     NULL);
 	} else {
-		error_address_to_page_and_offset(sys_addr, &page, &offset);
-		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+				     page, offset, 0,
+				     csrow, -1, -1,
+				     EDAC_MOD_STR, "", NULL);
 	}
 }
 
@@ -2486,6 +2526,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct amd64_pvt *pvt = NULL;
 	struct amd64_family_type *fam_type = NULL;
 	struct mem_ctl_info *mci = NULL;
+	struct edac_mc_layer layers[2];
 	int err = 0, ret;
 	u8 nid = get_node_id(F2);
 
@@ -2520,7 +2561,13 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 		goto err_siblings;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, pvt->csels[0].b_cnt, pvt->channel_count, nid);
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = pvt->csels[0].b_cnt;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = pvt->channel_count;
+	layers[1].is_virt_csrow = false;
+	mci = new_edac_mc_alloc(nid, ARRAY_SIZE(layers), layers, 0);
 	if (!mci)
 		goto err_siblings;
 

