Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1FOAZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:25:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1FOAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rTPNBR8sYSAoxZLLA41EiohFKxNG6RflYerlCH/GenyIm1fYuFI/YMZ+uQ896IXAKK
         nvYczWG4guBeYk8ROWVw==
Date: Tue, 14 Jun 2011 17:24:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
In-Reply-To: <BANLkTinGHSpn2aF-HM-R-eu12ZqMTpHQdQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1106141707540.31043@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140341070.29206@sister.anvils> <BANLkTinGHSpn2aF-HM-R-eu12ZqMTpHQdQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1819746192-1308097494=:31043"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1819746192-1308097494=:31043
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Pekka!

Thanks for taking a look.

On Tue, 14 Jun 2011, Pekka Enberg wrote:
> On Tue, Jun 14, 2011 at 1:42 PM, Hugh Dickins <hughd@google.com> wrote:
> > @@ -39,7 +39,15 @@
> > =A0* when it is shrunk, before we rcu free the node. See shrink code fo=
r
> > =A0* details.
> > =A0*/
> > -#define RADIX_TREE_INDIRECT_PTR =A0 =A0 =A0 =A01
> > +#define RADIX_TREE_INDIRECT_PTR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> > +/*
> > + * A common use of the radix tree is to store pointers to struct pages=
;
> > + * but shmem/tmpfs needs also to store swap entries in the same tree:
> > + * those are marked as exceptional entries to distinguish them.
> > + * EXCEPTIONAL_ENTRY tests the bit, EXCEPTIONAL_SHIFT shifts content p=
ast it.
> > + */
> > +#define RADIX_TREE_EXCEPTIONAL_ENTRY =A0 2
> > +#define RADIX_TREE_EXCEPTIONAL_SHIFT =A0 2
> >
> > =A0#define radix_tree_indirect_to_ptr(ptr) \
> > =A0 =A0 =A0 =A0radix_tree_indirect_to_ptr((void __force *)(ptr))
> > @@ -174,6 +182,28 @@ static inline int radix_tree_deref_retry
> > =A0}
> >
> > =A0/**
> > + * radix_tree_exceptional_entry =A0 =A0 =A0 =A0- radix_tree_deref_slot=
 gave exceptional entry?
> > + * @arg: =A0 =A0 =A0 value returned by radix_tree_deref_slot
> > + * Returns: =A0 =A00 if well-aligned pointer, non-0 if exceptional ent=
ry.
> > + */
> > +static inline int radix_tree_exceptional_entry(void *arg)
> > +{
> > + =A0 =A0 =A0 /* Not unlikely because radix_tree_exception often tested=
 first */
> > + =A0 =A0 =A0 return (unsigned long)arg & RADIX_TREE_EXCEPTIONAL_ENTRY;
> > +}
> > +
> > +/**
> > + * radix_tree_exception =A0 =A0 =A0 =A0- radix_tree_deref_slot returne=
d either exception?
> > + * @arg: =A0 =A0 =A0 value returned by radix_tree_deref_slot
> > + * Returns: =A0 =A00 if well-aligned pointer, non-0 if either kind of =
exception.
> > + */
> > +static inline int radix_tree_exception(void *arg)
> > +{
> > + =A0 =A0 =A0 return unlikely((unsigned long)arg &
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXC=
EPTIONAL_ENTRY));
> > +}
>=20
> Would something like radix_tree_augmented() be a better name for this
> (with RADIX_TREE_AUGMENTED_MASK defined)? This one seems too easy to
> confuse with radix_tree_exceptional_entry() to me which is not the
> same thing, right?

They're not _quite_ the same thing, and I agree that a different naming
that would make it clearer (without going on and on) would be welcome.

But I don't think the word "augmented" helps or really fits in there.

What I had in mind was: there are two exceptional conditions which you
can meet in reading the radix tree, and radix_tree_exception() covers
both of those conditions.

One exceptional condition is the radix_tree_deref_retry() case, a
momentary condition where you just have to go back and read it again.

The other exceptional condition is the radix_tree_exceptional_entry():
you've read a valid entry, but it's not the usual type of thing stored
there, you need to be careful to process it differently (not try to
increment its "page" count in our case).

I'm fairly happy with "radix_tree_exceptional_entry" for the second;
we could make the test for both more explicit by calling it
"radix_tree_exceptional_entry_or_deref_retry", but
I grow bored before I reach the end of that!

Hugh
--8323584-1819746192-1308097494=:31043--
