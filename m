Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3ACXT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:19:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3ACXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:19:22 -0500
Date: Thu, 3 Jan 2013 15:19:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 14/32] aio: Make aio_read_evt() more efficient, convert
 to hrtimers
Message-Id: <20130103151920.ae731c2c.akpm@linux-foundation.org>
In-Reply-To: <1356573611-18590-16-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-16-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012 17:59:52 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> Previously, aio_read_event() pulled a single completion off the
> ringbuffer at a time, locking and unlocking each time.  Changed it to
> pull off as many events as it can at a time, and copy them directly to
> userspace.
> 
> This also fixes a bug where if copying the event to userspace failed,
> we'd lose the event.
> 
> Also convert it to wait_event_interruptible_hrtimeout(), which
> simplifies it quite a bit.
> 
> ...
>
> -static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
> +static int aio_read_events_ring(struct kioctx *ctx,
> +				struct io_event __user *event, long nr)
>  {
> -	struct aio_ring_info *info = &ioctx->ring_info;
> +	struct aio_ring_info *info = &ctx->ring_info;
>  	struct aio_ring *ring;
> -	unsigned long head;
> -	int ret = 0;
> +	unsigned head, pos;
> +	int ret = 0, copy_ret;
> +
> +	if (!mutex_trylock(&info->ring_lock)) {
> +		__set_current_state(TASK_RUNNING);
> +		mutex_lock(&info->ring_lock);
> +	}

You're not big on showing your homework, I see :(

I agree that calling mutex_lock() in state TASK_[UN]INTERRUPTIBLE is at
least poor practice.  Assuming this is what the code is trying to do. 
But if aio_read_events_ring() is indeed called in state
TASK_[UN]INTERRUPTIBLE then the effect of the above code is to put the
task into an *unknown* state.

IOW, I don't have the foggiest clue what you're trying to do here and
you owe us all a code comment.  At least.


>  	ring = kmap_atomic(info->ring_pages[0]);
> -	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
> +	head = ring->head;
> +	kunmap_atomic(ring);
> +
> +	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
>  
> -	if (ring->head == ring->tail)
> +	if (head == info->tail)
>  		goto out;
>  
> -	spin_lock(&info->ring_lock);
> -
> -	head = ring->head % info->nr;
> -	if (head != ring->tail) {
> -		struct io_event *evp = aio_ring_event(info, head);
> -		*ent = *evp;
> -		head = (head + 1) % info->nr;
> -		smp_mb(); /* finish reading the event before updatng the head */
> -		ring->head = head;
> -		ret = 1;
> -		put_aio_ring_event(evp);
> +	__set_current_state(TASK_RUNNING);
> +
> +	while (ret < nr) {
> +		unsigned i = (head < info->tail ? info->tail : info->nr) - head;
> +		struct io_event *ev;
> +		struct page *page;
> +
> +		if (head == info->tail)
> +			break;
> +
> +		i = min_t(int, i, nr - ret);
> +		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
> +			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));

min_t() is kernel shorthand for "I screwed up my types".  Methinks
`ret' should have long type.  Or, better, unsigned (negative makes no
sense).  And when a C programmer sees an variable called "i" he thinks
it has type "int", so that guy should be renamed.

Can we please clean all this up?

> +		pos = head + AIO_EVENTS_OFFSET;
> +		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
> +		pos %= AIO_EVENTS_PER_PAGE;
> +
> +		ev = kmap(page);
> +		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
> +		kunmap(page);
> +
> +		if (unlikely(copy_ret)) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		ret += i;
> +		head += i;
> +		head %= info->nr;
>  	}
> -	spin_unlock(&info->ring_lock);
>  
> -out:
> +	ring = kmap_atomic(info->ring_pages[0]);
> +	ring->head = head;
>  	kunmap_atomic(ring);
> -	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
> +
> +	pr_debug("%d  h%u t%u\n", ret, head, info->tail);
> +out:
> +	mutex_unlock(&info->ring_lock);
> +
>  	return ret;
>  }
> 
> ...
>

