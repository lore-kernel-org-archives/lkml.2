Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab1DNUaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:30:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46158 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1DNUaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:30:10 -0400
Subject: Re: [RFC][PATCH] virtio balloon: kill tell-host-first logic
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: Amit Shah <amit.shah@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <878vvdawsa.fsf@rustcorp.com.au>
References: <20110407174325.ED21C82B@kernel>
	 <20110411110131.GA23123@redhat.com> <1302559871.7286.16749.camel@nimitz>
	 <20110412054330.GH26678@amit-x200.redhat.com>
	 <1302625352.8321.2126.camel@nimitz>  <878vvdawsa.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 14 Apr 2011 13:30:05 -0700
Message-ID: <1302813005.16562.818.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 21:07 +0930, Rusty Russell wrote:
> On Tue, 12 Apr 2011 09:22:32 -0700, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > On Tue, 2011-04-12 at 11:13 +0530, Amit Shah wrote:
> > > Sure, the only contention was on the commit message, where you stated
> > > modern qemus set this... qemu doesn't, and it should.  Care to do a
> > > patch for that? 
> > 
> > If Rusty hasn't pushed the commit out anywhere, we can still amend the
> > commit.  Otherwise, we're in a _bit_ of a pickle since you can't patch
> > git logs. :)
> 
> I only use git to send patches to Linus, and even if I did, I certainly
> wouldn't try to publish an non-rebasing tree for exactly this reason.
> 
> So send me the new commit, or just the new message...

Here's a new commit message:

--

The virtio balloon driver has a VIRTIO_BALLOON_F_MUST_TELL_HOST
feature bit.  Whenever the bit is set, the guest kernel must
always tell the host before we free pages back to the allocator.
Without this feature, we might free a page (and have another
user touch it) while the hypervisor is unprepared for it.

But, if the bit is _not_ set, we are under no obligation to
reverse the order; we're under no obligation to do _anything_.
As of now, qemu-kvm defines the bit, but doesn't set it.

This patch makes the "tell host first" logic the only case.  This
should make everybody happy, and reduce the amount of untested or
untestable code in the kernel.

This _also_ means that we don't have to preserve a pfn list
after the pages are freed, which should let us get rid of some
temporary storage (vb->pfns) eventually.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>


