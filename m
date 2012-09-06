Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2IFJYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab2IFJYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:24:12 -0400
Message-ID: <50486BB2.7070108@redhat.com>
Date: Thu, 06 Sep 2012 11:24:02 +0200
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
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com>
In-Reply-To: <20120906084736.GF17656@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 10:47, Michael S. Tsirkin ha scritto:
>> > - a migration from non-MUST_TELL_HOST to MUST_TELL_HOST will succeed,
>> > which is wrong;
>> > 
>> > - a migration from MUST_TELL_HOST to non-MUST_TELL_HOST will fail, which
>> > is useless.
>> > 
>> > Add instead a new feature VIRTIO_BALLOON_F_SILENT_DEFLATE, and deprecate
>> > VIRTIO_BALLOON_F_MUST_TELL_HOST since it is never actually used.
>> > 
>> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Frankly I think it's a qemu migration bug. I don't see why
> we need to tweak spec: just teach qemu to be smarter
> during migration.

Of course you can just teach QEMU to be smarter, but that would be a
one-off hack for the only ill-defined feature that says something is
_not_ supported.  Since in practice all virtio_balloon-enbled
hypervisors supported silent deflate (so the bit was always zero), and
no client used it (so it was never checked), it's easier to just reverse
the direction.

In fact, it's not clear how the driver should use the feature.  My guess
is that, if it wants to use silent deflate, it tries to negotiate
VIRTIO_BALLOON_F_MUST_TELL_HOST, and can use silent deflate if
negotiation fails.  This is against the logic of all other features.

> Can you show a scenario with old driver/new hypervisor or
> new driver/old hypervisor that fails?

Suppose the driver tried to negotiate the feature as above.  We then
have the two scenarios above.

In the harmless but annoying scenario, the source hypervisor doesn't
support silent deflate, so VIRTIO_BALLOON_F_MUST_TELL_HOST has been
negotiated successfully.  The destination hypervisor supports silent
deflate, so it does _not_ include the feature.  It sees that the guest
requests VIRTIO_BALLOON_F_MUST_TELL_HOST, and fails migration.

In the incorrect scenario, you are migrating to an older hypervisor.
The source hypervisor is newer and supports silent deflate, so
VIRTIO_BALLOON_F_MUST_TELL_HOST was _not_ negotiated.  The destination
hypervisor does not supports silent deflate.  However, the guest is not
requesting VIRTIO_BALLOON_F_MUST_TELL_HOST, and migration succeeds.
Next time the guest tries to do use a page from the balloon, badness
happens, because the hypervisor does not expect it.

Paolo
