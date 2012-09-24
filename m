Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2IXL0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:26:55 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:52278
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753726Ab2IXL0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:26:53 -0400
Message-ID: <50604368.8030202@mimc.co.uk>
Date: Mon, 24 Sep 2012 12:26:32 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "tony@atomide.com >> Tony Lindgren" <tony@atomide.com>
Subject: Re: gpmc_cs_request() causes early boot hang
References: <505CBFAA.3080604@mimc.co.uk> <C8443D0743D26F4388EA172BF4E2A7A93E9E7628@DBDE01.ent.ti.com> <50603B3C.8070402@mimc.co.uk> <C8443D0743D26F4388EA172BF4E2A7A93E9E7881@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E9E7881@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/12 12:13, Mohammed, Afzal wrote:
> Hi Mark,
> 
> On Mon, Sep 24, 2012 at 16:21:40, Mark Jackson wrote:
>> On 24/09/12 05:51, Mohammed, Afzal wrote:
> 
>>> It seems you are using PSP Kernel.
>>>
>>> Invoking omap_init_gpmc before gpmc request should help.
>>
>> Okay ... I'm now using earlyprintk and omap_init_gpmc(), but I still get boot hangs.
> 
>> Surely omap-gpmc needs to be setup before any calls such as gpmc_cs_request() ?
>>
>> Is there a method to delay my test code, or maybe get the omap-gpmc registered earlier ?
> 
> Hope below patch helps you (untested)
> 
> Regards
> Afzal
> 
> ----8<-------------------
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index 1c53c05..a4c6912 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -827,7 +827,19 @@ static struct platform_driver gpmc_driver = {
>         },
>  };
>  
> -module_platform_driver(gpmc_driver);
> +static __init int gpmc_init(void)
> +{
> +        return platform_driver_register(&gpmc_driver);
> +}
> +
> +static __exit void gpmc_exit(void)
> +{
> +        platform_driver_unregister(&gpmc_driver);
> +
> +}
> +
> +postcore_initcall(gpmc_init);
> +module_exit(gpmc_exit);
>  
>  int gpmc_suspend(void)
>  {
> ----8<----------------

Perfect !!

I also got it working by adding "late_init()" hooks into arch/arm/kernel/setup.c, but your code is
much simpler.

Regards
Mark J.
