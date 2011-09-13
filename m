Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1IMU4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:56:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:65303 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab1IMU43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:56:29 -0400
MIME-Version: 1.0
Message-ID: <a7d17e7e-c6a1-448e-b60f-b79a4ae0c3ba@default>
Date: Tue, 13 Sep 2011 13:56:00 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-mm@kvack.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com
Subject: RE: [PATCH] staging: zcache: fix cleancache crash
References: <4E6FA75A.8060308@linux.vnet.ibm.com
 1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E6FC374.0116,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Tuesday, September 13, 2011 1:19 PM
> To: gregkh@suse.de
> Cc: devel@driverdev.osuosl.org; linux-mm@kvack.org; ngupta@vflare.org; linux-kernel@vger.kernel.org;
> francis.moro@gmail.com; Dan Magenheimer; Seth Jennings
> Subject: [PATCH] staging: zcache: fix cleancache crash
> 
> After commit, c5f5c4db, cleancache crashes on the first
> successful get. This was caused by a remaining virt_to_page()
> call in zcache_pampd_get_data_and_free() that only gets
> run in the cleancache path.
> 
> The patch converts the virt_to_page() to struct page
> casting like was done for other instances in c5f5c4db.
> 
> Based on 3.1-rc4
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Yep, this appears to fix it!  Hopefully Francis can confirm.

Greg, ideally apply this additional fix rather than do the revert
of the original patch suggested in https://lkml.org/lkml/2011/9/13/234 

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/zcache/zcache-main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index a3f5162..462fbc2 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1242,7 +1242,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *bufsize, bool raw,
>  	int ret = 0;
> 
>  	BUG_ON(!is_ephemeral(pool));
> -	zbud_decompress(virt_to_page(data), pampd);
> +	zbud_decompress((struct page *)(data), pampd);
>  	zbud_free_and_delist((struct zbud_hdr *)pampd);
>  	atomic_dec(&zcache_curr_eph_pampd_count);
>  	return ret;
> --
> 1.7.4.1
> 
