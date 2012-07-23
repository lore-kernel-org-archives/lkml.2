Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2GWHbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab2GWHbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:31:44 -0400
Message-ID: <500CFDC2.2080603@redhat.com>
Date: Mon, 23 Jul 2012 09:31:14 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        James Bottomley <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 022/108] scsi: Silence unnecessary warnings about ioctl to
 partition
References: <20120723010654.873125604@decadent.org.uk>
In-Reply-To: <20120723010654.873125604@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/07/2012 03:07, Ben Hutchings ha scritto:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit 6d9359280753d2955f86d6411047516a9431eb51 upstream.
> 
> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: James Bottomley <JBottomley@parallels.com>
> CC: linux-scsi@vger.kernel.org
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [bwh: Backported to 3.2: use ENOTTY, not ENOIOCTLCMD]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  block/scsi_ioctl.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -721,11 +721,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
>  		break;
>  	}
>  
> +	if (capable(CAP_SYS_RAWIO))
> +		return 0;
> +
>  	/* In particular, rule out all resets and host-specific ioctls.  */
>  	printk_ratelimited(KERN_WARNING
>  			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
>  
> -	return capable(CAP_SYS_RAWIO) ? 0 : -ENOTTY;
> +	return -ENOTTY;

Here was the conflict, and you fixed it correctly.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

>  }
>  EXPORT_SYMBOL(scsi_verify_blk_ioctl);
>  
> 
> 
> 


