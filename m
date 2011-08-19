Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1HSQeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:34:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35154 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1HSQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:34:20 -0400
Subject: Re: [PATCH] virtio-net: Read MAC only after initializing MSI-X
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <20110819152335.GA19489@redhat.com>
References: <1313225461-24458-1-git-send-email-levinsasha928@gmail.com>
	 <20110819152335.GA19489@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 19 Aug 2011 19:33:07 +0300
Message-ID: <1313771587.12243.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 18:23 +0300, Michael S. Tsirkin wrote:
> On Sat, Aug 13, 2011 at 11:51:01AM +0300, Sasha Levin wrote:
> > The MAC of a virtio-net device is located at the first field of the device
> > specific header. This header is located at offset 20 if the device doesn't
> > support MSI-X or offset 24 if it does.
> > 
> > Current code in virtnet_probe() used to probe the MAC before checking for
> > MSI-X, which means that the read was always made from offset 20 regardless
> > of whether MSI-X in enabled or not.
> > 
> > This patch moves the MAC probe to after the detection of whether MSI-X is
> > enabled. This way the MAC will be read from offset 24 if the device indeed
> > supports MSI-X.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> I am not sure I see a bug in virtio: the config pace layout simply
> changes as msix is enabled and disabled (and if you look at the latest
> draft, also on whether 64 bit features are enabled).
> It doesn't depend on msix capability being present in device.
> 
> The spec seems to be explicit enough:
> 	If MSI-X is enabled for the device, two additional fields immediately
> 	follow this header.
> 
> So I'm guessing the bug is in kvm tools which assume
> same layout for when msix is enabled and disabled.
> qemu-kvm seems to do the right thing so the device
> seems to get the correct mac.

We assumed that PCI config space has a static layout like most other
devices. Having a behavior of "First bit 20 does something, but after
enabling MSI-X it does something completely different" sounds strange.

I'm wondering why offsets of the config structure change during run time
and are not statically defined when the device is started.

It's not like VIRTIO_F_FEATURES_HI can be disabled after it was enabled,
or MSI-X can be simply disabled during run time.

Maybe this is better solved by copying the way it was done in PCI itself
with capability linked list?

-- 

Sasha.

