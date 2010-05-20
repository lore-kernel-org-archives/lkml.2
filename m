Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0ETFB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 01:01:58 -0400
Received: from ozlabs.org ([203.10.76.45]:51304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0ETFB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 01:01:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into ring itself
Date: Thu, 20 May 2010 14:31:50 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com> <201005191709.16401.rusty@rustcorp.com.au> <4BF39C12.7090407@redhat.com>
In-Reply-To: <4BF39C12.7090407@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005201431.51142.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 05:36:42 pm Avi Kivity wrote:
> > Note that this is a exclusive->shared->exclusive bounce only, too.
> >    
> 
> A bounce is a bounce.

I tried to measure this to show that you were wrong, but I was only able
to show that you're right.  How annoying.  Test code below.

> Virtio is already way too bouncy due to the indirection between the 
> avail/used rings and the descriptor pool.

I tried to do a more careful analysis below, and I think this is an
overstatement.

> A device with out of order 
> completion (like virtio-blk) will quickly randomize the unused 
> descriptor indexes, so every descriptor fetch will require a bounce.
> 
> In contrast, if the rings hold the descriptors themselves instead of 
> pointers, we bounce (sizeof(descriptor)/cache_line_size) cache lines for 
> every descriptor, amortized.

We already have indirect, this would be a logical next step.  So let's
think about it. The avail ring would contain 64 bit values, the used ring
would contain indexes into the avail ring.

So client writes descriptor page and adds to avail ring, then writes to
index.  Server reads index, avail ring, descriptor page (3).  Writes used
entry (1).  Updates last_used (1).  Client reads used (1), derefs avail (1),
updates last_used (1), cleans descriptor page (1).

That's 9 cacheline transfers, worst case.  Best case of a half-full ring
in steady state, assuming 128-byte cache lines, the avail ring costs are
1/16, the used entry is 1/64.  This drops it to 6 and 9/64 transfers.

(Note, the current scheme adds 2 more cacheline transfers, for the descriptor
table, worst case.  Assuming indirect, we get 2/8 xfer best case.  Either way,
it's not the main source of cacheline xfers).

Can we do better?  The obvious idea is to try to get rid of last_used and
used, and use the ring itself.  We would use an invalid entry to mark the
head of the ring.

Any other thoughts?
Rusty.
