Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2D3LZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab2D3LZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:25:06 -0400
Message-ID: <4F9E763E.2050808@redhat.com>
Date: Mon, 30 Apr 2012 08:23:42 -0300
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
        =?ISO-8859-1?Q?Niklas_S=F6d?= =?ISO-8859-1?Q?erlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ADCE3.2030506@redhat.com> <20120428091621.GE26065@aftab.osrc.amd.com> <4F9D4D55.9070705@redhat.com> <20120430075940.GC8182@aftab.osrc.amd.com>
In-Reply-To: <20120430075940.GC8182@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 04:59, Borislav Petkov escreveu:
> On Sun, Apr 29, 2012 at 11:16:53AM -0300, Mauro Carvalho Chehab wrote:
>>> Hey, are you looking at compiled code or at source code? Because I'm
>>> looking at source code, and it is a pretty safe bet the majority of the
>>> people here do that too.
>>
>> What I said is that, from source code POV, a code where the loop variables are
>> initialized just before the loop is easier to read it when the initialization
>> of those vars are on another part of the code.
>>
>> That's basically why the "for" syntax starts with a var initialization clause.
>>
>> The tot_dimms & friends are loop vars: their value is calculated within the loop.
>>
>> At the object code, this won't bring any difference.
>>
>>>
>>>> it, either by using registers for those vars or by moving the initialization
>>>> to the top of the function.
>>>>
>>>> This function is too complex, so it is better to initialize those vars
>>>> just before the loops that are calculating those totals.
>>>
>>> Simply initialize those variables at declaration time and that's it.
>>> Initializing them before the loop doesn't make the function less complex
>>> - splitting it and sanitizing it does.
>>
>> Initializing loop-calculated vars just before the loop makes the code easier
>> to read, and may avoid issues that might happen during code lifecycle.
> 
> This is getting ridiculous:

With this I fully agree: you're nacking patches because it is not the way you
write your code, not because the code there is doing anything wrong.

If you point anything wrong on the way I wrote, then I'll fix. Otherwise, why
should I do a change that will obfuscate the code?

> the variable declaration and initialization
> are on the same screen as the loop (unless one uses a screen which can
> only show less than 40ish lines).
> 
> So the argument about making the code easier to read is bogus.
> 
> This function is already cluttered with a lot of crap, and is very large
> so adding more lines which can simply be stashed away at declaration
> time is better readability.
> 
> Besides, every modern editor can jump to the declaration of a local
> variable so that the user can see to what it is initialized to.

The editor used by te developer is not relevant. This is not a reason
to obfuscate the code.

>> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
>> +                                    unsigned n_layers,
>> +                                    struct edac_mc_layer *layers,
>> +                                    bool rev_order,
>> +                                    unsigned sz_pvt)
>>  {
>>       void *ptr = NULL;
>>       struct mem_ctl_info *mci;
>> -     struct csrow_info *csi, *csrow;
>> +     struct edac_mc_layer *layer;
>> +     struct csrow_info *csi, *csr;
>>       struct rank_info *chi, *chp, *chan;
>>       struct dimm_info *dimm;
>> +     u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
>>       void *pvt;
>> -     unsigned size;
>> -     int row, chn;
>> +     unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
>> +     unsigned tot_csrows, tot_channels, tot_errcount = 0;
>> +     int i, j;
>>       int err;
>> +     int row, chn;
>> +     bool per_rank = false;
>> +
>> +     BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
>> +     /*
>> +      * Calculate the total amount of dimms and csrows/cschannels while
>> +      * in the old API emulation mode
>> +      */
>> +     tot_dimms = 1;
>> +     tot_channels = 1;
>> +     tot_csrows = 1;
>> +     for (i = 0; i < n_layers; i++) {
>> +             tot_dimms *= layers[i].size;
>> +             if (layers[i].is_virt_csrow)
>> +                     tot_csrows *= layers[i].size;
>> +             else
>> +                     tot_channels *= layers[i].size;
>> +
>> +             if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
>> +                     per_rank = true;

Regards,
Mauro

