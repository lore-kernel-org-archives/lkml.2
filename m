Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2DTLWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:22:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50211 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544Ab2DTLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:22:17 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432N98dK179dNzz1202hzz15d4R8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2RZKU-02-5Z4-02
X-M-MSG: 
Date: Fri, 20 Apr 2012 13:22:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Roland Dreier <roland@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma-debug: Fix deadlock with netconsole or other drivers
 that use the DMA API
Message-ID: <20120420112206.GB12667@amd.com>
References: <1334859173-9446-1-git-send-email-roland@kernel.org>
 <20120419114811.9e77accb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120419114811.9e77accb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:48:11AM -0700, Andrew Morton wrote:
> On Thu, 19 Apr 2012 11:12:53 -0700
> Roland Dreier <roland@kernel.org> wrote:
> > ---
> >  lib/dma-debug.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> > index 13ef233..f198b4e 100644
> > --- a/lib/dma-debug.c
> > +++ b/lib/dma-debug.c
> > @@ -436,8 +436,8 @@ static struct dma_debug_entry *dma_entry_alloc(void)
> >  	spin_lock_irqsave(&free_entries_lock, flags);
> >  
> >  	if (list_empty(&free_entries)) {
> > -		pr_err("DMA-API: debugging out of memory - disabling\n");
> >  		global_disable = true;
> > +		pr_err("DMA-API: debugging out of memory - disabling\n");
> >  		goto out;
> >  	}
> 
> So *any* printk can deadlock if free_entries_lock is held and
> global_disable==false?
> 
> In that case we're going to need much sterner fixes.  Any list_head
> operation can do a printk if list_head debugging is enabled. 
> dma_debug_resize_entries() does a kfree() under free_entries_lock(!).
> 
> Methinks we need a more general fix?

Hmm, I think the best way to fix it is to switch the hash-bucket lists
to rcu. Then the lock is only needed in hash_bucket_add/del and we
should be fine.
But that is probably only a fix for the next merge window.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

