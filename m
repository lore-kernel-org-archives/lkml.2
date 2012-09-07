Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab2IGMW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2IGMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:22:56 -0400
Message-ID: <5049E717.8080307@redhat.com>
Date: Fri, 07 Sep 2012 14:22:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <5049BE0E.6040202@redhat.com> <20120907105335.GB17211@redhat.com> <5049D899.60705@redhat.com> <20120907121712.GA17397@redhat.com>
In-Reply-To: <20120907121712.GA17397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 14:17, Michael S. Tsirkin ha scritto:
>>> Next, consider the interface proposed here. You defacto declare
>>> all existing drivers buggy.
>>
>> No, only Windows (and it is buggy, it calls tell_host last).
> 
> It is not buggy. It does not ack MUST_TELL_HOST. So it is free to tell
> host at any point, it behaves exactly
> to spec. You can not retroactively declare drivers buggy like that.

Well, according to your reading of the spec.

In the spec I'm reading "Host must be told before pages from the balloon
are used".  Doesn't say anything about the guest.

Now, indeed a very free interpretation is "Guest will tell host before
pages from the balloon are used".  It turns out that it's exactly what
guests have been doing, hence that's exactly what I'm proposing now:
rename the feature to VIRTIO_BALLOON_F_WILL_TELL_HOST.

>> True, but the choice is:
>>
>> 1) add a once-only hack to QEMU that fixes migration of
>> VIRTIO_BALLOON_F_MUST_TELL_HOST;
>>
>> 2) always advertise VIRTIO_BALLOON_F_MUST_TELL_HOST.  If you do this,
>> guests cannot use anymore silent deflate, which is a regression.
>>
>> 3) use two bits.  One tells the device that the driver supports chatty
>> deflate; one tells the driver that the device supports silent deflate.
> 
> The right thing to do is either
> 4. realize we can not address all user errors, so no real issue
> 5. address this class of user errors by migrating host features
> 
>> So in the end you do use two feature bits for two different things.
>> Plus, both feature bits are "positive" and I'm happy.
> 
> I am not happy.
> We lose compatibility with all existing drivers

How so?

> so it will take years until the feature is actually
> useful.

No, we don't!  Windows guests will just not be able to use munlock/mlock
until the driver is fixed.  Which will probably happen before someone
writes the munlock/mlock code.

> Is this just a matter of naming? Same functionality:
> driver that acks this bit will tell host first,
> driver that does not will not?
> 
> If yes that is fine.

Yes, that part we agree on I think.  We disagree that (after the rename)
QEMU should start always proposing VIRTIO_BALLOON_F_WILL_TELL_HOST.

_Plus_ adding the new feature bit, which is needed to actually tell the
driver that the host supports the silent deflate.  Spec patch on the way.

Paolo
