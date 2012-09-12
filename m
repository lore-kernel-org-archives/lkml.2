Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab2ILDWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:22:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45174 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759868Ab2ILDWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:22:40 -0400
Message-ID: <1347420159.2456.15.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] Add ratelimited printk for different alert levels
From: Joe Perches <joe@perches.com>
To: raghu.prabhu13@gmail.com
Cc: xfs@oss.sgi.com, david@fromorbit.com,
        Raghavendra D Prabhu <rprabhu@wnohang.net>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 11 Sep 2012 20:22:39 -0700
In-Reply-To: <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	 <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 03:43 +0530, raghu.prabhu13@gmail.com wrote:
> Ratelimited printk will be useful in printing xfs messages which are otherwise
> not required to be printed always due to their high rate (to prevent kernel ring
> buffer from overflowing), while at the same time required to be printed.
[]
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
[]
> @@ -30,6 +32,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>  }
>  #endif
>  
> +#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
> +} while (0)

It might be better to use an xfs singleton RATELIMIT_STATE

DEFINE_RATELIMIT_STATE(xfs_rs);
...
#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
do {									\
	if (__ratelimit(&xfs_rs))					\
		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
} while (0)


