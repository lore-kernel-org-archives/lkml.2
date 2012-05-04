Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2EDJwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:52:41 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:57235 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2EDJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:52:39 -0400
Date: Fri, 4 May 2012 11:52:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120504095228.GA18459@aftab.osrc.amd.com>
References: <20120502133052.GE12914@aftab.osrc.amd.com>
 <4FA29356.3040601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA29356.3040601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 11:16:54AM -0300, Mauro Carvalho Chehab wrote:
> >> +				    bool enable_filter,
> >> +				    unsigned pos[EDAC_MAX_LAYERS])
> > 
> > Passing the whole array as an argument instead of only a pointer to it?
> 
> This is C, and not C++ or Pascal. Only the pointer is passed here. The size
> of the array is used for type check only.

Right, and you can see where he still has trouble. And by "he" I mean me :).

[ … ]

> >> +void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> >> +			  struct mem_ctl_info *mci,
> >> +			  const unsigned long page_frame_number,
> >> +			  const unsigned long offset_in_page,
> >> +			  const unsigned long syndrome,
> >> +			  const int layer0,
> >> +			  const int layer1,
> >> +			  const int layer2,
> > 
> > Instead of passing each layer as an arg, you can prepare the array pos[]
> > in each edac_mc_hanlde_*() and pass around a pointer to it - you need it
> > anyway in the edac_mc_inc*() functions.
> 
> Yes, but the changes at the drivers will be more complex, without any reason:
> before each call to this function, they would need to create and fill a temporary
> array.
> 
> As there are only 3 layers, in the worse case, this way is simpler and more
> efficient. We can review it, if we ever need more than 3 layers.

I see, the edac_mc_handle_error is the main interface for all edac drivers, ok.

[ … ]

> >> +	bool enable_filter = false;
> > 
> > What does this enable_filter thing mean:
> > 
> > 	if (pos[i] >= 0)
> > 		enable_filter = true;
> > 
> > This absolutely needs explanation and better naming!
> 
> Renamed it to "enable_per_layer_report".

Or "detailed_dimm_report" or ...

> The code that implement it seems self-explained: 
> 
> ..
> 		if (enable_filter && dimm->nr_pages) {
> 			if (p != label) {
> 				strcpy(p, OTHER_LABEL);
> 				p += strlen(OTHER_LABEL);
> 			}
> 			strcpy(p, dimm->label);
> 			p += strlen(p);
> 			*p = '\0';
> 
> ..
> 
> 	if (!enable_filter) {
> 		strcpy(label, "any memory");
> 	} else {
> 		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
> 			__func__, row, chan);
> 		if (p == label)
> 			strcpy(label, "unknown memory");
> 		if (type == HW_EVENT_ERR_CORRECTED) {
> 			if (row >= 0) {
> 				mci->csrows[row].ce_count++;
> 				if (chan >= 0)
> 					mci->csrows[row].channels[chan].ce_count++;
> 			}
> 		} else
> 			if (row >= 0)
> 				mci->csrows[row].ue_count++;
> 	}
> 
> Theis flag indicates if is there any useful information about the affected
> DIMM(s) provided by the EDAC driver. If this is provided, the DIMM location labels are
> filtered and reported, and the per-layer error counters are incremented.
> 
> As it was discussed on previous reviews, with FB-DIMM MCs, and/or when mirror 
> mode/lockstep mode is enabled, the memory controller points errors to 2 DIMMs 
> (or 4 DIMMs, when both mirror mode and lockstep mode are enabled) on most memory
> controllers, under some conditions. The edac_mc_handle_fbd_ue() function call were
> created due to that.
> 
> When comparing with the old code, "enable_filter = false" would be equivalent to call
> edac_mc_handle_ce_no_info/edac_mc_handle_ue_no_info.
> 
> I'm adding a comment about it.

Much better, thanks.

Btw, I have to admit, this is a pretty strange way of handling the case
where layers are { -1, -1, -1 }, i.e. edac_mc_handle_error is called
with the "no info" hint.

I'm wondering whether it wouldn't be more readable if you could do

	edac_mc_handle_error(HW_EVENT_ERR_INFO_INVALID | ..)

or similar and define such a flag which simply states that. But you'll
have to change enum hw_event_mc_err_type to a bitfield to allow more
than one set bit.

Hmm.


[ … ]

> > The SCRUB_SW_SRC piece can be another function.
> 
> It is now part of the edac_ce_error().

Hm, I can't find this function on your "experimental" branch on
infradead but it is mentioned in the inlined patch below, what's going
on? Which patch should I be looking at now?

[ … ]

> The following patch addresses the pointed issues. I've updated them
> on my experimental branch at infradead:
> 	git://git.infradead.org/users/mchehab/edac.git experimental

Ok, I checked this one out but can't find the edac_ce_error() function
as already stated above, pls check.

> They'll also be soon available at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v18

Will review the patch below now and reply in another mail.

Thanks.

> 
> Regards,
> Mauro
> 
> -
> 
> edac: Change internal representation to work with layers
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Change the EDAC internal representation to work with non-csrow
> based memory controllers.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
