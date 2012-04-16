Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2DPNcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:32:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34834 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2DPNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:32:07 -0400
Date: Mon, 16 Apr 2012 15:31:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] edac: move dimm properties to struct memset_info
Message-ID: <20120416133153.GC308@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-3-git-send-email-mchehab@redhat.com>
 <20120330170305.GG30876@aftab>
 <4F8BDECE.50801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8BDECE.50801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:56:46AM -0300, Mauro Carvalho Chehab wrote:
> >> @@ -2202,7 +2204,21 @@ static int init_csrows(struct mem_ctl_info *mci)
> >>  		csrow->page_mask = ~mask;
> >>  		/* 8 bytes of resolution */
> >>  
> >> -		csrow->mtype = amd64_determine_memory_type(pvt, i);
> >> +		mtype = amd64_determine_memory_type(pvt, i);
> >> +
> >> +		/*
> >> +		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
> >> +		 */
> >> +		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
> >> +			edac_mode = (pvt->nbcfg & NBCFG_CHIPKILL) ?
> >> +				    EDAC_S4ECD4ED : EDAC_SECDED;
> >> +		else
> >> +			edac_mode = EDAC_NONE;
> >> +
> >> +		for (j = 0; j < pvt->channel_count; j++) {
> >> +			csrow->channels[j].dimm->mtype = mtype;
> >> +			csrow->channels[j].dimm->edac_mode = edac_mode;
> >> +		}
> >>  
> >>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
> >>  		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
> >> @@ -2214,16 +2230,6 @@ static int init_csrows(struct mem_ctl_info *mci)
> >>  			"last_page: 0x%lx\n",
> >>  			(unsigned)csrow->nr_pages,
> >>  			csrow->first_page, csrow->last_page);
> >> -
> >> -		/*
> >> -		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
> >> -		 */
> >> -		if (pvt->nbcfg & NBCFG_ECC_ENABLE)
> >> -			csrow->edac_mode =
> >> -			    (pvt->nbcfg & NBCFG_CHIPKILL) ?
> >> -			    EDAC_S4ECD4ED : EDAC_SECDED;
> >> -		else
> >> -			csrow->edac_mode = EDAC_NONE;
> > 
> > This looks like a useless code movement, please leave it where it is
> > now and add the for-loop after it instead of pulling it up and causing
> > needless churn.
> 
> This is needed, as now mtype/edac_mode is per DIMM, and not per channel.
> In the specific case of amd64 (and all per-csrow/channel memory controllers),
> all channels use the same mtype/edac_mode, but this is not true for other
> memory controllers.
> 
> So, what the logic there does is to first retrieve the mtype/edac_mode, and
> then fill it for each dimm struct (the for loop).

I can see that. But you don't have to move it anywhere, simply add the

	for (j = 0; j < pvt->channel_count; j++) {
		...

loop after the debugf1() calls and this way the patch has a smaller
changes net count and it is easier to review.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
