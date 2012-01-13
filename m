Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2AMA3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:29:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35260 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2AMA3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:29:35 -0500
MIME-Version: 1.0
In-Reply-To: <87lipd4hqx.fsf@rustcorp.com.au>
References: <87lipd4hqx.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 16:29:14 -0800
X-Google-Sender-Auth: kbUClu6cwNTVUr5RghDSmO_ukA0
Message-ID: <CA+55aFyOy4bWUq6PH3ThM2CXOFwi75FE8HGOJ8DNZjFWw9rq6A@mail.gmail.com>
Subject: Re: [PULL] virtio and lguest
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Davidlohr Bueso <dave@gnu.org>, Jacek Galowicz <jacek@galowicz.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:22 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Amit Shah (12):
>      virtio: pci: switch to new PM API

Hmm. Afaik, this is broken, or at least not complete.

Sure, it switches to the new PM API, but it still does the PCI ops itself.

It should not need to - the PCI layer will do the power state and
standard PCI device state saving. And setting the PCI_D3hot state when
shared interrupts can still happen at suspend time is just a bad idea.

So I think you're doing extra work and introducing bugs by doing so -
the default PCI bus operations should already do all you do, just do
it better. And then you can use the SIMPLE_DEV_PM_OPS() to build the
dev_pm_ops structure and get all the normal cases right automatically.

I don't know if there is any particularly good example of this, but
you can see some of the network drivers for examples of this. Notice
how they don't need to worry about PCI power states etc at all, they
just need to worry about the actual chip suspend/resume (and for a
network driver, you'd do the netif_device_detach/netif_device_attach
etc)

                         Linus
