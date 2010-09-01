Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0IAUCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:02:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab0IAUCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:02:43 -0400
Message-ID: <4C7EB10A.4090809@redhat.com>
Date: Wed, 01 Sep 2010 16:01:14 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Luke Macken <lmacken@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efifb: support the EFI framebuffer on more Apple hardware
References: <20100901200115.GA21591@tomservo.cable.rcn.com>
In-Reply-To: <20100901200115.GA21591@tomservo.cable.rcn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 04:01 PM, Luke Macken wrote:
> This patch enables the EFI framebuffer on a variety of Mac models,
> including the iMac10,1 iMac8,1 Macmini3,1 Macmini4,1 and MacBookPro2,2.
> Information gathered from personal hardware and various user
> submissions.
> 
> Signed-off-by: Luke Macken <lmacken@redhat.com>

This looks good to me:

Signed-off-by: Peter Jones <pjones@redhat.com>

> 
> diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> index 815f84b..0d27e1e 100644
> --- a/drivers/video/efifb.c
> +++ b/drivers/video/efifb.c
> @@ -39,7 +39,11 @@ enum {
>  	M_I20,		/* 20-Inch iMac */
>  	M_I20_SR,	/* 20-Inch iMac (Santa Rosa) */
>  	M_I24,		/* 24-Inch iMac */
> +	M_I24_8_1,	/* 24-Inch iMac, 8,1th gen */
> +	M_I24_10_1,	/* 24-Inch iMac, 10,1th gen */
>  	M_MINI,		/* Mac Mini */
> +	M_MINI_3_1,	/* Mac Mini, 3,1th gen */
> +	M_MINI_4_1,	/* Mac Mini, 4,1th gen */
>  	M_MB,		/* MacBook */
>  	M_MB_2,		/* MacBook, 2nd rev. */
>  	M_MB_3,		/* MacBook, 3rd rev. */
> @@ -47,6 +51,7 @@ enum {
>  	M_MBA,		/* MacBook Air */
>  	M_MBP,		/* MacBook Pro */
>  	M_MBP_2,	/* MacBook Pro 2nd gen */
> +	M_MBP_2_2,	/* MacBook Pro 2,2nd gen */
>  	M_MBP_SR,	/* MacBook Pro (Santa Rosa) */
>  	M_MBP_4,	/* MacBook Pro, 4th gen */
>  	M_MBP_5_1,    /* MacBook Pro, 5,1th gen */
> @@ -64,11 +69,16 @@ static struct efifb_dmi_info {
>  	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050 }, /* guess */
>  	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050 },
>  	[M_I24] = { "i24", 0x80010000, 2048 * 4, 1920, 1200 }, /* guess */
> +	[M_I24_8_1] = { "imac8", 0xc0060000, 2048 * 4, 1920, 1200 },
> +	[M_I24_10_1] = { "imac10", 0xc0010000, 2048 * 4, 1920, 1080 },
>  	[M_MINI]= { "mini", 0x80000000, 2048 * 4, 1024, 768 },
> +	[M_MINI_3_1]= { "mini31", 0x40010000, 1024 * 4, 1024, 768 },
> +	[M_MINI_4_1]= { "mini41", 0xc0010000, 2048 * 4, 1920, 1200 },
>  	[M_MB] = { "macbook", 0x80000000, 2048 * 4, 1280, 800 },
>  	[M_MBA] = { "mba", 0x80000000, 2048 * 4, 1280, 800 },
>  	[M_MBP] = { "mbp", 0x80010000, 1472 * 4, 1440, 900 },
>  	[M_MBP_2] = { "mbp2", 0, 0, 0, 0 }, /* placeholder */
> +	[M_MBP_2_2] = { "mbp22", 0x80010000, 1472 * 4, 1440, 900 },
>  	[M_MBP_SR] = { "mbp3", 0x80030000, 2048 * 4, 1440, 900 },
>  	[M_MBP_4] = { "mbp4", 0xc0060000, 2048 * 4, 1920, 1200 },
>  	[M_MBP_5_1] = { "mbp51", 0xc0010000, 2048 * 4, 1440, 900 },
> @@ -92,7 +102,11 @@ static const struct dmi_system_id dmi_system_table[] __initconst = {
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac6,1", M_I24),
>  	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac6,1", M_I24),
>  	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac7,1", M_I20_SR),
> +	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac8,1", M_I24_8_1),
> +	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac10,1", M_I24_10_1),
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "Macmini1,1", M_MINI),
> +	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini3,1", M_MINI_3_1),
> +	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini4,1", M_MINI_4_1),
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook1,1", M_MB),
>  	/* At least one of these two will be right; maybe both? */
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook2,1", M_MB),
> @@ -104,6 +118,7 @@ static const struct dmi_system_id dmi_system_table[] __initconst = {
>  	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir1,1", M_MBA),
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro1,1", M_MBP),
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,1", M_MBP_2),
> +	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,2", M_MBP_2_2),
>  	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro2,1", M_MBP_2),
>  	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
>  	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),


-- 
        Peter

Computers don't make errors.  What they do, they do on purpose.
		-- Dale

01234567890123456789012345678901234567890123456789012345678901234567890123456789
