Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0J3VwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:52:10 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:63393 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0J3VwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:52:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADMvzExGGOIS/2dsb2JhbAChSXK8ZYVEBI9d
Date: Sat, 30 Oct 2010 17:47:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
	vzalloc rather than vmalloc and memset
Message-ID: <20101030214704.GA20005@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:33:00 up 206 days,  7:23,  3 users,  load average: 0.12, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jj@chaosbits.net) wrote:
> Hi,
> 
> We can optimize kernel/relay.c::relay_alloc_page_array() slightly by using 
> vzalloc. The patch makes these changes:
> 
>  - use vzalloc instead of vmalloc+memset.
>  - remove redundant local variable 'array'.
>  - declare local 'pa_size' as const.

Hrm ? How does declaring a local variable as const helps the compiler in
any way ?

Moreover, is there anyone still using this code ? LTTng uses the Generic
Ring Buffer library which completely deprecates relay.c. Perf and Ftrace
each have their own ring buffers, without dependency on relay.c.

BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
relay dependency to the Generic Ring Buffer Library might be a good
option to consider.

Thanks,

Mathieu

> 
> Cuts down nicely on both source and object-code size.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> Compile tested only.
> 
>  relay.c |   15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index c7cf397..859ea5a 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -70,17 +70,10 @@ static const struct vm_operations_struct relay_file_mmap_ops = {
>   */
>  static struct page **relay_alloc_page_array(unsigned int n_pages)
>  {
> -	struct page **array;
> -	size_t pa_size = n_pages * sizeof(struct page *);
> -
> -	if (pa_size > PAGE_SIZE) {
> -		array = vmalloc(pa_size);
> -		if (array)
> -			memset(array, 0, pa_size);
> -	} else {
> -		array = kzalloc(pa_size, GFP_KERNEL);
> -	}
> -	return array;
> +	const size_t pa_size = n_pages * sizeof(struct page *);
> +	if (pa_size > PAGE_SIZE)
> +		return vzalloc(pa_size);
> +	return kzalloc(pa_size, GFP_KERNEL);
>  }
>  
>  /*
> 
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
