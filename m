Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0DCBKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:10:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62694 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0DCBKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:10:48 -0400
Date: Fri, 2 Apr 2010 18:09:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mtd/maps/physmap: catch failure to register
 MTD_PHYSMAP_COMPAT device
Message-Id: <20100402180937.6c4a455a.randy.dunlap@oracle.com>
In-Reply-To: <0D753D10438DA54287A00B0270842697636A7E9D36@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636A7E9D36@AUSP01VMBX24.collaborationhost.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BB69591.0031:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 17:46:30 -0500 H Hartley Sweeten wrote:

> If the default Kconfig values are used with MTD_PHYSMAP_COMPAT you end
> up with a resource where end < start.  This causes __request_resource to
> return a conflict which then returns an -EBUSY error code.  The current
> physmap.c code just assumes that the platfom_device_register will always
> succeed.
> 
> Catch this failure during the physmap_init and propogate the error.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Hartley.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> 
> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
> index d9603f7..426461a 100644
> --- a/drivers/mtd/maps/physmap.c
> +++ b/drivers/mtd/maps/physmap.c
> @@ -264,8 +264,11 @@ static int __init physmap_init(void)
>  
>  	err = platform_driver_register(&physmap_flash_driver);
>  #ifdef CONFIG_MTD_PHYSMAP_COMPAT
> -	if (err == 0)
> -		platform_device_register(&physmap_flash);
> +	if (err == 0) {
> +		err = platform_device_register(&physmap_flash);
> +		if (err)
> +			platform_driver_unregister(&physmap_flash_driver);
> +	}
>  #endif
>  
>  	return err;


---
~Randy
