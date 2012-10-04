Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2JDBYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:24:19 -0400
Received: from ozlabs.org ([203.10.76.45]:46029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2JDBYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:24:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] virtio-net: correct capacity math on ring full
In-Reply-To: <f2f7123534aefb33a7a233d9fec56de6e9eeed73.1348824232.git.mst@redhat.com>
References: <cover.1348824232.git.mst@redhat.com> <f2f7123534aefb33a7a233d9fec56de6e9eeed73.1348824232.git.mst@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 04 Oct 2012 09:54:01 +0930
Message-ID: <878vbn2ify.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Capacity math on ring full is wrong: we are
> looking at num_sg but that might be optimistic
> because of indirect buffer use.
>
> The implementation also penalizes fast path
> with extra memory accesses for the benefit of
> ring full condition handling which is slow path.
>
> It's easy to query ring capacity so let's do just that.

This path will reduce the actual queue use to worst-case assumptions.
With bufferbloat maybe that's a good thing, but it's true.

If we do this, the code is now wrong:

	/* This can happen with OOM and indirect buffers. */
	if (unlikely(capacity < 0)) {

Because this should now *never* happen.

But I do like the cleanup; returning capacity from add_buf() was always
hacky.  I've got an idea, we'll see what it looks like...

Cheers,
Rusty.
