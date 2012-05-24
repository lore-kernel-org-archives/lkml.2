Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2EXAr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:47:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59652 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171Ab2EXArZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:47:25 -0400
Message-ID: <1337820443.1747.24.camel@joe2Laptop>
Subject: Re: [PATCH v2 12/14] Closures
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Date: Wed, 23 May 2012 17:47:23 -0700
In-Reply-To: <1337817771-25038-13-git-send-email-koverstreet@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	 <1337817771-25038-13-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:02 -0700, Kent Overstreet wrote:
> Asynchronous refcounty thingies;

Hi again Kent.

Highly descriptive word choice you've employed there.

> they embed a refcount and a work
> struct. Extensive documentation follows in include/linux/closure.h

All trivia:

> diff --git a/include/linux/closure.h b/include/linux/closure.h
[]
> +#define CLOSURE_REMAINING_MASK	(~(~0 << 20))

More commonly used is ((1 << 20) - 1)

> +#define CLOSURE_GUARD_MASK					\
> +	((1 << 20)|(1 << 22)|(1 << 24)|(1 << 26)|(1 << 28)|(1 << 30))

Perhaps a poor choice of layout.

Perhaps it'd be more sensible to define CLOSURE_<FOO>_GUARDs
along with CLOSURE_<FOO>

It might make more sense to use another macro with
the somewhat magic number of 20 more explicitly defined.

> +
> +	/*
> +	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
> +	 * closure_init() and when closure_put() runs then next function), and
> +	 * must be cleared before remaining hits 0. Primarily to help guard
> +	 * against incorrect usage and accidently transferring references.

accidentally

[]
> +	 * CLOSURE_TIMER: Analagous to CLOSURE_WAITING, indicates that a closure

analogous

[]

> +#define TYPE_closure			0U
> +#define TYPE_closure_with_waitlist	1U
> +#define TYPE_closure_with_timer		2U
> +#define TYPE_closure_with_waitlist_and_timer 3U

UPPER_lower is generally frowned on.
It'd be better to use CLOSURE_TYPE as all uses
are obscured by macros.

> +#define MAX_CLOSURE_TYPE		3U
> +	unsigned		type;
> +
> +#ifdef CONFIG_DEBUG_CLOSURES
> +#define CLOSURE_MAGIC_DEAD	0xc054dead
> +#define CLOSURE_MAGIC_ALIVE	0xc054a11e
> +
> +	unsigned		magic;
> +	struct list_head	all;
> +	unsigned long		ip;
> +	unsigned long		waiting_on;
> +#endif
> +};
> +
> +struct closure_with_waitlist {
> +	struct closure	cl;
> +	closure_list_t	wait;
> +};
> +
> +struct closure_with_timer {
> +	struct closure	cl;
> +	struct timer_list timer;
> +};
> +
> +struct closure_with_waitlist_and_timer {
> +	struct closure	cl;
> +	closure_list_t	wait;
> +	struct timer_list timer;
> +};
> +
> +extern unsigned invalid_closure_type(void);
> +
> +#define __CL_TYPE(cl, _t)						\
> +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> +		? TYPE_ ## _t :						\

Might as well use __CLOSURE_TYPE

> +
> +#define __closure_type(cl)						\
> +(									\
> +	__CL_TYPE(cl, closure)						\
> +	__CL_TYPE(cl, closure_with_waitlist)				\
> +	__CL_TYPE(cl, closure_with_timer)				\
> +	__CL_TYPE(cl, closure_with_waitlist_and_timer)			\
> +	invalid_closure_type()						\
> +)

outstandingly obscure. props.

> diff --git a/lib/closure.c b/lib/closure.c

[]
> +#define CL_FIELD(type, field)					\
> +	case TYPE_ ## type:					\
> +	return &container_of(cl, struct type, cl)->field
> +
> +static closure_list_t *closure_waitlist(struct closure *cl)
> +{
> +	switch (cl->type) {
> +		CL_FIELD(closure_with_waitlist, wait);
> +		CL_FIELD(closure_with_waitlist_and_timer, wait);
> +	}
> +	return NULL;
> +}
> +
> +static struct timer_list *closure_timer(struct closure *cl)
> +{
> +	switch (cl->type) {
> +		CL_FIELD(closure_with_timer, timer);
> +		CL_FIELD(closure_with_waitlist_and_timer, timer);
> +	}
> +	return NULL;
> +}
> +

Another paragon of intelligibility.

I think you should lose CL_FIELD and
write normal switch/cases.

[]

> +static int debug_seq_show(struct seq_file *f, void *data)
> +{
> +	struct closure *cl;
> +	spin_lock_irq(&closure_list_lock);
> +
> +	list_for_each_entry(cl, &closure_list, all) {
> +		int r = atomic_read(&cl->remaining);
> +
> +		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
> +			   cl, (void *) cl->ip, cl->fn, cl->parent,
> +			   r & CLOSURE_REMAINING_MASK);
> +
> +		if (test_bit(WORK_STRUCT_PENDING, work_data_bits(&cl->work)))
> +			seq_printf(f, "Q");

seq_putc or seq_puts

> +
> +		if (r & CLOSURE_RUNNING)
> +			seq_printf(f, "R");
> +
> +		if (r & CLOSURE_BLOCKING)
> +			seq_printf(f, "B");
> +
> +		if (r & CLOSURE_STACK)
> +			seq_printf(f, "S");
> +
> +		if (r & CLOSURE_SLEEPING)
> +			seq_printf(f, "Sl");
> +
> +		if (r & CLOSURE_TIMER)
> +			seq_printf(f, "T");
> +
> +		if (r & CLOSURE_WAITING)
> +			seq_printf(f, " W %pF\n",
> +				   (void *) cl->waiting_on);
> +
> +		seq_printf(f, "\n");

or maybe just bundle all this in a single seq_printf



