Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0ENW0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:26:51 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51066 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754081Ab0ENW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:26:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADdl7UtGGOJc/2dsb2JhbACeBXK9VYUQBA
Date: Fri, 14 May 2010 18:26:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 12/13 v3] ring-buffer: Add cached pages when freeing
	reader page
Message-ID: <20100514222647.GB14234@Krystal>
References: <20100514192246.079025623@goodmis.org> <20100514192916.945900385@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100514192916.945900385@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:24:35 up 37 days,  8:18,  3 users,  load average: 0.27, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
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

Trying to understand the effect of splice() putting the page in the page
cache and how it affects this patch.

Basically, how do you know you can call free_page() from splice() in the
first place ? Answering this question will probably help us see if this
page reuse is OK.

Thanks,

Mathieu

> 
> v2: Added in locking that should have been there in the first release.
> 
> Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |   52 ++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7f6059c..7aded7d 100644
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
> @@ -472,6 +477,10 @@ struct ring_buffer {
>  	atomic_t			record_disabled;
>  	cpumask_var_t			cpumask;
>  
> +	struct buffer_data_page		*free_pages;
> +	int				nr_free_pages;
> +	spinlock_t			free_pages_lock;
> +
>  	struct lock_class_key		*reader_lock_key;
>  
>  	struct mutex			mutex;
> @@ -1118,6 +1127,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  	buffer->flags = flags;
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
> +	spin_lock_init(&buffer->free_pages_lock);
>  
>  	/* need at least two pages */
>  	if (buffer->pages < 2)
> @@ -1184,6 +1194,7 @@ EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
>  void
>  ring_buffer_free(struct ring_buffer *buffer)
>  {
> +	struct buffer_data_page *bpage;
>  	int cpu;
>  
>  	get_online_cpus();
> @@ -1200,6 +1211,11 @@ ring_buffer_free(struct ring_buffer *buffer)
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
> @@ -3714,14 +3730,24 @@ EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
>   */
>  void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
>  {
> -	struct buffer_data_page *bpage;
> +	struct buffer_data_page *bpage = NULL;
>  	unsigned long addr;
>  
> -	addr = __get_free_page(GFP_KERNEL);
> -	if (!addr)
> -		return NULL;
> +	spin_lock(&buffer->free_pages_lock);
> +	if (buffer->free_pages) {
> +		bpage = buffer->free_pages;
> +		buffer->free_pages = bpage->next;
> +		buffer->nr_free_pages--;
> +	}
> +	spin_unlock(&buffer->free_pages_lock);
>  
> -	bpage = (void *)addr;
> +	if (!bpage) {
> +		addr = __get_free_page(GFP_KERNEL);
> +		if (!addr)
> +			return NULL;
> +
> +		bpage = (void *)addr;
> +	}
>  
>  	rb_init_page(bpage);
>  
> @@ -3738,7 +3764,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
>   */
>  void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
>  {
> -	free_page((unsigned long)data);
> +	struct buffer_data_page *bpage = data;
> +
> +	spin_lock(&buffer->free_pages_lock);
> +	if (buffer->nr_free_pages >= RB_MAX_FREE_PAGES) {
> +		spin_unlock(&buffer->free_pages_lock);
> +		free_page((unsigned long)data);
> +		return;
> +	}
> +
> +	bpage->next = buffer->free_pages;
> +	buffer->free_pages = bpage;
> +	buffer->nr_free_pages++;
> +	spin_unlock(&buffer->free_pages_lock);
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
>  
> -- 
> 1.7.0
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
