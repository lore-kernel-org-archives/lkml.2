Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2DZO73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab2DZO72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:59:28 -0400
Message-ID: <4F9962C0.7080204@redhat.com>
Date: Thu, 26 Apr 2012 11:59:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com> <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com> <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com> <4F96E1EB.1030407@redhat.com> <20120425171904.GM18882@aftab.osrc.amd.com> <4F9838BB.5010209@redhat.com> <20120426141149.GC28653@aftab.osrc.amd.com> <4F995ACA.2010701@redhat.com>
In-Reply-To: <4F995ACA.2010701@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-04-2012 11:25, Mauro Carvalho Chehab escreveu:
> Em 26-04-2012 11:11, Borislav Petkov escreveu:
>> On Wed, Apr 25, 2012 at 02:47:39PM -0300, Mauro Carvalho Chehab wrote:
>>>> Now let's look at your output from earlier:
>>>>
>>>>> $ ./edac-ctl --layout
>>>>>        +-----------------------------------+
>>>>>        |                mc0                |
>>>>>        | channel0  | channel1  | channel2  |
>>>>> -------+-----------------------------------+
>>>>> slot2: |     0 MB  |     0 MB  |     0 MB  |
>>>>> slot1: |  1024 MB  |     0 MB  |     0 MB  |
>>>>> slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
>>>>> -------+-----------------------------------+
>>>>>
>>>>> Those are the logs that dump the Memory Controller registers:
>>>>>
>>>>> [  115.818947] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 2 ranks, UDIMMs
>>>>
>>>> it says here 2 ranks
>>>
>>> The above output is for the Nehalem machine, with 4 dimms, all single ranked.
>>>
>>>>> [  115.818950] EDAC DEBUG: get_dimm_config:   dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
>>>>> [  115.818955] EDAC DEBUG: get_dimm_config:   dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400
>>>>> [  115.818982] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f4031): 2 ranks, UDIMMs
>>>>
>>>> and here 2 too although there's only one single-ranked DIMM here. So
>>>> which is it?
>>>
>>> The # of ranks there is the total amount of ranks at the channel.
>>
>> The total amount of ranks what? The channel supports, are present on the
>> channel, the number of physical slots?
>>
>> I'm just saying it is puzzling because your output says "2 ranks" whent
>> there are 2 single-ranked DIMMs connected to ch0 and also "2 ranks" when
>> there's only one DIMM connected to ch1.
> 
> Ah, ok, now I understood what you meant: yeah, channel 1 and 2 also says
> that there are two ranks.
> 
> I'll double check what's happening there.
> 

This were due to the way the driver reports that this channel doesn't
have any 4 Rank memories (e. g. all memories are either 1R or 2R).

The enclosed patch should improve the debug output information.

Thanks for pointing it,
Mauro

---

From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 26 Apr 2012 11:47:29 -0300
Subject: [PATCH] i7core: fix ranks information at the per-channel struct

There is a flag at the per-channel struct that indicates if there are
any 4R dimm on it. The way the presence of this flag were reported
is not ok, as it might give the false idea that the channel were filled
with 2R memories:

[  580.588701] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f7431): 2 ranks, UDIMMs
[  580.588704] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400

(in this case, just one 1R memory is filled on channel 1)

So, use a better way to represent the per-channel ranks information.
After the patch, it will show:

[ 2002.233978] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f7431): UDIMMs
[ 2002.233982] EDAC DEBUG: get_dimm_config: 	dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
[ 2002.233988] EDAC DEBUG: get_dimm_config: 	dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400

(in this case, there isn't any 4R memories)

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index dfdee48..f4a0fe1 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -221,7 +221,9 @@ struct i7core_inject {
 };
 
 struct i7core_channel {
-	u32		ranks;
+	bool		is_3dimms_present;
+	bool		is_single_4rank;
+	bool		has_4rank;
 	u32		dimms;
 };
 
@@ -557,21 +559,20 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 		pci_read_config_dword(pvt->pci_ch[i][0],
 				MC_CHANNEL_DIMM_INIT_PARAMS, &data);
 
-		pvt->channel[i].ranks = (data & QUAD_RANK_PRESENT) ?
-						4 : 2;
+
+		if (data & THREE_DIMMS_PRESENT)
+			pvt->channel[i].is_3dimms_present = true;
+
+		if (data & SINGLE_QUAD_RANK_PRESENT)
+			pvt->channel[i].is_single_4rank = true;
+
+		if (data & QUAD_RANK_PRESENT)
+			pvt->channel[i].has_4rank = true;
 
 		if (data & REGISTERED_DIMM)
 			mtype = MEM_RDDR3;
 		else
 			mtype = MEM_DDR3;
-#if 0
-		if (data & THREE_DIMMS_PRESENT)
-			pvt->channel[i].dimms = 3;
-		else if (data & SINGLE_QUAD_RANK_PRESENT)
-			pvt->channel[i].dimms = 1;
-		else
-			pvt->channel[i].dimms = 2;
-#endif
 
 		/* Devices 4-6 function 1 */
 		pci_read_config_dword(pvt->pci_ch[i][1],
@@ -582,11 +583,13 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				MC_DOD_CH_DIMM2, &dimm_dod[2]);
 
 		debugf0("Ch%d phy rd%d, wr%d (0x%08x): "
-			"%d ranks, %cDIMMs\n",
+			"%s%s%s%cDIMMs\n",
 			i,
 			RDLCH(pvt->info.ch_map, i), WRLCH(pvt->info.ch_map, i),
 			data,
-			pvt->channel[i].ranks,
+			pvt->channel[i].is_3dimms_present ? "3DIMMS " : "",
+			pvt->channel[i].is_3dimms_present ? "SINGLE_4R " : "",
+			pvt->channel[i].has_4rank ? "HAS_4R " : "",
 			(data & REGISTERED_DIMM) ? 'R' : 'U');
 
 		for (j = 0; j < 3; j++) {
