Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1K1D3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:29:12 -0500
Received: from ozlabs.org ([203.10.76.45]:40636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1K1D3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:29:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
In-Reply-To: <20111124070728.GH29994@redhat.com>
References: <20111122183621.GA5235@redhat.com> <87hb1v1scp.fsf@rustcorp.com.au> <20111123084640.GE22734@redhat.com> <87ty5uxso3.fsf@rustcorp.com.au> <20111124070728.GH29994@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 28 Nov 2011 11:25:43 +1030
Message-ID: <87vcq5t69c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 09:11:22 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Nov 24, 2011 at 11:06:44AM +1030, Rusty Russell wrote:
> > It'll be *clearer* to have two completely separate paths than to fill
> > with if() statements.
> 
> Well, look at my patches. See how each new feature basically adds *one*
> if statement.

Which means every new feature doubles the number of paths to test.  Both
in qemu and the kernel.  And I know we're not very good at testing.

And you've still got alignment setting and guest-set ringsize to go,
which are more complex.

> Yes, we could declare all existing features to be required,
> this is what you are advocating. But in a couple of years
> more if statements have accumulated and we still don't have
> a flying car. Meanwhile the driver has a huge legacy section
> which is a huge pain to maintain.

We've only implemented one layout change in 4 years (MSI-X) with one
more definite (64-bit features).  The rate of requests is also slowing:
they mainly came from early re-implementations.

And by drawing a line under legacy mode, we don't have to test those new
options with legacy mode.

> > And a rewrite won't hurt the driver.
> 
> Wow. Is everyone going for the rewrite these days?

Ok, I'll confess that was an ill-advised comment.  The virtio-pci driver
is actually quite nice.

> And yes it will hurt, it will hurt bisectability and testability.
> What you propose is a huge patch that just changes all of it.
> If there's a breakage, bisect just points at a rewrite.

I don't have a problem with bisectability; it's great in the transition.

But you're suggesting we maintain all those different variations
forever, and that burden be on other implementations too.

> What I would like to see is incremental patches. So I would like to
> 1. Split driver config from common config
> 2. Split isr/notifications out too
> 3. Copy config in MMIO
> 4. Add a new config
> 5. Add length checks
> 6. Add 64 bit features
> 7. Add alignment programming
> 
> At each point we can bisect.  It worked well for event index, qemu had a
> flag to turn it off, each time someone came in and went 'maybe it's
> event index' we just tested without.

Ok, I would like to see this too.  But I think the intermediate stages
should be disallowed in the final patch.

> > But to be honest I don't really care about the Linux driver: we're
> > steeped in this stuff and we'll get it right.
> 
> Maybe. What about windows drivers?

Yes.  My point was: I think one big switch is easier than lots of little
ones.

> > But I'm *terrified* of making the spec more complex;
> 
> All you do is move stuff around. Why do you think it simplifies the spec
> so much?

No, but it reduces the yuk factor.  Which has been important to adoption.

And that's *not* all I do: reducing the number of options definitely
simplifies the spec.  For example, the spec should currently say
(looking at your implementation):

  Notifying the device
  ====================
  If you find a valid VIRTIO_PCI_CAP_NOTIFY_CFG capability, and you can
  map 2 bytes within it, those two bytes should be used to notify the
  device of new descriptors in its virtqueues, by writing the index of the
  virtqueue to that mapping.

  If the capability is missing or malformed or you cannot map it, the
  virtqueue index should be written to the VIRTIO_PCI_QUEUE_NOTIFY offset
  of the legacy bar.

Vs:

  Notifying the device
  ====================
  The index of the virtqueue containing new descriptors should be written
  to the location specified by the VIRTIO_PCI_CAP_NOTIFY_CFG capability.
  (Unless the device is in legacy mode, see Appendix Y: Legacy Mode).

> > I *really* want to banish the legacy stuff to an appendix where noone will
> > ever know it's there :)
> 
> This does not make life easy for implementations as they
> need to implement it anyway. What makes life easy is
> making new features optional, so you pick just what you like.

Today, that's true.  Tomorrow, it's not.

I'd like to see kvmtools remove support for legacy mode altogether, but
they probably have existing users.

And there are boutique implementations who don't care about
compatibility with older versions, but they implement virtio because
it's well specified, and clear.

> For example, we might want to backport some new feature into
> rhel6.X at some point. I would like the diff to be small,
> and easily understandable in its impact.

Sure.  And I'm determined to reduce long-term complexity.

Look, I try to be more inclusive and polite than Linus, but at some
point more verbiage is wasted.  We will have single Legacy Mode switch.
Accept it, or fork the standard.

If you want to reuse the same structure, we're going to need to figure
out how to specify the virtqueue address without a fixed alignment, and
how to specify the alignment itself.

Thanks,
Rusty.
