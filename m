Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1EDIaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:30:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:53369 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1EDIaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:30:07 -0400
Date: Wed, 4 May 2011 10:30:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] mm: get rid of CONFIG_STACK_GROWSUP || CONFIG_IA64
Message-ID: <20110504083005.GA1375@tiehlicka.suse.cz>
References: <20110503141044.GA25351@tiehlicka.suse.cz>
 <alpine.LSU.2.00.1105031142260.7349@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105031142260.7349@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Tue 03-05-11 12:11:28, Hugh Dickins wrote:
> On Tue, 3 May 2011, Michal Hocko wrote:
[...]
> > IA64 needs some trickery for Register Backing Store so we have to
> > export expand_stack_upwards for it even though the architecture expands
> > its stack downwards normally.
> > We have defined VM_GROWSUP which is defined only for the above
> > configuration so let's use it everywhere rather than hardcoded
> > CONFIG_STACK_GROWSUP || CONFIG_IA64
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Sorry to be negative, but this seems more clever than helpful to me:
> it does not optimize anything (apart from saving a few bytes in mm/mmap.c
> itself), 

The patch doesn't aim at optimizing anything. It is just a cleanup.

> obscures the special IA64 case, and relies upon the ways in which
> we happen to define VM_GROWSUP elsewhere.

This case is obscure enough already because we are using VM_GROWSUP to
declare expand_stack_upwards in include/linux/mm.h while definition is
guarded by CONFIG_STACK_GROWSUP||CONFIG_IA64. 
What the patch does is just "make it consistent" thing. I think we
should at least use CONFIG_STACK_GROWSUP||CONFIG_IA64 at both places if
you do not like VM_GROWSUP misuse.

> Not a nack: others may well disagree with me.
> 
> And, though I didn't find time to comment on your later "symmetrical"
> patch before it went into mmotm, I didn't see how renaming expand_downwards
> and expand_upwards to expand_stack_downwards and expand_stack_upwards was
> helpful either - needless change, and you end up using expand_stack_upwards
> on something which is not (what we usually call) the stack.

OK, I see your point. expand_stack_upwards in ia64_do_page_fault can be
confusing as well. Maybe if we stick with the original expand_upwards
and just make expand_downwards symmetrical without renameing to
"_stack_" like the patch does? I can rework that patch if there is an
interest. I would like to have it symmetrical, though, because the
original code was rather confusing.

> Now, if you're looking to make a nice cleanup, 

Originally I didn't plan to do a big cleanup. I just needed to backport
some stack gap fixes and I found the code confusing...

> how about getting rid of find_vma_prev(), which Linus made redundant
> when he suddenly added vm_prev in 2.6.36?  There's at least one place
> where I apologize for its expense in a BUG_ON, I'd be glad to see that
> killed off.

Good thing to do, let's see if I find some time...

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
