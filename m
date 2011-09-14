Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab1INVzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:55:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55910 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab1INVzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:55:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=nbpgAiN8HZM48mrcupSKfy3vX5HppKN6DvVHEz7ekknrUpnwBEkWLT2vsmtvDce7N
	W+paQaCDy0SZxqFlsliYA==
Date: Wed, 14 Sep 2011 14:53:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Shaohua Li <shaohua.li@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
Subject: Re: [BUG] infinite loop in find_get_pages()
In-Reply-To: <1316033750.2835.2.camel@edumazet-laptop>
Message-ID: <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop> <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com> <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com> <1315983230.2565.28.camel@edumazet-laptop>
 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com> <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com> <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1315990519.29510.119.camel@sli10-conroe>
 <alpine.LSU.2.00.1109141337080.29178@sister.anvils> <1316033750.2835.2.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1660077110-1316037239=:29355"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1660077110-1316037239=:29355
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 14 Sep 2011, Eric Dumazet wrote:
> Le mercredi 14 septembre 2011 =C3=A0 13:38 -0700, Hugh Dickins a =C3=A9cr=
it :
> >=20
> > I'd like to think about that a little more before finalizing the
> > patch below - does it work, and does it look acceptable so far?
> > Of course, the mods to truncate.c and vmscan.c are not essential
> > parts of this fix, just things to tidy up while on the subject.
> > Right now I must attend to some other stuff, will return tomorrow.
>=20
> Hello Hugh
>=20
> I am going to test this ASAP,

Thanks, Eric, though it may not be worth spending your time on it.
It occurred to me over lunch that it may take painfully longer than
expected to invalidate_mapping_pages() on a single-swapped-out-page
1TB sparse tmpfs file - all those "start +=3D 1" restarts until it
reaches the end.

I might decide to leave invalidate_mapping_pages() giving up early
(unsatisfying, but no worse than before), and convert scan_mapping_
unevictable_pages() (which is used on nothing but shmem) to pass
index vector to radix_tree_gang_whatever().

Dunno, I'll think about it more later.

> but have one question below :
>=20
> >  =09/*
> >  =09 * If all entries were removed before we could secure them,
> >  =09 * try again, because callers stop trying once 0 is returned.
> >  =09 */
> > -=09if (unlikely(!ret && nr_found))
> > +=09if (unlikely(!ret && nr_found)) {
> > +=09=09cond_resched();
> > +=09=09start +=3D nr_found;
>=20
> Isnt it possible to go out of initial window ?
> start could be greater than 'end' ?
>=20
> invalidate_mapping_pages()
>=20
> does some capping (end - index)

Good question, but even before the change (or any of my changes here)
it's perfectly possible to go out of the initial window - the radix_tree
gang interfaces allow you to specify the maximum you want back (i.e. size
of buffer), but they do not actually allow you to specify end of range.

There's a few places where we trim the maximum to match our end of range,
but that's just a slight optimization in the face of an arguably incomplete
interface.  But the radix_tree is not too inefficient this way, because of
how empty nodes get removed immediately - there's a limit to the number
of nodes it will have to look through before it fills the buffer.

>=20
>=20
> >  =09pagevec_init(&pvec, 0);
> >  =09while (index <=3D end && pagevec_lookup(&pvec, mapping, index,
> >  =09=09=09min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {

It does cap by "end - index", but it has already checked "index <=3D end",
and it is only this minor optimization, nothing essential.

Hugh
--8323584-1660077110-1316037239=:29355--
