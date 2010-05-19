Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0ESHjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:39:21 -0400
Received: from ozlabs.org ([203.10.76.45]:56506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab0ESHjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:39:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into ring itself
Date: Wed, 19 May 2010 17:09:15 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com> <201005071253.53393.rusty@rustcorp.com.au> <4BE9AF9A.8080005@redhat.com>
In-Reply-To: <4BE9AF9A.8080005@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005191709.16401.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 04:57:22 am Avi Kivity wrote:
> On 05/07/2010 06:23 AM, Rusty Russell wrote:
> > On Thu, 6 May 2010 07:30:00 pm Avi Kivity wrote:
> >    
> >> On 05/05/2010 11:58 PM, Michael S. Tsirkin wrote:
> >>      
> >>> +	/* We publish the last-seen used index at the end of the available ring.
> >>> +	 * It is at the end for backwards compatibility. */
> >>> +	vr->last_used_idx =&(vr)->avail->ring[num];
> >>> +	/* Verify that last used index does not spill over the used ring. */
> >>> +	BUG_ON((void *)vr->last_used_idx +
> >>> +	       sizeof *vr->last_used_idx>   (void *)vr->used);
> >>>    }
> >>>
> >>>        
> >> Shouldn't this be on its own cache line?
> >>      
> > It's next to the available ring; because that's where the guest publishes
> > its data.  That whole page is guest-write, host-read.
> >
> > Putting it on a cacheline by itself would be a slight pessimization; the host
> > cpu would have to get the last_used_idx cacheline and the avail descriptor
> > cacheline every time.  This way, they are sometimes the same cacheline.
> 
> If one peer writes the tail of the available ring, while the other reads 
> last_used_idx, it's a false bounce, no?

I think we're talking about the last 2 entries of the avail ring.  That means
the worst case is 1 false bounce every time around the ring.  I think that's
why we're debating it instead of measuring it :)

Note that this is a exclusive->shared->exclusive bounce only, too.

Cheers,
Rusty.
