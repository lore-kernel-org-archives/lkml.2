Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2BQF10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:27:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2BQF1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:27:25 -0500
Date: Fri, 17 Feb 2012 16:27:14 +1100
From: NeilBrown <neilb@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-ID: <20120217162714.09250710@notabene.brown>
In-Reply-To: <20120217044557.GI14132@dastard>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	<1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	<20120214051659.GH14132@dastard>
	<1329198932.2753.62.camel@work-vm>
	<20120214235106.GL7479@dastard>
	<1329265750.2340.17.camel@work-vm>
	<20120215123750.3333141f@notabene.brown>
	<20120217044557.GI14132@dastard>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/54/pVMpevk6v+shju0DBqpU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/54/pVMpevk6v+shju0DBqpU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Feb 2012 15:45:57 +1100 Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Feb 15, 2012 at 12:37:50PM +1100, NeilBrown wrote:
> > On Tue, 14 Feb 2012 16:29:10 -0800 John Stultz <john.stultz@linaro.org>=
 wrote:
> >=20
> > > But I'm open to other ideas and arguments.
> >=20
> > I didn't notice the original patch, but found it at
> > https://lwn.net/Articles/468837/
> > and had a look.
> >=20
> > My first comment is -ENODOC.  A bit background always helps, so let me =
try to
> > construct that:
> >=20
> >  The goal is to allow applications to interact with the kernel's cache
> >  management infrastructure.  In particular an application can say "this
> >  memory contains data that might be useful in the future, but can be
> >  reconstructed if necessary, and it is cheaper to reconstruct it than t=
o read
> >  it back from disk, so don't bother writing it out".
> >=20
> >  The proposed mechanism - at a high level - is for user-space to be abl=
e to
> >  say "This memory is volatile" and then later "this memory is no longer
> >  volatile".  If the content of the memory is still available the second
> >  request succeeds.  If not, it fails.. Well, actually it succeeds but r=
eports
> >  that some content has been lost. (not sure what happens then - can the=
 app do
> >  a binary search to find which pages it still has or something).
> >=20
> >  (technically we should probably include the cost to reconstruct the pa=
ge,
> >  which the kernel measures as 'seeks' but maybe that isn't necessary).
> >=20
> >  This is implemented by using files in a 'tmpfs' filesystem.  These file
> >  support three new flags to fadvise:
> >=20
> >  POSIX_FADV_VOLATILE - this marks a range of pages as 'volatile'.  They=
 may be
> >         removed from the page cache as needed, even if they are not 'cl=
ean'.
> >  POSIX_FADV_NONVOLATILE - this marks a range of pages as non-volatile.
> >         If any pages in the range were previously volatile but have sin=
ce been
> >         removed, then a status is returned reporting this.
> >  POSIX_FADV_ISVOLATILE - this does not actually give any advice to the =
kernel
> >         but rather asks a question: Are any of these pages volatile?
>=20
> What about for files that aren't on tmpfs? the fadvise() interface
> is not tmpfs specific, and given that everyone is talking about
> volatility of page cache pages, I fail to see what is tmpfs specific
> about this proposal.

It seems I was looking at an earlier version of the patch which only seemed
to affect tmpfs file.  I see now that the latest version can affect all
filesystems.

>=20
> So what are the semantics that are supposed to apply to a file that
> is on a filesystem with stable storage that is cached in the page
> cache?

This is my question too.  Does this make any sense at all for a
storage-backed filesystem?

If I understand the current code (which is by no means certain), then
there is nothing concrete that stops volatile pages from being written back
to storage.  Whether they are or not would be the result of a race between
the 'volatile_shrinker' purging them, and the VM cleaning them.

Given that the volatile_shrinker sets 'seeks =3D DEFAULT_SEEKS * 4', I would
guess that the VM would get to the pages before the shrinker, but that is
mostly just a guess.

If this really what we want?

Certainly having this clarified in Documents/volatile.txt would help a lot =
:-)

Thanks,
NeilBrown


--Sig_/54/pVMpevk6v+shju0DBqpU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTz3lMjnsnt1WYoG5AQIUyw//cSCBo+h+IlyjUWoag/vkinmxbq9J9bqI
nL3ymCoa/m51yHEh8lFh6CkJxSJtIY0O6AvWhHL/JLvQDbAiGypyB8RK2QifcRDC
yo10VON85zgZ7mk+YGWcbsJZUIMJGmRp8G5Lkn1B1Wnr+mhy3w9JXNdFH5e/lBrg
3fk4GVoQY5izQdo070aAHk2FrF8yJDb9atgHWrjzPqy9WfZfdRZ7lUYgfTL4RRjt
/lg+P4J7t0g3tILBuIQ2oHajhwSswdC6i+UPUitpYLl6dsGKq13DuTiy7FvbOHct
/MlEZgEBBWWabxQJBdcCRwNpFmLO3zXCvQhuxgiZ7ms/BB3oFpi/k3NsFMl4jfSD
bXXbWkcXXFpnDT1cRy3gc0hxbwyS5vd/89ZhDz0Xan0S1W9IcLOsPXl/RpgMCc5j
E65v8wIc/2fycyuaekhBdrDwNREqiq5iUkj8AZO9xIkGTVZ5aFP2GersWQo2XeN0
JkWozIn8I1AJMl1aYXs5d9x5RlgCpagWxrlPrRvZj0dD366vIBbJrkRYhggYdUNy
se5tN+bfed5EQ8ZgI8OGK27DA62LhQquft02wU034+ma5GLmjKOxDHIuumgLr4D2
8zn3t/iHdhwxmmcK9D/XbNoFYDgCeOdDPJgtTb9iwewacDLz1UzYpSQsg1BhkDsU
91JHcC7rw1M=
=Q4uy
-----END PGP SIGNATURE-----

--Sig_/54/pVMpevk6v+shju0DBqpU--
