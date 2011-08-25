Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1HYR0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:26:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:7628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab1HYR0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:26:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="42241531"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
	 <1314282386.1606.42.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
	 <1314283286.1606.52.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 22:50:50 +0530
Message-ID: <1314292850.1606.88.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 16:55 +0200, Guennadi Liakhovetski wrote:
> On Thu, 25 Aug 2011, Koul, Vinod wrote:
> 
> > On Thu, 2011-08-25 at 16:37 +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 25 Aug 2011, Koul, Vinod wrote:
> > > 
> > > > On Thu, 2011-08-18 at 16:55 +0200, Guennadi Liakhovetski wrote:
> > > > > Currently the shdma dmaengine driver uses runtime PM to save power, when
> > > > > no channel on the specific controller is requested by a user. This patch
> > > > > switches the driver to count individual DMA transfers. That way the
> > > > > controller can be powered down between transfers, even if some of its
> > > > > channels are in use.
> > > > No, I don't agree with the approach here, you don't need to count the
> > > > transfers, the runtime_pm framework does that very well for you.
> > > > 
> > > > What you need to do is to call pm_runtime_get() in your .issue_pending
> > > > callback (NOT in tx_submit anyway, this needs to be fixed in driver, see
> > > > the Documentation/dmaengine.txt
> > > > And once the transfer has completed you need to call pm_rumtime_put()
> > > 
> > > This has been discussed before:
> > > 
> > > http://marc.info/?l=linux-sh&m=131004613801231&w=2
> > uh, yes but at least the runtime_xxx needs to get fixed.
> 
> This isn't so easy either. In principle, yes, I know, that pm_runtime_* 
> calls count depth. But I don't think the DMA case is simple enough for 
> that. It's not necessarily one in - one out. Think about terminating 
> transfers, timing out, closing the channel, etc. In those cases you'd have 
> to count pending transfers and pm_runtime_put() for each of them. This is 
> even less trivial on shdma, where DMA transfers get split into sg-lists, 
> which are then all queued on a single queue. So, you'd have to scan that 
> queue and check for transfer borders... That's why I decided that doing 
> just one get() on the first descriptor and one put() on the last one would 
> be easier and more robust.
Wont it be easy to to do:
- pm_runtime_get() in each submit
- pm_runtime_put() in each callback
Normal case above would work just fine
- In terminate case, count the number of issued transactions, and call
pm_runtime_put() for each canceled transaction
(i am assuming that for each timeout error, the client will call
terminate)

Let me know if there is a case for you which doesn't fit in above

-- 
~Vinod

