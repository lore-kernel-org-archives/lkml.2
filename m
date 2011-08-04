Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1HDWX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:23:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:33454 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754245Ab1HDWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:23:54 -0400
Date: Thu, 4 Aug 2011 15:17:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zcache: Use div_u64 for 64-bit division
Message-Id: <20110804151707.ccb67e28.rdunlap@xenotime.net>
In-Reply-To: <1312495234-20961-1-git-send-email-cascardo@holoscopio.com>
References: <20110804145145.4af47989.rdunlap@xenotime.net>
	<1312495234-20961-1-git-send-email-cascardo@holoscopio.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Aug 2011 19:00:33 -0300 Thadeu Lima de Souza Cascardo wrote:

> xv_get_total_size_bytes returns a u64 value and it's used in a division.
> This causes build failures in 32-bit architectures, as reported by Randy
> Dunlap.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: driverdevel <devel@driverdev.osuosl.org>
> Cc: linux-next@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/zcache/zcache-main.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 66469ac..2c41c44 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -28,6 +28,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/atomic.h>
> +#include <linux/math64.h>
>  #include "tmem.h"
>  
>  #include "../zram/xvmalloc.h" /* if built in drivers/staging */
> @@ -1162,6 +1163,7 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
>  	uint16_t client_id = get_client_id_from_client(cli);
>  	unsigned long zv_mean_zsize;
>  	unsigned long curr_pers_pampd_count;
> +	u64 total_zsize;
>  
>  	if (eph) {
>  		ret = zcache_compress(page, &cdata, &clen);
> @@ -1194,8 +1196,9 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
>  		}
>  		/* reject if mean compression is too poor */
>  		if ((clen > zv_max_mean_zsize) && (curr_pers_pampd_count > 0)) {
> -			zv_mean_zsize = xv_get_total_size_bytes(cli->xvpool) /
> -						curr_pers_pampd_count;
> +			total_zsize = xv_get_total_size_bytes(cli->xvpool);
> +			zv_mean_zsize = div_u64(total_zsize,
> +						curr_pers_pampd_count);
>  			if (zv_mean_zsize > zv_max_mean_zsize) {
>  				zcache_mean_compress_poor++;
>  				goto out;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
