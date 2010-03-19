Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0CSXgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:36:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:45020 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0CSXgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:36:04 -0400
X-IronPort-AV: E=Sophos;i="4.51,276,1267419600"; 
   d="scan'208";a="88855838"
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4BA407B8.7070503@kernel.org>
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org>
	 <4BA3F8ED.2090600@zytor.com>  <4BA407B8.7070503@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 19 Mar 2010 23:35:58 +0000
Message-ID: <1269041758.28761.33.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 23:24 +0000, Yinghai Lu wrote: 
> On 03/19/2010 03:21 PM, H. Peter Anvin wrote:
> > On 03/19/2010 03:18 PM, Yinghai Lu wrote:
> >> From: Ian Campbell <ian.campbell@citrix.com>
> >>
> >> This avoids an infinite loop in free_early_partial().
> >>
> >> Add a warning to free_early_partial to catch future problems.
> >>
> >> -v3: according to hpa, don't bother caller.
> >>
> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> ---
> >>  kernel/early_res.c             |    5 +++++
> >>  1 files changed, 5 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/early_res.c b/kernel/early_res.c
> >> index 3cb2c66..f3a861b 100644
> >> --- a/kernel/early_res.c
> >> +++ b/kernel/early_res.c
> >> @@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
> >>  	struct early_res *r;
> >>  	int i;
> >>  
> >> +	if (WARN_ONCE(start >= end,
> >> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
> >> +		      start, end))
> >> +		return;
> >> +
> >>  try_next:
> >>  	i = find_overlapped_early(start, end);
> >>  	if (i >= max_early_res)
> > 
> > No, that's wrong.
> > 
> > The workaround is still needed for the case of equality to avoid the
> > infinite loop.
> > 
> > So you need an:
> > 
> > 	if (start == end)
> > 		return;
> > 
> 
> confused, do you mean like this
> if (start < end), find_overlapped_early will stop the loop.

I think Peter means:

if (start == end)
return;

if (WARN_ONCE(start < end, "blah"))
return;

i.e. silently ignore a zero sized region and verbosely ignore a
negatively sized one.

Ian.


> From: Ian Campbell <ian.campbell@citrix.com>
> 
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.
> 
> -v3: according to hpa, don't bother caller.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/early_res.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/kernel/early_res.c
> ===================================================================
> --- linux-2.6.orig/kernel/early_res.c
> +++ linux-2.6/kernel/early_res.c
> @@ -333,6 +333,14 @@ void __init free_early_partial(u64 start
>  	struct early_res *r;
>  	int i;
>  
> +	if (start >= end) {
> +		WARN_ONCE(1,
> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
> +		      start, end);
> +
> +		return;
> +	}
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)


