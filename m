Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2EYU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:57:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46833 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753759Ab2EYU5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:57:05 -0400
Message-ID: <1337979424.30100.19.camel@joe2Laptop>
Subject: Re: [PATCH v3 12/16] Closures
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Date: Fri, 25 May 2012 13:57:04 -0700
In-Reply-To: <1337977539-16977-13-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
	 <1337977539-16977-13-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 13:25 -0700, Kent Overstreet wrote:
> Asynchronous refcounty thingies; they embed a refcount and a work
> struct. Extensive documentation follows in include/linux/closure.h
[]
> diff --git a/include/linux/closure.h b/include/linux/closure.h
[]
> +enum closure_type {
> +	TYPE_closure				= 0,

I still think these should be
	CLOSURE_TYPE_closure
etc.

> +#define __CLOSURE_TYPE(cl, _t)						\
> +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> +		? TYPE_ ## _t :						\
	CLOSURE_TYPE_##_t

> +#define __closure_type(cl)						\
> +(									\
> +	__CLOSURE_TYPE(cl, closure)					\
> +	__CLOSURE_TYPE(cl, closure_with_waitlist)			\
> +	__CLOSURE_TYPE(cl, closure_with_timer)				\
> +	__CLOSURE_TYPE(cl, closure_with_waitlist_and_timer)		\
> +	invalid_closure_type()						\
> +)

You should still feel dirty about this...

> +#define continue_at(_cl, _fn, _wq, ...)					\
> +do {									\
> +	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
> +	closure_set_ip(_cl);						\
> +	set_closure_fn(_cl, _fn, _wq);					\
> +	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
> +	return __VA_ARGS__;						\
> +} while (0)

Does this have to be a macro?

> diff --git a/lib/closure.c b/lib/closure.c
[]
> +#define CL_FIELD(type, field)					\
> +	case TYPE_ ## type:					\
> +	return &container_of(cl, struct type, cl)->field
> +
> +static struct closure_waitlist *closure_waitlist(struct closure *cl)
> +{
> +	switch (cl->type) {
> +		CL_FIELD(closure_with_waitlist, wait);
> +		CL_FIELD(closure_with_waitlist_and_timer, wait);
> +	default:
> +		return NULL;
> +	}
> +}

Here:

static struct closure_waitlist *closure_waitlist(struct closure *cl)
{
	switch (cl->type) {
	case CLOSURE_TYPE_closure_with_waitlist:
		return &container_of(cl, struct closure_with_waitlist, cl)->wait;
	case CLOSURE_TYPE_closure_with_waitlist_and_timer:
		return &container_of(cl, struct closure_with_waitlist_and_timer, cl)->wait;
	}

	return NULL;
}


