Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2JIVsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:48:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2JIVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:48:44 -0400
Date: Tue, 9 Oct 2012 14:48:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] lglock: add DEFINE_STATIC_LGLOCK()
Message-Id: <20121009144842.a4f161c9.akpm@linux-foundation.org>
In-Reply-To: <1349754403-4798-3-git-send-email-laijs@cn.fujitsu.com>
References: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
	<1349754403-4798-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012 11:46:40 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> When if the lglock don't to be exported,
> we can use DEFINE_STATIC_LGLOCK().
> 
> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -32,7 +32,8 @@
>  #define br_write_lock(name)	lg_global_lock(name)
>  #define br_write_unlock(name)	lg_global_unlock(name)
>  
> -#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
> +#define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
> +#define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  #define LOCKDEP_INIT_MAP lockdep_init_map
> @@ -53,6 +54,11 @@ struct lglock {
>  	= __ARCH_SPIN_LOCK_UNLOCKED;					\
>  	struct lglock name = { .lock = &name ## _lock }
>  
> +#define DEFINE_STATIC_LGLOCK(name)					\
> +	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
> +	= __ARCH_SPIN_LOCK_UNLOCKED;					\
> +	static struct lglock name = { .lock = &name ## _lock }
> +
>  void lg_lock_init(struct lglock *lg, char *name);
>  void lg_local_lock(struct lglock *lg);
>  void lg_local_unlock(struct lglock *lg);

hm, this is a bit sad.  It would be better if we could do

static DEFINE_LGLOCK(foo);

but I don't immediately see a way in which we can rework
DEFINE_LGLOCK() to permit that.

