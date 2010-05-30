Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0E3L0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 07:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0E3L0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 07:26:47 -0400
Date: Sun, 30 May 2010 14:22:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring
	itself
Message-ID: <20100530112220.GA27611@redhat.com>
References: <cover.1274903328.git.mst@redhat.com> <4BFF9366.5090103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFF9366.5090103@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 11:56:54AM +0200, Jes Sorensen wrote:
> On 05/26/10 21:50, Michael S. Tsirkin wrote:
> > Here's a rewrite of the original patch with a new layout.
> > I haven't tested it yet so no idea how this performs, but
> > I think this addresses the cache bounce issue raised by Avi.
> > Posting for early flames/comments.
> > 
> > Generally, the Host end of the virtio ring doesn't need to see where
> > Guest is up to in consuming the ring.  However, to completely understand
> > what's going on from the outside, this information must be exposed.
> > For example, host can reduce the number of interrupts by detecting
> > that the guest is currently handling previous buffers.
> > 
> > We add a feature bit so the guest can tell the host that it's writing
> > out the current value there, if it wants to use that.
> > 
> > This differs from original approach in that the used index
> > is put after avail index (they are typically written out together).
> > To avoid cache bounces on descriptor access,
> > and make future extensions easier, we put the ring itself at start of
> > page, and move the control after it.
> 
> Hi Michael,
> 
> It looks pretty good to me, however one thing I have been thinking of
> while reading through it:
> 
> Rather than storing a pointer within the ring struct, pointing into a
> position within the same struct. How about storing a byte offset instead
> and using a cast to get to the pointer position? That would avoid the
> pointer dereference, which is less effective cache wise and harder for
> the CPU to predict.
> 
> Not sure whether it really matters performance wise, just a thought.
> 
> Cheers,
> Jes

I think this won't work: when PUBLUSH_USED_IDX is negotiated,
the pointer is to within the ring.

-- 
MST
