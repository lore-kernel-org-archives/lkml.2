Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1KKCJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:09:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47922 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KKCJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:09:40 -0500
Date: Thu, 10 Nov 2011 18:09:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, nai.xia@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org,
        linux@arm.linux.org.uk
Subject: Re: mm: convert vma->vm_flags to 64bit
In-Reply-To: <1320959579.21206.24.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1111101723500.1239@sister.anvils>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com> <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com> <4EBC085D.3060107@jp.fujitsu.com> <1320959579.21206.24.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011, Benjamin Herrenschmidt wrote:
> On Thu, 2011-11-10 at 12:22 -0500, KOSAKI Motohiro wrote:
> > On 11/9/2011 11:09 PM, Nai Xia wrote:
> > > Hi all,
> > > 
> > > Did this patch get merged at last, or on this way being merged, or
> > > just dropped ?
> > 
> > Dropped.
> > Linus said he dislike 64bit enhancement.
> 
> Do you have a pointer ? (And a rationale)
> 
> I still want to put some arch flags in there at some point...

It was in this mail below, when Andrew sent Linus the patch, and Linus
opposed my "argument" in support: that wasn't on lkml or linux-mm,
but I don't see that its privacy needs protecting.

KOSAKI-san then sent instead a patch to correct some ints to longs,
which Linus did put in: but changing them to a new "vm_flags_t".

He was, I think, hoping that one of us would change all the other uses
of unsigned long vm_flags to vm_flags_t; but in fact none of us has
stepped up yet - yeah, we're still sulking that we didn't get our
shiny new 64-bit vm_flags ;)

I think Linus is not opposed to PowerPC and others defining a 64-bit
vm_flags_t if you need it, but wants not to bloat the x86_32 vma.

I'm still wary of the contortions we go to in constraining flags,
and feel that the 32-bit case holds back the 64-bit, which would
not itself be bloated at all.

The subject is likely to come up again, more pressingly, with page flags.

Hugh

> From torvalds@linux-foundation.org Wed May 25 10:43:32 2011
> Date: Wed, 25 May 2011 10:42:37 -0700
> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Ben Herrenschmidt <benh@kernel.crashing.org>, dave@linux.vnet.ibm.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Subject: Re: [patch 023/141] mm: convert vma->vm_flags to 64 bit
> 
> On Wed, May 25, 2011 at 10:09 AM, Hugh Dickins <hughd@google.com> wrote:
> >
> > If they don't absolutely want it today, they'll still be needing it
> > tomorrow...ish.
> 
> I think that's a very bogus argument.
> 
> I think having push-back for extending flags is a good idea. Some of
> the vm_flags we have now are almost certainly just total crap, brought
> on by people who said "let's just add a flag for this".
> 
> So if we don't have a situation where "we absolutely *have* to do
> this, and we've tried everything else", then I don't think we should
> encourage more of the same.
> 
> For example, do we care about VM_RESERVED vs VM_IO, for example? There
> are some subtle (but quite frankly, probably pointless and entirely
> historical) differences in how mlock() acts on them, for example.
> 
> Or what about the read-ahead flags? They don't seem sensible for
> non-file-backed mappings, and if it's file-backed, we have "vm_file"
> which actually has the whole read-ahead state in it. Do we really need
> two bits for that? Does anybody really want to map the same "struct
> file" (note: same particular "open()" call, not same file on disk)
> multiple times and have different read-ahead for them?
> 
> IOW, I really don't see why more than 32 bits would be needed in the
> first place, and I think people have been too eager to add bits to
> begin with. And if we really *do* need more bits, I think we have some
> options for that too, although I seriously think anybody who wants
> more bits should ask themselves whether they are actually going to be
> used, or are just some crazy feature that no sane person should care
> about.
> 
>                        Linus
