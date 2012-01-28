Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2A1Cb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 21:31:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52148 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2A1Cb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 21:31:26 -0500
Date: Fri, 27 Jan 2012 18:31:07 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Roland Dreier <roland@kernel.org>
cc: linux-rdma@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages()
 parameters
In-Reply-To: <CAL1RGDVBR49QrAbkZ0Wa9Gh98HTwjtsQbFQ4Ws3Ra7rEjT1Mng@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1201271819260.3402@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org> <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com> <CAL1RGDVBR49QrAbkZ0Wa9Gh98HTwjtsQbFQ4Ws3Ra7rEjT1Mng@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1830867477-1327717873=:3402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1830867477-1327717873=:3402
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 27 Jan 2012, Roland Dreier wrote:

> > Sigh, what a mess ... it seems what we really want to do is know
> > if userspace might trigger a COW because or not, and only do a
> > preemptive COW in that case. =A0(We're not really concerned with
> > userspace fork()ing and setting up a COW in the future, since that's
> > what we have MADV_DONTFORK for)
> >
> > The status quo works for userspace anonymous mappings but
> > it doesn't work for my case of mapping a kernel buffer read-only
> > into userspace. =A0And fixing my case breaks the anonymous case.
> > Do you see a way out of this dilemma? =A0Do we need to add yet
> > another flag to get_user_pages()?
>=20
> So thinking about this a bit more... it seems what we want is at least
> to first order that we do the equivalent of write=3D=3D1 exactly when the=
 vma
> for a mapping has VM_WRITE set

My first impression is that that's not what you want at all: that will
not do a preliminary COW of anonymous page to be written into by the
driver when the user only wants VM_READ access.  But perhaps I'm
worrying about the second order while you're sticking to first order.

Or perhaps I'm misunderstanding the context in which you want to do
this: are you now accepting to do a different get_user_pages in the
anonymous and driver-memory cases, and this suggestion was for the
driver-memory case only?

> (or is it VMA_MAYWRITE / force=3D=3D1?
> I don't quite understand the distinction between WRITE and MAYWRITE).

I may have told you more than you wanted to know in the other mail.

>=20
> Right now, one call to get_user_pages() might involve more than one vma,
> but we could simulate the above by doing find_vma() and making sure our
> call to get_user_pages() goes one vma at a time.  Of course that would be
> inefficient since get_user_pages() will redo the find_vma() internally, s=
o it
> would I guess make sense to add another FOLL_ flag to tell
> get_user_pages() to do this?

I cannot go further, without explanation for why you need get_user_pages
in the driver-memory case at all.

>=20
> Am I all wet, or am I becoming an MM hacker?

Certainly more than I'll ever be an RDMA hacker,

Hugh
--8323584-1830867477-1327717873=:3402--
