Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1LGD5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1LGD5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:57:15 -0500
Date: Wed, 7 Dec 2011 09:27:03 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/12] virtio: pci: switch to new PM API
Message-ID: <20111207035703.GA4651@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <f34bcde3d5103640176cf6a2cf8c534417771f08.1323199985.git.amit.shah@redhat.com>
 <201112062312.36498.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112062312.36498.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On (Tue) 06 Dec 2011 [23:12:36], Rafael J. Wysocki wrote:
> Hi,
> 
> On Tuesday, December 06, 2011, Amit Shah wrote:
> > The older PM API doesn't have a way to get notifications on hibernate
> > events.  Switch to the newer one that gives us those notifications.
> > 
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >  drivers/virtio/virtio_pci.c |   16 ++++++++++++----
> >  1 files changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > index 03d1984..23e1532 100644
> > --- a/drivers/virtio/virtio_pci.c
> > +++ b/drivers/virtio/virtio_pci.c
> > @@ -708,19 +708,28 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
> >  }
> >  
> >  #ifdef CONFIG_PM
> > -static int virtio_pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
> > +static int virtio_pci_suspend(struct device *dev)
> >  {
> > +	struct pci_dev *pci_dev = to_pci_dev(dev);
> > +
> >  	pci_save_state(pci_dev);
> >  	pci_set_power_state(pci_dev, PCI_D3hot);
> >  	return 0;
> >  }
> >  
> > -static int virtio_pci_resume(struct pci_dev *pci_dev)
> > +static int virtio_pci_resume(struct device *dev)
> >  {
> > +	struct pci_dev *pci_dev = to_pci_dev(dev);
> > +
> >  	pci_restore_state(pci_dev);
> >  	pci_set_power_state(pci_dev, PCI_D0);
> >  	return 0;
> >  }
> > +
> > +static const struct dev_pm_ops virtio_pci_pm_ops = {
> > +	.suspend = virtio_pci_suspend,
> > +	.resume  = virtio_pci_resume,
> > +};
> >  #endif
> 
> You seem to have forgotten about hibernation callbacks.

This patch just moves to the new API keeping everything else the same.
The hibernation callbacks come in patch 2.

>  Please use
> one the macros defined in include/linux/pm.h if you want to use the same
> callback routines for hibernation.

No, they're different functions, so I don't use the maros.

Thanks,

		Amit
