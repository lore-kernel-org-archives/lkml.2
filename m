Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936807Ab0COVht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:37:49 -0400
Received: from mail.vyatta.com ([76.74.103.46]:33940 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab0COVhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:37:46 -0400
Date: Mon, 15 Mar 2010 14:36:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       roger.oksanen@cs.helsinki.fi
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
Message-ID: <20100315143653.294c0650@nehalam>
In-Reply-To: <20100315.143225.212581877.davem@davemloft.net>
References: <20100105195007.GA23952@kroah.com>
	<20100105200301.449062585@mini.kroah.org>
	<20100315142953.7aae4395@nehalam>
	<20100315.143225.212581877.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 14:32:25 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Mon, 15 Mar 2010 14:29:53 -0700
> 
> > On Tue, 05 Jan 2010 12:02:15 -0800
> > Greg KH <gregkh@suse.de> wrote:
> > 
> >> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> >> 
> >> ------------------
> >> 
> >> From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> >> 
> >> commit 98468efddb101f8a29af974101c17ba513b07be1 upstream.
> >> 
> >> pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some systems
> >> with limited memory (Bug #14265). pci_pool_alloc allows waiting with
> >> GFP_KERNEL.
> >> 
> >> Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
> >> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> >> Signed-off-by: David S. Miller <davem@davemloft.net>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > 
> > These two e100 patches in 2.6.31.10 (and 2.6.32) caused kernel panic on one customer
> > system. I recommend they be reverted in next --stable update.
> 
> There was a subsequent fix that explicitly zeros out the memory.
> The problem was that whilst pci_alloc_consistent() zeros out
> the memory it returns, the pci pool stuff does not.
> 
> So please get that fix sent to -stable instead of the revert.
> For reference:
> 
> commit 70abc8cb90e679d8519721e2761d8366a18212a6
> Author: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
> Date:   Fri Dec 18 20:18:21 2009 -0800
> 
>     e100: Fix broken cbs accounting due to missing memset.
>     
>     Alan Stern noticed that e100 caused slab corruption.
>     commit 98468efddb101f8a29af974101c17ba513b07be1 changed
>     the allocation of cbs to use dma pools that don't return zeroed memory,
>     especially the cb->status field used to track which cb to clean, causing
>     (the visible) double freeing of skbs and a wrong free cbs count.
>     
>     Now the cbs are explicitly zeroed at allocation time.
>     
>     Reported-by: Alan Stern <stern@rowland.harvard.edu>
>     Tested-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
>     Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

The kernel has both fixes in it. The customer reported that if both
were reverted, the kernel panic went away.


commit 1bfc1db036675e61af0ea34d3ac18206de566b64
Author: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Date:   Fri Dec 18 20:18:21 2009 -0800

    e100: Fix broken cbs accounting due to missing memset.
    
    commit 70abc8cb90e679d8519721e2761d8366a18212a6 upstream.
    
    Alan Stern noticed that e100 caused slab corruption.
    commit 98468efddb101f8a29af974101c17ba513b07be1 changed
    the allocation of cbs to use dma pools that don't return zeroed memory,
    especially the cb->status field used to track which cb to clean, causing
    (the visible) double freeing of skbs and a wrong free cbs count.
    
    Now the cbs are explicitly zeroed at allocation time.
    
    Reported-by: Alan Stern <stern@rowland.harvard.edu>
    Tested-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
    Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 550b1d3896894543cc13dafe6910119024177482
Author: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Date:   Sun Nov 29 17:17:29 2009 -0800

    e100: Use pci pool to work around GFP_ATOMIC order 5 memory allocation failu
    
    commit 98468efddb101f8a29af974101c17ba513b07be1 upstream.
    
    pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some system
    with limited memory (Bug #14265). pci_pool_alloc allows waiting with
    GFP_KERNEL.
    
    Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
    Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


