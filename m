Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2EZU1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 16:27:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54747 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2EZU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 16:27:17 -0400
Date: Sat, 26 May 2012 13:26:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <levinsasha928@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>,
        oleg@redhat.com, "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
        mingo <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: mm: kernel BUG at mm/memory.c:1230
In-Reply-To: <CA+1xoqcbZWLpvHkOsZY7rijsaryFDvh=pqq=QyDDgo_NfPyCpA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1205261317310.2488@eggly.anvils>
References: <1337884054.3292.22.camel@lappy> <20120524120727.6eab2f97.akpm@linux-foundation.org> <CA+1xoqcbZWLpvHkOsZY7rijsaryFDvh=pqq=QyDDgo_NfPyCpA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1719037168-1338064015=:2488"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1719037168-1338064015=:2488
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 24 May 2012, Sasha Levin wrote:
> On Thu, May 24, 2012 at 9:07 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 24 May 2012 20:27:34 +0200
> > Sasha Levin <levinsasha928@gmail.com> wrote:
> >
> >> Hi all,
> >>
> >> During fuzzing with trinity inside a KVM tools guest, using latest lin=
ux-next, I've stumbled on the following:
> >>
> >> [ 2043.098949] ------------[ cut here ]------------
> >> [ 2043.099014] kernel BUG at mm/memory.c:1230!
> >
> > That's
> >
> > =A0 =A0 =A0 =A0VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
> >
> > in zap_pmd_range()?
>=20
> Yup.
>=20
> > The assertion was added in Jan 2011 by 14d1a55cd26f1860 ("thp: add
> > debug checks for mapcount related invariants"). =A0AFAICT it's just wro=
ng
> > on the exit path. =A0Unclear why it's triggering now...

I've been round this loop before with that particular VM_BUG_ON.

At first I thought like Andrew, that it's glaringly wrong on the exit
path; but then changed my mind.

When munmapping, we certainly can arrive here with an unaligned addr
and next; but in that case rwsem_is_locked.

Whereas in exiting, rwsem is not locked, but we're going linearly upwards,
and whenever we walk into a pmd_trans_huge area, both addr and next should
be hpage aligned: the vma bounds are unsuited to THP if they're unaligned.

Other cases equally should not arise: madvise MADV_DONTNEED should
have rwsem_is_locked; and truncation or hole-punching shouldn't be
possible on a pure-anonymous (!vma->vm_ops) area considered for THP.

But I cannot remember what brought me here before: a crash in testing
on one of my machines, which further investigation root-caused elsewhere?
or a report from someone else? or noticed when auditing another problem?
I'm frustrated not to recall.

>=20
> I'm not sure if that's indeed the issue or not, but note that this is
> the first time I've managed to trigger that with the fuzzer, and it's
> not that easy to reproduce. Which is a bit odd for code that was there
> for 4 months...

I'm keeping off the linux-next for the moment; I'll worry about this
more if it shows up when we try 3.5-rc1.  Your fuzzing tells that my
logic above is wrong, but maybe it's just a passing defect in next.

Hugh
--8323584-1719037168-1338064015=:2488--
