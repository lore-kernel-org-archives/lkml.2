Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1KOPhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:37:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab1KOPhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:37:22 -0500
Date: Tue, 15 Nov 2011 21:07:12 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 09/11] virtio: net: Add freeze, restore handlers to
 support S4
Message-ID: <20111115153643.GF26378@amit-x200.redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
 <5b7834c9a30254220f9c079ba54d29abaf63db8f.1317311033.git.amit.shah@redhat.com>
 <20111002093324.GD29706@redhat.com>
 <20111115122902.GA26378@amit-x200.redhat.com>
 <20111115125127.GA31208@redhat.com>
 <20111115140346.GC26378@amit-x200.redhat.com>
 <20111115142259.GA16395@redhat.com>
 <20111115143149.GE26378@amit-x200.redhat.com>
 <20111115143620.GA16609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115143620.GA16609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 15 Nov 2011 [16:36:20], Michael S. Tsirkin wrote:
> On Tue, Nov 15, 2011 at 08:01:49PM +0530, Amit Shah wrote:
> > On (Tue) 15 Nov 2011 [16:23:00], Michael S. Tsirkin wrote:
> > > On Tue, Nov 15, 2011 at 07:33:46PM +0530, Amit Shah wrote:
> > > > On (Tue) 15 Nov 2011 [14:51:27], Michael S. Tsirkin wrote:
> > > > > On Tue, Nov 15, 2011 at 05:59:36PM +0530, Amit Shah wrote:
> > > > > > On (Sun) 02 Oct 2011 [11:33:26], Michael S. Tsirkin wrote:
> > > > > > > On Thu, Sep 29, 2011 at 09:19:40PM +0530, Amit Shah wrote:
> > > > > > > > Remove all the vqs on hibernation and re-create them after restoring
> > > > > > > > from a hibernated image.  This keeps networking working across
> > > > > > > > hibernation.
> > > > > > > > 
> > > > > > > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > > > > > > ---
> > > > > > > >  drivers/net/virtio_net.c |   28 ++++++++++++++++++++++++++++
> > > > > > > >  1 files changed, 28 insertions(+), 0 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > > > index dcd4b01..8b9ed43 100644
> > > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > > @@ -1131,6 +1131,30 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
> > > > > > > >  	free_netdev(vi->dev);
> > > > > > > >  }
> > > > > > > >  
> > > > > > > > +#ifdef CONFIG_PM
> > > > > > > > +static int virtnet_freeze(struct virtio_device *vdev)
> > > > > > > > +{
> > > > > > > > +	struct virtnet_info *vi = vdev->priv;
> > > > > > > 
> > > > > > > I'm guessing we need to do something like netif_device_detach here,
> > > > > > > otherwise guest might be in the process of using the vq for transmit at
> > > > > > > this point.
> > > > > > 
> > > > > > Done.
> > > > > > 
> > > > > > > I think we also must make sure NAPI RX handler is not in progress.
> > > > > > 
> > > > > > How to do that?  napi_disable() / napi_enable() doesn't seem right
> > > > > > (and it doesn't work, too).  pci_disable_device() in the suspend
> > > > > > routine may work?
> > > > > > 
> > > > > > > We also might need to mask interrupts from the device
> > > > > > > to prevent TX or RX from getting rescheduled?
> > > > > > 
> > > > > > pci_disable_device() will help this too, right?
> > > > > > 
> > > > > 
> > > > > No, why would it help?
> > > > 
> > > > IRQs will be disabled after the call to pci_disable_device(),
> > > > isn't that sufficient?
> > > > 
> > > 
> > > They will?
> > >  * pci_disable_device - Disable PCI device after use
> > >  * @dev: PCI device to be disabled
> > >  *
> > >  * Signal to the system that the PCI device is not in use by the system
> > >  * anymore.  This only involves disabling PCI bus-mastering, if active.
> > >  *
> > >  * Note we don't actually disable the device until all callers of
> > >  * pci_enable_device() have called pci_disable_device().
> > 
> > You mean multiple devices could have called pci_enable_device()?  Not
> > likely to happen, at least in case of our virtio devices... only we
> > claim ownership over them.  I don't think that'll change.
> > 
> 
> I simply mean that pci_disable_device does not seem to disable
> interrupts.

As far as I know, all our irqs are allocated for vqs, and they'll be
freed when the vqs are freed too.

Are there any others that need special handling?

		Amit
