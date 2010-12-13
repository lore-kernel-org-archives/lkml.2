Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0LMHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:25:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0LMHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:25:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M6c4ApSJ3a5aGASilsWgFyIZo2BcXAMrHgDN/olwYjey8bBwkoN8FgamKm6ZgYPcpl
         xgf+zsCnTMDOY6i4ilTEhLyp07QjnBNMiqVaGOx8YVGTbHPwOkXXl/MsytLDN+G47WY5
         wLhsFcX4v+s8tX5/t9zC71bn/BRyQCoV0lfxE=
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and
 dcache scaling tree update and status)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101213024217.GC6522@amd>
References: <20101213023733.GB6522@amd>  <20101213024217.GC6522@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 08:25:13 +0100
Message-ID: <1292225113.18698.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 13 décembre 2010 à 13:42 +1100, Nick Piggin a écrit :
> + */
> +static inline void add_mnt_count(struct vfsmount *mnt, int n)

maybe name it __add_mnt_count() (should be called with preempt off)

> +{
> +#ifdef CONFIG_SMP
> +	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) += n;

__this_cpu_add(mnt->mnt_count, n);

> +#else
> +	mnt->mnt_count += n;
> +#endif
> +}

and define a preempt safe version :

static inline void __add_mnt_count(struct vfsmount *mnt, int n)
{
#ifdef CONFIG_SMP
	__this_cpu_add(mnt->mnt_count, n);
#else
	mnt->mnt_count += n;
#endif
}

static inline void add_mnt_count(struct vfsmount *mnt, int n)
{
#ifdef CONFIG_SMP
	this_cpu_add(mnt->mnt_count, n);
#else
	preempt_disable();
	mnt->mnt_count += n;
	preempt_enable();
#endif
}

> +
> +static inline void set_mnt_count(struct vfsmount *mnt, int n)
> +{
> +#ifdef CONFIG_SMP


> +	preempt_disable();
> +	(*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) = n;
> +	preempt_enable();

last 3 lines can be replaced by :

	this_cpu_write(mnt->mnt_count, n);

> +#else
> +	mnt->mnt_count = n;
> +#endif
> +}
> +

>  #ifdef CONFIG_SMP
>  	int __percpu *mnt_writers;
> +	int __percpu *mnt_count;
>  #else
>  	int mnt_writers;
> +	int mnt_count;
>  #endif

You could use a struct and one per cpu allocation to use one cache line
for both objects :

struct mnt_counters {
	int writers;
	int count;
};

...

#ifdef CONFIG_SMP
	struct mnt_counters __percpu *mnt_counters;
#else
	struct mnt_counters mnt_counters;
#endif

This would use one pointer instead of two in SMP


