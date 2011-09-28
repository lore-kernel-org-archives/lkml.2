Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1I1QIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:08:10 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:22271 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1I1QIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:08:07 -0400
Date: Wed, 28 Sep 2011 09:08:07 -0700 (PDT)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, adrian hunter <adrian.hunter@intel.com>,
        james p freyensee <james_p_freyensee@linux.intel.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
Message-ID: <1419276380.765271.1317226086965.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1316840820-2014-1-git-send-email-linkinjeon@gmail.com>
Subject: Re: [PATCH v2] mmc : general purpose partition support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.61.162]
X-Mailer: Zimbra 7.1.1_GA_3225 (ZimbraWebClient - FF3.0 (Linux)/7.1.1_GA_3225)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,

In general I think your approach is fine and solves the problem. See further inline
comments.

----- Original Message -----
> From: "Namjae Jeon" <linkinjeon@gmail.com>
> To: cjb@laptop.org, linux-mmc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com, "adrian hunter" <adrian.hunter@intel.com>, "james p
> freyensee" <james_p_freyensee@linux.intel.com>, "Namjae Jeon" <linkinjeon@gmail.com>
> Sent: Saturday, September 24, 2011 1:07:00 AM
> Subject: [PATCH v2] mmc : general purpose partition support.
> 
> It allows gerneral purpose partitions in MMC Device.
> And I try to simpliy make mmc_blk_alloc_parts using mmc_part
> structure suggested by Andrei Warkentin.
> After patching, we can see general purpose partitions like this.
> > cat /proc/partitions
>           179 0 847872 mmcblk0
>           179 192 4096 mmcblk0gp4
>           179 160 4096 mmcblk0gp3
>           179 128 4096 mmcblk0gp2
>           179 96  1052672 mmcblk0gp1
>           179 64  1024 mmcblk0boot1
>           179 32  1024 mmcblk0boot0
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

> +		if (ext_csd[EXT_CSD_BOOT_MULT]) {
> +			for (i = 0, boot_part_config = 0x1;
> +				i < MMC_NUM_BOOT_PARTITION;
> +				i++, boot_part_config++) {
> +				card->part[i].size = ...
> +				card->part[i].cookie = ...
> +				sprintf(card->part[i].name, "boot%d", i);
> +				card->part[i].force_ro = ...
> +			}
> +		}
>  	}
>  
>
> +		if (ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x1) {
> +                     ....
> +			int i, gp_num, gp_part_config, gp_size_mult;
> +			for (i = 2, gp_num = 1, gp_part_config = 0x4,
> +				card->part[i].size = ...
> +				card->part[i].cookie = ...
> +				sprintf(card->part[i].name,
> +					"gp%d", gp_num);
> +				card->part[i].force_ro = ..
> +			}
> +		}
>

I feel that you should factor out a function that operates on the static part[] array and
adds a new entry base name, index (i.e. the %d for gp%d), cookie, size, force. 
Otherwise you end up with these hidden mines like fixed indeces for
particular parts (i = 2, etc...) which becomes indecipherable for others. 
Plus you're mostly doing the same thing.

Thanks,
A
