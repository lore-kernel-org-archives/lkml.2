Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1GOVrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 17:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1GOVrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 17:47:16 -0400
Message-ID: <4E20B55E.9080908@redhat.com>
Date: Fri, 15 Jul 2011 16:47:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Ehrenberg <dehrenberg@google.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ext4: Ignore a stripe width of 1
References: <1310766115-4164-1-git-send-email-dehrenberg@google.com> <1310766115-4164-2-git-send-email-dehrenberg@google.com>
In-Reply-To: <1310766115-4164-2-git-send-email-dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/11 4:41 PM, Dan Ehrenberg wrote:
> If the stripe width was set to 1, then this patch will ignore
> that stripe width and ext4 will act as if the stripe width
> were 0 with respect to optimizing allocations.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>

Thanks, I think this makes sense.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/super.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9ea71aa..0a3745b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2383,17 +2383,27 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
>  	unsigned long stride = le16_to_cpu(sbi->s_es->s_raid_stride);
>  	unsigned long stripe_width =
>  			le32_to_cpu(sbi->s_es->s_raid_stripe_width);
> +	int ret;
>  
>  	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
> -		return sbi->s_stripe;
> +		ret = sbi->s_stripe;
>  
> -	if (stripe_width <= sbi->s_blocks_per_group)
> -		return stripe_width;
> +	else if (stripe_width <= sbi->s_blocks_per_group)
> +		ret = stripe_width;
>  
> -	if (stride <= sbi->s_blocks_per_group)
> -		return stride;
> +	else if (stride <= sbi->s_blocks_per_group)
> +		ret = stride;
> +	else
> +		ret = 0;
>  
> -	return 0;
> +	/*
> +	 * If the stripe width is 1, this makes no sense and
> +	 * we set it to 0 to turn off stripe handling code.
> +	 */
> +	if (ret <= 1)
> +		ret = 0;
> +
> +	return ret;
>  }
>  
>  /* sysfs supprt */

