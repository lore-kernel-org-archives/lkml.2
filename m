Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2JFTM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab2JFTMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:12:25 -0400
Date: Sat, 6 Oct 2012 21:14:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns (v2)
Message-ID: <20121006191400.GA24391@redhat.com>
References: <1349516497-715551-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349516497-715551-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Andrew Vagin wrote:
>
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
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

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

But, Andrew... please note that this adds the unnecessary empty
line after "while (1)". The coding style police will complain
anyway, so I'd suggest you to send v3 ;)

Oleg.

