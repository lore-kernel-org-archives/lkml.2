Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2H0JDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 05:03:54 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42445 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2H0JDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 05:03:52 -0400
Date: Mon, 27 Aug 2012 11:03:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Stefan Weinhuber <wein@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, "open list:S390" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 5/5] s390:block:fix up ENOIOCTLCMD error handling
Message-ID: <20120827090354.GA5840@osiris.de.ibm.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1346052196-32682-6-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346052196-32682-6-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12082709-5024-0000-0000-0000039DA356
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 03:23:16PM +0800, Wanlong Gao wrote:
> At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
> translated as ENOTTY to user mode.
> 
[...]

> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  drivers/s390/block/dasd_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
> index cceae70..809a89b 100644
> --- a/drivers/s390/block/dasd_ioctl.c
> +++ b/drivers/s390/block/dasd_ioctl.c
> @@ -501,7 +501,7 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
>  		if (base->discipline->ioctl) {
>  			rc = base->discipline->ioctl(block, cmd, argp);
>  			if (rc == -ENOIOCTLCMD)
> -				rc = -EINVAL;
> +				rc = -ENOTTY;
>  		} else
>  			rc = -EINVAL;
>  	}

Thanks, but you missed the else path. I'm going to commit the patch below
unless Stefan has any objections:

>From dac16bd8b314dc6f3f4e6815feab199fdfc8cddd Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 27 Aug 2012 10:59:42 +0200
Subject: [PATCH] s390/dasd: fix ioctl return value

For unimplemented ioctls the dasd driver should return -ENOTTY.

Reported-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/block/dasd_eckd.c  | 2 +-
 drivers/s390/block/dasd_ioctl.c | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 40a826a..2fb2b9e 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3804,7 +3804,7 @@ dasd_eckd_ioctl(struct dasd_block *block, unsigned int cmd, void __user *argp)
 	case BIODASDSYMMIO:
 		return dasd_symm_io(device, argp);
 	default:
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index cceae70..654c692 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -498,12 +498,9 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	default:
 		/* if the discipline has an ioctl method try it. */
-		if (base->discipline->ioctl) {
+		rc = -ENOTTY;
+		if (base->discipline->ioctl)
 			rc = base->discipline->ioctl(block, cmd, argp);
-			if (rc == -ENOIOCTLCMD)
-				rc = -EINVAL;
-		} else
-			rc = -EINVAL;
 	}
 	dasd_put_device(base);
 	return rc;
-- 
1.7.11.5

