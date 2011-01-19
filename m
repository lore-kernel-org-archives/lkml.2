Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1ASO1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:27:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1ASO1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:27:04 -0500
Date: Wed, 19 Jan 2011 15:27:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        osst-users@lists.sourceforge.net, osst-users@lists.sourceforge.net,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17][trivial] scsi: Remove unnecessary casts of void
 ptr returning alloc function return values
In-Reply-To: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1101191526410.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Jesper Juhl wrote:

> Hi,
> 
> The [vk][cmz]alloc(_node) family of functions return void pointers which
> it's completely unnecessary/pointless to cast to other pointer types since
> that happens implicitly.
> 
> This patch removes such casts from drivers/scsi/
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  aic7xxx/aic7xxx_core.c |    2 +-
>  osst.c                 |   10 ++++------
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index 3f5a542..e021b48 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -4780,7 +4780,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  	SLIST_INIT(&scb_data->sg_maps);
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = (struct scb *)kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
>  	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index 54de1d1..521e218 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -1484,7 +1484,7 @@ static int osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct osst
>  	int			dbg              = debugging;
>  #endif
>  
> -	if ((buffer = (unsigned char *)vmalloc((nframes + 1) * OS_DATA_SIZE)) == NULL)
> +	if ((buffer = vmalloc((nframes + 1) * OS_DATA_SIZE)) == NULL)
>  		return (-EIO);
>  
>  	printk(KERN_INFO "%s:I: Reading back %d frames from drive buffer%s\n",
> @@ -2296,7 +2296,7 @@ static int osst_write_header(struct osst_tape * STp, struct osst_request ** aSRp
>  	if (STp->raw) return 0;
>  
>  	if (STp->header_cache == NULL) {
> -		if ((STp->header_cache = (os_header_t *)vmalloc(sizeof(os_header_t))) == NULL) {
> +		if ((STp->header_cache = vmalloc(sizeof(os_header_t))) == NULL) {
>  			printk(KERN_ERR "%s:E: Failed to allocate header cache\n", name);
>  			return (-ENOMEM);
>  		}
> @@ -2484,7 +2484,7 @@ static int __osst_analyze_headers(struct osst_tape * STp, struct osst_request **
>  				   name, ppos, update_frame_cntr);
>  #endif
>  		if (STp->header_cache == NULL) {
> -			if ((STp->header_cache = (os_header_t *)vmalloc(sizeof(os_header_t))) == NULL) {
> +			if ((STp->header_cache = vmalloc(sizeof(os_header_t))) == NULL) {
>  				printk(KERN_ERR "%s:E: Failed to allocate header cache\n", name);
>  				return 0;
>  			}
> @@ -5851,9 +5851,7 @@ static int osst_probe(struct device *dev)
>  	/* if this is the first attach, build the infrastructure */
>  	write_lock(&os_scsi_tapes_lock);
>  	if (os_scsi_tapes == NULL) {
> -		os_scsi_tapes =
> -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> -				   GFP_ATOMIC);
> +		os_scsi_tapes = kmalloc(osst_max_dev * sizeof(struct osst_tape *), GFP_ATOMIC);
>  		if (os_scsi_tapes == NULL) {
>  			write_unlock(&os_scsi_tapes_lock);
>  			printk(KERN_ERR "osst :E: Unable to allocate array for OnStream SCSI tapes.\n");
> 

Not present in linux-next as of today, taking through trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
