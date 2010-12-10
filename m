Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0LJHAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:00:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60323 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0LJHAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:00:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from mapping_unevictable()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <1291688533.16223.119.camel@gandalf.stny.rr.com>
References: <20101207021328.569328536@goodmis.org> <1291688533.16223.119.camel@gandalf.stny.rr.com>
Message-Id: <20101210160115.C7C4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Dec 2010 16:00:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/pagemap.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2d1ffe3..9c66e99 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -48,7 +48,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
>  
>  static inline int mapping_unevictable(struct address_space *mapping)
>  {
> -	if (likely(mapping))
> +	if (mapping)
>  		return test_bit(AS_UNEVICTABLE, &mapping->flags);
>  	return !!mapping;
>  }

I think you are right.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




