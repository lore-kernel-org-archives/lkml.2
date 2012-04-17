Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2DQVkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:40:45 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44045 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2DQVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:40:44 -0400
Date: Tue, 17 Apr 2012 23:40:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [EDAC PATCH v13 4/7] edac: move nr_pages to dimm struct
Message-ID: <20120417214027.GB15397@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-5-git-send-email-mchehab@redhat.com>
 <20120417184808.GD13989@aftab>
 <4F8DC471.3050809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8DC471.3050809@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 04:28:49PM -0300, Mauro Carvalho Chehab wrote:
> Ok. well, we can either multiply nr_pages by channel_count or to let it
> clear that this is per channel. I prefer the last option (see the enclosed
> patch).
> 
> >> @@ -2152,6 +2146,7 @@ static int init_csrows(struct mem_ctl_info *mci)
> >>  	int i, j, empty = 1;
> >>  	enum mem_type mtype;
> >>  	enum edac_type edac_mode;
> >> +	int nr_pages;
> >>  
> >>  	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
> >>  
> >> @@ -2174,14 +2169,14 @@ static int init_csrows(struct mem_ctl_info *mci)
> >>  			i, pvt->mc_node_id);
> >>  
> >>  		empty = 0;
> >> -		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
> >> +		nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
> >>  		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
> >>  		/* 8 bytes of resolution */
> >>  
> >>  		mtype = amd64_determine_memory_type(pvt, i);
> >>  
> >>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
> >> -		debugf1("    nr_pages: %u\n", csrow->nr_pages);
> >> +		debugf1("    nr_pages: %u\n", nr_pages);
> >>  
> >>  		/*
> >>  		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
> >> @@ -2195,6 +2190,7 @@ static int init_csrows(struct mem_ctl_info *mci)
> >>  		for (j = 0; j < pvt->channel_count; j++) {
> >>  			csrow->channels[j].dimm->mtype = mtype;
> >>  			csrow->channels[j].dimm->edac_mode = edac_mode;
> >> +			csrow->channels[j].dimm->nr_pages = nr_pages;
> > 
> > I'm guessing you want to accumulate the nr_pages for all channels here
> > and dump it properly?
> > 
> 
> As you've requested to not move the debugf0() to be after the loop, it is
> easier to just multiply it at the printk. As an advantage, when the kernel
> is compiled without debug, no code will be produced.
> 
> IMO, the best way to solve it is with this small patch. If you're ok, I'll
> fold it with this one and add your ack.
> 
> Regards,
> Mauro
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 8804ac8..6d6ec68 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2127,7 +2127,7 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
>  	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
>  
>  	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
> -	debugf0("    nr_pages= %u  channel-count = %d\n",
> +	debugf0("    nr_pages/channel= %u  channel-count = %d\n",
>  		nr_pages, pvt->channel_count);
>  
>  	return nr_pages;
> @@ -2176,7 +2176,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  		mtype = amd64_determine_memory_type(pvt, i);
>  
>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
> -		debugf1("    nr_pages: %u\n", nr_pages);
> +		debugf1("    nr_pages: %u\n", nr_pages * pvt->channel_count);
>  
>  		/*
>  		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating

Yeah, this is basically what the code did anyway, so yes, please fold it
in and you can add my ACK. I'll continue reviewing the rest tomorrow.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
