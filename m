Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0HDJBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab0HDJBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:01:34 -0400
Date: Wed, 4 Aug 2010 11:00:49 +0200
From: Karel Zak <kzak@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to
	hd_structs
Message-ID: <20100804090049.GH5464@nb.net.home>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> <1280887483-2979-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280887483-2979-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 09:04:42PM -0500, Will Drewry wrote:
> This change extends the partition_meta_info structure to
> support EFI GPT-specific metadata and ensures that data
> is copied in on partition scanning.

Why do want to store GPT-specific data (efi_guid_t) to
partition_meta_info? I think it would be better to use label and uuid
in a generic format (e.g. string or u8 uuid[16]) -- then you don't
have to use things like union, disklabel specific code to compare
uuids, etc.  IMHO your current code is too complicated.

> +		info = alloc_part_info(NULL);
> +		if (!info) {
> +			printk(KERN_WARNING
> +			       "unable to allocate memory for part->info\n");
> +			continue;
> +		}
> +		info->format = PARTITION_META_INFO_FORMAT_EFI;
> +		memcpy(info->efi.uuid.b, ptes[i].unique_partition_guid.b,
> +			sizeof(info->efi.uuid.b));
> +		memcpy(info->efi.type.b, ptes[i].partition_type_guid.b,
> +			sizeof(info->efi.type.b));

why do you need to partition type?

> +		memcpy(info->efi.label, ptes[i].partition_name,
> +			sizeof(info->efi.label));

the partition name is in UTF8LE, is it correct to use it in raw
format?

> +		state->parts[i + 1].info = info;
>  	}
>  	kfree(ptes);
>  	kfree(gpt);
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 7b6644a..beb98e3 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -91,11 +91,25 @@ struct disk_stats {
>  enum partition_meta_info_format_t {
>  	/* Partition info format */
>  	PARTITION_META_INFO_FORMAT_NONE = 0,
> +	PARTITION_META_INFO_FORMAT_EFI,
> +	/* Place additional formats here. */
> +	PARTITION_META_INFO_FORMAT_MAX,
>  };
>  
> +#ifdef CONFIG_EFI_PARTITION
> +#include <linux/efi.h>
> +#endif
> +
>  struct partition_meta_info {
>  	enum partition_meta_info_format_t format;
>  	union {
> +#ifdef CONFIG_EFI_PARTITION
> +		struct {
> +			efi_guid_t uuid;
> +			efi_guid_t type;
> +			efi_char16_t label[72 / sizeof(efi_char16_t)];
> +		} efi;
> +#endif
>  	};
>  };
>  
> -- 
> 1.7.0.4
> 

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
