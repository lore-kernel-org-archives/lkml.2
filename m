Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0CSW2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:28:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47927 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0CSW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:28:30 -0400
Message-ID: <4BA3F8ED.2090600@zytor.com>
Date: Fri, 19 Mar 2010 15:21:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org>
In-Reply-To: <4BA3F82D.5090807@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 03:18 PM, Yinghai Lu wrote:
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
>  kernel/early_res.c             |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 3cb2c66..f3a861b 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	if (WARN_ONCE(start >= end,
> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
> +		      start, end))
> +		return;
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)

No, that's wrong.

The workaround is still needed for the case of equality to avoid the
infinite loop.

So you need an:

	if (start == end)
		return;

	-hpa
