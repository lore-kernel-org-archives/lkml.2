Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2JEIiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2JEIiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:38:17 -0400
Date: Fri, 5 Oct 2012 10:37:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-wireless@vger.kernel.org,
        johannes.berg@intel.com, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
Message-ID: <20121005083659.GA2819@redhat.com>
References: <20120909213228.GA5538@elf.ucw.cz>
 <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com>
 <20120910111113.GA25159@elf.ucw.cz>
 <20120911162536.bd5171a1.akpm@linux-foundation.org>
 <20120912101826.GL11266@suse.de>
 <20121003113659.GD2259@redhat.com>
 <alpine.DEB.2.00.1210031104120.29765@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210031104120.29765@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:07:13AM -0700, David Rientjes wrote:
> On Wed, 3 Oct 2012, Stanislaw Gruszka wrote:
> 
> > So, can this problem be solved like on below patch, or I should rather
> > split firmware loading into chunks similar like was already iwlwifi did?

Hmm, I looked at iwl3945 code and looks loading firmware in chunks is
nothing that can be easily done. 3945 bootstrap code expect that runtime
ucode will be placed in physically continue memory, and there are no
separate instructions for copy and for execute, just one to perform both
those actions. Maybe loading firmware in chunks can be done using
undocumented features of the device, but I'm eager to do this.

> > diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
> > index 5f50177..1b58222 100644
> > --- a/drivers/net/wireless/iwlegacy/common.h
> > +++ b/drivers/net/wireless/iwlegacy/common.h
> > @@ -2247,7 +2247,7 @@ il_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
> >  
> >  	desc->v_addr =
> >  	    dma_alloc_coherent(&pci_dev->dev, desc->len, &desc->p_addr,
> > -			       GFP_KERNEL);
> > +			       GFP_KERNEL | __GFP_REPEAT);
> >  	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
> >  }
> >  
> 
> I think this will certainly make memory compaction more aggressive by 
> avoiding the logic to defer calling compaction in the page allocator, but 
> because we lack lumpy reclaim this still has a higher probability of 
> failing than it had in the past because it will fail if 128KB of memory is 
> reclaimed that may not happen to be contiguous for an order-5 allocation 
> to succeed.

I understand that complex systems like virtual memory manager require
various design compromises. In this case decision was to make memory
allocator to perform faster in cost of possible allocation failures.
I'm not quite sure if that was good decision, but I think VM developers
know best what is good for VM.

However, maybe this allocation issue initially reported here, was
caused by some bug, which is possibly now fixed i.e. memory leak on
some driver or subsystem. 

Pavel, do you still can reproduce this problem on released 3.6 ? 

Thanks
Stanislaw
