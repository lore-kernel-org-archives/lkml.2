Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2DRRRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:17:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58077 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751083Ab2DRRRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:17:47 -0400
Message-ID: <1334697467.3920.5.camel@joe2Laptop>
Subject: Re: [EDAC ABI v13 24/25] edac: change the mem allocation scheme to
 make Documentation/kobject.txt happy
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
In-Reply-To: <1334608729-30803-25-git-send-email-mchehab@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
	 <1334608729-30803-25-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 15:17:47 -0600
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 17:38 -0300, Mauro Carvalho Chehab wrote:
> Kernel kobjects have rigid rules: each container object should be
> dynamically allocated, and can't be allocated into a single kmalloc.
> 
> EDAC never obeyed this rule: it has a single malloc function that
> allocates all needed data into a single kzalloc.
> 
> As this is not accepted anymore, change the allocation schema of the
> EDAC *_info structs to enforce this Kernel standard.
[]
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
[]
> @@ -2228,9 +2228,9 @@ static int init_csrows(struct mem_ctl_info *mci)
>  			edac_mode = EDAC_NONE;
>  
>  		for (j = 0; j < pvt->channel_count; j++) {
> -			csrow->channels[j].dimm->mtype = mtype;
> -			csrow->channels[j].dimm->edac_mode = edac_mode;
> -			csrow->channels[j].dimm->nr_pages = nr_pages;
> +			csrow->channels[j]->dimm->mtype = mtype;
> +			csrow->channels[j]->dimm->edac_mode = edac_mode;
> +			csrow->channels[j]->dimm->nr_pages = nr_pages;

It might be better to use an automatic for
	typeof foo dimm = csrow->channels[j]->dimm;
	dimm->mtype = mtype;
	etc...
[]
> @@ -293,39 +286,56 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>  	mci->mem_is_per_rank = per_rank;
>  
>  	/*
> -	 * Fills the csrow struct
> +	 * Alocate and fill the csrow/channels structs
>  	 */
> +	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);

kcalloc

[]
> +		csr->channels = kzalloc(sizeof(*csr->channels) * tot_cschannels,
> +					GFP_KERNEL);

here too

> @@ -391,7 +401,31 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>  
>  	trace_hw_event_init("edac", (unsigned)edac_index);
>  
> +	debugf1("EDAC MCI allocated\n");
>  	return mci;
> +
> +error:
> +	debugf1("Failed to allocate one or more EDAC MCI structs\n");

Generally, it's not necessary to have specific "OOM" messages
as allocations without GFP_NOWARN do dump_stack()s


