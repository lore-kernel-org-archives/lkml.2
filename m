Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2FPKF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 06:05:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55314 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2FPKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 06:05:55 -0400
Date: Sat, 16 Jun 2012 03:05:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: Wanpeng Li <liwp.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] swap: fix shmem swapping when more than 8 areas
In-Reply-To: <CAM_iQpXPH2SgjKbj1g5azcddusBmQ0CDvDz_RJe2r2HSTo51yA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1206160241480.13075@eggly.anvils>
References: <alpine.LSU.2.00.1206151752420.8741@eggly.anvils> <20120616045637.GA2331@kernel> <CAM_iQpXPH2SgjKbj1g5azcddusBmQ0CDvDz_RJe2r2HSTo51yA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2136590732-1339841134=:13075"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2136590732-1339841134=:13075
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 16 Jun 2012, Cong Wang wrote:
> On Sat, Jun 16, 2012 at 12:56 PM, Wanpeng Li <liwp.linux@gmail.com> wrote=
:
> >>-#define SWP_TYPE_SHIFT(e) =C2=A0 =C2=A0 (sizeof(e.val) * 8 - MAX_SWAPF=
ILES_SHIFT)
> >>+#define SWP_TYPE_SHIFT(e) =C2=A0 =C2=A0 ((sizeof(e.val) * 8) - \
> >>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0(MAX_SWAPFILES_SHIFT + RADIX_TREE_EXCEPTIONAL_SHIFT))
> > Since SHIFT =3D=3D MAX_SWAPFILES_SHIFT + RADIX_TREE_EXCEPTIONAL_SHIFT =
=3D=3D 7
> > and the low two bits used for radix_tree, the available swappages numbe=
r
> > based of 32bit architectures reduce to 2^(32-7-2) =3D 32GB?
>=20
> The lower two bits are in the 7 bits you calculated,
> so it is 2^(32-7), not 2^(32-7-2)

Correct.

And that is not the limiting condition on available swap pages on 32-bit
without PAE, which is limited more by the pte<->swp conversion: a swap
entry must be distinguished from a present pte, from a PROT_NONE page,
and from a pte_file() entry - see arch/x86/include/asm/pgtable-2level.h
for how i386 in particular arranges that.

Nor is it the limiting condition on 64-bit, where include/linux/swap.h's
use of __u32 and unsigned int for counting swap pages is more limiting.

Hugh
--8323584-2136590732-1339841134=:13075--
