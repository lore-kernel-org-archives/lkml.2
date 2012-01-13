Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab2AMKtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 05:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab2AMKtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 05:49:12 -0500
Date: Fri, 13 Jan 2012 16:18:45 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Davidlohr Bueso <dave@gnu.org>,
        Jacek Galowicz <jacek@galowicz.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PULL] virtio and lguest
Message-ID: <20120113104845.GC9506@amit.redhat.com>
References: <87lipd4hqx.fsf@rustcorp.com.au>
 <CA+55aFyOy4bWUq6PH3ThM2CXOFwi75FE8HGOJ8DNZjFWw9rq6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyOy4bWUq6PH3ThM2CXOFwi75FE8HGOJ8DNZjFWw9rq6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On (Thu) 12 Jan 2012 [16:29:14], Linus Torvalds wrote:
> On Wed, Jan 11, 2012 at 9:22 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > Amit Shah (12):
> >      virtio: pci: switch to new PM API
> 
> Hmm. Afaik, this is broken, or at least not complete.
> 
> Sure, it switches to the new PM API, but it still does the PCI ops itself.
> 
> It should not need to - the PCI layer will do the power state and
> standard PCI device state saving. And setting the PCI_D3hot state when
> shared interrupts can still happen at suspend time is just a bad idea.

The idea behind this patchset is to get S4 working properly.  There's
no change to the way S3 was/is being done, and the state-setting is
done only in the S3 PM callbacks.

> So I think you're doing extra work and introducing bugs by doing so -
> the default PCI bus operations should already do all you do, just do

For S4, we need some driver-specific (not just virtio-specific) work
to be done on the freeze/restore callbacks...

> it better. And then you can use the SIMPLE_DEV_PM_OPS() to build the
> dev_pm_ops structure and get all the normal cases right automatically.

... and we also have separate stuff to be done in thaw/restore/freeze
callbacks for different drivers.  So using the *_PM_OPS() macros
wouldn't have worked.

> I don't know if there is any particularly good example of this, but
> you can see some of the network drivers for examples of this. Notice
> how they don't need to worry about PCI power states etc at all, they
> just need to worry about the actual chip suspend/resume (and for a
> network driver, you'd do the netif_device_detach/netif_device_attach
> etc)

I think your concern is with the way S3 is being done, and I volunteer
to look at improving the situation there.  Might take a while, though.

		Amit
