Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2IFJ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab2IFJ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:57:31 -0400
Message-ID: <50487382.8030303@redhat.com>
Date: Thu, 06 Sep 2012 11:57:22 +0200
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
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com>
In-Reply-To: <20120906094442.GA22816@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/09/2012 11:44, Michael S. Tsirkin ha scritto:
>> In fact, it's not clear how the driver should use the feature.  My guess
>> is that, if it wants to use silent deflate, it tries to negotiate
>> VIRTIO_BALLOON_F_MUST_TELL_HOST, and can use silent deflate if
>> negotiation fails.  This is against the logic of all other features.
> 
> Let's take a step back from the implementation details.
> You are trying to add a new feature bit, after all.
> Why? Why is silent deflate useful? This is what is
> missing in all this discussion. If it is not useful
> we do not need a bit for it.

It is useful because it lets guests inflate the balloon aggressively,
and then use ballooned-out pages even in places where the guest OS
cannot sleep, such as kmalloc(GFP_ATOMIC).

>>> Can you show a scenario with old driver/new hypervisor or
>>> new driver/old hypervisor that fails?
>
> Sorry this is not the example I asked for.  Please give and example
> without migration.
> 
> Migration is qemu's problem: it is hypervisor's job to
> make sure guest sees no change during migration.

Quoting my message: "Of course you can just teach QEMU to be smarter,
but that would be a one-off hack for the only ill-defined feature that
says something is _not_ supported".

Currently migration works the same way for all virtio devices, and
assumes that features are defined only in the "positive" direction:
drivers request features if they want to use it, devices provide
features to say they support something.

Instead, in the case of this feature, the driver requests it before
relying on its lack (which is odd); the device provides if they do not
support something (which is wrong).  You can see that this just cannot
provide backwards-compatibility in the device; it happens to work only
because the feature was there in the first version of the spec.

> It should be able to do this with any hardware it emulates,
> there should be no need to change hardware to make it
> "migrateable" somehow.

Of course, but if we can fix the hardware with no bad effects, let's do
that instead.

Paolo
