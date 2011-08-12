Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab1HLVa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:30:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1HLVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:30:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:user-agent:x-system-of-record;
	b=f5xqpnmhKm3JOjFE9B+lgwqKzbv4EtUP3IU58OXlcJIaKMBgdUIWx85XumY+ExyCx
	wD1IszfOA9qjbCIIOx+sg==
Date: Fri, 12 Aug 2011 14:30:37 -0700
From: Todd Poynor <toddpoynor@google.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, nm@ti.com, vikram.pandita@ti.com
Subject: Re: [PATCH 5/5 v4] mfd: omap: usb: Runtime PM support
Message-ID: <20110812213037.GA24803@google.com>
References: <1312899309-24067-1-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-2-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-3-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-4-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-5-git-send-email-keshava_mgowda@ti.com>
 <1312899309-24067-6-git-send-email-keshava_mgowda@ti.com>
 <20110810163142.GA10156@google.com>
 <CAP05o4L+qn4K=jLx5Jo8WsG7LnU=VniQSR+fLc=RM5mW4kP1OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP05o4L+qn4K=jLx5Jo8WsG7LnU=VniQSR+fLc=RM5mW4kP1OQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:20:21PM +0530, Munegowda, Keshava wrote:
> On Wed, Aug 10, 2011 at 10:01 PM, Todd Poynor <toddpoynor@google.com> wrote:
> >> @@ -913,12 +598,15 @@ static int usbhs_enable(struct device *dev)
> >>                               (pdata->ehci_data->reset_gpio_port[1], 1);
> >>       }
> >>
> >> -end_count:
> >> -     omap->count++;
> >> +     pm_runtime_put_sync(dev);
> >>       spin_unlock_irqrestore(&omap->lock, flags);
> >
> > Is pm_runtime_irq_safe() needed (else I think runtime PM callbacks may
> > re-enable IRQs... or there's the new *_suspend runtime PM calls that
> > may avoid this)?
> 
>  pm_runtime_irq_safe()  is not required; usbhs does not have a parent
> and it is the parent driver of
> ehci and ohci drivers.

But the above expects IRQs to be disabled during the
pm_runtime_put_sync, and synchronous calls can turn IRQs back on in
rpm_idle:

        if (callback) {
                spin_unlock_irq(&dev->power.lock);

                callback(dev);

I see other folks who know this better than me are discussing USB run
time PM and might_sleep contexts, so I'll note this concern and let
others chime in if they think there's a real problem here.


Todd
