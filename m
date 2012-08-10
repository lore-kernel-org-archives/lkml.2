Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab2HJRfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab2HJRfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:35:43 -0400
Date: Fri, 10 Aug 2012 13:35:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 6/6] floppy: use disk_registered for checking if a drive
 is present
Message-ID: <20120810173527.GJ5416@redhat.com>
References: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
 <1344542391-16474-7-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344542391-16474-7-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:59:51PM -0300, Herton Ronaldo Krzesinski wrote:
> Simplify/cleanup code, replacing remaining checks for drives present
> using disk_registered array.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  drivers/block/floppy.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 438ffc9..5fcc2a1 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4114,9 +4114,7 @@ static struct platform_device floppy_device[N_DRIVE];
>  static struct kobject *floppy_find(dev_t dev, int *part, void *data)
>  {
>  	int drive = (*part & 3) | ((*part & 0x80) >> 5);
> -	if (drive >= N_DRIVE ||
> -	    !(allowed_drive_mask & (1 << drive)) ||
> -	    fdc_state[FDC(drive)].version == FDC_NONE)
> +	if (drive >= N_DRIVE || !disk_registered[drive])
>  		return NULL;
>  	if (((*part >> 2) & 0x1f) >= ARRAY_SIZE(floppy_type))
>  		return NULL;
> @@ -4559,8 +4557,7 @@ static void __exit floppy_module_exit(void)
>  	for (drive = 0; drive < N_DRIVE; drive++) {
>  		del_timer_sync(&motor_off_timer[drive]);
>  
> -		if ((allowed_drive_mask & (1 << drive)) &&
> -		    fdc_state[FDC(drive)].version != FDC_NONE) {
> +		if (disk_registered[drive]) {
>  			del_gendisk(disks[drive]);
>  			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
>  			platform_device_unregister(&floppy_device[drive]);
> @@ -4571,8 +4568,7 @@ static void __exit floppy_module_exit(void)
>  		 * These disks have not called add_disk().  Don't put down
>  		 * queue reference in put_disk().
>  		 */
> -		if (!(allowed_drive_mask & (1 << drive)) ||
> -		    fdc_state[FDC(drive)].version == FDC_NONE)
> +		if (!disk_registered[drive])
>  			disks[drive]->queue = NULL;
>  
>  		put_disk(disks[drive]);
> -- 
> 1.7.9.5
