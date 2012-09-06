Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2IFNNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab2IFNNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:13:05 -0400
Message-ID: <5048A152.9050105@redhat.com>
Date: Thu, 06 Sep 2012 15:12:50 +0200
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
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <20120906125107.GA1639@redhat.com>
In-Reply-To: <20120906125107.GA1639@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 14:51, Michael S. Tsirkin ha scritto:
> On Thu, Sep 06, 2012 at 02:13:14PM +0200, Paolo Bonzini wrote:
>> Il 06/09/2012 12:53, Michael S. Tsirkin ha scritto:
>>>> It is useful because it lets guests inflate the balloon aggressively,
>>>> and then use ballooned-out pages even in places where the guest OS
>>>> cannot sleep, such as kmalloc(GFP_ATOMIC).
>>>
>>> Interesting.
>>> Do you intend to develop a driver patch using this?  I'd like to see how
>>> that works.  Because if not, IMO it's best to wait until someone asks
>>> for it.
>>
>> It's been two months, but Frank Swiderski's patch that triggered the
>> debate is exactly that
>> (http://permalink.gmane.org/gmane.linux.kernel/1318984).  However, he
>> didn't check VIRTIO_BALLOON_F_MUST_TELL_HOST, so he has a bug there.
> 
> He is using a sepate device ID though, so we do not need a feature bit.

It doesn't need to, it can work just as well with the existing device.

>> Exactly, virtio migration currently fails if it would change hardware
>> due to features not supported in the destination.  Except for
>> VIRTIO_BALLOON_F_MUST_TELL_HOST, where it does not fail because it is
>> defined in the wrong direction.
> 
> There is nothing wrong with the direction that I can see.
> The bug is that migration between backends

...?

>>     BUG_ON(!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_CONFIG_WCE));
> 
> This is a bug BTW - we should not crash on bad device, failing probe
> is the right thing.

(I knew you would say that. :)  The feature has been checked elsewhere,
and this code will be unreachable if the feature was not there in the
first place).

>>>>  You can see that this just cannot
>>>> provide backwards-compatibility in the device;
>>>
>>> Sorry I do not understand this meta argument.
>>> There should be an example where a driver and device
>>> fail to work together.
>>
>> There's nothing that you cannot work around.  Use virtio_has_feature in
>> the device, invert the migration feature check in the driver.  Why not
>> just _get it right_ instead?
> 
> Exactly. Bug is in qemu, fix it _there_. What you do is a work around
> in spec: you declare old configurations unsupported.

Such old configurations do not exist, so it's fine.

>> There are _no_ other negative features besides
>> VIRTIO_BALLOON_F_MUST_TELL_HOST in the spec, and for a good
>> reason---because they're broken.
>>
>> (Hmm, actually we have one, VIRTIO_BLK_F_RO.  It is also a bit broken,
>> but it is not so important because it depends on user input more than
>> hypervisor version).
> 
> Now that we have a specific example, we can talk.
> Simply, some features do not need an ack from guest:
> they just tell guest something about device.
> RO is one such feature.

I don't understand how that's relevant.  All features that just say
"this field is there in the configuration at that offset" need no ack
from guest, yet they're expressed as "positive" features.

>> Reasoning on migration is just another way to see if the feature is
>> positive.  During migration, new features available on the destination
>> can always be masked.  But if removing the feature _adds_ a capability
>> to the hardware, it's wrong.
> 
> Fact is, nothing except migration seems broken. This alone should
> make you realize there is a bug in qemu not in driver or protocol.

I'm not entirely sure that you understand why migration is broken and
why it is only broken for this particular feature bit (and in a more
benign way for VIRTIO_BLK_F_RO).

>>> Don't fix what is not broken. We get to carry compatibility
>>> in both driver and host for a long time for each feature.
>>
>> Sure, but better fix broken things _before_ somebody uses them.
>>
>> I'm not proposing to replace VIRTIO_BLK_F_RO with VIRTIO_BLK_F_RW
>> because it's in wide use and it would pose compatibility problems indeed.
>>
>> But since VIRTIO_BALLOON_F_MUST_TELL_HOST does not exist in any source
>> code, neither driver nor hypervisor,
>> we get lucky and we can instantly
>> deprecate it.
> 
> Which driver are you looking at?
> 
>  grep VIRTIO_BALLOON_F_MUST_TELL_HOST drivers/virtio/*c|wc -l
> 2

Well, I am also looking at how it is used:

static unsigned int features[] = {
        VIRTIO_BALLOON_F_MUST_TELL_HOST,
        VIRTIO_BALLOON_F_STATS_VQ,
};

        /*
         * Note that if
         * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
         * is true, we *have* to do it in this order
         */
        tell_host(vb, vb->deflate_vq);
        release_pages_by_pfn(vb->pfns, vb->num_pfns);

So no, it is not used with virtio_has_feature in any way that matters.

> So it does not look like we can just remove it like you did. At minimum
> we will need to reserve the bit.

Yes, reserving the bit is necessary.

> Benefit seems very small. Why bother?

Because the problem is clear, and easily solved, and I don't like time
bombs.

>>> Note: adding new features adds zero value in this respect - it will not
>>> allow simplifying the hypervisor.
>>
>> Indeed, it will add one line of code to the hypervisor to advertise the
>> new feature.
> 
> So there's no point. Migration will stil be broken until it is
> fixed properly.

Migration of VIRTIO_BALLOON_F_MUST_TELL_HOST would be broken, but
VIRTIO_BALLOON_F_MUST_TELL_HOST does not exist and will not exist in the
hypervisor, so it will not be broken.

Paolo
