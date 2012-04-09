Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2DIIri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:47:38 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:53061 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2DIIrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:47:37 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 04:47:37 EDT
Subject: Re: [PATCH 1/3] vmevent: Should not grab mutex in the atomic
 context
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
In-Reply-To: <20120408233802.GA4839@panacea>
References: <20120408233550.GA3791@panacea>  <20120408233802.GA4839@panacea>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 09 Apr 2012 11:40:31 +0300
Message-ID: <1333960831.3943.4.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 03:38 +0400, Anton Vorontsov wrote:
> vmevent grabs a mutex in the atomic context, and so this pops up:
> 
> BUG: sleeping function called from invalid context at kernel/mutex.c:271
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
> 1 lock held by swapper/0/0:
>  #0:  (&watch->timer){+.-...}, at: [<ffffffff8103eb80>] call_timer_fn+0x0/0xf0
> Pid: 0, comm: swapper/0 Not tainted 3.2.0+ #6
> Call Trace:
>  <IRQ>  [<ffffffff8102f5da>] __might_sleep+0x12a/0x1e0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff81321f2c>] mutex_lock_nested+0x3c/0x340
>  [<ffffffff81064b33>] ? lock_acquire+0xa3/0xc0
>  [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff810bda21>] vmevent_timer_fn+0x91/0xf0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff8103ebf5>] call_timer_fn+0x75/0xf0
>  [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
>  [<ffffffff81062fdd>] ? trace_hardirqs_on_caller+0x7d/0x120
>  [<ffffffff8103ee9f>] run_timer_softirq+0x10f/0x1e0
>  [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
>  [<ffffffff81038d90>] __do_softirq+0xb0/0x160
>  [<ffffffff8105eb0f>] ? tick_program_event+0x1f/0x30
>  [<ffffffff8132642c>] call_softirq+0x1c/0x26
>  [<ffffffff810036d5>] do_softirq+0x85/0xc0
> 
> This patch fixes the issue by removing the mutex and making the logic
> lock-free.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

What guarantees that there's only one thread writing to struct
vmevent_attr::value in vmevent_sample() now that the mutex is gone?

> ---
>  mm/vmevent.c |   35 ++++++++++++-----------------------
>  1 files changed, 12 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/vmevent.c b/mm/vmevent.c
> index 1847b56..a56174f 100644
> --- a/mm/vmevent.c
> +++ b/mm/vmevent.c
> @@ -1,4 +1,5 @@
>  #include <linux/anon_inodes.h>
> +#include <linux/atomic.h>
>  #include <linux/vmevent.h>
>  #include <linux/syscalls.h>
>  #include <linux/timer.h>
> @@ -23,7 +24,7 @@ struct vmevent_watch {
>  	struct vmevent_config		config;
>  
>  	struct mutex			mutex;
> -	bool				pending;
> +	atomic_t			pending;
>  
>  	/*
>  	 * Attributes that are exported as part of delivered VM events.
> @@ -103,20 +104,18 @@ static void vmevent_sample(struct vmevent_watch *watch)
>  {
>  	int i;
>  
> +	if (atomic_read(&watch->pending))
> +		return;
>  	if (!vmevent_match(watch))
>  		return;
>  
> -	mutex_lock(&watch->mutex);
> -
> -	watch->pending = true;
> -
>  	for (i = 0; i < watch->nr_attrs; i++) {
>  		struct vmevent_attr *attr = &watch->sample_attrs[i];
>  
>  		attr->value = vmevent_sample_attr(watch, attr);
>  	}
>  
> -	mutex_unlock(&watch->mutex);
> +	atomic_set(&watch->pending, 1);
>  }
>  
>  static void vmevent_timer_fn(unsigned long data)
> @@ -125,7 +124,7 @@ static void vmevent_timer_fn(unsigned long data)
>  
>  	vmevent_sample(watch);
>  
> -	if (watch->pending)
> +	if (atomic_read(&watch->pending))
>  		wake_up(&watch->waitq);
>  	mod_timer(&watch->timer, jiffies +
>  			nsecs_to_jiffies64(watch->config.sample_period_ns));
> @@ -148,13 +147,9 @@ static unsigned int vmevent_poll(struct file *file, poll_table *wait)
>  
>  	poll_wait(file, &watch->waitq, wait);
>  
> -	mutex_lock(&watch->mutex);
> -
> -	if (watch->pending)
> +	if (atomic_read(&watch->pending))
>  		events |= POLLIN;
>  
> -	mutex_unlock(&watch->mutex);
> -
>  	return events;
>  }
>  
> @@ -171,15 +166,13 @@ static ssize_t vmevent_read(struct file *file, char __user *buf, size_t count, l
>  	if (count < size)
>  		return -EINVAL;
>  
> -	mutex_lock(&watch->mutex);
> -
> -	if (!watch->pending)
> -		goto out_unlock;
> +	if (!atomic_read(&watch->pending))
> +		goto out;
>  
>  	event = kmalloc(size, GFP_KERNEL);
>  	if (!event) {
>  		ret = -ENOMEM;
> -		goto out_unlock;
> +		goto out;
>  	}
>  
>  	for (i = 0; i < watch->nr_attrs; i++) {
> @@ -195,14 +188,10 @@ static ssize_t vmevent_read(struct file *file, char __user *buf, size_t count, l
>  
>  	ret = count;
>  
> -	watch->pending = false;
> -
> +	atomic_set(&watch->pending, 0);
>  out_free:
>  	kfree(event);
> -
> -out_unlock:
> -	mutex_unlock(&watch->mutex);
> -
> +out:
>  	return ret;
>  }
>  


