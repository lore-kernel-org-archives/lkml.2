Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2EDKRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:17:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2EDKRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:17:07 -0400
Message-ID: <4FA3AC4B.9010804@redhat.com>
Date: Fri, 04 May 2012 07:15:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
        =?UTF-8?B?TmlrbGFzIFPDtmRlcmx1?= =?UTF-8?B?bmQ=?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <20120502133052.GE12914@aftab.osrc.amd.com> <4FA29356.3040601@redhat.com> <20120504095228.GA18459@aftab.osrc.amd.com>
In-Reply-To: <20120504095228.GA18459@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-05-2012 06:52, Borislav Petkov escreveu:
> On Thu, May 03, 2012 at 11:16:54AM -0300, Mauro Carvalho Chehab wrote:
>>>> +				    bool enable_filter,
>>>> +				    unsigned pos[EDAC_MAX_LAYERS])
>>>
>>> Passing the whole array as an argument instead of only a pointer to it?
>>
>> This is C, and not C++ or Pascal. Only the pointer is passed here. The size
>> of the array is used for type check only.
> 
> Right, and you can see where he still has trouble. And by "he" I mean me :).

:)
> 
> [ … ]
> 
>>>> +void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>>>> +			  struct mem_ctl_info *mci,
>>>> +			  const unsigned long page_frame_number,
>>>> +			  const unsigned long offset_in_page,
>>>> +			  const unsigned long syndrome,
>>>> +			  const int layer0,
>>>> +			  const int layer1,
>>>> +			  const int layer2,
>>>
>>> Instead of passing each layer as an arg, you can prepare the array pos[]
>>> in each edac_mc_hanlde_*() and pass around a pointer to it - you need it
>>> anyway in the edac_mc_inc*() functions.
>>
>> Yes, but the changes at the drivers will be more complex, without any reason:
>> before each call to this function, they would need to create and fill a temporary
>> array.
>>
>> As there are only 3 layers, in the worse case, this way is simpler and more
>> efficient. We can review it, if we ever need more than 3 layers.
> 
> I see, the edac_mc_handle_error is the main interface for all edac drivers, ok.
> 
> [ … ]
> 
>>>> +	bool enable_filter = false;
>>>
>>> What does this enable_filter thing mean:
>>>
>>> 	if (pos[i] >= 0)
>>> 		enable_filter = true;
>>>
>>> This absolutely needs explanation and better naming!
>>
>> Renamed it to "enable_per_layer_report".
> 
> Or "detailed_dimm_report" or ...

Detail is used on another context; "enable_per_layer_report" won't generate
any doubts for anyone reading the code.

>> The code that implement it seems self-explained: 
>>
>> ..
>> 		if (enable_filter && dimm->nr_pages) {
>> 			if (p != label) {
>> 				strcpy(p, OTHER_LABEL);
>> 				p += strlen(OTHER_LABEL);
>> 			}
>> 			strcpy(p, dimm->label);
>> 			p += strlen(p);
>> 			*p = '\0';
>>
>> ..
>>
>> 	if (!enable_filter) {
>> 		strcpy(label, "any memory");
>> 	} else {
>> 		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
>> 			__func__, row, chan);
>> 		if (p == label)
>> 			strcpy(label, "unknown memory");
>> 		if (type == HW_EVENT_ERR_CORRECTED) {
>> 			if (row >= 0) {
>> 				mci->csrows[row].ce_count++;
>> 				if (chan >= 0)
>> 					mci->csrows[row].channels[chan].ce_count++;
>> 			}
>> 		} else
>> 			if (row >= 0)
>> 				mci->csrows[row].ue_count++;
>> 	}
>>
>> Theis flag indicates if is there any useful information about the affected
>> DIMM(s) provided by the EDAC driver. If this is provided, the DIMM location labels are
>> filtered and reported, and the per-layer error counters are incremented.
>>
>> As it was discussed on previous reviews, with FB-DIMM MCs, and/or when mirror 
>> mode/lockstep mode is enabled, the memory controller points errors to 2 DIMMs 
>> (or 4 DIMMs, when both mirror mode and lockstep mode are enabled) on most memory
>> controllers, under some conditions. The edac_mc_handle_fbd_ue() function call were
>> created due to that.
>>
>> When comparing with the old code, "enable_filter = false" would be equivalent to call
>> edac_mc_handle_ce_no_info/edac_mc_handle_ue_no_info.
>>
>> I'm adding a comment about it.
> 
> Much better, thanks.
> 
> Btw, I have to admit, this is a pretty strange way of handling the case
> where layers are { -1, -1, -1 }, i.e. edac_mc_handle_error is called
> with the "no info" hint.

Well, negative values are used on Linux to indicate error conditions, so this is not
that strange. Also, it allows partial "no info", as, on some cases, a channel or
a csrow may not be known. So, this allows code simplification at the drivers. 

For example, look at this hunk on the amd64_edac conversion patch:

@@ -1585,16 +1609,10 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
        if (dct_ganging_enabled(pvt))
                chan = get_channel_from_ecc_syndrome(mci, syndrome);
 
-       if (chan >= 0)
-               edac_mc_handle_ce(mci, page, offset, syndrome, csrow, chan,
-                                 EDAC_MOD_STR);
-       else
-               /*
-                * Channel unknown, report all channels on this CSROW as failed.
-                */
-               for (chan = 0; chan < mci->csrows[csrow].nr_channels; chan++)
-                       edac_mc_handle_ce(mci, page, offset, syndrome,
-                                         csrow, chan, EDAC_MOD_STR);
+       edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+                               page, offset, syndrome,
+                               csrow, chan, -1,
+                               EDAC_MOD_STR, "", NULL);

There's no need anymore to check if chan is bigger than 0: if channel is invalid,
the edac_mc_handle_error() will get the DIMM labels for all channels, without needing
to do any loop inside the drivers.

> I'm wondering whether it wouldn't be more readable if you could do
> 
> 	edac_mc_handle_error(HW_EVENT_ERR_INFO_INVALID | ..)
> 
> or similar and define such a flag which simply states that. But you'll
> have to change enum hw_event_mc_err_type to a bitfield to allow more
> than one set bit.
> 
> Hmm.
> 
> 
> [ … ]
> 
>>> The SCRUB_SW_SRC piece can be another function.
>>
>> It is now part of the edac_ce_error().
> 
> Hm, I can't find this function on your "experimental" branch on
> infradead but it is mentioned in the inlined patch below, what's going
> on? Which patch should I be looking at now?

My fault. I forgot to update the push line for the "experimental" remote
at .git/config. I just updated it with the right branch.

The tree on Infradead should now point to the same patch I forwarded at the
ML.

> 
> [ … ]
> 
>> The following patch addresses the pointed issues. I've updated them
>> on my experimental branch at infradead:
>> 	git://git.infradead.org/users/mchehab/edac.git experimental
> 
> Ok, I checked this one out but can't find the edac_ce_error() function
> as already stated above, pls check.
> 
>> They'll also be soon available at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v18
> 
> Will review the patch below now and reply in another mail.

Thanks!
Mauro
