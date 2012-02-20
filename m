Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2BTHfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:35:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab2BTHfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:35:16 -0500
Date: Mon, 20 Feb 2012 18:34:40 +1100
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-ID: <20120220183440.01bd4c5c@notabene.brown>
In-Reply-To: <1329456095.2373.43.camel@js-netbook>
References: <1328832993-23228-1-git-send-email-john.stultz@linaro.org>
	<1328832993-23228-2-git-send-email-john.stultz@linaro.org>
	<20120214051659.GH14132@dastard>
	<1329198932.2753.62.camel@work-vm>
	<20120214235106.GL7479@dastard>
	<1329265750.2340.17.camel@work-vm>
	<20120215123750.3333141f@notabene.brown>
	<1329456095.2373.43.camel@js-netbook>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p=fEGtIvTQ.H1gOs7XEZcBF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p=fEGtIvTQ.H1gOs7XEZcBF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi John,
 thanks for your answers....

>=20
> >  The proposed mechanism - at a high level - is for user-space to be abl=
e to
> >  say "This memory is volatile" and then later "this memory is no longer
> >  volatile".  If the content of the memory is still available the second
> >  request succeeds.  If not, it fails.. Well, actually it succeeds but r=
eports
> >  that some content has been lost. (not sure what happens then - can the=
 app do
> >  a binary search to find which pages it still has or something).
>=20
> The app should expect all was lost in that range.

So... the app has some idea of the real granularity of the cache, which=20
is several objects in one file, and marks them volatile as a whole - then
marks them non-volatile as a whole and if that fails it assumes that the
whole object is gone.
However the kernel doesn't really have any idea of real granularity and so
just removes individual pages until it has freed up enough.
It could have just corrupted a much bigger object and so the rest of the
object is of no value and may as well be freed, but it has no way to know
this, so frees something else instead.

Is this a problem?  If the typical granularity is a page or two then it is
unlikely to hurt.  If it is hundreds of pages I think it would mean that we
don't make as good use of memory as we could (but it is all heuristics anyw=
ay
and we probably waste lots of opportunities already so maybe it doesn't
matter).

My gut feeling is that seeing the app has concrete knowledge about
granularity it should give it to the kernel somehow.

