Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab2HJReU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:34:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228Ab2HJReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:34:18 -0400
Date: Fri, 10 Aug 2012 13:34:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 4/6] floppy: properly handle failure on add_disk loop
Message-ID: <20120810173402.GI5416@redhat.com>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
 <1344542391-16474-5-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344542391-16474-5-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:59:49PM -0300, Herton Ronaldo Krzesinski wrote:
> On do_floppy_init, if something failed inside the loop we call add_disk,
> there was no cleanup of previous iterations in the error handling.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Cc: stable@vger.kernel.org
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  drivers/block/floppy.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 9272203..3eafe93 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4294,7 +4294,7 @@ static int __init do_floppy_init(void)
>  
>  		err = platform_device_register(&floppy_device[drive]);
>  		if (err)
> -			goto out_release_dma;
> +			goto out_remove_drives;
>  
>  		err = device_create_file(&floppy_device[drive].dev,
>  					 &dev_attr_cmos);
> @@ -4313,6 +4313,14 @@ static int __init do_floppy_init(void)
>  
>  out_unreg_platform_dev:
>  	platform_device_unregister(&floppy_device[drive]);
> +out_remove_drives:
> +	while (drive--) {
> +		if (disk_registered[drive]) {
> +			del_gendisk(disks[drive]);
> +			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
> +			platform_device_unregister(&floppy_device[drive]);
> +		}
> +	}
>  out_release_dma:
>  	if (atomic_read(&usage_count))
>  		floppy_release_irq_and_dma();
> -- 
> 1.7.9.5
