Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2BHXKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:10:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab2BHXKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:10:49 -0500
Date: Wed, 8 Feb 2012 15:10:17 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Roland Dreier <roland@kernel.org>
cc: linux-rdma@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages()
 parameters
In-Reply-To: <alpine.LSU.2.00.1202071225250.2024@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202081446110.1320@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org> <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com> <alpine.LSU.2.00.1201271458130.3402@eggly.anvils>
 <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA@mail.gmail.com> <alpine.LSU.2.00.1201301217530.4505@eggly.anvils> <CAL1RGDVSBb1DVsfvuz=ijRZX06crsqQfKoXWJ+6FO4xi3aYyTg@mail.gmail.com> <alpine.LSU.2.00.1202071225250.2024@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Hugh Dickins wrote:
> On Mon, 6 Feb 2012, Roland Dreier wrote:
> > Which I think explains why the code is the way it is.  But clearly
> > we could do better if we had a better way of telling GUP our real
> > intentions -- ie the FOLL_READONLY_COW flag.
> 
> You've persuaded me.  Yes, you have been using force because that was
> the only tool available at the time, to get close to the sensible
> behaviour you are now asking for.
> 
> > 
> > > Can you, for example, enforce the permissions set up by the user?
> > > I mean, if they do the ibv_reg_mr() on a private readonly area,
> > > so __get_user_pages with the FOLL_APPROPRIATELY flag will fault
> > > in ZERO_PAGEs, can you enforce that RDMA will never spray data
> > > into those pages?
> > 
> > Yes, the access flags passed into ibv_reg_mr() are enforced by
> > the RDMA hardware, so if no write access is request, no write
> > access is possible.
> 
> Okay, if you enforce the agreed permissions in hardware, that's fine.

A doubt assaulted me overnight: sorry, I'm back to not understanding.

What are these access flags passed into ibv_reg_mr() that are enforced?
What relation do they bear to what you will pass to __get_user_pages()?

You are asking for a FOLL_FOLLOW ("follow permissions of the vma") flag,
which automatically works for read-write access to a VM_READ|VM_WRITE vma,
but read-only access to a VM_READ-only vma, without you having to know
which permission applies to which range of memory in the area specified.

But you don't need that new flag to set up read-only access, and if you
use that new flag to set up read-write access to an area which happens to
contain VM_READ-only ranges, you have set it up to write into ZERO_PAGEs.

?Hugh?
