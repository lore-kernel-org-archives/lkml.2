Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0I3Qp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 12:45:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab0I3Qp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 12:45:26 -0400
Date: Thu, 30 Sep 2010 09:45:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
Message-Id: <20100930094558.97c9afa2.akpm@linux-foundation.org>
In-Reply-To: <1285842136.2615.251.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-16-git-send-email-david@fromorbit.com>
	<20100929215312.5fcb6976.akpm@linux-foundation.org>
	<1285824982.5211.675.camel@edumazet-laptop>
	<1285833189.2615.31.camel@edumazet-laptop>
	<20100930011417.6ca16ed7.akpm@linux-foundation.org>
	<1285842136.2615.251.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 12:22:16 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 30 septembre 2010 __ 01:14 -0700, Andrew Morton a __crit :
> 
> > Perhaps
> > 
> > 	WARN_ON_ONCE(preemptible());
> > 
> > if we had a developer-only version of WARN_ON_ONCE, which we don't.
> 
> Or just use a regular PER_CPU variable, even on !SMP, and get preempt
> safe implementation.

Good stuff.

> What do you think of following patch, on top of current linux-2.6 tree ?
>
> ...
>
> +static noinline unsigned int last_ino_get(void)
> +{
> +	unsigned int *p = &get_cpu_var(last_ino);
> +	unsigned int res = *p;
> +
> +#ifdef CONFIG_SMP
> +	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
> +		static atomic_t shared_last_ino;
> +		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
> +
> +		res = next - LAST_INO_BATCH;
> +	}
> +#endif
> +	*p = ++res;
> +	put_cpu_var(last_ino);
> +	return res;
> +}

Could eliminate `p' I guess, but that would involve using
__get_cpu_var() as an lval, which looks vile and might generate worse
code.

Readers of this code won't know why last_ino_get() was marked noinline.
It looks wrong, really.
