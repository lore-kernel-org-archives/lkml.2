Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1ACQel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:34:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1ACQej (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 3 Jan 2011 11:34:39 -0500
Date: Mon, 3 Jan 2011 11:34:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        gurudas.pai@oracle.com, guru.anbalagane@oracle.com,
        greg.marsden@oracle.com, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [patch] xenfb: fix xenfb suspend/resume race
Message-ID: <20110103163418.GA14102@dumpdata.com>
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>
 <20101230164051.GC24313@dumpdata.com>
 <4D1D2A2D.80206@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1D2A2D.80206@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am unclear from your description whether the patch fixes
> > the problem (I would presume so). Or does it take a long time
> > to hit this race?
> > 
> Yes, more than 100 migrations. we hit this issue around 3 times.

OK, so you are still trying to find the culprit.

Did you look at this patch from Ian:

https://patchwork.kernel.org/patch/403192/

?
> 
> I dumped vmcore when guest crashed, from vmcore everything
> looked good, fb_info, xenfb_info and so on.

And the event channels are correct?

.. snip..
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index ac7b42f..4cfb5e2 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -175,6 +175,8 @@ static struct irq_info *info_for_irq(unsigned irq)
>  
>  static unsigned int evtchn_from_irq(unsigned irq)
>  {
> +	if (unlikely(irq < 0 || irq >= nr_irqs))
> +		return 0;

You could insert a WARN_ON here to see see if you get this during your
migration process.

Or use xen_raw_printk in case the guest is hung for good.

>  	return info_for_irq(irq)->evtchn;
>  }
>  
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