>=20
> >  (technically we should probably include the cost to reconstruct the pa=
ge,
> >  which the kernel measures as 'seeks' but maybe that isn't necessary).
>=20
> Not sure I'm following this.

The shrinker in your code (and the original ashmem) contains:

	.seeks =3D DEFAULT_SEEKS * 4,

This means that objects in this cache are 4 times as expensive to replace as
most other caches.
(the cost of replacing an entry in the cache is measured in 'seeks' and the
default is to assume that it takes 2 seeks to reload and object).

I don't really know what the practical importance of 'seeks' is.  Maybe it =
is
close to meaningless, in which case you should probably use DEFAULT_SEEKS
like (almost) everyone else.
Maybe it is quite relevant, in which case maybe you should expose that
setting to user-space somehow.
Or maybe 'DEFAULT_SEEKS * 4' is perfect for all possible users of this
caching mechanism.

I guess my point is that any non-default value should be justified.


>=20
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
> >=20
> >=20
> > Is this an accurate description?
>=20
> Right now its not tmpfs specific, but otherwise this is pretty spot on.
>=20
> > My first thoughts are:
> >  1/ is page granularity really needed?  Would file granularity be suffi=
cient?
>=20
> The current users of similar functionality via ashmem do seem to find
> page granularity useful. You can share basically an unlinked tmpfs fd
> between two applications and mark and unmark ranges of pages
> "volatile" (unpinned in ashmem terms) as needed.

Sharing an unlinked cache between processes certainly seems like a valid ca=
se
that my model doesn't cover.
I feel uncomfortable about different processes being able to unpin each
other's pages.  It means they need to negotiate with each other to ensure o=
ne
doesn't unpin a page that the other is using.

If this was a common use case, it would make a lot of sense for the kernel =
to
refcount the pinning so that a range only becomes really unpinned when no-o=
ne
has it pinned any more.

Do you know any more about these apps that share a cache file?  Do they need
extra inter-locking (or are they completely hypothetical?).


>=20
> >  2/ POSIX_FADV_ISVOLATILE is a warning sign to me - it doesn't actually
> >     provide advice.  Is this really needed?  What for?  Because it feel=
s like
> >     a wrong interface.
>=20
> It is more awkward, I agree. And the more I think about it, it seems
> like its something we can drop, as it is likely only useful as a probe
> before using a page, and using the POSIX_FADV_NONVOLAILE on the range to
> be used would also provide the same behavior. So I'll drop it in the
> next revision.=20

Good.  That makes me feel happier.

>=20
> >  3/ Given that this is specific to one filesystem, is fadvise really an
> >     appropriate interface?
> >=20
> > (fleshing out the above documentation might be an excellent way to answ=
er
> > these questions).
>=20
> So, the ashmem implementation is really tmpfs specific, but there's also
> the expectation on android devices that there isn't swap, so its more
> like ramfs.  I'd like to think that this behavior makes some sense on
> other filesystems, providing a way to cheaply throw out dirty data
> without the cost of hitting the disk. However, the next time the file is
> opened, that could cause some really strange inconsistent results, with
> some recent pages written out and some stale pages. The vmtruncate would
> punch a hole instead of leaving stale data, but that still would have to
> hit the disk so its not free. So I'm not really sure if it makes sense
> in a totally generic way. That said, it would be easy for now to return
> errors if the fs isn't shmem based.=20

As I think I said somewhere, I cannot see how the functionality makes any
sense at all on a storage-backed filesystem - and what you have said about
inconsistent on-disk images only re-enforces that.
I think it should definitely be ramfs only (maybe tmpfs as well??).


>=20
> Really, I'm not married to any specific interface here. fadvise just
> seemed the most logical to me. Given page granularity is needed, what
> would be a filesystem specific interface that makes sense here?

OK, let me try again.
This looks to me a bit like byte-range locking.
locking can already have a filesystem-specific implementation so this could
be implemented as a ramfs-specific locking protocol.  This would be activat=
ed
by some mount option (or it could even be a different filesystem type -
ramcachefs).

1- a shared lock (F_RDLCK) pins the range in memory and prevents an exclusi=
ve
   lock, or any purge of pages.
2- an exclusive lock (F_WRLCK) is used to create or re-create an object in
   the cache.
3- when pages are purged a lock-range is created which marks the range as
   purged and prevents any read lock from succeeding.
   This lock-range is removed when a write-lock is taken out.

So initially all pages are marked by an internal 'purged' lock indicating t=
hat
they contain nothing.

Objects can be created by creating a write lock and writing data.  Then
unlocking (or down grading to a read lock) allows them to be accessed by
other processes.=20
Any process that wants to read an object first asks for a shared lock.  If
this succeeds they are sure that the pages are still available (and that
no-one has an exclusive lock).
If the shared lock fails then at least one page doesn't exist - probably all
are gone. They can then optionally try to get a write lock.  Once they get
that they can revalidate somehow, or refill the object.
When the last lock is removed, the locking code could keep the range
information but mark it as unlocked and put it on an lru list.

So 4 sorts of ranges are defined and they cover the entire file:
shared locks - these might overlap
exclusive locks - these don't overlap
purge locks - mark ranges that have been purged or never written
pending locks - mark all remaining ranges.

When a shared or exclusive lock is released it becomes a pending lock.
When the shrinker fires it converts some number of pending locks to
purge locks and discards the pages wholly in them.
A shared lock can only be taken when there is a shared or pending lock ther=
e.
An exclusive lock can be taken when a purge or pending lock is present.

For the most part this doesn't conflict with the more normal usage of byte
range locks.  However it does mean that a process cannot place a range in a
state where some other process is allowed to write, but the kernel is not
allowed to purge the pages.  I cannot tell if this might be a problem.
(it could probably be managed by some convention where locking the first by=
te
in an object gives read/write permission and locking the rest keeps it in
cache. One byte by itself will never be purged).

I'm not sure what should happen if you write without first getting a write
lock.  I guess it should turn a purge lock to a pending lock, but leave an
other range unchanged.

NeilBrown

--Sig_/p=fEGtIvTQ.H1gOs7XEZcBF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0H3njnsnt1WYoG5AQJCghAAjwZi6BD1uRZqenoq+oMGVZ2WH4MLmHi/
Ba9VWCqWh1zvdWlelPR/+A44e5cTEbFD2oAoHdXi1BpcRol36apTAuyFmtLo+fy9
P4MiaYUA7xSO7cymW5xkg5cEOO4+NiGGVeh0yrbvCQAMGf0ARQpyfmbBgH16DJxH
+RhmGVFTXbwZwMgqrlPJH+Lmq7ISI9EYPxw0Nb1Q9LPy769WHE1TaYG/kW3BHXj2
NOh3QHvOckZhYm5lFmuIlqKi6QbsybTacQDuVYXw9V1dfHbxIgo6HXjfdSvhnF2o
qe0s4zDrj3ivMrDtBe5KHErmTz6XWHSneR0kTz4aZ+4wCNFdGoiTkjQ7c9I2iGoX
++5feGvWqWNV53Kxhhr46Zj4Jyxmz9ukWtaFAiXNl4CHe6UOF9HK8zJFXg7EKkNY
QMX5iyy+8UaqtvaIP5E8ShsaHk89ruxCRhvPVfrZn9/BRssE8GdeAChXJJCHHbKP
YtYW8TeotERaQ/l9hE9mUE35LgUnzhQNd1QcF0PTkYwcWSC0JDqsAUBPZu3WB21E
CoXQavfrt1ZX6skk5nkE/BDhthNRSESOSrQJdznDG+eNS0yQ6PlGe0Z3muxDoTyF
UXYrLo6RkLfNOIKq1eGVsv5bQiDmlHShbI7JSHFdoClG9NbtL4ym16GOL4EjODUq
syzDPgbzmY8=
=cY/F
-----END PGP SIGNATURE-----

--Sig_/p=fEGtIvTQ.H1gOs7XEZcBF--
