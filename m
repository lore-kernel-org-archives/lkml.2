Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1LAIJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:09:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1LAIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:09:50 -0500
Message-ID: <1322726977.3259.3.camel@lappy>
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Date: Thu, 01 Dec 2011 10:09:37 +0200
In-Reply-To: <20111201075847.GA5479@redhat.com>
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
	 <20111129125622.GB19157@redhat.com> <1322573688.4395.11.camel@lappy>
	 <20111129135406.GB30966@redhat.com> <1322576464.7003.6.camel@lappy>
	 <20111129145451.GD30966@redhat.com> <4ED4F30F.8000603@redhat.com>
	 <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au>
	 <20111201075847.GA5479@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 09:58 +0200, Michael S. Tsirkin wrote:
> On Thu, Dec 01, 2011 at 01:12:25PM +1030, Rusty Russell wrote:
> > On Wed, 30 Nov 2011 18:11:51 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > > On Tue, 2011-11-29 at 16:58 +0200, Avi Kivity wrote:
> > > > On 11/29/2011 04:54 PM, Michael S. Tsirkin wrote:
> > > > > > 
> > > > > > Which is actually strange, weren't indirect buffers introduced to make
> > > > > > the performance *better*? From what I see it's pretty much the
> > > > > > same/worse for virtio-blk.
> > > > >
> > > > > I know they were introduced to allow adding very large bufs.
> > > > > See 9fa29b9df32ba4db055f3977933cd0c1b8fe67cd
> > > > > Mark, you wrote the patch, could you tell us which workloads
> > > > > benefit the most from indirect bufs?
> > > > >
> > > > 
> > > > Indirects are really for block devices with many spindles, since there
> > > > the limiting factor is the number of requests in flight.  Network
> > > > interfaces are limited by bandwidth, it's better to increase the ring
> > > > size and use direct buffers there (so the ring size more or less
> > > > corresponds to the buffer size).
> > > > 
> > > 
> > > I did some testing of indirect descriptors under different workloads.
> > 
> > MST and I discussed getting clever with dynamic limits ages ago, but it
> > was down low on the TODO list.  Thanks for diving into this...
> > 
> > AFAICT, if the ring never fills, direct is optimal.  When the ring
> > fills, indirect is optimal (we're better to queue now than later).
> > 
> > Why not something simple, like a threshold which drops every time we
> > fill the ring?
> > 
> > struct vring_virtqueue
> > {
> > ...
> >         int indirect_thresh;
> > ...
> > }
> > 
> > virtqueue_add_buf_gfp()
> > {
> > ...
> > 
> >         if (vq->indirect &&
> >             (vq->vring.num - vq->num_free) + out + in > vq->indirect_thresh)
> >                 return indirect()
> > ...
> > 
> > 	if (vq->num_free < out + in) {
> >                 if (vq->indirect && vq->indirect_thresh > 0)
> >                         vq->indirect_thresh--;
> >         
> > ...
> > }
> > 
> > Too dumb?
> > 
> > Cheers,
> > Rusty.
> 
> We'll presumably need some logic to increment is back,
> to account for random workload changes.
> Something like slow start?

We can increment it each time the queue was less than 10% full, it
should act like slow start, no?

-- 

Sasha.

