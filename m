Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab0INGa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:30:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:41119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0INGa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,362,1280732400"; 
   d="scan'208";a="324256746"
Message-ID: <4C8F167E.40506@linux.intel.com>
Date: Tue, 14 Sep 2010 14:30:22 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: fenghua.yu@intel.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix module init for		hotplug-but-no-device-found
 case
References: <4C8E139F0200007800015AA5@vpn.id2.novell.com>
In-Reply-To: <4C8E139F0200007800015AA5@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/13/2010 6:05 PM, Jan Beulich 写道:
> In commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae the call to
> platform_driver_unregister() was made conditional upon !HOTPLUG_CPU,
> but the return value from coretemp_init() was left to indicate an
> error. This isn't correct, as the negative return value indicates to
> the module loader that initialization failed, which isn't intended

only !HOTPLUG_CPU can remove the driver. That is what we need to do 
because under the hotplug condition, we need to consider those "offline"
cpus. I don't understand what you are afraid. Can you give me a scinario ?

> here and results in dangling pointers.
>
> Signed-off-by: Jan Beulich<jbeulich@novell.com>
> Cc: Chen Gong<gong.chen@linux.intel.com>
>
> ---
>   drivers/hwmon/coretemp.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
> +++ 2.6.36-rc4-x86-coretemp-hotplug-init-return/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
> @@ -541,16 +541,19 @@ static int __init coretemp_init(void)
>   				" has no thermal sensor.\n", c->x86_model);
>   		}
>   	}
> +
> +#ifndef CONFIG_HOTPLUG_CPU
>   	if (list_empty(&pdev_list)) {
>   		err = -ENODEV;
>   		goto exit_driver_unreg;
>   	}
> +#endif
>
>   	register_hotcpu_notifier(&coretemp_cpu_notifier);
>   	return 0;
>
> -exit_driver_unreg:
>   #ifndef CONFIG_HOTPLUG_CPU
> +exit_driver_unreg:
>   	platform_driver_unregister(&coretemp_driver);
>   #endif
>   exit:
>
>
>
>
