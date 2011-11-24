Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1KXC3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:29:42 -0500
Received: from ozlabs.org ([203.10.76.45]:55648 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1KXC3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:29:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv3 RFC] virtio-pci: flexible configuration layout
In-Reply-To: <1322041120.3581.6.camel@lappy>
References: <20111122183621.GA5235@redhat.com> <87hb1v1scp.fsf@rustcorp.com.au>  <20111123084932.GF22734@redhat.com> <1322041120.3581.6.camel@lappy>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 24 Nov 2011 11:37:26 +1030
Message-ID: <87r50yxr8x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 11:38:40 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Wed, 2011-11-23 at 10:49 +0200, Michael S. Tsirkin wrote:
> > On Wed, Nov 23, 2011 at 01:02:22PM +1030, Rusty Russell wrote:
> > > +/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> > > +struct virtio_pci_common_cfg {
> > > +	/* About the whole device. */
> > > +	__u64 device_features;	/* read-only */
> > > +	__u64 guest_features;	/* read-write */
> > 
> > We currently require atomic accesses to common fields.
> > Some architectures might not have such for 64 bit,
> > so these need to be split I think ...
> 
> We can consider stealing the feature implementation from virtio-mmio:
> Use the first 32 bits as a selector and the last as the features
> themselves.
> 
> It's more complex to work with, but it provides 2**32 32 feature bits
> (which should be enough for a while) and it solves the atomic access
> issue.

That works.  I don't expect we'll need more than 64 features given that
virtio_net hasn't seen a new one in over a year, but it's gone from 5 to
18 in 4 years, so another 32 bits at that rate only gets us another decade.

Unfortunately, it doesn't solve the queue_address problem.

We currently multiply the (32-bit) address by 4096 (the alignment).  If
drivers are going to reduce alignment, that makes it trickier, hence the
change here to a 64.  Simplicity.

We could cheat and assert that a 32-bit write there implies 0 in the
upper bits, and hope that all 64 bit platforms can do a 64-bit atomic
write.  Or insist the value not be intepreted until the guest writes its
(first) feature bit.

Perhaps we really need a "I'm done configuring!" trigger, now we can't
use the feature bit field for that.

Thoughts welcome...
Rusty.
