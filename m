Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1GCPM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 11:12:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1GCPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 11:12:53 -0400
Subject: Re: [PATCH] virtio_balloon: Notify guest only after deflating the
 balloon
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        dave@linux.vnet.ibm.com, Amit Shah <amit.shah@redhat.com>,
        Pekka Enberg <penberg@kernel.org>
In-Reply-To: <20110703134439.GA22493@redhat.com>
References: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com>
	 <20110703082748.GD13183@redhat.com> <1309686419.2250.8.camel@sasha>
	 <20110703103051.GA15537@redhat.com> <1309690349.2250.21.camel@sasha>
	 <20110703121137.GA15826@redhat.com> <1309696356.2250.31.camel@sasha>
	 <20110703134439.GA22493@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 03 Jul 2011 18:12:41 +0300
Message-ID: <1309705961.2250.36.camel@sasha>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-03 at 16:44 +0300, Michael S. Tsirkin wrote:
> On Sun, Jul 03, 2011 at 03:32:36PM +0300, Sasha Levin wrote:
> > On Sun, 2011-07-03 at 15:11 +0300, Michael S. Tsirkin wrote:
> > > On Sun, Jul 03, 2011 at 01:52:29PM +0300, Sasha Levin wrote:
> > > > On Sun, 2011-07-03 at 13:30 +0300, Michael S. Tsirkin wrote:
> > > > > On Sun, Jul 03, 2011 at 12:46:59PM +0300, Sasha Levin wrote:
> > > > > > On Sun, 2011-07-03 at 11:27 +0300, Michael S. Tsirkin wrote:
> > > > > > > Doesn't this basically just revert
> > > > > > > bf50e69f63d21091e525185c3ae761412be0ba72?
> > > > > > > 
> > > > > > 
> > > > > > Yes. I haven't noticed that commit.
> > > > > > 
> > > > > > Ignoring the VIRTIO_BALLOON_F_MUST_TELL_HOST feature flag causes an
> > > > > > unnecessary delay due to having to kick and wait for the host to process
> > > > > > the deflate vq before actually using the memory pages.
> > > > > 
> > > > > OTOH, as the commit points out:
> > > > > 	Without this feature, we might free a page (and have another
> > > > > 	user touch it) while the hypervisor is unprepared for it
> > > > > 
> > > > > Are you doing so many deflates that the speed is important?
> > > > > 
> > > > 
> > > > In the case of kvm tools and qemu for example, the hypervisor doesn't
> > > > need to be 'prepared' for it.
> > > > 
> > > > When the balloon if inflated, the pages are madvise(MADV_DONTNEED),
> > > > which means that we can access those pages immediately when deflating
> > > > without having to do anything special to prepare for it.
> > > > 
> > > > I'm not saying that speed is critical here, I'm just saying that the
> > > > feature was added to the spec for a reason - to prevent unnecessary
> > > > overhead like in the case of kvm tools and qemu, and we just choose to
> > > > ignore it completely.
> > > > 
> > > > > > I've stumbled on it when writing the virtio_balloon driver for kvm
> > > > > > tools. Initially my plan was to ignore the deflate vq completely, since
> > > > > > the virtio spec says that unless we set the MUST_TELL_HOST flag,
> > > > > > "deflation advice is merely a courtesy".
> > > > > > 
> > > > > > I've noticed that if I don't process the deflate vq the guest doesn't
> > > > > > use the deflated pages at all - something which contradicts the feature
> > > > > > that lets him use the deflated pages without waiting for the deflate vq.
> > > > > 
> > > > > OK, so you have a host that does not process the vq.
> > > > > As a result tell_host blocks forever.
> > > > > With your patch, guest will block after releasing the
> > > > > page, so the next deflate request will get stuck.
> > > > > This doesn't seem to be a huge improvement so
> > > > > we can conclude such a host is broken?
> > > > > 
> > > > 
> > > > No, the host is not doing anything wrong by not processing deflate vq.
> > > > 
> > > > This just leads me to believe that we should either not notify the host,
> > > > or not wait_for_completion() when telling the host.
> > > 
> > > Interesting. The spec says
> > > 
> > > (a) The driver constructs an array of addresses of memory pages it has
> > > previously given to the balloon, as described above. This descriptor
> > > is added to the deflateq.
> > > (b) If the VIRTIO_BALLOON_F_MUST_TELL_HOST feature is set,
> > > the guest may not use these requested pages until that descriptor in
> > > the deflateq has been used by the device.
> > > (c) Otherwise, the guest may begin to re-use pages previously given to
> > > the balloon before the device has acknowledged their withdrawl.
> > >  21 In this case, deflation advice is merely a courtesy
> > > 
> > > This does not discuss the following issue: what happens
> > > if the device never uses the descriptor in the deflateq
> > > and VIRTIO_BALLOON_F_MUST_TELL_HOST is not set?
> > > 
> > > Rusty, any comments?
> > > 
> > > As far as I can tell, linux drivers assume that
> > > devices acknowledge all descriptors, and did this
> > > from the very beginning, so if you want the
> > > device not to process that queue at all,
> > > you will probably need a new flag for this rather than reuse
> > > MUST_TELL_HOST.
> > > 
> > 
> > There are 2 questions here:
> > 
> > One is whether devices should acknowledge all descriptors. I agree with
> > what you said that if the assumption was that devices should acknowledge
> > all descriptors I should definitely work on processing deflate vq (maybe
> > then it's also worth a note in the spec to make it more than an
> > assumption).
> 
> It's not by design but it seems to be required for existing drivers to
> work, so a historical note would be in place, yes. Spec patch?
> 
> > The other is whether we should wait for the balloon device to
> > acknowledge deflated pages before using them with MUST_TELL_HOST not
> > set. Even if I do acknowledge deflate vq descriptors, I may want to do
> > it at set intervals (say once a minute for example) - theres no reason
> > for deflation to stall until this processing occurs.
> 
> Well, it seems that if you process descriptors very slowly guest
> driver will get stuck for a while, with or without this patch.
> Can you present a convincing argument why batching deflate
> descriptors in this way makes sense?
> 

