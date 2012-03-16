Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2CPVTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:19:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61160 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2CPVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:19:30 -0400
Date: Fri, 16 Mar 2012 14:18:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 06/11] huge-memory: Use lockdep_assert_held
In-Reply-To: <20120316194436.GN24602@redhat.com>
Message-ID: <alpine.LSU.2.00.1203161411160.1258@eggly.anvils>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org> <1331924464-18023-7-git-send-email-andi@firstfloor.org> <20120316194436.GN24602@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Andrea Arcangeli wrote:
> On Fri, Mar 16, 2012 at 12:00:59PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Use lockdep_assert_held to check for locks instead of an opencoded
> > variant.
> > 
> > Cc: aarcange@redhat.com
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  mm/huge_memory.c |    4 ++--
> >  mm/swap.c        |    2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 91d3efb..28669c6 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2083,7 +2083,7 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
> >  {
> >  	struct mm_struct *mm = mm_slot->mm;
> >  
> > -	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
> > +	lockdep_assert_held(&khugepaged_mm_lock);
> 
> This check was intended to be a VM debug check, so getting enabled by
> DEBUG_VM, not through lockdep. I mean I always have DEBUG_VM enabled
> in all my kernels, but lockdep only enabled on my test system. So it's
> not an opencoded variant strictly speaking.
> 
> My estimate is that what gets more tested is BUG_ON, second VM_BUG_ON,
> third LOCKDEP.

My estimate too.

> But hey, this code has been tested for a while so I'm
> neutral and if you prefer the lockdep version it's up to you.

Yes, it's not as if these are public interfaces used by drivers and
filesystems: they have very few callsites, and by now those lines
are mostly useful as documentation.

Andrew did mention assert_spin_locked() when I added those NR_CPUS
conditions, but we preferred VM_BUG_ON to BUG_ON, and I'm content
with Andi's further restriction to lockdep.

Acked-by: Hugh Dickins <hughd@google.com>

Hugh
