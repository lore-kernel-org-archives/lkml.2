Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2DPLoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab2DPLow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:44:52 -0400
Message-ID: <4F8C0628.5020104@redhat.com>
Date: Mon, 16 Apr 2012 08:44:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] edac: Create a dimm struct and move the labels
 into it
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <1333039546-5590-2-git-send-email-mchehab@redhat.com> <20120330105048.GA30876@aftab> <4F8BDB3D.2020808@redhat.com> <20120416110222.GA308@aftab>
In-Reply-To: <20120416110222.GA308@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-04-2012 08:02, Borislav Petkov escreveu:
> On Mon, Apr 16, 2012 at 05:41:33AM -0300, Mauro Carvalho Chehab wrote:
>> This is not a double loop.
> 
> But it is, actually.
> 
> Let's look at the code:
> 
>         /* setup index and various internal pointers */
>         mci->mc_idx = edac_index;
>         mci->csrows = csi;
>         mci->dimms  = dimm;
>         mci->pvt_info = pvt;
>         mci->nr_csrows = nr_csrows;
> 
>         for (row = 0; row < nr_csrows; row++) {					<-- A1
>                 csrow = &csi[row];
>                 csrow->csrow_idx = row;
>                 csrow->mci = mci;
>                 csrow->nr_channels = nr_chans;
>                 chp = &chi[row * nr_chans];
>                 csrow->channels = chp;
> 
>                 for (chn = 0; chn < nr_chans; chn++) {				<-- B1
>                         chan = &chp[chn];
>                         chan->chan_idx = chn;
>                         chan->csrow = csrow;
>                 }
>         }
> 
>         /*
>          * By default, assumes that a per-csrow arrangement will be used,
>          * as most drivers are based on such assumption.
>          */
>         dimm = mci->dimms;
>         for (row = 0; row < mci->nr_csrows; row++) {				<-- A2
>                 for (chn = 0; chn < mci->csrows[row].nr_channels; chn++) {	<-- B2
>                         mci->csrows[row].channels[chn].dimm = dimm;
>                         dimm->csrow = row;
>                         dimm->csrow_channel = chn;
>                         dimm++;
>                         mci->nr_dimms++;
>                 }
>         }
> 
> So the lines tagged with A1 and A2 iterate over the nr_csrows, while
> lines tagged with B1 and B2 iterate over nr_chans. In B2, loop termination is
> 
> 	mci->csrows[row].nr_channels
> 
> which is assigned in the first loop above to
> 
> 	csrow->nr_channels = nr_chans
> 
> In B1, it is simply nr_chans.

Yes, this is true, on this patchset, because it is a preparation for a bigger
change, but this won't be true after changeset 5/13, where the dimm_info will
get a real life.

> 
> So how about we merge those two:
> 
> 	...
> 	dimm = mci->dimms;
> 
>         for (row = 0; row < nr_csrows; row++) {					<-- A1
>                 csrow = &csi[row];
>                 csrow->csrow_idx = row;
>                 csrow->mci = mci;
>                 csrow->nr_channels = nr_chans;
>                 chp = &chi[row * nr_chans];
>                 csrow->channels = chp;
> 
>                 for (chn = 0; chn < nr_chans; chn++) {				<-- B1
>                         chan = &chp[chn];
>                         chan->chan_idx = chn;
>                         chan->csrow = csrow;
> 
> 			 /* second loop */
>                         csrow->channels[chn].dimm = dimm;
>                         dimm->csrow = row;
>                         dimm->csrow_channel = chn;
>                         dimm++;
>                         mci->nr_dimms++;
>                 }
>         }
> 
> So it is only 5 lines of code instead of another loop.

Because this will make patch 5/13 even bigger and messy. Each of those
loops have different functions: the first one initializes the legacy API
data structures for virtual csrows/channels, while the second one 
initializes the struct that contains the real DIMM or rank information.

Patches 1 to 4 are just a preparation for patch 5/13, cleaning what's
possible before the big change.

While it is possible to do the above merge on this patch alone, such
cleanup doesn't make sense at the patch series (and should be reverted
on patch 5/13 anyway), as what we want is to separate the DIMM information 
on a data structure that won't mix it with a memory layout-dependent 
information, as not all drivers use csrows/channels.

Regards,
Mauro.


