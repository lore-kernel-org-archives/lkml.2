Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1AFICe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:02:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:22281 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1AFICd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:02:33 -0500
X-IronPort-AV: E=Sophos;i="4.60,282,1291611600"; 
   d="scan'208";a="11807366"
Subject: Re: [patch] xenfb: fix xenfb suspend/resume race
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Joe Jin <joe.jin@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>
In-Reply-To: <4D256BC7.1080501@oracle.com>
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>
	 <20101230164051.GC24313@dumpdata.com>
	 <1294139733.3831.141.camel@zakaz.uk.xensource.com>
	 <4D256BC7.1080501@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Thu, 6 Jan 2011 08:02:04 +0000
Message-ID: <1294300924.13733.42.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 07:14 +0000, Joe Jin wrote: 
> On 01/04/11 19:15, Ian Campbell wrote:
> > On Thu, 2010-12-30 at 16:40 +0000, Konrad Rzeszutek Wilk wrote:
> >> On Thu, Dec 30, 2010 at 08:56:16PM +0800, Joe Jin wrote:
> >>> Hi,
> >>
> >> Joe,
> >>
> >> Patch looks good, however..
> >>
> >> I am unclear from your description whether the patch fixes
> >> the problem (I would presume so). Or does it take a long time
> >> to hit this race?
> > 
> > I also don't see how the patch relates to the stack trace.
> > 
> > Is the issue is that xenfb_send_event is called between xenfb_resume
> > (which tears down the state, including evtchn->irq binding) and the
> > probe/connect of the new fb?
> 
> Yes, when hit this issue, with debugging kernel found irq is invalid(-1).

But why is it -1? I really don't think you have identified the root
cause here. If you really have identified the root cause then your
changelog needs to go into much greater depth regarding your analysis.

> Check if irq is valid will fix this issue.

No, it papers over the issue, the code should never have been allowed to
get this far if the connection to the backend is not yet fully resumed
(i.e. when irq == -1).

The call to xenfb_send_event should have been gated further up the call
chain, AFAICT by the check of info->update_wanted in xenfb_refresh. This
suggests that the correct fix is to set info->update_wanted = 0 in
xenfb_resume.

I said all this in my previous mail and you ignored it. Did you try this
approach?

> And, when failed to connect to backend, need to release the resource.

So the changes to xenfb_connect_backend are independent of the irq == -1
issue? In which case this part, which seems like a reasonable and valid
fix, should be split into a separate patch.

> Please review new patch for this issue.

Nacked-by: Ian Campbell <ian.campbell@citrix.com>

Ian.

> Thanks,
> Joe
> 
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> ---
>  video/xen-fbfront.c |   19 +++++++++++--------
>  xen/events.c        |    4 ++++
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index dc72563..367fb1c 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -561,26 +561,24 @@ static void xenfb_init_shared_page(struct xenfb_info *info,
>  static int xenfb_connect_backend(struct xenbus_device *dev,
>  				 struct xenfb_info *info)
>  {
> -	int ret, evtchn;
> +	int ret, evtchn, irq;
>  	struct xenbus_transaction xbt;
>  
>  	ret = xenbus_alloc_evtchn(dev, &evtchn);
>  	if (ret)
>  		return ret;
> -	ret = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
> +	irq = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
>  					0, dev->devicetype, info);
> -	if (ret < 0) {
> +	if (irq < 0) {
>  		xenbus_free_evtchn(dev, evtchn);
>  		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
> -		return ret;
> +		return irq;
>  	}
> -	info->irq = ret;
> -
>   again:
>  	ret = xenbus_transaction_start(&xbt);
>  	if (ret) {
>  		xenbus_dev_fatal(dev, ret, "starting transaction");
> -		return ret;
> +		goto unbind_irq;
>  	}
>  	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
>  			    virt_to_mfn(info->page));
> @@ -602,15 +600,20 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
>  		if (ret == -EAGAIN)
>  			goto again;
>  		xenbus_dev_fatal(dev, ret, "completing transaction");
> -		return ret;
> +		goto unbind_irq;
>  	}
>  
>  	xenbus_switch_state(dev, XenbusStateInitialised);
> +	info->irq = irq;
>  	return 0;
>  
>   error_xenbus:
>  	xenbus_transaction_end(xbt, 1);
>  	xenbus_dev_fatal(dev, ret, "writing xenstore");
> + unbind_irq:
> +	printk(KERN_ERR "xenfb_connect_backend failed!\n");
> +	unbind_from_irqhandler(irq, info);
> +	xenbus_free_evtchn(dev, evtchn);
>  	return ret;
>  }
>  
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index ac7b42f..4028704 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -175,6 +175,10 @@ static struct irq_info *info_for_irq(unsigned irq)
>  
>  static unsigned int evtchn_from_irq(unsigned irq)
>  {
> +	if (unlikely(irq < 0 || irq >= nr_irqs)) {
> +		WARN_ON(1, "[%s]: Invalid irq(%d)!\n", __func__, irq);
> +		return 0;
> +	}
>  	return info_for_irq(irq)->evtchn;
>  }
>  


