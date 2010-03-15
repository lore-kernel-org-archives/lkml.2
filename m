Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0COVcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:32:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35811
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373Ab0COVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:32:04 -0400
Date: Mon, 15 Mar 2010 14:32:25 -0700 (PDT)
Message-Id: <20100315.143225.212581877.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       roger.oksanen@cs.helsinki.fi
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100315142953.7aae4395@nehalam>
References: <20100105195007.GA23952@kroah.com>
	<20100105200301.449062585@mini.kroah.org>
	<20100315142953.7aae4395@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 15 Mar 2010 14:29:53 -0700

> On Tue, 05 Jan 2010 12:02:15 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
>> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
>> 
>> ------------------
>> 
>> From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
>> 
>> commit 98468efddb101f8a29af974101c17ba513b07be1 upstream.
>> 
>> pci_alloc_consistent uses GFP_ATOMIC allocation that may fail on some systems
>> with limited memory (Bug #14265). pci_pool_alloc allows waiting with
>> GFP_KERNEL.
>> 
>> Tested-by: Karol Lewandowski <karol.k.lewandowski@gmail.com>
>> Signed-off-by: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> 
> These two e100 patches in 2.6.31.10 (and 2.6.32) caused kernel panic on one customer
> system. I recommend they be reverted in next --stable update.

There was a subsequent fix that explicitly zeros out the memory.
The problem was that whilst pci_alloc_consistent() zeros out
the memory it returns, the pci pool stuff does not.

So please get that fix sent to -stable instead of the revert.
For reference:

commit 70abc8cb90e679d8519721e2761d8366a18212a6
Author: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
Date:   Fri Dec 18 20:18:21 2009 -0800

    e100: Fix broken cbs accounting due to missing memset.
    
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

