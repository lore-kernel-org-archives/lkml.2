Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2LMC6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:58:02 -0500
Received: from gate.crashing.org ([63.228.1.57]:44145 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab2LMC6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:58:00 -0500
Message-ID: <1355367458.19932.84.camel@pasglop>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 13 Dec 2012 13:57:38 +1100
In-Reply-To: <1355355035.3224.343.camel@bling.home>
References: <1354901926.3224.96.camel@bling.home>
	 <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
	 <1355355035.3224.343.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 16:30 -0700, Alex Williamson wrote:
> Locked page accounting in this version is very, very broken.  How do
> powerpc folks feel about seemingly generic kernel iommu interfaces
> messing with the current task mm?  Besides that, more problems
> below...

After a second look & thought...

This whole accounting business is fucked. First, we simply can't just
randomly return errors from H_PUT_TCE because the process reached some
rlimit. This is not a proper failure mode. That means that the guest
will probably panic() ... possibly right in the middle of some disk
writeback or god knows what. Not good.

Also the overhead of doing all that crap on every TCE map/unmap is
ridiculous.

Finally, it's just not going to work for real mode which we really want,
since we can't take the mmap-sem in real mode anyway, so unless we
convert that counter to an atomic, we can't do it.

I'd suggest just not bothering, or if you want to bother, check once
when creating a TCE table that the rlimit is enough to bolt as many
pages as can be populated in that table and fail to create *that*. The
failure mode is much better, ie, qemu failing to create a PCI bus due to
insufficient rlimits.

Cheers,
Ben.


