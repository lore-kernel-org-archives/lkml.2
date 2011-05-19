Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab1ESHYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab1ESHYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:24:40 -0400
Date: Thu, 19 May 2011 10:24:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCH 14/18] virtio: add api for delayed callbacks
Message-ID: <20110519072412.GA31253@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
 <64d47c628b3fdc0ac156aed4be182933d8bcc0db.1304541919.git.mst@redhat.com>
 <871v08h0vm.fsf@rustcorp.com.au>
 <20110515124818.GD24932@redhat.com>
 <87boz3dsoe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87boz3dsoe.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 04:43:21PM +0930, Rusty Russell wrote:
> On Sun, 15 May 2011 15:48:18 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, May 09, 2011 at 03:27:33PM +0930, Rusty Russell wrote:
> > > On Wed, 4 May 2011 23:52:33 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > Add an API that tells the other side that callbacks
> > > > should be delayed until a lot of work has been done.
> > > > Implement using the new used_event feature.
> > > 
> > > Since you're going to add a capacity query anyway, why not add the
> > > threshold argument here?
> > 
> > I thought that if we keep the API kind of generic
> > there might be more of a chance that future transports
> > will be able to implement it. For example, with an
> > old host we can't commit to a specific index.
> 
> No, it's always a hint anyway: you can be notified before the threshold
> is reached.  But best make it explicit I think.
> 
> Cheers,
> Rusty.


I tried doing that and remembered the real reason I went for this API:

capacity is limited by descriptor table space, not
used ring space: each entry in the used ring frees up multiple entries
in the descriptor ring. Thus the ring can't provide
callback after capacity is N: capacity is only available
after we get bufs.

We could try and make the API pass in the number of freed bufs, however:
- this is not really what virtio-net cares about (it cares about
  capacity)
- if the driver passes a number > number of outstanding bufs, it will
  never get a callback. So to stay correct the driver will need to
  track number of outstanding requests. The simpler API avoids that. 


APIs are easy to change so I'm guessing it's not a major blocker:
we can change later when e.g. block tries to
pass in some kind of extra hint: we'll be smarter
about how this API can change then.

Right?

-- 
MST
