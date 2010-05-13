Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0EMXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:23:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0EMXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:23:17 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=_-wlEGonTnIA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=nKOPiV2LdG4oEJHN4BsA:9 a=n2ufFOQB4VCYSzKBqv4A:7 a=PVnQ1Qeksgzi045SBx-e1BV4SjQA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 12/12 v2] ring-buffer: Add cached pages when freeing
 reader page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100513221250.045111767@goodmis.org>
References: <20100513221004.765293881@goodmis.org>
	 <20100513221250.045111767@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 19:23:14 -0400
Message-ID: <1273792994.27703.1558.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 18:10 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0012-ring-buffer-Add-cached-pages-when-freeing-reader-pag.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When the pages are removed from the ring buffer for things like
> splice they are freed with ring_buffer_free_read_page().
> They are also allocated with ring_buffer_alloc_read_page().
> 
> Currently the ring buffer does not take advantage of this situation.
> Every time the page is freed, the ring buffer simply frees it.
> When a new page is needed, it allocates it. This means that reading
> several pages with splice will cause a page to be freed and allocated
> several times. This is simply a waste.
> 
> This patch adds a cache of the pages freed (16 max). This allows
> the pages to be reused quickly without need to go back to the memory
> pool.

Ah,

Silly me forgot to add locking. I was thinking that these were called
under a lock. They are in the above layers, but we can't rely on that
here.

Since this is the last patch, I'll just remove it from the branch. So
you can pull this branch still, and it will not include this patch.

Thanks!

-- Steve

> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |   41 +++++++++++++++++++++++++++++++++++------
>  1 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7f6059c..40667b2 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -157,6 +157,8 @@ static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
>  
>  #define BUF_PAGE_HDR_SIZE offsetof(struct buffer_data_page, data)
>  
> +#define RB_MAX_FREE_PAGES	16
> +
>  /**
>   * tracing_on - enable all tracing buffers
>   *
> @@ -325,7 +327,10 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
>  #define RB_MISSED_STORED	(1 << 30)
>  
>  struct buffer_data_page {
> -	u64		 time_stamp;	/* page time stamp */
> +	union {
> +		struct buffer_data_page	*next;	/* for free pages */
> +		u64		 time_stamp;	/* page time stamp */
> +	};
>  	local_t		 commit;	/* write committed index */
>  	unsigned char	 data[];	/* data of buffer page */
>  };
> @@ -472,6 +477,9 @@ struct ring_buffer {
>  	atomic_t			record_disabled;
>  	cpumask_var_t			cpumask;
>  
> +	struct buffer_data_page		*free_pages;
> +	int				nr_free_pages;
> +
>  	struct lock_class_key		*reader_lock_key;
>  
>  	struct mutex			mutex;
> @@ -1184,6 +1192,7 @@ EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
>  void
>  ring_buffer_free(struct ring_buffer *buffer)
>  {
> +	struct buffer_data_page *bpage;
>  	int cpu;
>  
>  	get_online_cpus();
> @@ -1200,6 +1209,11 @@ ring_buffer_free(struct ring_buffer *buffer)
>  	kfree(buffer->buffers);
>  	free_cpumask_var(buffer->cpumask);
>  
> +	while (buffer->free_pages) {
> +		bpage = buffer->free_pages;
> +		buffer->free_pages = bpage->next;
> +		free_page((unsigned long)bpage);
> +	};
>  	kfree(buffer);
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_free);
> @@ -3717,11 +3731,17 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
>  	struct buffer_data_page *bpage;
>  	unsigned long addr;
>  
> -	addr = __get_free_page(GFP_KERNEL);
> -	if (!addr)
> -		return NULL;
> +	if (!buffer->free_pages) {
> +		addr = __get_free_page(GFP_KERNEL);
> +		if (!addr)
> +			return NULL;
>  
> -	bpage = (void *)addr;
> +		bpage = (void *)addr;
> +	} else {
> +		bpage = buffer->free_pages;
> +		buffer->free_pages = bpage->next;
> +		buffer->nr_free_pages--;
> +	}
>  
>  	rb_init_page(bpage);
>  
> @@ -3738,7 +3758,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
>   */
>  void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
>  {
> -	free_page((unsigned long)data);
> +	struct buffer_data_page *bpage = data;
> +
> +	if (buffer->nr_free_pages >= RB_MAX_FREE_PAGES) {
> +		free_page((unsigned long)data);
> +		return;
> +	}
> +
> +	bpage->next = buffer->free_pages;
> +	buffer->free_pages = bpage;
> +	buffer->nr_free_pages++;
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
>  


