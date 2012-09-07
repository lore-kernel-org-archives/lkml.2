Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2IGDaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:30:15 -0400
Received: from ozlabs.org ([203.10.76.45]:54079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759266Ab2IGDaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:30:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
In-Reply-To: <20120907002533.GB16360@google.com>
References: <20120903044133.GA9980@moria.home.lan> <87wr0ae26e.fsf@rustcorp.com.au> <20120906074113.GA5902@koverstreet-glaptop> <20120906084403.GD17656@redhat.com> <20120906092512.GB5902@koverstreet-glaptop> <20120906094956.GB22816@redhat.com> <20120906100247.GA27355@koverstreet-glaptop> <87zk52hg9i.fsf@rustcorp.com.au> <20120907002533.GB16360@google.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 07 Sep 2012 12:27:18 +0930
Message-ID: <874nnah75d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:
> On Fri, Sep 07, 2012 at 09:10:25AM +0930, Rusty Russell wrote:
>> Kent Overstreet <koverstreet@google.com> writes:
>> 
>> > On Thu, Sep 06, 2012 at 12:49:56PM +0300, Michael S. Tsirkin wrote:
>> >> On Thu, Sep 06, 2012 at 02:25:12AM -0700, Kent Overstreet wrote:
>> >> > Do you not understand the difference between depends an selects?
>> >> > Or did you not read my original mail?
>> 
>> Now you're getting insulting.
>
> Yes, but at least I'm not being intentionally obtuse.

Insulting again.  Wow.

It took me this long to understand your complaint.  Perhaps I'm stupid.
Or perhaps you are terrible at explaining yourself, and it is only
through our patient and heroic efforts that we can comprehend you at
all?

> Think about it from the user's pov. They check what VIRTIO_BLK depends
> on - just VIRTIO.
>
> So they try to figure out how to flip on VIRTIO, or what VIRTIO even is.
>
> See how that last step might be problematic? CONFIG_VIRTIO is not
> exposed! It doesn't even seem to control anything!
>
> Go back to your example. Checking the dependencies for E1000 would tell
> you the user needs to flip on CONFIG_PCI. Done. Easy.

Actually, it depends on NET_VENDOR_INTEL which depends on CONFIG_PCI,
but yes, it's discoverable.

So your actual complaint is that:
1) CONFIG_VIRTIO is misleadingly documented both in comment and name.
2) It's not discoverable, since it's only selected via other things.

> And, if that is what you're doing with CONFIG_VIRTIO (I'm still not
> sure) the comment at the top of drivers/virtio/Kconfig is _wrong_:

As grep would show you, it's selected by LGUEST, S390_GUEST, RPMSG,
VIRTIO_PCI and VIRTIO_MMIO (VIRTIO_BALLOON is a cut & paste bug, already
patched by MST).

We could change every virtio device to depend on (CONFIG_LGUEST |
CONFIG_S390_GUEST | CONFIG_RPMSG | CONFIG_VIRTIO_PCI |
CONFIG_VIRTIO_MMIO), which is more discoverable but uglier.  How's this
workaround?

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: virtio: add help to CONFIG_VIRTIO option.

Trying to enable a virtio driver (eg CONFIG_VIRTIO_BLK) is painful
because it depends on CONFIG_VIRTIO.  CONFIG_VIRTIO doesn't tell you
how to turn it on (it's selected from anything which provides a virtio
bus).

This patch at least adds some documentation, visible in menuconfig, as
a hint.

Reported-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -1,8 +1,10 @@
-# Virtio always gets selected by whoever wants it.
 config VIRTIO
 	tristate
+	---help---
+	  This option is selected by any driver which implements the virtio
+	  bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_LGUEST,
+	  CONFIG_RPMSG or CONFIG_S390_GUEST.
 
-# Similarly the virtio ring implementation.
 config VIRTIO_RING
 	tristate
 	depends on VIRTIO
