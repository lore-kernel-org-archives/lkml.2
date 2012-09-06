Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2IFMN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab2IFMNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:13:23 -0400
Message-ID: <5048935A.8090308@redhat.com>
Date: Thu, 06 Sep 2012 14:13:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com>
In-Reply-To: <20120906105301.GC32325@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 12:53, Michael S. Tsirkin ha scritto:
>> It is useful because it lets guests inflate the balloon aggressively,
>> and then use ballooned-out pages even in places where the guest OS
>> cannot sleep, such as kmalloc(GFP_ATOMIC).
> 
> Interesting.
> Do you intend to develop a driver patch using this?  I'd like to see how
> that works.  Because if not, IMO it's best to wait until someone asks
> for it.

It's been two months, but Frank Swiderski's patch that triggered the
debate is exactly that
(http://permalink.gmane.org/gmane.linux.kernel/1318984).  However, he
didn't check VIRTIO_BALLOON_F_MUST_TELL_HOST, so he has a bug there.

>> Currently migration works the same way for all virtio devices,
>> and assumes that features are defined only in the "positive" direction:
>> drivers request features if they want to use it, devices provide
>> features to say they support something.
> 
> Well this approach is buggy. If I reread features after migration what
> do I see? Something changed right? So this is a bug. Migration should
> not change hardware.

Exactly, virtio migration currently fails if it would change hardware
due to features not supported in the destination.  Except for
VIRTIO_BALLOON_F_MUST_TELL_HOST, where it does not fail because it is
defined in the wrong direction.

> Fix that in qemu, and the problem goes away without spec changes.

That would be a one-off hack, for the sole feature that was defined wrong.

>> Instead, in the case of this feature, the driver requests it before
>> relying on its lack (which is odd);
> 
> Which code in driver do you refer to?

I'm talking of the code Frank should have put in the driver, but he
didn't (so he has a bug).  Something like

    if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST))
	return -ENODEV;

So it has to request the feature, and then fail if the feature is
present.  That's quite backwards.  Everywhere else you'll find

    if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
        return -ENOTTY;

    BUG_ON(!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_CONFIG_WCE));

    if (virtio_has_feature(vblk->vdev, VIRTIO_NET_F_CTRL_VQ)) {
        /* do cool stuff */
    }

etc.


>> the device provides if they do not
>> support something (which is wrong).
> 
> Not support? It just seems to be asking guest to tell it about deflates.
> If guest acks the bit, we know it will. If it does not,
> it will not.

No, it is the other way round.  The host ultimately decides what
features are negotiated, so it doesn't ask anything to the guest.  The
_guest_ is asking the host about the need for explicit deflate.

>>  You can see that this just cannot
>> provide backwards-compatibility in the device;
> 
> Sorry I do not understand this meta argument.
> There should be an example where a driver and device
> fail to work together.

There's nothing that you cannot work around.  Use virtio_has_feature in
the device, invert the migration feature check in the driver.  Why not
just _get it right_ instead?

>> it happens to work only
>> because the feature was there in the first version of the spec.
> 
> This is how we do compatiblity in virtio. If we want driver to do
> something, we add a feature and it can ack, if it does we know it will
> do what we want.  Another example is network announce bit.  If driver
> acks it, we know we do not need to send gratitious arp from qemu.  You
> are saying it is also broken?

No, it's not broken.  A reverse feature, let's call it like
VIRTIO_NET_F_HOST_MUST_SEND_GARP, would be broken.

VIRTIO_NET_F_GUEST_ANNOUNCE is a "positive" feature: if set, the host
_can_ ask the guest to send a gARP, but it may also send it itself.
Similarly if VIRTIO_BALLOON_F_SILENT_DEFLATE is set, the guest _can_ use
ballooned pages directly, but may also deflate them explicitly.

Instead, VIRTIO_NET_F_HOST_MUST_SEND_GARP would be a "negative" feature:
if set, the host _may not_ rely on the guest to send a gARP.  Similarly
if VIRTIO_BALLOON_F_MUST_TELL_HOST is set, the guest _may not_ use
ballooned pages directly.

There are _no_ other negative features besides
VIRTIO_BALLOON_F_MUST_TELL_HOST in the spec, and for a good
reason---because they're broken.

(Hmm, actually we have one, VIRTIO_BLK_F_RO.  It is also a bit broken,
but it is not so important because it depends on user input more than
hypervisor version).

Reasoning on migration is just another way to see if the feature is
positive.  During migration, new features available on the destination
can always be masked.  But if removing the feature _adds_ a capability
to the hardware, it's wrong.

> Don't fix what is not broken. We get to carry compatibility
> in both driver and host for a long time for each feature.

Sure, but better fix broken things _before_ somebody uses them.

I'm not proposing to replace VIRTIO_BLK_F_RO with VIRTIO_BLK_F_RW
because it's in wide use and it would pose compatibility problems indeed.

But since VIRTIO_BALLOON_F_MUST_TELL_HOST does not exist in any source
code, neither driver nor hypervisor, we get lucky and we can instantly
deprecate it.

> Note: adding new features adds zero value in this respect - it will not
> allow simplifying the hypervisor.

Indeed, it will add one line of code to the hypervisor to advertise the
new feature.

Paolo
