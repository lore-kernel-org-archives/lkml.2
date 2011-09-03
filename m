Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1ICCpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 22:45:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1ICCpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 22:45:36 -0400
X-Authority-Analysis: v=1.1 cv=8/tC3RumM5rsUT5KRAstW8ZpQtAyVpHweSUJct9LT6E= c=1 sm=0 a=WwlJiVmu3h4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=1XWaLZrsAAAA:8 a=cVYPzewkWZjKHrrlQ9gA:9 a=DjjO5bBcJfdx8vzJBVIA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=cTm3sj1N8mjvzHyA:21 a=k57JLrFOBhHVOc5F:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH v3] trace: Add per_cpu ring buffer control files
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1314062244-2997-1-git-send-email-vnagarnaik@google.com>
References: <1313531179-9323-4-git-send-email-vnagarnaik@google.com>
	 <1314062244-2997-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 02 Sep 2011 22:45:32 -0400
Message-ID: <1315017933.21100.55.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 18:17 -0700, Vaibhav Nagarnaik wrote:
> Add a debugfs entry under per_cpu/ folder for each cpu called
> buffer_size_kb to control the ring buffer size for each CPU
> independently.
> 
> If the global file buffer_size_kb is used to set size, the individual
> ring buffers will be adjusted to the given size. The buffer_size_kb will
> report the common size to maintain backward compatibility.
> 
> If the buffer_size_kb file under the per_cpu/ directory is used to
> change buffer size for a specific CPU, only the size of the respective
> ring buffer is updated. When tracing/buffer_size_kb is read, it reports
> 'X' to indicate that sizes of per_cpu ring buffers are not equivalent.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
> Changelog v3-v2:
> * Fix compilation errors when using allyesconfig.
> 
>  include/linux/ring_buffer.h |    6 +-
>  kernel/trace/ring_buffer.c  |  248 ++++++++++++++++++++++++-------------------
>  kernel/trace/trace.c        |  191 ++++++++++++++++++++++++++-------
>  kernel/trace/trace.h        |    2 +-
>  4 files changed, 298 insertions(+), 149 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 67be037..ad36702 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -96,9 +96,11 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
>  	__ring_buffer_alloc((size), (flags), &__key);	\
>  })
>  
> +#define RING_BUFFER_ALL_CPUS -1
> +
>  void ring_buffer_free(struct ring_buffer *buffer);
>  
> -int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
> +int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size, int cpu);
>  
>  void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
>  
> @@ -129,7 +131,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
>  void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
>  int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
>  
> -unsigned long ring_buffer_size(struct ring_buffer *buffer);
> +unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu);
>  
>  void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
>  void ring_buffer_reset(struct ring_buffer *buffer);
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index acf6b68..bb0ffdd 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -481,6 +481,7 @@ struct ring_buffer_per_cpu {
>  	spinlock_t			reader_lock;	/* serialize readers */
>  	arch_spinlock_t			lock;
>  	struct lock_class_key		lock_key;
> +	unsigned int			nr_pages;
>  	struct list_head		*pages;
>  	struct buffer_page		*head_page;	/* read from head */
>  	struct buffer_page		*tail_page;	/* write to tail */
> @@ -498,10 +499,12 @@ struct ring_buffer_per_cpu {
>  	unsigned long			read_bytes;
>  	u64				write_stamp;
>  	u64				read_stamp;
> +	/* ring buffer pages to update, > 0 to add, < 0 to remove */
> +	int				nr_pages_to_update;
> +	struct list_head		new_pages; /* new pages to add */

There's no reason for the added new_pages. And I'm not sure I even like
the 'nr_pages_to_update' either. These are only used for resizing and
are just wasting space otherwise.

You could allocate an array of numbers for the nr_pages_to_update and
use that instead. As for the list, heck, you can still use a single list
and pass that around like the original code did.


>  };
>  
>  struct ring_buffer {
> -	unsigned			pages;
>  	unsigned			flags;
>  	int				cpus;
>  	atomic_t			record_disabled;
> @@ -995,14 +998,10 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
>  	return 0;
>  }
>  
> -static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
> -			     unsigned nr_pages)
> +static int __rb_allocate_pages(int nr_pages, struct list_head *pages, int cpu)
>  {
> +	int i;
>  	struct buffer_page *bpage, *tmp;
> -	LIST_HEAD(pages);
> -	unsigned i;
> -
> -	WARN_ON(!nr_pages);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		struct page *page;
> @@ -1013,15 +1012,13 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  		 */
>  		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
>  				    GFP_KERNEL | __GFP_NORETRY,
> -				    cpu_to_node(cpu_buffer->cpu));
> +				    cpu_to_node(cpu));
>  		if (!bpage)
>  			goto free_pages;
>  
> -		rb_check_bpage(cpu_buffer, bpage);
> -
> -		list_add(&bpage->list, &pages);
> +		list_add(&bpage->list, pages);
>  
> -		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
> +		page = alloc_pages_node(cpu_to_node(cpu),
>  					GFP_KERNEL | __GFP_NORETRY, 0);
>  		if (!page)
>  			goto free_pages;
> @@ -1029,6 +1026,27 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  		rb_init_page(bpage->page);
>  	}
>  
> +	return 0;
> +
> +free_pages:
> +	list_for_each_entry_safe(bpage, tmp, pages, list) {
> +		list_del_init(&bpage->list);
> +		free_buffer_page(bpage);
> +	}
> +
> +	return -ENOMEM;
> +}
> +
> +static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
> +			     unsigned nr_pages)
> +{
> +	LIST_HEAD(pages);
> +
> +	WARN_ON(!nr_pages);
> +
> +	if (__rb_allocate_pages(nr_pages, &pages, cpu_buffer->cpu))
> +		return -ENOMEM;
> +
>  	/*
>  	 * The ring buffer page list is a circular list that does not
>  	 * start and end with a list head. All page list items point to
> @@ -1037,20 +1055,15 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	cpu_buffer->pages = pages.next;
>  	list_del(&pages);
>  
> +	cpu_buffer->nr_pages = nr_pages;
> +
>  	rb_check_pages(cpu_buffer);
>  
>  	return 0;
> -
> - free_pages:
> -	list_for_each_entry_safe(bpage, tmp, &pages, list) {
> -		list_del_init(&bpage->list);
> -		free_buffer_page(bpage);
> -	}
> -	return -ENOMEM;
>  }
>  
>  static struct ring_buffer_per_cpu *
> -rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
> +rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct buffer_page *bpage;
> @@ -1084,7 +1097,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
>  
>  	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
>  
> -	ret = rb_allocate_pages(cpu_buffer, buffer->pages);
> +	ret = rb_allocate_pages(cpu_buffer, nr_pages);
>  	if (ret < 0)
>  		goto fail_free_reader;
>  
> @@ -1145,7 +1158,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  {
>  	struct ring_buffer *buffer;
>  	int bsize;
> -	int cpu;
> +	int cpu, nr_pages;
>  
>  	/* keep it in its own cache line */
>  	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
> @@ -1156,14 +1169,14 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
>  		goto fail_free_buffer;
>  
> -	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
> +	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
>  	buffer->flags = flags;
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
>  
>  	/* need at least two pages */
> -	if (buffer->pages < 2)
> -		buffer->pages = 2;
> +	if (nr_pages < 2)
> +		nr_pages = 2;
>  
>  	/*
>  	 * In case of non-hotplug cpu, if the ring-buffer is allocated
> @@ -1186,7 +1199,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  
>  	for_each_buffer_cpu(buffer, cpu) {
>  		buffer->buffers[cpu] =
> -			rb_allocate_cpu_buffer(buffer, cpu);
> +			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
>  		if (!buffer->buffers[cpu])
>  			goto fail_free_buffers;
>  	}
> @@ -1308,6 +1321,17 @@ out:
>  	spin_unlock_irq(&cpu_buffer->reader_lock);
>  }
>  
> +static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	if (cpu_buffer->nr_pages_to_update > 0)
> +		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
> +				cpu_buffer->nr_pages_to_update);
> +	else
> +		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
> +	/* reset this value */
> +	cpu_buffer->nr_pages_to_update = 0;
> +}
> +
>  /**
>   * ring_buffer_resize - resize the ring buffer
>   * @buffer: the buffer to resize.
> @@ -1317,14 +1341,12 @@ out:
>   *
>   * Returns -1 on failure.
>   */
> -int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
> +int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
> +			int cpu_id)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
> -	unsigned nr_pages, rm_pages, new_pages;
> -	struct buffer_page *bpage, *tmp;
> -	unsigned long buffer_size;
> -	LIST_HEAD(pages);
> -	int i, cpu;
> +	unsigned nr_pages;
> +	int cpu;
>  
>  	/*
>  	 * Always succeed at resizing a non-existent buffer:
> @@ -1334,15 +1356,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  
>  	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
>  	size *= BUF_PAGE_SIZE;
> -	buffer_size = buffer->pages * BUF_PAGE_SIZE;
>  
>  	/* we need a minimum of two pages */
>  	if (size < BUF_PAGE_SIZE * 2)
>  		size = BUF_PAGE_SIZE * 2;
>  
> -	if (size == buffer_size)
> -		return size;
> -
>  	atomic_inc(&buffer->record_disabled);
>  
>  	/* Make sure all writers are done with this buffer. */
> @@ -1353,68 +1371,59 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  
>  	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
>  
> -	if (size < buffer_size) {
> +	if (cpu_id == RING_BUFFER_ALL_CPUS) {
> +		/* calculate the pages to update */
> +		for_each_buffer_cpu(buffer, cpu) {
> +			cpu_buffer = buffer->buffers[cpu];
> +
> +			cpu_buffer->nr_pages_to_update = nr_pages -
> +							cpu_buffer->nr_pages;
>  
> -		/* easy case, just free pages */
> -		if (RB_WARN_ON(buffer, nr_pages >= buffer->pages))
> -			goto out_fail;
> +			/*
> +			 * nothing more to do for removing pages or no update
> +			 */
> +			if (cpu_buffer->nr_pages_to_update <= 0)
> +				continue;
>  
> -		rm_pages = buffer->pages - nr_pages;
> +			/*
> +			 * to add pages, make sure all new pages can be
> +			 * allocated without receiving ENOMEM
> +			 */
> +			INIT_LIST_HEAD(&cpu_buffer->new_pages);
> +			if (__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
> +						&cpu_buffer->new_pages, cpu))
> +				/* not enough memory for new pages */
> +				goto no_mem;
> +		}
>  
> +		/* wait for all the updates to complete */
>  		for_each_buffer_cpu(buffer, cpu) {
>  			cpu_buffer = buffer->buffers[cpu];
> -			rb_remove_pages(cpu_buffer, rm_pages);
> +			if (cpu_buffer->nr_pages_to_update) {
> +				update_pages_handler(cpu_buffer);
> +				cpu_buffer->nr_pages = nr_pages;

The two places that call update_pages_handler() also updates
cpu_buffer->nr_pages. Move that to the update_pages_handler() as well.


> +			}
>  		}
> -		goto out;
> -	}
> +	} else {
> +		cpu_buffer = buffer->buffers[cpu_id];
> +		if (nr_pages == cpu_buffer->nr_pages)
> +			goto out;
>  
> -	/*
> -	 * This is a bit more difficult. We only want to add pages
> -	 * when we can allocate enough for all CPUs. We do this
> -	 * by allocating all the pages and storing them on a local
> -	 * link list. If we succeed in our allocation, then we
> -	 * add these pages to the cpu_buffers. Otherwise we just free
> -	 * them all and return -ENOMEM;
> -	 */
> -	if (RB_WARN_ON(buffer, nr_pages <= buffer->pages))
> -		goto out_fail;
> +		cpu_buffer->nr_pages_to_update = nr_pages -
> +						cpu_buffer->nr_pages;
>  
> -	new_pages = nr_pages - buffer->pages;
> +		INIT_LIST_HEAD(&cpu_buffer->new_pages);
> +		if (cpu_buffer->nr_pages_to_update > 0 &&
> +			__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
> +						&cpu_buffer->new_pages, cpu_id))
> +			goto no_mem;
>  
> -	for_each_buffer_cpu(buffer, cpu) {
> -		for (i = 0; i < new_pages; i++) {
> -			struct page *page;
> -			/*
> -			 * __GFP_NORETRY flag makes sure that the allocation
> -			 * fails gracefully without invoking oom-killer and
> -			 * the system is not destabilized.
> -			 */
> -			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
> -						  cache_line_size()),
> -					    GFP_KERNEL | __GFP_NORETRY,
> -					    cpu_to_node(cpu));
> -			if (!bpage)
> -				goto free_pages;
> -			list_add(&bpage->list, &pages);
> -			page = alloc_pages_node(cpu_to_node(cpu),
> -						GFP_KERNEL | __GFP_NORETRY, 0);
> -			if (!page)
> -				goto free_pages;
> -			bpage->page = page_address(page);
> -			rb_init_page(bpage->page);
> -		}
> -	}
> +		update_pages_handler(cpu_buffer);
>  
> -	for_each_buffer_cpu(buffer, cpu) {
> -		cpu_buffer = buffer->buffers[cpu];
> -		rb_insert_pages(cpu_buffer, &pages, new_pages);
> +		cpu_buffer->nr_pages = nr_pages;
>  	}
>  
> -	if (RB_WARN_ON(buffer, !list_empty(&pages)))
> -		goto out_fail;
> -
>   out:
> -	buffer->pages = nr_pages;
>  	put_online_cpus();
>  	mutex_unlock(&buffer->mutex);
>  
> @@ -1422,25 +1431,24 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  
>  	return size;
>  
> - free_pages:
> -	list_for_each_entry_safe(bpage, tmp, &pages, list) {
> -		list_del_init(&bpage->list);
> -		free_buffer_page(bpage);
> + no_mem:
> +	for_each_buffer_cpu(buffer, cpu) {
> +		struct buffer_page *bpage, *tmp;
> +		cpu_buffer = buffer->buffers[cpu];
> +		/* reset this number regardless */
> +		cpu_buffer->nr_pages_to_update = 0;
> +		if (list_empty(&cpu_buffer->new_pages))
> +			continue;
> +		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
> +					list) {
> +			list_del_init(&bpage->list);
> +			free_buffer_page(bpage);
> +		}
>  	}
>  	put_online_cpus();
>  	mutex_unlock(&buffer->mutex);
>  	atomic_dec(&buffer->record_disabled);
>  	return -ENOMEM;
> -
> -	/*
> -	 * Something went totally wrong, and we are too paranoid
> -	 * to even clean up the mess.
> -	 */
> - out_fail:
> -	put_online_cpus();
> -	mutex_unlock(&buffer->mutex);
> -	atomic_dec(&buffer->record_disabled);
> -	return -1;
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_resize);
>  
> @@ -1542,7 +1550,7 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
>  	 * assign the commit to the tail.
>  	 */
>   again:
> -	max_count = cpu_buffer->buffer->pages * 100;
> +	max_count = cpu_buffer->nr_pages * 100;
>  
>  	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
>  		if (RB_WARN_ON(cpu_buffer, !(--max_count)))
> @@ -3563,9 +3571,18 @@ EXPORT_SYMBOL_GPL(ring_buffer_read);
>   * ring_buffer_size - return the size of the ring buffer (in bytes)
>   * @buffer: The ring buffer.
>   */
> -unsigned long ring_buffer_size(struct ring_buffer *buffer)
> +unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu)
>  {
> -	return BUF_PAGE_SIZE * buffer->pages;
> +	/*
> +	 * Earlier, this method returned
> +	 *	BUF_PAGE_SIZE * buffer->nr_pages
> +	 * Since the nr_pages field is now removed, we have converted this to
> +	 * return the per cpu buffer value.
> +	 */
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +		return 0;
> +
> +	return BUF_PAGE_SIZE * buffer->buffers[cpu]->nr_pages;
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_size);
>  
> @@ -3740,8 +3757,11 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
>  		goto out;
>  
> +	cpu_buffer_a = buffer_a->buffers[cpu];
> +	cpu_buffer_b = buffer_b->buffers[cpu];
> +
>  	/* At least make sure the two buffers are somewhat the same */
> -	if (buffer_a->pages != buffer_b->pages)
> +	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
>  		goto out;
>  
>  	ret = -EAGAIN;
> @@ -3755,9 +3775,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	if (atomic_read(&buffer_b->record_disabled))
>  		goto out;
>  
> -	cpu_buffer_a = buffer_a->buffers[cpu];
> -	cpu_buffer_b = buffer_b->buffers[cpu];
> -
>  	if (atomic_read(&cpu_buffer_a->record_disabled))
>  		goto out;
>  
> @@ -4108,6 +4125,8 @@ static int rb_cpu_notify(struct notifier_block *self,
>  	struct ring_buffer *buffer =
>  		container_of(self, struct ring_buffer, cpu_notify);
>  	long cpu = (long)hcpu;
> +	int cpu_i, nr_pages_same;
> +	unsigned int nr_pages;
>  
>  	switch (action) {
>  	case CPU_UP_PREPARE:
> @@ -4115,8 +4134,23 @@ static int rb_cpu_notify(struct notifier_block *self,
>  		if (cpumask_test_cpu(cpu, buffer->cpumask))
>  			return NOTIFY_OK;
>  
> +		nr_pages = 0;
> +		nr_pages_same = 1;
> +		/* check if all cpu sizes are same */
> +		for_each_buffer_cpu(buffer, cpu_i) {
> +			/* fill in the size from first enabled cpu */
> +			if (nr_pages == 0)
> +				nr_pages = buffer->buffers[cpu_i]->nr_pages;
> +			if (nr_pages != buffer->buffers[cpu_i]->nr_pages) {
> +				nr_pages_same = 0;
> +				break;
> +			}
> +		}
> +		/* allocate minimum pages, user can later expand it */
> +		if (!nr_pages_same)
> +			nr_pages = 2;
>  		buffer->buffers[cpu] =
> -			rb_allocate_cpu_buffer(buffer, cpu);
> +			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
>  		if (!buffer->buffers[cpu]) {
>  			WARN(1, "failed to allocate ring buffer on CPU %ld\n",
>  			     cpu);
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b419070..bb3c867 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -784,7 +784,8 @@ __acquires(kernel_lock)
>  
>  		/* If we expanded the buffers, make sure the max is expanded too */
>  		if (ring_buffer_expanded && type->use_max_tr)
> -			ring_buffer_resize(max_tr.buffer, trace_buf_size);
> +			ring_buffer_resize(max_tr.buffer, trace_buf_size,
> +						RING_BUFFER_ALL_CPUS);
>  
>  		/* the test is responsible for initializing and enabling */
>  		pr_info("Testing tracer %s: ", type->name);
> @@ -800,7 +801,8 @@ __acquires(kernel_lock)
>  
>  		/* Shrink the max buffer again */
>  		if (ring_buffer_expanded && type->use_max_tr)
> -			ring_buffer_resize(max_tr.buffer, 1);
> +			ring_buffer_resize(max_tr.buffer, 1,
> +						RING_BUFFER_ALL_CPUS);
>  
>  		printk(KERN_CONT "PASSED\n");
>  	}
> @@ -2853,7 +2855,14 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
>  	return t->init(tr);
>  }
>  
> -static int __tracing_resize_ring_buffer(unsigned long size)
> +static void set_buffer_entries(struct trace_array *tr, unsigned long val)
> +{
> +	int cpu;
> +	for_each_tracing_cpu(cpu)
> +		tr->data[cpu]->entries = val;
> +}
> +
> +static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
>  {
>  	int ret;
>  
> @@ -2864,19 +2873,32 @@ static int __tracing_resize_ring_buffer(unsigned long size)
>  	 */
>  	ring_buffer_expanded = 1;
>  
> -	ret = ring_buffer_resize(global_trace.buffer, size);
> +	ret = ring_buffer_resize(global_trace.buffer, size, cpu);
>  	if (ret < 0)
>  		return ret;
>  
>  	if (!current_trace->use_max_tr)
>  		goto out;
>  
> -	ret = ring_buffer_resize(max_tr.buffer, size);
> +	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
>  	if (ret < 0) {
> -		int r;
> +		int r = 0;
> +
> +		if (cpu == RING_BUFFER_ALL_CPUS) {
> +			int i;
> +			for_each_tracing_cpu(i) {
> +				r = ring_buffer_resize(global_trace.buffer,
> +						global_trace.data[i]->entries,
> +						i);
> +				if (r < 0)
> +					break;
> +			}
> +		} else {
> +			r = ring_buffer_resize(global_trace.buffer,
> +						global_trace.data[cpu]->entries,
> +						cpu);
> +		}
>  
> -		r = ring_buffer_resize(global_trace.buffer,
> -				       global_trace.entries);
>  		if (r < 0) {
>  			/*
>  			 * AARGH! We are left with different
> @@ -2898,14 +2920,21 @@ static int __tracing_resize_ring_buffer(unsigned long size)
>  		return ret;
>  	}
>  
> -	max_tr.entries = size;
> +	if (cpu == RING_BUFFER_ALL_CPUS)
> +		set_buffer_entries(&max_tr, size);
> +	else
> +		max_tr.data[cpu]->entries = size;
> +
>   out:
> -	global_trace.entries = size;
> +	if (cpu == RING_BUFFER_ALL_CPUS)
> +		set_buffer_entries(&global_trace, size);
> +	else
> +		global_trace.data[cpu]->entries = size;
>  
>  	return ret;
>  }
>  
> -static ssize_t tracing_resize_ring_buffer(unsigned long size)
> +static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
>  {
>  	int cpu, ret = size;
>  
> @@ -2921,12 +2950,19 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size)
>  			atomic_inc(&max_tr.data[cpu]->disabled);
>  	}
>  
> -	if (size != global_trace.entries)
> -		ret = __tracing_resize_ring_buffer(size);
> +	if (cpu_id != RING_BUFFER_ALL_CPUS) {
> +		/* make sure, this cpu is enabled in the mask */
> +		if (!cpumask_test_cpu(cpu_id, tracing_buffer_mask)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +	}
>  
> +	ret = __tracing_resize_ring_buffer(size, cpu_id);
>  	if (ret < 0)
>  		ret = -ENOMEM;
>  
> +out:
>  	for_each_tracing_cpu(cpu) {
>  		if (global_trace.data[cpu])
>  			atomic_dec(&global_trace.data[cpu]->disabled);
> @@ -2957,7 +2993,8 @@ int tracing_update_buffers(void)
>  
>  	mutex_lock(&trace_types_lock);
>  	if (!ring_buffer_expanded)
> -		ret = __tracing_resize_ring_buffer(trace_buf_size);
> +		ret = __tracing_resize_ring_buffer(trace_buf_size,
> +						RING_BUFFER_ALL_CPUS);
>  	mutex_unlock(&trace_types_lock);
>  
>  	return ret;
> @@ -2981,7 +3018,8 @@ static int tracing_set_tracer(const char *buf)
>  	mutex_lock(&trace_types_lock);
>  
>  	if (!ring_buffer_expanded) {
> -		ret = __tracing_resize_ring_buffer(trace_buf_size);
> +		ret = __tracing_resize_ring_buffer(trace_buf_size,
> +						RING_BUFFER_ALL_CPUS);
>  		if (ret < 0)
>  			goto out;
>  		ret = 0;
> @@ -3007,8 +3045,8 @@ static int tracing_set_tracer(const char *buf)
>  		 * The max_tr ring buffer has some state (e.g. ring->clock) and
>  		 * we want preserve it.
>  		 */
> -		ring_buffer_resize(max_tr.buffer, 1);
> -		max_tr.entries = 1;
> +		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
> +		set_buffer_entries(&max_tr, 1);
>  	}
>  	destroy_trace_option_files(topts);
>  
> @@ -3016,10 +3054,17 @@ static int tracing_set_tracer(const char *buf)
>  
>  	topts = create_trace_option_files(current_trace);
>  	if (current_trace->use_max_tr) {
> -		ret = ring_buffer_resize(max_tr.buffer, global_trace.entries);
> -		if (ret < 0)
> -			goto out;
> -		max_tr.entries = global_trace.entries;
> +		int cpu;
> +		/* we need to make per cpu buffer sizes equivalent */
> +		for_each_tracing_cpu(cpu) {
> +			ret = ring_buffer_resize(max_tr.buffer,
> +						global_trace.data[cpu]->entries,
> +						cpu);
> +			if (ret < 0)
> +				goto out;
> +			max_tr.data[cpu]->entries =
> +					global_trace.data[cpu]->entries;
> +		}
>  	}
>  
>  	if (t->init) {
> @@ -3521,30 +3566,82 @@ out_err:
>  	goto out;
>  }
>  
> +struct ftrace_entries_info {
> +	struct trace_array	*tr;
> +	int			cpu;
> +};
> +
> +static int tracing_entries_open(struct inode *inode, struct file *filp)
> +{
> +	struct ftrace_entries_info *info;
> +
> +	if (tracing_disabled)
> +		return -ENODEV;
> +
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->tr = &global_trace;
> +	info->cpu = (unsigned long)inode->i_private;
> +
> +	filp->private_data = info;
> +
> +	return 0;
> +}
> +
>  static ssize_t
>  tracing_entries_read(struct file *filp, char __user *ubuf,
>  		     size_t cnt, loff_t *ppos)
>  {
> -	struct trace_array *tr = filp->private_data;
> -	char buf[96];
> -	int r;
> +	struct ftrace_entries_info *info = filp->private_data;
> +	struct trace_array *tr = info->tr;
> +	char buf[64];
> +	int r = 0;
> +	ssize_t ret;
>  
>  	mutex_lock(&trace_types_lock);
> -	if (!ring_buffer_expanded)
> -		r = sprintf(buf, "%lu (expanded: %lu)\n",
> -			    tr->entries >> 10,
> -			    trace_buf_size >> 10);
> -	else
> -		r = sprintf(buf, "%lu\n", tr->entries >> 10);
> +
> +	if (info->cpu == RING_BUFFER_ALL_CPUS) {
> +		int cpu, buf_size_same;
> +		unsigned long size;
> +
> +		size = 0;
> +		buf_size_same = 1;
> +		/* check if all cpu sizes are same */
> +		for_each_tracing_cpu(cpu) {
> +			/* fill in the size from first enabled cpu */
> +			if (size == 0)
> +				size = tr->data[cpu]->entries;
> +			if (size != tr->data[cpu]->entries) {
> +				buf_size_same = 0;
> +				break;
> +			}
> +		}
> +
> +		if (buf_size_same) {
> +			if (!ring_buffer_expanded)
> +				r = sprintf(buf, "%lu (expanded: %lu)\n",
> +					    size >> 10,
> +					    trace_buf_size >> 10);
> +			else
> +				r = sprintf(buf, "%lu\n", size >> 10);
> +		} else
> +			r = sprintf(buf, "X\n");
> +	} else
> +		r = sprintf(buf, "%lu\n", tr->data[info->cpu]->entries >> 10);
> +
>  	mutex_unlock(&trace_types_lock);
>  
> -	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +	return ret;
>  }
>  
>  static ssize_t
>  tracing_entries_write(struct file *filp, const char __user *ubuf,
>  		      size_t cnt, loff_t *ppos)
>  {
> +	struct ftrace_entries_info *info = filp->private_data;
>  	unsigned long val;
>  	int ret;
>  
> @@ -3559,7 +3656,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	/* value is in KB */
>  	val <<= 10;
>  
> -	ret = tracing_resize_ring_buffer(val);
> +	ret = tracing_resize_ring_buffer(val, info->cpu);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3568,6 +3665,16 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	return cnt;
>  }
>  
> +static int
> +tracing_entries_release(struct inode *inode, struct file *filp)
> +{
> +	struct ftrace_entries_info *info = filp->private_data;
> +
> +	kfree(info);
> +
> +	return 0;
> +}
> +
>  static ssize_t
>  tracing_total_entries_read(struct file *filp, char __user *ubuf,
>  				size_t cnt, loff_t *ppos)
> @@ -3579,7 +3686,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
>  
>  	mutex_lock(&trace_types_lock);
>  	for_each_tracing_cpu(cpu) {
> -		size += tr->entries >> 10;
> +		size += tr->data[cpu]->entries >> 10;
>  		if (!ring_buffer_expanded)
>  			expanded_size += trace_buf_size >> 10;
>  	}
> @@ -3613,7 +3720,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
>  	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
>  		tracing_off();
>  	/* resize the ring buffer to 0 */
> -	tracing_resize_ring_buffer(0);
> +	tracing_resize_ring_buffer(0, RING_BUFFER_ALL_CPUS);
>  
>  	return 0;
>  }
> @@ -3757,9 +3864,10 @@ static const struct file_operations tracing_pipe_fops = {
>  };
>  
>  static const struct file_operations tracing_entries_fops = {
> -	.open		= tracing_open_generic,
> +	.open		= tracing_entries_open,
>  	.read		= tracing_entries_read,
>  	.write		= tracing_entries_write,
> +	.release	= tracing_entries_release,
>  	.llseek		= generic_file_llseek,
>  };
>  
> @@ -4211,6 +4319,9 @@ static void tracing_init_debugfs_percpu(long cpu)
>  
>  	trace_create_file("stats", 0444, d_cpu,
>  			(void *) cpu, &tracing_stats_fops);
> +
> +	trace_create_file("buffer_size_kb", 0444, d_cpu,
> +			(void *) cpu, &tracing_entries_fops);
>  }
>  
>  #ifdef CONFIG_FTRACE_SELFTEST
> @@ -4491,7 +4602,7 @@ static __init int tracer_init_debugfs(void)
>  			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
>  
>  	trace_create_file("buffer_size_kb", 0644, d_tracer,
> -			&global_trace, &tracing_entries_fops);
> +			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
>  
>  	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
>  			&global_trace, &tracing_total_entries_fops);
> @@ -4737,8 +4848,6 @@ __init static int tracer_alloc_buffers(void)
>  		WARN_ON(1);
>  		goto out_free_cpumask;
>  	}
> -	global_trace.entries = ring_buffer_size(global_trace.buffer);
> -
>  
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
> @@ -4748,7 +4857,6 @@ __init static int tracer_alloc_buffers(void)
>  		ring_buffer_free(global_trace.buffer);
>  		goto out_free_cpumask;
>  	}
> -	max_tr.entries = 1;
>  #endif
>  
>  	/* Allocate the first page for all buffers */
> @@ -4757,6 +4865,11 @@ __init static int tracer_alloc_buffers(void)
>  		max_tr.data[i] = &per_cpu(max_tr_data, i);
>  	}
>  
> +	set_buffer_entries(&global_trace, ring_buf_size);
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	set_buffer_entries(&max_tr, 1);
> +#endif
> +
>  	trace_init_cmdlines();
>  
>  	register_tracer(&nop_trace);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 616846b..126d333 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -125,6 +125,7 @@ struct trace_array_cpu {
>  	atomic_t		disabled;
>  	void			*buffer_page;	/* ring buffer spare */
>  
> +	unsigned long		entries;
>  	unsigned long		saved_latency;
>  	unsigned long		critical_start;
>  	unsigned long		critical_end;
> @@ -146,7 +147,6 @@ struct trace_array_cpu {
>   */
>  struct trace_array {
>  	struct ring_buffer	*buffer;
> -	unsigned long		entries;
>  	int			cpu;
>  	cycle_t			time_start;
>  	struct task_struct	*waiter;


I'm still very nervous about this patch. I'm going to hold off a release
cycle before even giving it up to Ingo.

Thanks!

-- Steve


