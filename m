Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2H3WAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:00:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2H3WAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:00:09 -0400
Date: Thu, 30 Aug 2012 15:00:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paul.clements@steeleye.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [RESEND] add discard support to nbd
Message-Id: <20120830150008.c6a5cd37.akpm@linux-foundation.org>
In-Reply-To: <503e0dcd.6eub+7cESkENGK2l%paul.clements@steeleye.com>
References: <503e0dcd.6eub+7cESkENGK2l%paul.clements@steeleye.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCH 1/2] [RESEND] add discard support to nbd

Please don't send multiple patches with the same title.  And please
prefix the patch titles with text which identifies the affected
subsystem.  Documentation/SubmittingPatches goes into details.


On Wed, 29 Aug 2012 08:40:45 -0400
paul.clements@steeleye.com wrote:

> Description: This patch adds a set-flags ioctl, allowing various option
> flags to be set on an nbd device.

That tells us what it does, but omits the all-important "why it does it".  
What's the requirement here?  What value does this change add to NBD users?

What does the interface do and how are users to use it?

Are the nbd ioctls documented anywhere?

> Signed-off-by: Paul Clements <paul.clements@steeleye.com>
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index d07c9f7..c544bb4 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -78,6 +78,8 @@ static const char *ioctl_cmd_to_ascii(int cmd)
>  	case NBD_SET_SOCK: return "set-sock";
>  	case NBD_SET_BLKSIZE: return "set-blksize";
>  	case NBD_SET_SIZE: return "set-size";
> +	case NBD_SET_TIMEOUT: return "set-timeout";

That was an unchangelogged bugfix.

> +	case NBD_SET_FLAGS: return "set-flags";
>  	case NBD_DO_IT: return "do-it";
>  	case NBD_CLEAR_SOCK: return "clear-sock";
>  	case NBD_CLEAR_QUE: return "clear-que";
> @@ -460,7 +462,7 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
>  	nbd_cmd(req) = NBD_CMD_READ;
>  	if (rq_data_dir(req) == WRITE) {
>  		nbd_cmd(req) = NBD_CMD_WRITE;
> -		if (nbd->flags & NBD_READ_ONLY) {
> +		if (nbd->flags & NBD_FLAG_READ_ONLY) {
>  			dev_err(disk_to_dev(nbd->disk),
>  				"Write on read-only\n");
>  			goto error_out;
> @@ -642,6 +644,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>  		nbd->xmit_timeout = arg * HZ;
>  		return 0;
>  
> +	case NBD_SET_FLAGS:
> +		nbd->flags = arg;
> +		return 0;
> +
>  	case NBD_SET_SIZE_BLOCKS:
>  		nbd->bytesize = ((u64) arg) * nbd->blksize;
>  		bdev->bd_inode->i_size = nbd->bytesize;
> diff --git a/include/linux/nbd.h b/include/linux/nbd.h
> index d146ca1..bb349be 100644
> --- a/include/linux/nbd.h
> +++ b/include/linux/nbd.h
> @@ -27,6 +27,7 @@
>  #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
>  #define NBD_DISCONNECT  _IO( 0xab, 8 )
>  #define NBD_SET_TIMEOUT _IO( 0xab, 9 )
> +#define NBD_SET_FLAGS   _IO( 0xab, 10)
>  
>  enum {
>  	NBD_CMD_READ = 0,
> @@ -34,6 +35,10 @@ enum {
>  	NBD_CMD_DISC = 2
>  };
>  
> +/* values for flags field */
> +#define NBD_FLAG_HAS_FLAGS	(1 << 0)
> +#define NBD_FLAG_READ_ONLY	(1 << 1)

These could be individually documented right here, at their definition
site.


>  #define nbd_cmd(req) ((req)->cmd[0])
>  
>  /* userspace doesn't need the nbd_device structure */
> @@ -42,10 +47,6 @@ enum {
>  #include <linux/wait.h>
>  #include <linux/mutex.h>
>  
> -/* values for flags field */
> -#define NBD_READ_ONLY 0x0001
> -#define NBD_WRITE_NOCHK 0x0002
> -
>  struct request;
>  
>  struct nbd_device {
