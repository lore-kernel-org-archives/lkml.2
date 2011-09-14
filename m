Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab1INUjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:39:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:39:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=roVAVK27aOxUcfVKPyGRVWgLJOLhSsaxSINN72bD9a6XPnx3rPf0aKpk9fp+cgNEg
	6k7tZropxWgD1IreTp3zg==
Date: Wed, 14 Sep 2011 13:38:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Shaohua Li <shaohua.li@intel.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
Subject: Re: [BUG] infinite loop in find_get_pages()
In-Reply-To: <1315990519.29510.119.camel@sli10-conroe>
Message-ID: <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop> <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com> <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com> <1315983230.2565.28.camel@edumazet-laptop>
 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com> <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com> <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1315990519.29510.119.camel@sli10-conroe>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1438471-1316032703=:29178"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1438471-1316032703=:29178
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 14 Sep 2011, Shaohua Li wrote:
> On Wed, 2011-09-14 at 16:43 +0800, Eric Dumazet wrote:
> > Le mercredi 14 septembre 2011 =C3=A0 16:20 +0800, Shaohua Li a =C3=A9cr=
it :
> > > 2011/9/14 Shaohua Li <shli@kernel.org>:
> > > > it appears we didn't account skipped swap entry in find_get_pages()=
=2E
> > > > does the attached patch help?
> > > I can easily reproduce the issue. Just cp files in tmpfs, trigger swa=
p and
> > > drop caches. The debug patch fixes it at my side.
> > > Eric, please try it.
> > >=20
> >=20
> > Hello Shaohua
> >=20
> > I tried it with added traces :
> >=20
> >=20
> > [  277.077855] mv used greatest stack depth: 3336 bytes left
> > [  310.558012] nr_found=3D2 nr_skip=3D2
> > [  310.558139] nr_found=3D14 nr_skip=3D14
> > [  332.195162] nr_found=3D2 nr_skip=3D2
> > [  332.195274] nr_found=3D14 nr_skip=3D14
> > [  352.315273] nr_found=3D14 nr_skip=3D14
> > [  372.673575] nr_found=3D14 nr_skip=3D14
> > [  397.115463] nr_found=3D14 nr_skip=3D14
> > [  403.391694] cc1 used greatest stack depth: 3184 bytes left
> > [  404.761194] cc1 used greatest stack depth: 2640 bytes left
> > [  417.306510] nr_found=3D14 nr_skip=3D14
> > [  440.198051] nr_found=3D14 nr_skip=3D14
> >=20
> > I also used :
> >=20
> > -=09if (unlikely(!ret && nr_found))
> > +=09if (unlikely(!ret && nr_found > nr_skip))
> >  =09=09goto restart;
> nr_found > nr_skip is better
>=20
> > It seems to fix the bug. I suspect it also aborts
> > invalidate_mapping_pages() if we skip 14 pages, but existing comment
> > states its OK :
> >=20
> >         /*
> >          * Note: this function may get called on a shmem/tmpfs mapping:
> >          * pagevec_lookup() might then return 0 prematurely (because it
> >          * got a gangful of swap entries); but it's hardly worth worryi=
ng
> >          * about - it can rarely have anything to free from such a mapp=
ing
> >          * (most pages are dirty), and already skips over any difficult=
ies.
> >          */
> that might be a problem, let Hugh answer if it is.

Thanks to you all for suffering, reporting and investigating this.
Yes, in 3.1-rc I have converted an extremely rare try-again-once
into a too-easily stumbled-upon endless loop.

