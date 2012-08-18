Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab2HRAMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 20:12:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47161 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab2HRAMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 20:12:13 -0400
Message-ID: <502EDDCC.200@iki.fi>
Date: Sat, 18 Aug 2012 03:11:56 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG
References: <20120817.090416.563933713934615530.hdoyu@nvidia.com>
In-Reply-To: <20120817.090416.563933713934615530.hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 09:04 AM, Hiroshi Doyu wrote:
> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
> suppressed". This shouldn't print anything without DEBUG.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Antti Palosaari <crope@iki.fi>
> ---
>   include/linux/device.h |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index eb945e1..d4dc26e 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -962,9 +962,13 @@ do {									\
>   	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>   #define dev_info_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> +#if defined(DEBUG)
>   #define dev_dbg_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
> -
> +#else
> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> +#endif
>   /*
>    * Stupid hackaround for existing uses of non-printk uses dev_info
>    *
>

NACK. I don't think that's correct behavior. After that patch it kills 
all output of dev_dbg_ratelimited(). If I use dynamic debugs and order 
debugs, I expect to see debugs as earlier.

I did test module in order to demonstrate problem. Here it is:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dev_dbg_ratelimited

There is also file named: test_results.txt
It contains 4 test cases:
1) without that patch & without module dynamic debug
2) without that patch & module dynamic debug ordered
3) with that patch & without module dynamic debug
4) with that patch & module dynamic debug ordered

regards
Antti

-- 
http://palosaari.fi/
