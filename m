Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1KAMfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:35:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1KAMfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:35:24 -0400
Subject: Re: [PULL] virtio
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <20111101114542.GA13434@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 01 Nov 2011 14:33:33 +0200
Message-ID: <1320150813.3847.24.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 13:45 +0200, Michael S. Tsirkin wrote:
> On Tue, Nov 01, 2011 at 10:39:08AM +1030, Rusty Russell wrote:
> >  * [new tag]         rusty@rustcorp.com.au-v3.1-7196-gac5be1e -> rusty@rustcorp.com.au-v3.1-7196-gac5be1e
> > 
> > The following changes since commit 839d8810747bbf39e0a5a7f223b67bffa7945f8d:
> > 
> >   Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-10-30 15:54:59 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://github.com/rustyrussell/linux.git master
> > 
> > Alexey Kardashevskiy (1):
> >       virtio-pci: Use PCI MMIO instead of PIO when available
> 
> I missed this one - wasn't Cc'd neither me, kvm or virtio mailing lists.
> 
> It's well known that mmio is much slower than pio on kvm, since
> mmio needs to be emulated to get at the address.
> So I'm expecting this will cause a performance regression.
> IMO we should keep using PIO for VQ and interrupt status access
> if PIO is available.
> 
> Another consideration is that in an attempt to pack data
> densely in the PIO space the layout became messy.
> It would be better to have common config space and
> per-device config space in separate pages, possibly
> with padding between them.
> 
> So I'd like a bit more discussion on this patch,
> I'm concerned that if this is released in 3.2 as is we'll
> have to support this forever. How about a revert for now?

Another thing, the patch tries to map BAR 2 and use it as the
configuration space.

It's both not documented properly anywhere, and is not fully backwards
compatible - we currently use BAR 2 as part of our MSIX handling in the
kvm tool and I'm sure we're not the only ones to assume virtio-pci only
uses BAR 0.

A proper solution would be for example a configuration in the PIO config
space which points to the MMIO BAR to use instead.

Unless Michael pointed this patch out, it would have broken (at least)
the kvm tool in a non obvious way which would require a rather long
session of 'git bisect' to figure out whats wrong.

-- 

Sasha.

