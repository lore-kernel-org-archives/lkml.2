Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0IEGe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 02:34:27 -0400
Received: from kroah.org ([198.145.64.141]:45286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0IEGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 02:34:23 -0400
Date: Sat, 4 Sep 2010 22:24:23 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] West Bridge Astoria Driver 2.6.35, minor block and
	device driver updates
Message-ID: <20100905052423.GA4396@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467794.4378.17.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283467794.4378.17.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:49:54PM -0700, David Cross wrote:
> This patch contains minor updates to the west bridge block and device
> drivers, including the addition of a common lock and a minor update to
> remove the blk_fs_request call based on a kernel update. These changes
> could possibly be separated, but are very minor in scope and as such
> have been submitted together.

Again, one patch per logical change please.  That's the way patches for
the kernel work.  So can you please separate these and resend them?


> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-25 18:29:44.000000000 -0700
> @@ -389,7 +389,7 @@ int cyasblkdev_media_changed(struct gend
>  	struct cyasblkdev_blk_data *bd;
>  
>  	#ifndef WESTBRIDGE_NDEBUG
> -	cy_as_hal_print_message("cyasblkdev_media_changed() is called\n");
> +	cy_as_hal_print_message(KERN_INFO"cyasblkdev_media_changed() is called\n");

Ick.  How about a ' ' after KERN_INFO?  And do you really always want to
do this?  You can enable tracing to get this type of info.

>  	#endif

The whole NDEBUG stuff should be removed from the .c files and put in
the .h file if it's really needed.

> @@ -493,7 +493,7 @@ static void cyasblkdev_issuecallback(
>  {
>  	int retry_cnt = 0;
>  	DBGPRN_FUNC_NAME;
> -
> +	
>  	if (status != CY_AS_ERROR_SUCCESS) {
>  		#ifndef WESTBRIDGE_NDEBUG
>  		cy_as_hal_print_message(

You added a line of trailing spaces for no good reason :(


> @@ -509,7 +509,10 @@ static void cyasblkdev_issuecallback(
>  		__func__, (unsigned int) gl_bd->queue.req, status,
>  		(unsigned int) blk_rq_sectors(gl_bd->queue.req)) ;
>  	#endif
> -
> +	
> +	if(rq_data_dir(gl_bd->queue.req) != READ) {
> +		cy_as_release_common_lock();
> +	}

No need for the extra {}, please take a look at
Documentation/CodingStyle for how to do things for the kernel.  Also a
space is needed after the 'if'.

Please run your patches through the scripts/checkpatch.pl tool before
sending them to me.  Yes, there's lots of checkpatch issues in the
driver already, but don't add new ones now please.

Care to redo this?

thanks,

greg k-h
