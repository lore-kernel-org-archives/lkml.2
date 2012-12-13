Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2LMDWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:22:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2LMDWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:22:46 -0500
Message-ID: <1355368956.3224.357.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date: Wed, 12 Dec 2012 20:22:36 -0700
In-Reply-To: <1355367458.19932.84.camel@pasglop>
References: <1354901926.3224.96.camel@bling.home>
	 <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
	 <1355355035.3224.343.camel@bling.home> <1355367458.19932.84.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 13:57 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2012-12-12 at 16:30 -0700, Alex Williamson wrote:
> > Locked page accounting in this version is very, very broken.  How do
> > powerpc folks feel about seemingly generic kernel iommu interfaces
> > messing with the current task mm?  Besides that, more problems
> > below...
> 
> After a second look & thought...
> 
> This whole accounting business is fucked. First, we simply can't just
> randomly return errors from H_PUT_TCE because the process reached some
> rlimit. This is not a proper failure mode. That means that the guest
> will probably panic() ... possibly right in the middle of some disk
> writeback or god knows what. Not good.
> 
> Also the overhead of doing all that crap on every TCE map/unmap is
> ridiculous.
> 
> Finally, it's just not going to work for real mode which we really want,
> since we can't take the mmap-sem in real mode anyway, so unless we
> convert that counter to an atomic, we can't do it.
> 
> I'd suggest just not bothering, or if you want to bother, check once
> when creating a TCE table that the rlimit is enough to bolt as many
> pages as can be populated in that table and fail to create *that*. The
> failure mode is much better, ie, qemu failing to create a PCI bus due to
> insufficient rlimits.

I agree, we don't seem to be headed in the right direction.  x86 needs
to track rlimits or else a user can exploit the interface to pin all the
memory in the system.  On power, only the iova window can be pinned, so
it's a fixed amount.  I could see it as granting access to a group
implicitly grants access to pinning the iova window.  We can still make
it more explicit by handling the rlimit accounting upfront.  Thanks,

Alex

