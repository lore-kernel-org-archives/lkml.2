Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1KCNrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab1KCNrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:47:07 -0400
Date: Thu, 3 Nov 2011 15:48:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
Message-ID: <20111103134816.GM18296@redhat.com>
References: <1320259767.22582.2.camel@lappy>
 <8762j2t19l.fsf@rustcorp.com.au>
 <1320309203.29407.1.camel@lappy>
 <20111103124651.GK18296@redhat.com>
 <1320326341.29407.25.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320326341.29407.25.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 03:19:01PM +0200, Sasha Levin wrote:
> On Thu, 2011-11-03 at 14:46 +0200, Michael S. Tsirkin wrote:
> > On Thu, Nov 03, 2011 at 10:33:23AM +0200, Sasha Levin wrote:
> > > On Thu, 2011-11-03 at 12:28 +1030, Rusty Russell wrote: 
> > > > On Wed, 02 Nov 2011 20:49:27 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > > > > This is a proposal for a new layout of the virtio-pci config space.
> > > > > 
> > > > > We will separate the current configuration into two: A virtio-pci common
> > > > > configuration and a device specific configuration. This allows more flexibility
> > > > > with adding features and makes usage easier, specifically in cases like the
> > > > > ones in virtio-net where device specific configurations depend on device
> > > > > specific features.
> > > > 
> > > > Thanks for this Sasha.  Several general comments:
> > > > 
> > > > 1) How to we distinguish the two layouts?  In theory, we need to do this
> > > >    forever.  In practice we can deprecate the old layout in several
> > > >    years' time.
> > > 
> > > Old layouts won't have the new virtio-pci cap structure in their PCI
> > > config space.
> > 
> > What happens next time we want to change something?
> 
> Thats why there are virtio-pci cap values. This layout cap was defined
> as VIRTIO_PCI_C_LAYOUT. If for example we want to provide a whole
> different layout, we can define something similar to
> VIRTIO_PCI_C_LAYOUT_V2 and use it in newer drivers (we can also add a
> version field to the original layout ofcourse).
> 
> This also allows an easy way to provide backwards compatibility by
> specifying many layout definitions and letting the driver choose the
> latest layout he can. This would also allow to make larger changes
> easier as it allows you to have several different layout configs in the
> same code.

This plan does not make me happy. Versioning is much messier than
features to support, and much harder for downstreams to
cherry-pick.

> > 
> > > > 2) I don't think we want to turn the device-specific config into a
> > > >    linked list.  We haven't needed variable-length config (yet!), and
> > > >    it's (slightly) more complex.  That's also the part of the spec which
> > > >    is shared with non-PCI virtio implementations.
> > > 
> > > Variable length config wasn't used yet because space in the device
> > > specific space was reserved for a feature even if that feature wasn't
> > > used.
> > 
> > Not only that, also because it is messy to debug.  With fixed offsets
> > you just print the address/data and you know what it's doing.
> > 
> > > For example, the MAC feature reserved 6 bytes in the config space for
> > > the MAC even if VIRTIO_NET_F_MAC wasn't enabled. Here we can just avoid
> > > having it pollute the config space until it's enabled.
> > > 
> > 
> > This looks like overdesign to me. The only reason PCI spec
> > used capability list is
> > 1. to save space
> > 2. standard mechanism to discover features
> > You say explicitly space is not an issue, and you keep
> > feature bits around.
> 
> Okay, I agree with not doing linked lists for device specific features.
> 
> I do think we need them for virtio-pci itself to handle features such as
> MSI-X.

It's definitely easier for virtio-pci than for devices.
But let's address the motivation point.
Do you expect a need to have a huge structure there, like
megabytes in size, so space will be an issue again?

> > > I don't think it'll have any impact on non-PCI implementations since the
> > > "pointers" are simply offsets from the beginning of the config space,
> > > and are not PCI specific in any way.
> > 
> > The APIs use a single offset cookie to pass configuration.
> > If you want capabilities, that will have to be changed.
> > 
> > > > 3) If we're changing the queue layout, it's a chance to fix a
> > > >    longstanding bug: let the guest notify the host of preferred
> > > >    queue size and alignment.
> > > 
> > > Yup, we can do that.
> > > 
> > > -- 
> > > 
> > > Sasha.
> > > 
> 
> -- 
> 
> Sasha.
