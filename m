Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2D3Mvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:51:33 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40095 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2D3Mvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:51:31 -0400
Date: Mon, 30 Apr 2012 14:51:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
Message-ID: <20120430125122.GG9303@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
 <20120427133304.GE9626@aftab.osrc.amd.com>
 <4F9ADCE3.2030506@redhat.com>
 <20120428091621.GE26065@aftab.osrc.amd.com>
 <4F9D4D55.9070705@redhat.com>
 <20120430075940.GC8182@aftab.osrc.amd.com>
 <4F9E763E.2050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E763E.2050808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:23:42AM -0300, Mauro Carvalho Chehab wrote:
> With this I fully agree: you're nacking patches because it is not the way you

Where? Have I written Nacked-by somewhere?

> write your code, not because the code there is doing anything wrong.
> 
> If you point anything wrong on the way I wrote, then I'll fix. Otherwise, why
> should I do a change that will obfuscate the code?

What obfuscation are you talking about? Having the initialization of
variables along with their declaration is not it.

Now let's look what you're doing:

> >> +     unsigned tot_csrows, tot_channels, tot_errcount = 0;
> >> +     unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];

just to reassign 1 to some of them

> >> +     tot_dimms = 1;
> >> +     tot_channels = 1;
> >> +     tot_csrows = 1;

a couple of lines below.

Now this is misleading.

Now let's look at what I'm proposing

	unsigned tot_dimms = 1;
	unsigned tot_csrows = 1;
	unsigned tot_channels = 1;

How is this an obfuscation? It is basic code layout practices.

> The editor used by te developer is not relevant. This is not a reason
> to obfuscate the code.
> 
> >> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> >> +                                    unsigned n_layers,
> >> +                                    struct edac_mc_layer *layers,
> >> +                                    bool rev_order,
> >> +                                    unsigned sz_pvt)
> >>  {
> >>       void *ptr = NULL;
> >>       struct mem_ctl_info *mci;
> >> -     struct csrow_info *csi, *csrow;
> >> +     struct edac_mc_layer *layer;
> >> +     struct csrow_info *csi, *csr;
> >>       struct rank_info *chi, *chp, *chan;
> >>       struct dimm_info *dimm;
> >> +     u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
> >>       void *pvt;
> >> -     unsigned size;
> >> -     int row, chn;
> >> +     unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
> >> +     unsigned tot_csrows, tot_channels, tot_errcount = 0;
> >> +     int i, j;
> >>       int err;
> >> +     int row, chn;
> >> +     bool per_rank = false;
> >> +
> >> +     BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
> >> +     /*
> >> +      * Calculate the total amount of dimms and csrows/cschannels while
> >> +      * in the old API emulation mode
> >> +      */
> >> +     tot_dimms = 1;
> >> +     tot_channels = 1;
> >> +     tot_csrows = 1;
> >> +     for (i = 0; i < n_layers; i++) {
> >> +             tot_dimms *= layers[i].size;
> >> +             if (layers[i].is_virt_csrow)
> >> +                     tot_csrows *= layers[i].size;
> >> +             else
> >> +                     tot_channels *= layers[i].size;
> >> +
> >> +             if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
> >> +                     per_rank = true;

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
