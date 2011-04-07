Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1DGOR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:17:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1DGORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WBaVw+27hGAkZIzv4p6GxCMCbGOCeLMbmSFq556KDCc4CEhivqpgxTUA7q8ArTABhL
         qvty2tENJU3wzfqlJ2OA==
Date: Thu, 7 Apr 2011 07:17:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Robert Swiecki <robert@swiecki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
In-Reply-To: <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1104070639350.28555@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils> <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com> <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com> <alpine.LSU.2.00.1103182158200.18771@sister.anvils>
 <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com> <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com> <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com> <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
 <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com> <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com> <BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com> <BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com> <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
 <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-146406036-1302185851=:28555"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-146406036-1302185851=:28555
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 6 Apr 2011, Linus Torvalds wrote:
> On Wed, Apr 6, 2011 at 8:43 AM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I was about to send you my own UNTESTED patch: let me append it anyway,
> > I think it is more correct than yours (it's the offset of vm_end we nee=
d
> > to worry about, and there's the funny old_len,new_len stuff).
>=20
> Umm. That's what my patch did too. The
>=20
>    pgoff =3D (addr - vma->vm_start) >> PAGE_SHIFT;
>=20
> is the "offset of the pgoff" from the original mapping, then we do
>=20
>    pgoff +=3D vma->vm_pgoff;
>=20
> to get the pgoff of the new mapping, and then we do
>=20
>    if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
>=20
> to check that the new mapping is ok.

Right, I was forgetting the semantics for mremap when
addr + old_len < vma->vm_end.  It has to move out the
old section and extend it elsewhere, it does not affect
the page just before vma->vm_end at all.  So mine was
indeed a more complicated way of doing yours.

>=20
> I think yours is equivalent, just a different (and odd - that
> linear_page_index() thing will do lots of unnecessary shifts and
> hugepage crap) way of writing it.

I was trying to use the common function provided: but it's
actually wrong, that's a function for getting the value found
in page->index (in units of PAGE_CACHE_SIZE), whereas here we
want the value found in vm_pgoff (in units of PAGE_SIZE).

Of course PAGE_CACHE_SIZE has equalled PAGE_SIZE everywhere but in
some patches by Christoph Lameter a few years back, so there isn't
an effective difference; but I was wrong to use that function.

>=20
> >=A0See what you think - sorry, I'm going out now.
>=20
> I think _yours_ is conceptually buggy, because I think that test for
> "vma->vm_file" is wrong.

Just being cautious: we cannot hit the BUG in prio_tree.c when we're
dealing with an anonymous mapping, and I didn't want to think about
anonymous at the time.

>=20
> Yes, new anonymous mappings set vm_pgoff to the virtual address, but
> that's not true for mremap() moving them around, afaik.
>=20
> Admittedly it's really hard to get to the overflow case, because the
> address is shifted down, so even if you start out with an anonymous
> mmap at a high address (to get a big vm_off), and then move it down
> and expand it (to get a big size), I doubt you can possibly overflow.
> But I still don't think that the test for vm_file is semantically
> sensible, even if it might not _matter_.

The strangest case is when a 64-bit kernel execs a 32-bit executable,
preparing the stack with a very high virtual address which goes into
vm_pgoff (shifted by PAGE_SHIFT), then moves that stack down into the
32-bit address space but leaving it with the original high vm_pgoff.

I think you are now excluding some wild anonymous cases which were
allowed before, and gave no trouble - vma_address() looks like a wrap
won't upset it.  But they're not cases which anyone is likely to do,
and safer to keep the anon rules in synch with the file rules.

>=20
> But whatever. I suspect both our patches are practically doing the
> same thing, and it would be interesting to hear if it actually fixes
> the issue. Maybe there is some other way to mess up vm_pgoff that I
> can't think of right now.

Here's yours inline below:

Acked-by: Hugh Dickins <hughd@google.com>
---

 mm/mremap.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 1de98d492ddc..a7c1f9f9b941 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -277,9 +277,16 @@ static struct vm_area_struct *vma_to_resize(unsigned l=
ong addr,
 =09if (old_len > vma->vm_end - addr)
 =09=09goto Efault;
=20
-=09if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
-=09=09if (new_len > old_len)
+=09/* Need to be careful about a growing mapping */
+=09if (new_len > old_len) {
+=09=09unsigned long pgoff;
+
+=09=09if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 =09=09=09goto Efault;
+=09=09pgoff =3D (addr - vma->vm_start) >> PAGE_SHIFT;
+=09=09pgoff +=3D vma->vm_pgoff;
+=09=09if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
+=09=09=09goto Einval;
 =09}
=20
 =09if (vma->vm_flags & VM_LOCKED) {
--8323584-146406036-1302185851=:28555--
