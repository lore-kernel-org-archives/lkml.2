Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2EaKiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:38:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:36941 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2EaKiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149888045"
Message-ID: <4FC74A04.30100@intel.com>
Date: Thu, 31 May 2012 13:37:56 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337771191-95358-1-git-send-email-richard@nod.at> <1337771191-95358-2-git-send-email-richard@nod.at>
In-Reply-To: <1337771191-95358-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/12 14:06, Richard Weinberger wrote:
> Fastmap (aka checkpointing) allows attaching of an UBI volume in nearly
> constant time. Only a fixed number of PEBs has to be scanned.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/Makefile    |    2 +-
>  drivers/mtd/ubi/attach.c    |   34 +-
>  drivers/mtd/ubi/build.c     |   25 +
>  drivers/mtd/ubi/eba.c       |   18 +-
>  drivers/mtd/ubi/fastmap.c   | 1240 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/ubi/ubi-media.h |  119 +++++
>  drivers/mtd/ubi/ubi.h       |   68 +++-
>  drivers/mtd/ubi/wl.c        |  184 +++++++-
>  8 files changed, 1667 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/mtd/ubi/fastmap.c
> 

...

> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> new file mode 100644
> index 0000000..7757e5a

...

> +/**
> + * ubi_find_fastmap - searches the first UBI_FM_MAX_START PEBs for the
> + * fastmap super block.
> + * @ubi: UBI device object
> + */
> +static int ubi_find_fastmap(struct ubi_device *ubi, int *fm_start)
> +{
> +	int i, ret;
> +	struct ubi_vid_hdr *vhdr;
> +
> +	vhdr = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
> +	if (!vhdr)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < UBI_FM_MAX_START; i++) {
> +		ret = ubi_io_read_vid_hdr(ubi, i, vhdr, 0);
> +		if (ret < 0)
> +			break;
> +		else if (ret > 0)
> +			continue;
> +
> +		if (be32_to_cpu(vhdr->vol_id) == UBI_FM_SB_VOLUME_ID) {
> +			*fm_start = i;
> +			dbg_bld("Found fastmap super block at PEB %i\n", i);
> +			ret = 0;
> +
> +			break;

How do you know that this is the current fastmap and not a remnant of an old
fastmap?

> +		}
> +	}
> +
> +	ubi_free_vid_hdr(ubi, vhdr);
> +
> +	return ret;
> +}