Would it be a problem to give up early on a shmem/tmpfs mapping in
invalidate_mapping_pages()?  No, not really: it's rare for it to find
anything it can throw away from tmpfs, because it cannot recognize the
clean swapcache pages (getting it to work on those would be nice, and
something I did look into once, but it's not a job for today), and
entirely clean pages (readonly mmap'ed zeroes never touched) are uncommon.

However, I did independently run across scan_mapping_unevictable_pages()
a few days ago: that uses pagevec_lookup() on shmem when doing SHM_UNLOCK,
and although the normal case would be that everything then is in memory,
I think it's not impossible for some to be swapped out (already swapped
out at SHM_LOCK time, and not touched since), which should not stop it
from doing its work on unswapped pages beyond.

My preferred patch is below: but it does add a cond_resched() into
find_get_pages(), which is really below the level at which we usually
do cond_resched().  All callers appear fine with it, and in practice
it would be very^14 rare on anything other than shmem/tmpfs: so this
being rc6 I'm reluctant to make matters worse with a might_sleep().

But I'm not signing this off yet, because I'm still mystified by the
several reports of seemingly the same problem on 3.0.1 and 3.0.2,
which I fear the patch below (even if adjusted to apply) will do
nothing to help - there are no swap entries in radix_tree in 3.0.

My suspicion is that there's some path by which a page gets trapped
in the radix_tree with page count 0.  While it's easy to imagine that
THP's use of compaction and compaction's use of migration could have
made a bug there more common, I do not see it.

I'd like to think about that a little more before finalizing the
patch below - does it work, and does it look acceptable so far?
Of course, the mods to truncate.c and vmscan.c are not essential
parts of this fix, just things to tidy up while on the subject.
Right now I must attend to some other stuff, will return tomorrow.

Hugh

---

 mm/filemap.c  |   14 ++++++++++----
 mm/truncate.c |    8 --------
 mm/vmscan.c   |    2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

--- 3.1-rc6/mm/filemap.c=092011-08-07 23:44:41.231928061 -0700
+++ linux/mm/filemap.c=092011-09-14 12:24:26.431242155 -0700
@@ -829,8 +829,8 @@ unsigned find_get_pages(struct address_s
 =09unsigned int ret;
 =09unsigned int nr_found;
=20
-=09rcu_read_lock();
 restart:
+=09rcu_read_lock();
 =09nr_found =3D radix_tree_gang_lookup_slot(&mapping->page_tree,
 =09=09=09=09(void ***)pages, NULL, start, nr_pages);
 =09ret =3D 0;
@@ -849,12 +849,15 @@ repeat:
 =09=09=09=09 * to root: none yet gotten, safe to restart.
 =09=09=09=09 */
 =09=09=09=09WARN_ON(start | i);
+=09=09=09=09rcu_read_unlock();
 =09=09=09=09goto restart;
 =09=09=09}
 =09=09=09/*
 =09=09=09 * Otherwise, shmem/tmpfs must be storing a swap entry
 =09=09=09 * here as an exceptional entry: so skip over it -
-=09=09=09 * we only reach this from invalidate_mapping_pages().
+=09=09=09 * we only reach this from invalidate_mapping_pages(),
+=09=09=09 * or SHM_UNLOCK's scan_mapping_unevictable_pages() -
+=09=09=09 * in each case it's correct to skip a swapped entry.
 =09=09=09 */
 =09=09=09continue;
 =09=09}
@@ -871,14 +874,17 @@ repeat:
 =09=09pages[ret] =3D page;
 =09=09ret++;
 =09}
+=09rcu_read_unlock();
=20
 =09/*
 =09 * If all entries were removed before we could secure them,
 =09 * try again, because callers stop trying once 0 is returned.
 =09 */
-=09if (unlikely(!ret && nr_found))
+=09if (unlikely(!ret && nr_found)) {
+=09=09cond_resched();
+=09=09start +=3D nr_found;
 =09=09goto restart;
-=09rcu_read_unlock();
+=09}
 =09return ret;
 }
=20
--- 3.1-rc6/mm/truncate.c=092011-08-07 23:44:41.299928402 -0700
+++ linux/mm/truncate.c=092011-09-14 11:23:19.513059010 -0700
@@ -336,14 +336,6 @@ unsigned long invalidate_mapping_pages(s
 =09unsigned long count =3D 0;
 =09int i;
=20
-=09/*
-=09 * Note: this function may get called on a shmem/tmpfs mapping:
-=09 * pagevec_lookup() might then return 0 prematurely (because it
-=09 * got a gangful of swap entries); but it's hardly worth worrying
-=09 * about - it can rarely have anything to free from such a mapping
-=09 * (most pages are dirty), and already skips over any difficulties.
-=09 */
-
 =09pagevec_init(&pvec, 0);
 =09while (index <=3D end && pagevec_lookup(&pvec, mapping, index,
 =09=09=09min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
--- 3.1-rc6/mm/vmscan.c=092011-08-28 22:10:26.516791859 -0700
+++ linux/mm/vmscan.c=092011-09-14 11:25:27.701694661 -0700
@@ -3375,8 +3375,8 @@ void scan_mapping_unevictable_pages(stru
 =09=09pagevec_release(&pvec);
=20
 =09=09count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
+=09=09cond_resched();
 =09}
-
 }
=20
 /**
--8323584-1438471-1316032703=:29178--
