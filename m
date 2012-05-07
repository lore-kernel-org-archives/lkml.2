Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2EGQYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab2EGQYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:24:18 -0400
Message-ID: <4FA7F725.6070207@redhat.com>
Date: Mon, 07 May 2012 13:24:05 -0300
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
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607705-30320-1-git-send-email-mchehab@redhat.com> <1334607705-30320-2-git-send-email-mchehab@redhat.com> <20120507143143.GD11462@aftab.osrc.amd.com> <4FA7F468.8070101@redhat.com>
In-Reply-To: <4FA7F468.8070101@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-05-2012 13:12, Mauro Carvalho Chehab escreveu:
> Em 07-05-2012 11:31, Borislav Petkov escreveu:
>> Pasting latest version here:
>>
>>> From bdd1d4a73e48676e1aaab0dc41fca81e42d5e644 Mon Sep 17 00:00:00 2001
>>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> Date: Mon, 16 Apr 2012 15:03:50 -0300
>>> Subject: [PATCH] amd64_edac: convert driver to use the new edac ABI
>>>
>>> The legacy edac ABI is going to be removed. Port the driver to use
>>> and benefit from the new API functionality.
>>>
>>> Cc: Doug Thompson <norsk5@yahoo.com>
>>> Cc: Borislav Petkov <borislav.petkov@amd.com>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> Btw,
>>
>> now when I inject a correctable ECC error, I get:
>>
>> [ 2377.733708] [Hardware Error]: CPU:0     MC4_STATUS[-|CE|-|-|AddrV|CECC]: 0x945f4000b1080a13
>> [ 2377.742143] [Hardware Error]:        MC4_ADDR: 0x000000005bac7388
>> [ 2377.742151] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
>> [ 2377.742164] EDAC amd64 MC0: CE ERROR_ADDRESS= 0x5bac7388
>> [ 2377.742172] EDAC DEBUG: f1x_match_to_this_node: (range 0) SystemAddr= 0x5bac7388 Limit=0x437ffffff
>> [ 2377.742183] EDAC DEBUG: f1x_match_to_this_node:    Normalized DCT addr: 0x2dd63980
>> [ 2377.742190] EDAC DEBUG: f1x_lookup_addr_in_dct: input addr: 0x2dd63980, DCT: 1
>> [ 2377.742199] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=0 CSBase=0x0 CSMask=0xffffffe1fff9ffff
>> [ 2377.742206] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x0
>> [ 2377.742215] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=1 CSBase=0x20000 CSMask=0xffffffe1fff9ffff
>> [ 2377.742223] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x20000
>> [ 2377.742231] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=2 CSBase=0x40000 CSMask=0xffffffe1fff9ffff
>> [ 2377.742239] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x40000
>> [ 2377.742247] EDAC DEBUG: f1x_lookup_addr_in_dct:     CSROW=3 CSBase=0x60000 CSMask=0xffffffe1fff9ffff
>> [ 2377.742255] EDAC DEBUG: f1x_lookup_addr_in_dct:     (InputAddr & ~CSMask)=0x60000 (CSBase & ~CSMask)=0x60000
>> [ 2377.742262] EDAC DEBUG: f1x_lookup_addr_in_dct:  MATCH csrow=3
>> [ 2377.742279] EDAC MC0: CE amd64_edac on unknown memory (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )
>> 					  ^^^^^^^^^^^^^^
>>
>> which is misleading. I think that removing the line from
>> edac_mc_handle_error() is better:
>>
>> -		if (p == label)
>> -			strcpy(label, "unknown memory");
>>
>> because this way we don't puzzle the user even more with EDAC-internal
>> details of how we represent DIMMs and ranks etc.
> 
> That happens because the EDAC core couldn't find any EDAC labels for the affected
> memory.
> 
> There are two reasons for seeing a "unknown memory":
> 	1) there's no label information. This is fixed by:
> 	   http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=b14dbb9b8220f8e07634125bf0e315f739cbf501
> 	2) there's no info about the label e. g. something like the old 
> 	   edac_mc_handle_ce_no_info().
> 
> As csrow and channel info is filled on your log, it is very likely to be
> caused by (1) and that you didn't load the labels for this system with edac-ctl.
> 
> If you had a table with the labels for your motherboard at /etc/edac/labels.db
> and run "edac-ctl --load" during your system init (that's the default on RHEL/Fedora,
> not sure what other distros do), the message would be like:
> 
> EDAC MC0: CE amd64_edac on DIMM_4B (csrow 3 channel 1 page 0x5bac7 offset 0x388 grain 0 syndrome 0xb1be )
> 
>> IOW, simply having:
>>
>> [ 2377.742279] EDAC MC0: CE amd64_edac (csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xb1be)
>>
>> is much better IMO.
>>
>> Also, formatting that info with ":" makes the data even easily
>> understandable and parseable.
> 
> Ok. I'll write a patch to replace it at the end of the series.
> 
>> Also, you have a trailing space at the end: "... syndrome 0xb1be <---HERE)
>>
>> which needs to be removed.
> 
> I'll do it also at the printk cleanup patch at the end of the series.

