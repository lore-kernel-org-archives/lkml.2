Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0ETOel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:34:41 -0400
Received: from ozlabs.org ([203.10.76.45]:56576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab0ETOek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:34:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into ring itself
Date: Fri, 21 May 2010 00:04:28 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <4BF4DE28.2080103@redhat.com>
In-Reply-To: <4BF4DE28.2080103@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005210004.29670.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 04:30:56 pm Avi Kivity wrote:
> On 05/20/2010 08:01 AM, Rusty Russell wrote:
> >
> >> A device with out of order
> >> completion (like virtio-blk) will quickly randomize the unused
> >> descriptor indexes, so every descriptor fetch will require a bounce.
> >>
> >> In contrast, if the rings hold the descriptors themselves instead of
> >> pointers, we bounce (sizeof(descriptor)/cache_line_size) cache lines for
> >> every descriptor, amortized.
> >>      
> > We already have indirect, this would be a logical next step.  So let's
> > think about it. The avail ring would contain 64 bit values, the used ring
> > would contain indexes into the avail ring.
> 
> Have just one ring, no indexes.  The producer places descriptors into 
> the ring and updates the head,  The consumer copies out descriptors to 
> be processed and copies back in completed descriptors.  Chaining is 
> always linear.  The descriptors contain a tag that allow the producer to 
> identify the completion.

This could definitely work.  The original reason for the page boundaries
was for untrusted inter-guest communication: with appropriate page protections
they could see each other's rings and a simply inter-guest copy hypercall
could verify that the other guest really exposed that data via virtio ring.

But, cute as that is, we never did that.  And it's not clear that it wins
much over simply having the hypervisor read both rings directly.

> > Can we do better?  The obvious idea is to try to get rid of last_used and
> > used, and use the ring itself.  We would use an invalid entry to mark the
> > head of the ring.
> 
> Interesting!  So a peer will read until it hits a wall.  But how to 
> update the wall atomically?
> 
> Maybe we can have a flag in the descriptor indicate headness or 
> tailness.  Update looks ugly though: write descriptor with head flag, 
> write next descriptor with head flag, remove flag from previous descriptor.

I was thinking a separate magic "invalid" entry.  To publish an 3 descriptor
chain, you would write descriptors 2 and 3, write an invalid entry at 4,
barrier, write entry 1.  It is a bit ugly, yes, but not terrible.

I think that a simple simulator for this is worth writing, which tracks
cacheline moves under various fullness scenarios...

Cheers,
Rusty.