It'll be slow with this patch, but as I said above - This patch is
probably wrong. The right patch should either avoid telling the host or
shouldn't wait for an answer from the host.
The real reason behind it is just following the specs. If we choose to
leave it this way we can just go ahead and remove MUST_TELL_HOST.

> It seems that this all started because the kvm tool didn't
> process deflate vq at all. Assuming it gains this processing,
> is some other reason left?
> 

There wasn't any real kvm tools issue there, I've added the deflate vq
handling immediately - I just wanted to see why the balloon driver
doesn't behave like it was described in the specs.

> > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > > > 
> > > > > > > On Sat, Jul 02, 2011 at 06:06:56AM +0300, Sasha Levin wrote:
> > > > > > > > Unless the host requires that requested pages won't be used until
> > > > > > > > he us notified (VIRTIO_BALLOON_F_MUST_TELL_HOST), only notify after
> > > > > > > > deflating the balloon.
> > > > > > > > 
> > > > > > > > This will avoid having to take an exit before actually using the pages.
> > > > > > > > 
> > > > > > > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > > > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > > > > Cc: virtualization@lists.linux-foundation.org
> > > > > > > > Cc: kvm@vger.kernel.org
> > > > > > > > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > > > > > > > ---
> > > > > > > >  drivers/virtio/virtio_balloon.c |   16 ++++++++++------
> > > > > > > >  1 files changed, 10 insertions(+), 6 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > > > > > index e058ace..055f95d 100644
> > > > > > > > --- a/drivers/virtio/virtio_balloon.c
> > > > > > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > > > > > @@ -148,14 +148,18 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
> > > > > > > >  		vb->num_pages--;
> > > > > > > >  	}
> > > > > > > >  
> > > > > > > > -
> > > > > > > >  	/*
> > > > > > > > -	 * Note that if
> > > > > > > > -	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
> > > > > > > > -	 * is true, we *have* to do it in this order
> > > > > > > > +	 * If the host doesn't require us to notify him before using
> > > > > > > > +	 * pages which belong to the balloon, update him only after
> > > > > > > > +	 * freeing those pages for guest use.
> > > > > > > >  	 */
> > > > > > > > -	tell_host(vb, vb->deflate_vq);
> > > > > > > > -	release_pages_by_pfn(vb->pfns, vb->num_pfns);
> > > > > > > > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST)) {
> > > > > > > > +		tell_host(vb, vb->deflate_vq);
> > > > > > > > +		release_pages_by_pfn(vb->pfns, vb->num_pfns);
> > > > > > > > +	} else {
> > > > > > > > +		release_pages_by_pfn(vb->pfns, vb->num_pfns);
> > > > > > > > +		tell_host(vb, vb->deflate_vq);
> > > > > > > > +	}
> > > > > > > >  }
> > > > > > > >  
> > > > > > > >  static inline void update_stat(struct virtio_balloon *vb, int idx,
> > > > > > > > -- 
> > > > > > > > 1.7.6
> > > > > > 
> > > > > > 
> > > > > > -- 
> > > > > > 
> > > > > > Sasha.
> > > > 
> > > > 
> > > > -- 
> > > > 
> > > > Sasha.
> > 
> > 
> > -- 
> > 
> > Sasha.


-- 

Sasha.

