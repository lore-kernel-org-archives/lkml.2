Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1H2MVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:21:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1H2MVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:21:13 -0400
Date: Mon, 29 Aug 2011 14:21:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
In-Reply-To: <1314619909.1606.130.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange> 
 <1314282386.1606.42.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
  <1314283286.1606.52.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
  <1314292850.1606.88.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
 <1314619909.1606.130.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:3HNH4DUeZTBdLla2dZdDjHG5id3F7pvqrnvWPbHN2GZ
 G+me/Xqt9SauE/plt09j90vXcYSvFjp44HmTeTvgXBnH6JX4NU
 ZBojLZMfuD6iSZ5WmJIBig2F7/a6t+Vfc35xMa2PrnPPDIyALW
 Qq5gkRQJkTxSxlLlxb/AkiQBizT6x9W9x0O94IQZ7OhvlGUYd+
 wH0DoWlcMQgqJiTDc5x23Nu2Ihl/Ofx6ogIJ3wEn5g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Vinod Koul wrote:

> On Fri, 2011-08-26 at 01:11 +0200, Guennadi Liakhovetski wrote:
> > On Thu, 25 Aug 2011, Koul, Vinod wrote:
> > > Wont it be easy to to do:
> > > - pm_runtime_get() in each submit
> > > - pm_runtime_put() in each callback
> > > Normal case above would work just fine
> > > - In terminate case, count the number of issued transactions, and call
> > > pm_runtime_put() for each canceled transaction
> > > (i am assuming that for each timeout error, the client will call
> > > terminate)
> > 
> > As I said, this won't be very easy to do this in a robust way. You'd have 
> > to scan your list of DMA blocks and see, which of them belong to one 
> > descriptor, and once you reach the end of that descriptor, issue a put(). 
> > Perhaps, this can be done, but my choice went to the currently presented 
> > solution.
> If you count the number of descriptor submitted in your submitted list
> and call _put for each, I see no reason why it wont be simple and better
> than current approach.

Sorry, I thought, you wanted to avoid extra counting, because runtime-pm 
counts by itself. Now you propose to count...

> Something like:
> /* since callback is set for last descriptor of chain, we call runtime
>  * put for that desc alone
>  */
> list_for_each_entry_safe(desc, __desc, sh_chan->ld_queue, node) {
> 	if (desc->async_tx.callback)
> 		pm_runtime_put(device);

Not all dma users have callbacks.

> If i read shdma correctly, descriptors are put into ld_queue of channel
> and any pending should be checked in this list alone.
> For normal case again you check for the callback to decide if you need
> to call pm_runtime_put() or not.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
