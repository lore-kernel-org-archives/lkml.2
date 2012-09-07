Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab2IGJ1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760179Ab2IGJ1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:27:52 -0400
Message-ID: <5049BE0E.6040202@redhat.com>
Date: Fri, 07 Sep 2012 11:27:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au>
In-Reply-To: <87vcfqfia1.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 08:39, Rusty Russell ha scritto:
>> > So it looks like a bug: we should teach driver to tell host first on leak?
>> > Yan, Vadim, can you comment please?
>> >
>> > Also if true, looks like this bit will be useful to detect a fixed driver on
>> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
>> > think?
> So, feature is unimplemented in qemu, and broken in drivers.  I starting
> to share Paolo's dislike of it.
> 
> Don't understand why we'd care about fixed drivers though, if we remove
> the feature bit....

Hmm, Michael has a point here.  Basically, the Windows driver is using
silent deflate, but not telling the host (yet) about it.  So, we must
assume that a driver that does not negotiate
VIRTIO_BALLOON_F_MUST_TELL_HOST _will_ use silent deflate.

Here's a way to proceed.

We add VIRTIO_BALLOON_F_SILENT_DEFLATE, which is negotiated normally.
If not available, at worst the guest driver may refuse to start, or
revert to using the deflateq.

We rename VIRTIO_BALLOON_F_MUST_TELL_HOST to WILL_TELL_HOST, since
that's how it's being used.  Now for the device there are three cases:

- does not support silent deflate at all: it should always propose
  VIRTIO_BALLOON_F_WILL_TELL_HOST; if the (bad) driver does not
  negotiate it, the device must assume that the guest will use silent
  deflate, and fail to start the guest if the device does not support
  silent deflate.

- optionally supports silent deflate: it should always propose
  VIRTIO_BALLOON_F_WILL_TELL_HOST; if the (bad) driver does not
  negotiate it, the device must assume that the guest will use silent
  deflate

- always supports silent deflate: does not need to do anything,
  current behavior works fine.  But the driver might as well propose
  VIRTIO_BALLOON_F_WILL_TELL_HOST, so that migration works fine.  (This
  is a hardware change, so it must be versioned, yadda yadda).

I can prepare a spec patch for this.


BTW, since we have in the archives an example of using silent deflate,
here is an example of non-silent deflate.  It may help understanding the
above with an actual example of a device.  Suppose a guest is using PCI
passthrough, so it has all memory pinned.

- If the guest will _not_ use silent deflate, we can unlock memory on
inflate and lock it back on deflate.  (The question is what to do if
locking fail; left for when someone actually implements this thing).

- If the guest will use silent deflate, we cannot do that.

So this is the second case above.  The device must propose
VIRTIO_BALLOON_F_WILL_TELL_HOST.  Then:

- if the guest negotiates VIRTIO_BALLOON_F_SILENT_DEFLATE,
  we cannot do the munlock/mlock

- if the guest negotiates VIRTIO_BALLOON_F_WILL_TELL_HOST,
  we can do the munlock/mlock

- if the guest does not negotiate either, the driver is buggy
  and we cannot do the munlock/mlock

Paolo
