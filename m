Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2JISsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:48:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2JISsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:48:22 -0400
Date: Tue, 9 Oct 2012 11:48:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns (v3)
Message-Id: <20121009114821.dc4c2aff.akpm@linux-foundation.org>
In-Reply-To: <1349553393-902065-1-git-send-email-avagin@openvz.org>
References: <1349553393-902065-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Oct 2012 23:56:33 +0400
Andrew Vagin <avagin@openvz.org> wrote:

> Here is a stack trace of recursion:
> free_pid_ns(parent)
>   put_pid_ns(parent)
>     kref_put(&ns->kref, free_pid_ns);
>       free_pid_ns
> 
> This patch turns recursion into loops.
> 
> pidns can be nested many times, so in case of recursion
> a simple user space program can provoke a kernel panic
> due to exceed of a kernel stack.

So we should backport this into earlier kernels.

> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -95,6 +95,18 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
>  	return kref_sub(kref, 1, release);
>  }
>  
> +/**
> + * kref_put - decrement refcount for object.
> + * @kref: object.
> + *
> + * Decrement the refcount.
> + * Return 1 if refcount is zero.
> + */
> +static inline int __kref_put(struct kref *kref)
> +{
> +	return atomic_dec_and_test(&kref->refcount);
> +}

Greg might be interested in this.

It's a pretty specialised thing and perhaps it needs some stern words
in the description explaining when and why it should and shouldn't be
used.

I wonder if people might (ab)use this to avoid the "doesn't
have a release function" warning.

>  static inline int kref_put_mutex(struct kref *kref,
>  				 void (*release)(struct kref *kref),
>  				 struct mutex *lock)
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 6144bab..b051fa6 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -138,11 +138,19 @@ void free_pid_ns(struct kref *kref)
>  
>  	ns = container_of(kref, struct pid_namespace, kref);
>  
> -	parent = ns->parent;
> -	destroy_pid_namespace(ns);
> +	while (1) {
> +		parent = ns->parent;
> +		destroy_pid_namespace(ns);
>  
> -	if (parent != NULL)
> -		put_pid_ns(parent);
> +		if (parent == &init_pid_ns)
> +			break;
> +
> +		/* kref_put cannot be used for avoiding recursion */
> +		if (__kref_put(&parent->kref) == 0)
> +			break;
> +
> +		ns = parent;
> +	}
>  }
>  
>  void zap_pid_ns_processes(struct pid_namespace *pid_ns)

