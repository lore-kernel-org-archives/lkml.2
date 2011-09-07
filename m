Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1IGQaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:30:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39844 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1IGQa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:30:27 -0400
MIME-Version: 1.0
In-Reply-To: <1315406503-7883-3-git-send-email-pbonzini@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-3-git-send-email-pbonzini@redhat.com>
Date: Wed, 7 Sep 2011 12:30:26 -0400
Message-ID: <CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
From: Paul Clements <paul.clements@us.sios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nbd-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

thanks for the patch...

On Wed, Sep 7, 2011 at 10:41 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Add a IOCTL to negotiate features between the server and the
> kernel module (mediated by the usermode client).  Features are
> stored in the pre-existing flags field.

I'm not crazy about another ioctl, but we need to get this flag
setting functionality in, and I just have not had the time...

> Also zero out the flags when NBD_DO_IT completes.
>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/block/nbd.c |    8 ++++++++
>  include/linux/nbd.h |   24 +++++++++++++++---------
>  2 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index be23aec..c4fe9c8 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -85,6 +85,7 @@ static const char *ioctl_cmd_to_ascii(int cmd)
>        case NBD_PRINT_DEBUG: return "print-debug";
>        case NBD_SET_SIZE_BLOCKS: return "set-size-blocks";
>        case NBD_DISCONNECT: return "disconnect";
> +       case NBD_SET_FEATURES: return "set-features";

Could you name this as NBD_SET_FLAGS, as that's more consistent with
what it's really doing?

Otherwise these look good for inclusion.

Thanks,
Paul


>        case BLKROSET: return "set-read-only";
>        case BLKFLSBUF: return "flush-buffer-cache";
>        }
> @@ -634,6 +635,12 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
>                lo->xmit_timeout = arg * HZ;
>                return 0;
>
> +       case NBD_SET_FEATURES:
> +               if (((u64) arg) & NBD_FEATURE_RESERVED)
> +                       return -EINVAL;
> +               lo->flags = (lo->flags & NBD_FEATURE_RESERVED) | (u64)arg;
> +               return 0;
> +
>        case NBD_SET_SIZE_BLOCKS:
>                lo->bytesize = ((u64) arg) * lo->blksize;
>                bdev->bd_inode->i_size = lo->bytesize;
> @@ -672,6 +679,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
>                printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
>                if (file)
>                        fput(file);
> +               lo->flags = 0;
>                lo->bytesize = 0;
>                bdev->bd_inode->i_size = 0;
>                set_capacity(lo->disk, 0);
> diff --git a/include/linux/nbd.h b/include/linux/nbd.h
> index 0582054..926f19d 100644
> --- a/include/linux/nbd.h
> +++ b/include/linux/nbd.h
> @@ -17,16 +17,22 @@
>
>  #include <linux/types.h>
>
> -#define NBD_SET_SOCK   _IO( 0xab, 0 )
> -#define NBD_SET_BLKSIZE        _IO( 0xab, 1 )
> -#define NBD_SET_SIZE   _IO( 0xab, 2 )
> -#define NBD_DO_IT      _IO( 0xab, 3 )
> -#define NBD_CLEAR_SOCK _IO( 0xab, 4 )
> -#define NBD_CLEAR_QUE  _IO( 0xab, 5 )
> -#define NBD_PRINT_DEBUG        _IO( 0xab, 6 )
> -#define NBD_SET_SIZE_BLOCKS    _IO( 0xab, 7 )
> -#define NBD_DISCONNECT  _IO( 0xab, 8 )
> -#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
> +#define NBD_SET_SOCK           _IO(0xab, 0)
> +#define NBD_SET_BLKSIZE                _IO(0xab, 1)
> +#define NBD_SET_SIZE           _IO(0xab, 2)
> +#define NBD_DO_IT              _IO(0xab, 3)
> +#define NBD_CLEAR_SOCK         _IO(0xab, 4)
> +#define NBD_CLEAR_QUE          _IO(0xab, 5)
> +#define NBD_PRINT_DEBUG                _IO(0xab, 6)
> +#define NBD_SET_SIZE_BLOCKS    _IO(0xab, 7)
> +#define NBD_DISCONNECT         _IO(0xab, 8)
> +#define NBD_SET_TIMEOUT                _IO(0xab, 9)
> +#define NBD_SET_FEATURES       _IO(0xab, 10)
> +
> +/* bits 0 and 1 are already used for flags in the protocol, we do
> + * not want any overlap.  Bits 32-63 are reserved because they
> + * are inaccessible on 32-bit platforms.  */
> +#define NBD_FEATURE_RESERVED   0xFFFFFFFF00000003LL
>
>  enum {
>        NBD_CMD_READ = 0,
> --
> 1.7.6
>
>
>
