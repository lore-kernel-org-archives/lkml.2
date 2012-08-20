Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2HTV34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:29:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59694 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2HTV3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:29:52 -0400
Message-ID: <5032AC3E.5080402@iki.fi>
Date: Tue, 21 Aug 2012 00:29:34 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG
References: <20120817.090416.563933713934615530.hdoyu@nvidia.com><502EDDCC.200@iki.fi> <20120820.141454.449841061737873578.hdoyu@nvidia.com>
In-Reply-To: <20120820.141454.449841061737873578.hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 02:14 PM, Hiroshi Doyu wrote:
> Hi Antti,
>
> Antti Palosaari <crope@iki.fi> wrote @ Sat, 18 Aug 2012 02:11:56 +0200:
>
>> On 08/17/2012 09:04 AM, Hiroshi Doyu wrote:
>>> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
>>> suppressed". This shouldn't print anything without DEBUG.
>>>
>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>> Reported-by: Antti Palosaari <crope@iki.fi>
>>> ---
>>>    include/linux/device.h |    6 +++++-
>>>    1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/linux/device.h b/include/linux/device.h
>>> index eb945e1..d4dc26e 100644
>>> --- a/include/linux/device.h
>>> +++ b/include/linux/device.h
>>> @@ -962,9 +962,13 @@ do {									\
>>>    	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>>>    #define dev_info_ratelimited(dev, fmt, ...)				\
>>>    	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
>>> +#if defined(DEBUG)
>>>    #define dev_dbg_ratelimited(dev, fmt, ...)				\
>>>    	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
>>> -
>>> +#else
>>> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
>>> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>>> +#endif
>>>    /*
>>>     * Stupid hackaround for existing uses of non-printk uses dev_info
>>>     *
>>>
>>
>> NACK. I don't think that's correct behavior. After that patch it kills
>> all output of dev_dbg_ratelimited(). If I use dynamic debugs and order
>> debugs, I expect to see debugs as earlier.
>
> You are right. I attached the update patch, just moving *_ratelimited
> functions after dev_dbg() definitions.
>
> With DEBUG defined/undefined in your "test.ko", it works fine. With
> CONFIG_DYNAMIC_DEBUG, it works with "+p", but with "-p", still
> "..callbacks suppressed" is printed.

I am using dynamic debugs and behavior is now just same as it was when 
reported that bug. OK, likely for static debug it is now correct.

> $ insmod test.ko
> $ echo -n 'module test +p' > /sys/kernel/debug/dynamic_debug/control"
> $ rmmod test
> $ dmesg | tail -15
> <7>[   69.047192] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   69.047233] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   69.047275] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <4>[   75.057045] print_dev_dbg_ratelimited: 90 callbacks suppressed
> <7>[   75.063595] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.063796] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.063970] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064137] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064307] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064472] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064640] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064806] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.064972] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <7>[   75.065137] (NULL device *): print_dev_dbg_ratelimited: dev_dbg_ratelimited()
> <6>[   75.065510] test module unloaded!
>
> $ insmod test.ko
> $ echo -n 'module test -p' > /sys/kernel/debug/dynamic_debug/control"
> $ rmmod test
> $ dmesg
> ...
> <6>[   82.715925] test module loaded!
> <6>[   82.795642] dynamic_debug:ddebug_exec_queries: processed 1 queries, with 1 matches, 0 errs
> <4>[   88.892096] print_dev_dbg_ratelimited: 90 callbacks suppressed
> <6>[   88.898397] test module unloaded!
>
> Any suggestion to control "... callbacks suppressed" with
> CONFIG_DYNAMIC_DEBUG would be appreciated.

Is it Joe Perches who has added these Kernel dynamic pr_ and dev_ 
debugging? Maybe he has proper solution that fixes ratelimit for dynamic 
debugging too.

regards
Antti

>
>>From 5b33751f89c2e91ee734325e6d73ed7e1c6d4b02 Mon Sep 17 00:00:00 2001
> From: Hiroshi Doyu <hdoyu@nvidia.com>
> Date: Mon, 20 Aug 2012 13:49:19 +0300
> Subject: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
>   DEBUG
>
> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
> suppressed". This shouldn't print anything without DEBUG.
>
> With CONFIG_DYNAMIC_DEBUG, the print should be configured as expected.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Antti Palosaari <crope@iki.fi>
> ---
>   include/linux/device.h |   53 ++++++++++++++++++++++++++---------------------
>   1 files changed, 29 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 9648331..763bca4 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -932,6 +932,32 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
>
>   #endif
>
> +/*
> + * Stupid hackaround for existing uses of non-printk uses dev_info
> + *
> + * Note that the definition of dev_info below is actually _dev_info
> + * and a macro is used to avoid redefining dev_info
> + */
> +
> +#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> +
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +#define dev_dbg(dev, format, ...)		     \
> +do {						     \
> +	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> +} while (0)
> +#elif defined(DEBUG)
> +#define dev_dbg(dev, format, arg...)		\
> +	dev_printk(KERN_DEBUG, dev, format, ##arg)
> +#else
> +#define dev_dbg(dev, format, arg...)				\
> +({								\
> +	if (0)							\
> +		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> +	0;							\
> +})
> +#endif
> +
>   #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
>   do {									\
>   	static DEFINE_RATELIMIT_STATE(_rs,				\
> @@ -955,33 +981,12 @@ do {									\
>   	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>   #define dev_info_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> +#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
>   #define dev_dbg_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
> -
> -/*
> - * Stupid hackaround for existing uses of non-printk uses dev_info
> - *
> - * Note that the definition of dev_info below is actually _dev_info
> - * and a macro is used to avoid redefining dev_info
> - */
> -
> -#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> -
> -#if defined(CONFIG_DYNAMIC_DEBUG)
> -#define dev_dbg(dev, format, ...)		     \
> -do {						     \
> -	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> -} while (0)
> -#elif defined(DEBUG)
> -#define dev_dbg(dev, format, arg...)		\
> -	dev_printk(KERN_DEBUG, dev, format, ##arg)
>   #else
> -#define dev_dbg(dev, format, arg...)				\
> -({								\
> -	if (0)							\
> -		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
> -	0;							\
> -})
> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>   #endif
>
>   #ifdef VERBOSE_DEBUG
>


-- 
http://palosaari.fi/
