Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab2D0KnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:43:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63863 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab2D0KnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:43:17 -0400
Date: Fri, 27 Apr 2012 03:43:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
In-Reply-To: <4F9A0360.3030900@kernel.org>
Message-ID: <alpine.DEB.2.00.1204270340450.11866@chino.kir.corp.google.com>
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com> <4F965413.9010305@kernel.org>
 <CAPa8GCCwfCFO6yxwUP5Qp9O1HGUqEU2BZrrf50w8TL9FH9vbrA@mail.gmail.com> <20120424143015.99fd8d4a.akpm@linux-foundation.org> <4F973BF2.4080406@jp.fujitsu.com> <CAHGf_=r09BCxXeuE8dSti4_SrT5yahrQCwJh=NrrA3rsUhhu_w@mail.gmail.com> <4F973FB8.6050103@jp.fujitsu.com>
 <20120424172554.c9c330dd.akpm@linux-foundation.org> <4F98914C.2060505@jp.fujitsu.com> <alpine.DEB.2.00.1204251715420.19452@chino.kir.corp.google.com> <4F9A0360.3030900@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Minchan Kim wrote:

> > Maybe a per-thread_info variant of gfp_allowed_mask?  So Andrew's 
> > set_current_gfp() becomes set_current_gfp_allowed() that does
> > 
> > 	void set_current_gfp_allowed(gfp_t gfp_mask)
> > 	{
> > 		current->gfp_allowed = gfp_mask & gfp_allowed_mask;
> > 	}
> > 
> > and then the page allocator does
> > 
> > 	gfp_mask &= current->gfp_allowed;
> > 
> > rather than how it currently does
> > 
> > 	gfp_mask &= gfp_allowed_mask;
> > 
> > and then the caller of set_current_gfp_allowed() cleans up with 
> > set_current_gfp_allowed(__GFP_BITS_MASK).
> 

[trimmed the newsgroups from the reply, not sure what the point is?]

> Caller should restore old gfp_mask instead of __GFP_BITS_MASK in case of
> nesting.And how do we care of atomic context?
> 

Eek, I'm hoping these aren't going to be nested but sure that seems 
appropraite if they are.  (I'm also hoping these will only be either 
__GFP_HIGH or __GFP_BITS_MASK and no other combinations.)

Forcing atomic context would just be set_current_gfp_allowed(__GFP_HIGH).
