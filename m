Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2IJWJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2IJWJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:09:50 -0400
Date: Tue, 11 Sep 2012 01:11:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
Message-ID: <20120910221111.GA21854@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120903143018.GA5353@redhat.com>
 <CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
 <20120903202737.GD6181@redhat.com>
 <CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
 <20120904135022.GI9805@redhat.com>
 <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
 <20120904185541.GB3602@redhat.com>
 <87k3w7j49i.fsf@rustcorp.com.au>
 <20120906052735.GB17656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120906052735.GB17656@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:27:35AM +0300, Michael S. Tsirkin wrote:
> On Thu, Sep 06, 2012 at 11:34:25AM +0930, Rusty Russell wrote:
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> > > On Tue, Sep 04, 2012 at 06:58:47PM +0200, Sjur Brændeland wrote:
> > >> Hi Michael,
> > >> 
> > >> > Exactly. Though if we just fail load it will be much less code.
> > >> >
> > >> > Generally, using a feature bit for this is a bit of a problem though:
> > >> > normally driver is expected to be able to simply ignore
> > >> > a feature bit. In this case driver is required to
> > >> > do something so a feature bit is not a good fit.
> > >> > I am not sure what the right thing to do is.
> > >> 
> > >> I see - so in order to avoid the binding between driver and device
> > >> there are two options I guess. Either make virtio_dev_match() or
> > >> virtcons_probe() fail. Neither of them seems like the obvious choice.
> > >> 
> > >> Maybe adding a check for VIRTIO_CONSOLE_F_DMA_MEM match
> > >> between device and driver in virtcons_probe() is the lesser evil?
> > >> 
> > >> Regards,
> > >> Sjur
> > >
> > > A simplest thing to do is change dev id. rusty?
> > 
> > For generic usage, this is correct.  But my opinion is that fallback on
> > feature non-ack is quality-of-implementation issue: great to have, but
> > there are cases where you just want to fail with "you're too old".
> > 
> > And in this case, an old system simply will never work.  So it's a
> > question of how graceful the failure is.
> > 
> > Can your userspace loader can refuse to proceed if the driver doesn't
> > ack the bits?  If so, it's simpler than a whole new ID.
> > 
> > Cheers,
> > Rusty.
> 
> Yes but how can it signal guest that it will never proceed?
> 
> Also grep for BUG_ON in core found this:
> 
>        drv->remove(dev);
> 
>        /* Driver should have reset device. */
>        BUG_ON(dev->config->get_status(dev));
> 
> I think below is what Sjur refers to.
> I think below is a good idea for 3.6. Thoughts?
> 
> --->
> 
> virtio: don't crash when device is buggy
> 
> Because of a sanity check in virtio_dev_remove, a buggy device can crash
> kernel.  And in case of rproc it's userspace so it's not a good idea.
> We are unloading a driver so how bad can it be?
> Be less aggressive in handling this error: if it's a driver bug,
> warning once should be enough.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> --

Rusty?

> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index c3b3f7f..1e8659c 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -159,7 +159,7 @@ static int virtio_dev_remove(struct device *_d)
>  	drv->remove(dev);
>  
>  	/* Driver should have reset device. */
> -	BUG_ON(dev->config->get_status(dev));
> +	WARN_ON_ONCE(dev->config->get_status(dev));
>  
>  	/* Acknowledge the device's existence again. */
>  	add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> 
> -- 
> MST
