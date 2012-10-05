Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2JEOp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab2JEOpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:45:53 -0400
Date: Fri, 5 Oct 2012 16:47:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns
Message-ID: <20121005144729.GA20497@redhat.com>
References: <1349385662-571743-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349385662-571743-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Andrew Vagin wrote:
>
> Here is a stack trace of recursion:
> free_pid_ns(parent)
>   put_pid_ns(parent)
>     kref_put(&ns->kref, free_pid_ns);
>       free_pid_ns
>
> This patch turns recursion into loops.

I think the patch is correct, a couple of minor nits.

> +static inline int __kref_put(struct kref *kref)
> +{
> +	return atomic_sub_and_test(1, &kref->refcount);

perhaps atomic_dec_and_test(&kref->refcount) makes more sense?

> +}
> @@ -138,11 +138,20 @@ void free_pid_ns(struct kref *kref)
>
>  	ns = container_of(kref, struct pid_namespace, kref);
>
> -	parent = ns->parent;
> -	destroy_pid_namespace(ns);
> +	while (1) {
>
> -	if (parent != NULL)
> -		put_pid_ns(parent);
> +		parent = ns->parent;
> +		destroy_pid_namespace(ns);
> +
> +		if (parent == NULL || parent == &init_pid_ns)
                    ^^^^^^^^^^^^^^

Why ns->parent == NULL is only possible if ns == init_pid_ns, right?
But in this case we should not be here. The caller verifies that
initial ns != init_pid_ns, and this loops should stop once we reach
init_pid_ns.

Oleg.

