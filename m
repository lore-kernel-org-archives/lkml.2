Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3ABSsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:48:50 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45793 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3ABSsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:48:46 -0500
Date: Wed, 2 Jan 2013 10:48:42 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting
 memory
In-Reply-To: <CA+55aFyH63agfbf+pYNRGHaprPqAJF=F19GR6ASP_RhoyDGLdA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1301021031230.30549@eggly.anvils>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils> <0000013bfbfbb293-ccc455ed-2db6-46e2-8362-dc418bae0def-000000@email.amazonses.com> <CA+55aFyH63agfbf+pYNRGHaprPqAJF=F19GR6ASP_RhoyDGLdA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013, Linus Torvalds wrote:
> On Wed, Jan 2, 2013 at 7:57 AM, Christoph Lameter <cl@linux.com> wrote:
> > On Wed, 2 Jan 2013, Hugh Dickins wrote:
> >
> >> @@ -2796,10 +2787,7 @@ int mpol_to_str(char *buffer, int maxlen
> >>       case MPOL_BIND:
> >>               /* Fall through */
> >>       case MPOL_INTERLEAVE:
> >> -             if (no_context)
> >> -                     nodes = pol->w.user_nodemask;
> >> -             else
> >> -                     nodes = pol->v.nodes;
> >> +             nodes = pol->v.nodes;
> >>               break;
> >>
> >
> > no_context was always true. Why is the code from the false branch kept?
> 
> no_context is zero in the caller in fs/proc/task_mmu.c, and one in the
> mm/shmem.c caller. So it's not always true (for mpol_parse_str() there
> is only one caller, and it's always true as Hugh said).

Yes, I think Christoph was remembering the old days when mpol_to_str()
started out just for tmpfs; later /proc/pid/numa_maps extended it for
use on vmas (the "contextualized" !no_context case).

> 
> Anyway, I do not know why Hugh took the true case, but I don't really
> imagine that it matters. So I'll take these two patches, but it would
> be good if you double-checked this, Hugh.

Thanks, yes, I played with a number of ways of fixing it (and sat on my
original fix for several days, rightly guessing this an area where more
problems would emerge - only later realizing mpol=prefer:Node wrong too).

I could probably have kept mpol_to_str()'s no_context arg, and done
something with it in the MPOL_PREFERRED case; perhaps would have chosen
that if the arg had been more understandably named than "no_context";
but in the end thought removing the need for the arg was simplest.

Hugh
