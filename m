Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1H2MNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:13:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:31408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab1H2MM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:12:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43238509"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
	 <1314282386.1606.42.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
	 <1314283286.1606.52.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
	 <1314292850.1606.88.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 17:41:49 +0530
Message-ID: <1314619909.1606.130.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 01:11 +0200, Guennadi Liakhovetski wrote:
> On Thu, 25 Aug 2011, Koul, Vinod wrote:
> > Wont it be easy to to do:
> > - pm_runtime_get() in each submit
> > - pm_runtime_put() in each callback
> > Normal case above would work just fine
> > - In terminate case, count the number of issued transactions, and call
> > pm_runtime_put() for each canceled transaction
> > (i am assuming that for each timeout error, the client will call
> > terminate)
> 
> As I said, this won't be very easy to do this in a robust way. You'd have 
> to scan your list of DMA blocks and see, which of them belong to one 
> descriptor, and once you reach the end of that descriptor, issue a put(). 
> Perhaps, this can be done, but my choice went to the currently presented 
> solution.
If you count the number of descriptor submitted in your submitted list
and call _put for each, I see no reason why it wont be simple and better
than current approach.

Something like:
/* since callback is set for last descriptor of chain, we call runtime
 * put for that desc alone
 */
list_for_each_entry_safe(desc, __desc, sh_chan->ld_queue, node) {
	if (desc->async_tx.callback)
		pm_runtime_put(device);

If i read shdma correctly, descriptors are put into ld_queue of channel
and any pending should be checked in this list alone.
For normal case again you check for the callback to decide if you need
to call pm_runtime_put() or not.

--
~Vinod

