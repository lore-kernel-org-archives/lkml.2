Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2GIKPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:15:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40957 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2GIKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com> <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 9 Jul 2012 12:15:17 +0200
Message-ID: <CACQ1gAhOtCTVVnSvso1-jq+MyminKC2i244d9je=v0acAzzRBw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad PEB handling
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/4 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
> index f6a7d7a..e9dcb83 100644
> --- a/drivers/mtd/ubi/misc.c
> +++ b/drivers/mtd/ubi/misc.c
> @@ -98,10 +98,18 @@ int ubi_check_volume(struct ubi_device *ubi, int vol_id)
>   */
>  void ubi_calculate_reserved(struct ubi_device *ubi)
>  {
> -       ubi->beb_rsvd_level = ubi->good_peb_count/100;
> -       ubi->beb_rsvd_level *= CONFIG_MTD_UBI_BEB_RESERVE;
> -       if (ubi->beb_rsvd_level < MIN_RESEVED_PEBS)
> -               ubi->beb_rsvd_level = MIN_RESEVED_PEBS;
> +       /*
> +        * Calculate the actual number of PEBs currently needed to be reserved
> +        * for future bad eraseblock handling.
> +        */
> +       ubi->beb_rsvd_level = ubi->bad_peb_limit - ubi->bad_peb_count;
> +       if (ubi->beb_rsvd_level < 0) {
> +               ubi->beb_rsvd_level = 0;
> +               ubi_warn("number of bad PEBs (%d) is above the expected limit "
> +                        "(%d), not reserving any PEBs for bad PEB handling, "
> +                        "will use available PEBs (if any)",
> +                        ubi->bad_peb_count, ubi->bad_peb_limit);
> +       }
>  }
is it ok for beb_rsvd_level to be in the range [0..x[ instead of [2..x[ ?
