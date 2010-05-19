Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0ESU1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:27:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab0ESU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:27:46 -0400
Date: Wed, 19 May 2010 13:26:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix uninitialized spinlock of printk_ratelimited()
Message-Id: <20100519132659.b787d17f.akpm@linux-foundation.org>
In-Reply-To: <87hbm7e6x9.fsf@devron.myhome.or.jp>
References: <87hbm7e6x9.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 08:57:38 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> ratelimit_state initialization of printk_ratelimited() seems
> broken. This fixes it by using DEFINE_RATELIMIT_STATE() to initialize
> spinlock properly.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  include/linux/kernel.h |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff -puN include/linux/kernel.h~printk_ratelimited-fix include/linux/kernel.h
> --- linux-2.6/include/linux/kernel.h~printk_ratelimited-fix	2010-05-17 03:37:33.000000000 +0900
> +++ linux-2.6-hirofumi/include/linux/kernel.h	2010-05-17 03:37:33.000000000 +0900
> @@ -420,14 +420,13 @@ static inline char *pack_hex_byte(char *
>   * no local ratelimit_state used in the !PRINTK case
>   */
>  #ifdef CONFIG_PRINTK
> -#define printk_ratelimited(fmt, ...)  ({		\
> -	static struct ratelimit_state _rs = {		\
> -		.interval = DEFAULT_RATELIMIT_INTERVAL, \
> -		.burst = DEFAULT_RATELIMIT_BURST,       \
> -	};                                              \
> -							\
> -	if (__ratelimit(&_rs))                          \
> -		printk(fmt, ##__VA_ARGS__);		\
> +#define printk_ratelimited(fmt, ...)  ({				\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +									\
> +	if (__ratelimit(&_rs))						\
> +		printk(fmt, ##__VA_ARGS__);				\
>  })

hm, yes, that spinlock will get the all-zeroes pattern.

It's been like this since December 2009.  I'm a bit surprised that none
of our spinlock-debugging goodies picked this up.  All the
CONFIG_DEBUG_SPINLOCK spinlock fields end up zeroed out also.

