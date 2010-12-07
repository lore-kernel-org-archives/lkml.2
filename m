Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LGHCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:02:40 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:47733 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0LGHCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:02:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC1o/Ux5LdIm/2dsb2JhbACjNnLAA4VJBJAH
Date: Tue, 7 Dec 2010 18:02:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from
  mapping_unevictable()
Message-ID: <20101207070233.GB3307@amd>
References: <20101207015834.196176991@goodmis.org>
 <20101207021328.569328536@goodmis.org>
 <1291688533.16223.119.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291688533.16223.119.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 09:22:13PM -0500, Steven Rostedt wrote:
> [ Resending to Nick's real email ]
> 
> 
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The mapping_unevictable() has a likely() around the mapping parameter.
> This mapping parameter comes from page_mapping() which has an
> unlikely() that the page will be set as PAGE_MAPPING_ANON, and if
> so, it will return NULL. One would think that this unlikely() means
> that the mapping returned by page_mapping() would not be NULL, but
> where page_mapping() is used just above mapping_unevictable(), that
> unlikely() is incorrect most of the time. This means that the
> "likely(mapping)" in mapping_unevictable() is incorrect most of the
> time.
> 
> Running the annotated branch profiler on my main box which runs firefox,
> evolution, xchat and is part of my distcc farm, I had this:
> 
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
> 12872836 1269443893  98 mapping_unevictable            pagemap.h            51
> 35935762 1270265395  97 page_mapping                   mm.h                 659
> 1306198001   143659   0 page_mapping                   mm.h                 657
> 203131478   121586   0 page_mapping                   mm.h                 657
>  5415491     1116   0 page_mapping                   mm.h                 657
> 74899487     1116   0 page_mapping                   mm.h                 657
> 203132845      224   0 page_mapping                   mm.h                 659
>  5415464       27   0 page_mapping                   mm.h                 659
>    13552        0   0 page_mapping                   mm.h                 657
>    13552        0   0 page_mapping                   mm.h                 659
>   242630        0   0 page_mapping                   mm.h                 657
>   242630        0   0 page_mapping                   mm.h                 659
> 74899487        0   0 page_mapping                   mm.h                 659
> 
> The page_mapping() is a static inline, which is why it shows up multiple
> times. The mapping_unevictable() is also a static inline but seems to
> be used only once in my setup.
> 
> The unlikely in page_mapping() was correct a total of 1909540379 times and
> incorrect 1270533123 times, with a 39% being incorrect. Perhaps this is
> enough to remove the unlikely from page_mapping() as well.

I think so. We don't have good guidelines or empirical numbers on this,
unfortunately, but I think it would be somewhere over 90%, given that it
tends to add jumps to and from out of line icache in the incorrect case.

Acked-by: Nick Piggin <npiggin@kernel.dk>

