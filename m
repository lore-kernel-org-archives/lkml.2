Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1HEOU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:20:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53893 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1HEOU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:20:57 -0400
Message-ID: <4E3BFC26.8060904@linux.vnet.ibm.com>
Date: Fri, 05 Aug 2011 10:20:22 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] tpm: tpm_nsc: Fix a double free of pdev in cleanup_nsc
References: <1312415887.2604.1.camel@phoenix>
In-Reply-To: <1312415887.2604.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 07:58 PM, Axel Lin wrote:
> platform_device_unregister() will release all resources
> and remove it from the subsystem, then drop reference count by
> calling platform_device_put().
I also changed code into that direction in the recent patch to the 
tpm_nsc driver. I didn't know whether that memory had to be freed or 
not. Looking at several other drivers I found that none was freeing it 
but calling platform_device_put() (which is also called by 
platform_device_unregiser()) with the memory previously allocated via 
platform_device_alloc(). Though platform_device_put() calls put_device()

http://lxr.linux.no/#linux+v3.0/drivers/base/platform.c#L138

which in turn calls kobject_put().

http://lxr.linux.no/#linux+v3.0/drivers/base/core.c#L1066

It was not clear to me whether the pdev memory would actually get freed 
by kobject_put() -- but since other drivers were not freeing it 
explicitly I wasn't sure. So either many drivers have a memory leak or 
tpm_nsc was previously right about freeing it...

    Stefan

> We should not call kfree(pdev) after platform_device_unregister(pdev).
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/char/tpm/tpm_nsc.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
> index 82facc9..4d24648 100644
> --- a/drivers/char/tpm/tpm_nsc.c
> +++ b/drivers/char/tpm/tpm_nsc.c
> @@ -396,8 +396,6 @@ static void __exit cleanup_nsc(void)
>   	if (pdev) {
>   		tpm_nsc_remove(&pdev->dev);
>   		platform_device_unregister(pdev);
> -		kfree(pdev);
> -		pdev = NULL;
>   	}
>
>   	platform_driver_unregister(&nsc_drv);

