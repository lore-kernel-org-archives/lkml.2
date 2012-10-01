Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2JAXWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:22:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47853 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036Ab2JAXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:22:40 -0400
Date: Mon, 1 Oct 2012 16:22:35 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121001232235.GH26488@google.com>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001231222.GB14533@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 04:12:22PM -0700, Zach Brown wrote:
> On Mon, Oct 01, 2012 at 03:23:41PM -0700, Kent Overstreet wrote:
> > So, I and other people keep running into things where we really need to
> > add an interface to pass some auxiliary... stuff along with a pread() or
> > pwrite().
> 
> Sure.  Martin (cc:ed) will sympathize.
> 
> > A few examples:
> > 
> > * IO scheduler hints...
> > * Cache hints...
> > 
> > * Passing checksums out to userspace. We've got bio integrity, which is
> > a (somewhat) generic interface for passing data checksums between the
> > filesystem and the hardware.
> 
> Hmm, careful here.  I think that in DIF/DIX the checksums are
> per-sector, not per IO, right?  That'd mean that the PAGE_SIZE attr
> limit in this patch would be magically creating different max IO size
> limits on different architectures.  That doesn't seem great.

Not just per sector, Per hardware sector. For passing around checksums
userspace would have to find out the hardware sector size and checksum
type/size via a different interface, and then the attribute would
contain a pointer to a buffer that can hold the appropriate number of
checksums.

> 
> > Hence, AIO attributes.
> 
> I have to be honest: I really don't like tying the interface to AIO, but
> I guess it's the only per-io facility we have today.  It'd be nice to
> include sync O_DIRECT when designing the interface to make sure that it
> is possible to use generic syscalls in the future without running up
> against unexpected problems. 

It'd certainly useful with regular sync IO, I just want to take it
one step at a time particularly since for sync IO we'll probably need
new syscalls.

But yes you're right, it would be good to keep in mind.

> > An iocb_attr has an id field, and a size field - and some amount of data
> > specific to that attribute.
> 
> I'd hope that we can come up with a less fragile interface.  The kernel
> would have to scan the attributes to make sure that there aren't
> malicious sizes.  I only quickly glanced at the loops, but it seemed
> like you could have a 0 size attribute in there and _next() would spin
> forever.

Ouch, yeah that's wrong :/

I don't think there's anything fragile about the basic idea though. Or
do you have some way of improving upon it in mind?

The idea with the size field is that it's just sizeof(the particular
attribute struct), so when userspace is appending attributes it just
sets size = sizeof() and attr_list->size += attr->size.

The kernel is going to have to sanity check the size fields of the
individual attributes anyways to verify the size of the last attr
doesn't extend off the end of the attr list, so I think it makes sense
to keep the current semantics of the size fields and just also check
that the size field is nonzero (actually >= sizeof(struct iocb_attr)).
