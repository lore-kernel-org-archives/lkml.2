Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab2DZAUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:20:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2DZAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:20:36 -0400
Date: Wed, 25 Apr 2012 17:20:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
In-Reply-To: <4F98914C.2060505@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1204251715420.19452@chino.kir.corp.google.com>
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com> <4F965413.9010305@kernel.org>
 <CAPa8GCCwfCFO6yxwUP5Qp9O1HGUqEU2BZrrf50w8TL9FH9vbrA@mail.gmail.com> <20120424143015.99fd8d4a.akpm@linux-foundation.org> <4F973BF2.4080406@jp.fujitsu.com> <CAHGf_=r09BCxXeuE8dSti4_SrT5yahrQCwJh=NrrA3rsUhhu_w@mail.gmail.com> <4F973FB8.6050103@jp.fujitsu.com>
 <20120424172554.c9c330dd.akpm@linux-foundation.org> <4F98914C.2060505@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, KAMEZAWA Hiroyuki wrote:

> > Or do we instead do this:
> > 
> > -	some_function(foo, bar, GFP_NOIO);
> > +	old_gfp = set_current_gfp(GFP_NOIO);
> > +	some_function(foo, bar);
> > +	set_current_gfp(old_gfp);
> > 
> > So the rule is "if the code was using an explicit GFP_foo then convert
> > it to use set_current_gfp().  If the code was receiving a gfp_t
> > variable from the caller then delete that arg".
> > 
> > Or something like that.  It's all too hopelessly impractical to bother
> > discussing - 20 years too late!
> > 
> > 
> > otoh, maybe a constrained version of this could be used to address the
> > vmalloc() problem alone.
> > 
> 
> Yes, I think it will be good start.
> 

Maybe a per-thread_info variant of gfp_allowed_mask?  So Andrew's 
set_current_gfp() becomes set_current_gfp_allowed() that does

	void set_current_gfp_allowed(gfp_t gfp_mask)
	{
		current->gfp_allowed = gfp_mask & gfp_allowed_mask;
	}

and then the page allocator does

	gfp_mask &= current->gfp_allowed;

rather than how it currently does

	gfp_mask &= gfp_allowed_mask;

and then the caller of set_current_gfp_allowed() cleans up with 
set_current_gfp_allowed(__GFP_BITS_MASK).
