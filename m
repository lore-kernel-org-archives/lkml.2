Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2G0E1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:27:00 -0400
Received: from ozlabs.org ([203.10.76.45]:43409 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab2G0E06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:26:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <1342168731-11797-4-git-send-email-asias@redhat.com>
References: <1342168731-11797-1-git-send-email-asias@redhat.com> <1342168731-11797-4-git-send-email-asias@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 27 Jul 2012 10:03:48 +0930
Message-ID: <87d33initv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 16:38:51 +0800, Asias He <asias@redhat.com> wrote:
> Add 'virtio_blk.use_bio=1' to kernel cmdline or 'modprobe virtio_blk
> use_bio=1' to enable ->make_request_fn() based I/O path.

This patch conflicts with Paolo's Bonzini's 'virtio-blk: allow toggling
host cache between writeback and writethrough' which is also queued (see
linux-next).

I'm not sure what the correct behavior for bio & cacheflush is, if any.

But as to the patch itself: it's a hack.

1) Leaving the guest's admin to turn on the switch is a terrible choice.
2) The block layer should stop merging and sorting when a device is
   fast, not the driver.
3) I pointed out that slow disks have low IOPS, so why is this
   conditional?  Sure, more guest exits, but it's still a small number
   for a slow device.
4) The only case where we want merging is on a slow device when the host
   isn't doing it.

Now, despite this, I'm prepared to commit it.  But in my mind it's a
hack: we should aim for use_bio to be based on a feature bit fed from
the host, and use the module parameter only if we want to override it.

Cheers,
Rusty.
