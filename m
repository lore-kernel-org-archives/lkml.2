Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1HYXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:11:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1HYXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:11:18 -0400
Date: Fri, 26 Aug 2011 01:11:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
In-Reply-To: <1314292850.1606.88.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange> 
 <1314282386.1606.42.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
  <1314283286.1606.52.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
 <1314292850.1606.88.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:KCjiKRzRSi6EP1glH7CflRmtkpqnhTBP/28Ra84XDCG
 V6tkGNmYMSMK7hDFTKVwPAWpu7sIvRyVFi61/gN/ddraPjIOMv
 FrHJsAmb50j94AD1VbsSY92+QeEJxpCHx16EHue0qanWOtVAmp
 f7Pw6nCFj7HpevMKuUT7JnHIkBekIYTTGhPHX/v8RQaB7eD0eV
 OkXIoWvkAo77q4MisyoKrZoGCGNUITyq92QLS6Qz1Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Koul, Vinod wrote:

> On Thu, 2011-08-25 at 16:55 +0200, Guennadi Liakhovetski wrote:
> > On Thu, 25 Aug 2011, Koul, Vinod wrote:
> > 
> > > On Thu, 2011-08-25 at 16:37 +0200, Guennadi Liakhovetski wrote:
> > > > On Thu, 25 Aug 2011, Koul, Vinod wrote:
> > > > 
> > > > > On Thu, 2011-08-18 at 16:55 +0200, Guennadi Liakhovetski wrote:
> > > > > > Currently the shdma dmaengine driver uses runtime PM to save power, when
> > > > > > no channel on the specific controller is requested by a user. This patch
> > > > > > switches the driver to count individual DMA transfers. That way the
> > > > > > controller can be powered down between transfers, even if some of its
> > > > > > channels are in use.
> > > > > No, I don't agree with the approach here, you don't need to count the
> > > > > transfers, the runtime_pm framework does that very well for you.
> > > > > 
> > > > > What you need to do is to call pm_runtime_get() in your .issue_pending
> > > > > callback (NOT in tx_submit anyway, this needs to be fixed in driver, see
> > > > > the Documentation/dmaengine.txt
> > > > > And once the transfer has completed you need to call pm_rumtime_put()
> > > > 
> > > > This has been discussed before:
> > > > 
> > > > http://marc.info/?l=linux-sh&m=131004613801231&w=2
> > > uh, yes but at least the runtime_xxx needs to get fixed.
> > 
> > This isn't so easy either. In principle, yes, I know, that pm_runtime_* 
> > calls count depth. But I don't think the DMA case is simple enough for 
> > that. It's not necessarily one in - one out. Think about terminating 
> > transfers, timing out, closing the channel, etc. In those cases you'd have 
> > to count pending transfers and pm_runtime_put() for each of them. This is 
> > even less trivial on shdma, where DMA transfers get split into sg-lists, 
> > which are then all queued on a single queue. So, you'd have to scan that 
> > queue and check for transfer borders... That's why I decided that doing 
> > just one get() on the first descriptor and one put() on the last one would 
> > be easier and more robust.
> Wont it be easy to to do:
> - pm_runtime_get() in each submit
> - pm_runtime_put() in each callback
> Normal case above would work just fine
> - In terminate case, count the number of issued transactions, and call
> pm_runtime_put() for each canceled transaction
> (i am assuming that for each timeout error, the client will call
> terminate)

As I said, this won't be very easy to do this in a robust way. You'd have 
to scan your list of DMA blocks and see, which of them belong to one 
descriptor, and once you reach the end of that descriptor, issue a put(). 
Perhaps, this can be done, but my choice went to the currently presented 
solution.

Thanks
Guennadi

> Let me know if there is a case for you which doesn't fit in above
> 
> -- 
> ~Vinod

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
