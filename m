Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2GDMDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:03:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2GDMDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:03:18 -0400
Date: Wed, 4 Jul 2012 14:03:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] floppy: Run floppy initialization asynchronous
In-Reply-To: <1341275224-31696-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LNX.2.00.1207041402010.17304@pobox.suse.cz>
References: <1341275224-31696-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> floppy_init is quite slow, 3s on my test system to determine
> that there is no floppy. Run it asynchronous to the other
> init calls to improve boot time.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/block/floppy.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index cce7df3..8b5769b 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -191,6 +191,7 @@ static int print_unex = 1;
>  #include <linux/mutex.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> +#include <linux/async.h>
>  
>  /*
>   * PS/2 floppies have much slower step rates than regular floppies.
> @@ -4122,7 +4123,7 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
>  	return get_disk(disks[drive]);
>  }
>  
> -static int __init floppy_init(void)
> +static int __init do_floppy_init(void)
>  {
>  	int i, unit, drive;
>  	int err, dr;
> @@ -4337,6 +4338,24 @@ out_put_disk:
>  	return err;
>  }
>  
> +#ifndef MODULE
> +static __init void floppy_async_init(void *data, async_cookie_t cookie)
> +{
> +	do_floppy_init();
> +}
> +#endif
> +
> +static int __init floppy_init(void)
> +{
> +#ifdef MODULE
> +	return do_floppy_init(void);

This isn't really a valid C.

I have fixed that and applied.

-- 
Jiri Kosina
SUSE Labs
