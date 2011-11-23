Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1KWWUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:20:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41411 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1KWWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:20:30 -0500
Date: Wed, 23 Nov 2011 14:20:12 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@kernel.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
In-Reply-To: <CAOJsxLH2foaRHYoPgRufu_J8B-YEvQ8aJNuQqHOPNj9YFvAubw@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1111231407170.2573@sister.anvils>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <CAHGf_=rOYkEGHakyHpihopMg2VtVfDV7XvC_QGs_kj6HgDmBRA@mail.gmail.com> <CAOJsxLH2foaRHYoPgRufu_J8B-YEvQ8aJNuQqHOPNj9YFvAubw@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-143952957-1322086825=:2573"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-143952957-1322086825=:2573
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 23 Nov 2011, Pekka Enberg wrote:
> On Wed, Nov 23, 2011 at 9:59 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> +
> >> + =A0 =A0 =A0 goto unlock;
> >> +
> >> +undo:
> >> + =A0 =A0 =A0 while (index > start) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 shmem_truncate_page(inode, index);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 index--;
> >
> > Hmmm...
> > seems too aggressive truncate if the file has pages before starting fal=
locate.
> > but I have no idea to make better undo. ;)
>=20
> Why do we need to undo anyway?

One answer comes earlier in this thread:

On Mon, Nov 21, 2011, Christoph Hellwig write:
> On Sun, Nov 20, 2011 at 01:22:10PM -0800, Hugh Dickins wrote:
> > First question that springs to mind (to which I shall easily find
> > an answer): is it actually acceptable for fallocate() to return
> > -ENOSPC when it has already completed a part of the work?
>=20
> No, it must undo all allocations if it returns ENOSPC.

Another answer would be: if fallocate() had been defined to return
the length that has been successfully allocated (as write() returns
the length written), then it would be reasonable to return partial
length instead of failing with ENOSPC, and not undo.  But it was
defined to return -1 on failure or 0 on success, so cannot report
partial success.

Another answer would be: if the disk is near full, it's not good
for a fallocate() to fail with -ENOSPC while nonetheless grabbing
all the remaining blocks; even worse if another fallocate() were
racing with it.

Hugh
--8323584-143952957-1322086825=:2573--