edac: Improve EDAC handle error logs

From: Mauro Carvalho Chehab <mchehab@redhat.com>

As suggested by Borislav:
- Instead of using space to split between a field and its value,
  use ':';
- when no driver-specific error details are provided via
  "other_detail" field, don't add an extra space.

Reported-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 4f4953c..0adbfa9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -951,11 +951,18 @@ static void edac_ce_error(struct mem_ctl_info *mci,
 {
 	unsigned long remapped_page;
 
-	if (edac_mc_get_log_ce())
-		edac_mc_printk(mci, KERN_WARNING,
-				"CE %s on %s (%s%s %s)\n",
-				msg, label, location,
-				detail, other_detail);
+	if (edac_mc_get_log_ce()) {
+		if (other_detail && *other_detail)
+			edac_mc_printk(mci, KERN_WARNING,
+				       "CE %s on %s (%s%s - %s)\n",
+				       msg, label, location,
+				       detail, other_detail);
+		else
+			edac_mc_printk(mci, KERN_WARNING,
+				       "CE %s on %s (%s%s)\n",
+				       msg, label, location,
+				       detail);
+	}
 	edac_inc_ce_error(mci, enable_per_layer_report, pos);
 
 	if (mci->scrub_mode & SCRUB_SW_SRC) {
@@ -988,14 +995,26 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 			  const char *other_detail,
 			  const bool enable_per_layer_report)
 {
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_WARNING,
-			"UE %s on %s (%s%s %s)\n",
-			msg, label, location, detail, other_detail);
+	if (edac_mc_get_log_ue()) {
+		if (other_detail && *other_detail)
+			edac_mc_printk(mci, KERN_WARNING,
+				       "UE %s on %s (%s%s - %s)\n",
+			               msg, label, location, detail,
+				       other_detail);
+		else
+			edac_mc_printk(mci, KERN_WARNING,
+				       "UE %s on %s (%s%s)\n",
+			               msg, label, location, detail);
+	}
 
-	if (edac_mc_get_panic_on_ue())
-		panic("UE %s on %s (%s%s %s)\n",
-			msg, label, location, detail, other_detail);
+	if (edac_mc_get_panic_on_ue()) {
+		if (other_detail && *other_detail)
+			panic("UE %s on %s (%s%s - %s)\n",
+			      msg, label, location, detail, other_detail);
+		else
+			panic("UE %s on %s (%s%s)\n",
+			      msg, label, location, detail);
+	}
 
 	edac_inc_ue_error(mci, enable_per_layer_report, pos);
 }
@@ -1139,7 +1158,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		if (pos[i] < 0)
 			continue;
 
-		p += sprintf(p, "%s %d ",
+		p += sprintf(p, "%s:%d ",
 			     edac_layer_name[mci->layers[i].type],
 			     pos[i]);
 	}
@@ -1147,12 +1166,12 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED)
 		snprintf(detail, sizeof(detail),
-			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx",
+			"page:0x%lx offset:0x%lx grain:%d syndrome:0x%lx",
 			page_frame_number, offset_in_page,
 			grain, syndrome);
 	else
 		snprintf(detail, sizeof(detail),
-			"page 0x%lx offset 0x%lx grain %d",
+			"page:0x%lx offset:0x%lx grain:%d",
 			page_frame_number, offset_in_page, grain);
 
 	/* Report the error via the trace interface */

