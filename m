Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0EUVTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:19:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0EUVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:19:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cHWhRnyxFWqHtSuz8WssyoDuPQfQr9yxo8wWCFQu+FvSXgnr2S9efGfinUCkGgQ+K
	Gh8kYVti8ZdIiNfHbvA7g==
Date: Fri, 21 May 2010 14:18:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: dave b <db.pub.mail@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
In-Reply-To: <AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1005211410170.14789@sister.anvils>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> <AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com> <AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1807566609-1274476747=:14789"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1807566609-1274476747=:14789
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 20 May 2010, dave b wrote:

> Is there a reason - no one has taken any interesting in my email ?....
>  The behaviour isn't found on the 2.6.26 debian kernel. So I was
> thinking that it might be due to my intel graphics card / memory
> interplay ? ....

It's nothing personal: the usual reason is that people are very busy.

>=20
> On 14 May 2010 23:14, dave b <db.pub.mail@gmail.com> wrote:
> > On 14 May 2010 22:53, dave b <db.pub.mail@gmail.com> wrote:
> >> In 2.6.3* kernels (test case was performed on the 2.6.33.3 kernel)
> >> when physical memory runs out and there is a large swap partition -
> >> the system completely stalls.
> >>
> >> I noticed that when running debian lenny using dm-crypt =C2=A0with
> >> encrypted / and swap with a =C2=A02.6.33.3 kernel (and all of the 2.6.=
3*
> >> series iirc) when all physical memory is used (swapiness was left at
> >> the default 60) the system hangs and does not respond. It can resume
> >> normal operation some time later - however it seems to take a *very*
> >> long time for the oom killer to come in. Obviously with swapoff this
> >> doesn't happen - the oom killer comes in and does its job.
> >>
> >>
> >> free -m
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers =C2=
=A0 =C2=A0 cached
> >> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01980 =C2=A0 =C2=A0 =C2=A0 1101 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0879 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 58 =C2=A0 =C2=A0 =C2=A0 =C2=A0201
> >> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0840 =C2=A0 =C2=A0 =C2=A0=
 1139
> >> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A024943 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A024943
> >>
> >>
> >> My simple test case is
> >>
> >> dd if=3D/dev/zero of=3D/tmp/stall
> >> and wait till /tmp fills...

Is that tmpfs sized the default 50% of RAM?
If you have sized it larger, then indeed filling it up might behave badly.

> >>
> >
> > Sorry - I forgot to say I am running x86-64

But I wonder if you're suffering from a bug which KOSAKI-San just
identified, and has very recently posted this patch: please try
it and let us all know - thanks.

Hugh

[PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first

Shaohua Li reported parallel file copy on tmpfs can lead to
OOM killer. This is regression of caused by commit 9ff473b9a7
(vmscan: evict streaming IO first). Wow, It is 2 years old patch!

Currently, tmpfs file cache is inserted active list at first. It
mean the insertion doesn't only increase numbers of pages in anon LRU,
but also reduce anon scanning ratio. Therefore, vmscan will get totally
confusion. It scan almost only file LRU even though the system have
plenty unused tmpfs pages.

Historically, lru_cache_add_active_anon() was used by two reasons.
1) Intend to priotize shmem page rather than regular file cache.
2) Intend to avoid reclaim priority inversion of used once pages.

But we've lost both motivation because (1) Now we have separate
anon and file LRU list. then, to insert active list doesn't help
such priotize. (2) In past, one pte access bit will cause page
activation. then to insert inactive list with pte access bit mean
higher priority than to insert active list. Its priority inversion
may lead to uninteded lru chun. but it was already solved by commit
645747462 (vmscan: detect mapped file pages used only once).
(Thanks Hannes, you are great!)

Thus, now we can use lru_cache_add_anon() instead.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b941996..023ef61 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -452,7 +452,7 @@ int add_to_page_cache_lru(struct page *page, struct add=
ress_space *mapping,
 =09=09if (page_is_file_cache(page))
 =09=09=09lru_cache_add_file(page);
 =09=09else
-=09=09=09lru_cache_add_active_anon(page);
+=09=09=09lru_cache_add_anon(page);
 =09}
 =09return ret;
 }
--=20
1.6.5.2
--8323584-1807566609-1274476747=:14789--
