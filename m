Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1HVQZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:25:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:30655 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1HVQZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:25:42 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1314030326!32239619!14
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Julia Lawall <julia@diku.dk>, Liam Girdwood <lrg@ti.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Alexander Sverdlin <subaparts@yandex.ru>,
        Ryan Mallon <rmallon@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Aug 2011 11:25:32 -0500
Subject: RE: [PATCH 2/4] sound/soc/ep93xx/ep93xx-i2s.c: add missing kfree
Thread-Topic: [PATCH 2/4] sound/soc/ep93xx/ep93xx-i2s.c: add missing kfree
Thread-Index: AcxfAEzkPqBcRUzvSuO/SkRLVaZhzAB545Ug
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F38857523F@AUSP01VMBX24.collaborationhost.net>
References: <1313820761-12042-2-git-send-email-julia@diku.dk>
In-Reply-To: <1313820761-12042-2-git-send-email-julia@diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011 11:13 PM, Julia Lawall wrote:
>
> Introduce a new label that includes kfree and jump to that one.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier x;
> expression E1!=0,E2,E3,E4;
> statement S;
> iterator I;
> @@
>
> (
> if (...) { ... when != kfree(x)
>                when != x = E3
>                when != E3 = x
> *  return ...;
>  }
> ... when != x = E2
>     when != I(...,x,...) S
> if (...) { ... when != x = E4
>  kfree(x); ... return ...; }
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  sound/soc/ep93xx/ep93xx-i2s.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
> index 56efa0c..099614e 100644
> --- a/sound/soc/ep93xx/ep93xx-i2s.c
> +++ b/sound/soc/ep93xx/ep93xx-i2s.c
> @@ -385,14 +385,14 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
>  		err = -ENODEV;
> -		goto fail;
> +		goto fail_free_info;
>  	}
>  
>  	info->mem = request_mem_region(res->start, resource_size(res),
>  				       pdev->name);
>  	if (!info->mem) {
>  		err = -EBUSY;
> -		goto fail;
> +		goto fail_free_info;
>  	}
>  
>  	info->regs = ioremap(info->mem->start, resource_size(info->mem));
> @@ -435,6 +435,7 @@ fail_unmap_mem:
>  	iounmap(info->regs);
>  fail_release_mem:
>  	release_mem_region(info->mem->start, resource_size(info->mem));
> +fail_free_info:
>  	kfree(info);
>  fail:
>  	return err;

Looks correct to me...

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
