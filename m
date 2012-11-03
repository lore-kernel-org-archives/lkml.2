Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2KCQgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:36:44 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:60988 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2KCQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:36:41 -0400
Message-ID: <50954818.8050908@acm.org>
Date: Sat, 03 Nov 2012 17:36:40 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 04/10] scsi: allocate scsi_cmnd-s from the device's
 local numa node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-5-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-5-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/12 22:45, Jeff Moyer wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2936b44..4db6973 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -173,16 +173,20 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
>    * NULL on failure
>    */
>   static struct scsi_cmnd *
> -scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> +scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask,
> +			int node)
>   {
>   	struct scsi_cmnd *cmd;
>
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +				    node);
>   	if (!cmd)
>   		return NULL;
>
> -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> -					     gfp_mask | pool->gfp_mask);
> +	cmd->sense_buffer = kmem_cache_alloc_node(pool->sense_slab,
> +					gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +					node);

It's not clear to me why __GFP_ZERO is added to the allocation flags ?

Bart.
