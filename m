Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab1CCUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:50:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15448 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab1CCUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:50:11 -0500
Date: Thu, 3 Mar 2011 21:49:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        linux-scsi@vger.kernel.org
cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aacraid: Remove mem leak in aac_send_raw_srb().
In-Reply-To: <alpine.LNX.2.00.1101062120090.13988@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1103032148300.2430@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062120090.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING!

Any chance we could get this patch merged? Any objections?


/Jesper Juhl


On Thu, 6 Jan 2011, Jesper Juhl wrote:

> 
> We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb().
> 
> We allocate memory:
> 	...
> 			struct user_sgmap* usg;
> 			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
> 			  + sizeof(struct sgmap), GFP_KERNEL);
> and then neglect to free it:
> 	...
> 			for (i = 0; i < usg->count; i++) {
> 				u64 addr;
> 				void* p;
> 				if (usg->sg[i].count >
> 				    ((dev->adapter_info.options &
> 				     AAC_OPT_NEW_COMM) ?
> 				      (dev->scsi_host_ptr->max_sectors << 9) :
> 				      65536)) {
> 					rcode = -EINVAL;
> 					goto cleanup;
> 	... this 'goto' makes 'usg' go out of scope and leak the memory we 
> 	    allocated.
> 	    Other exits properly kfree(usg), it's just here it is 
> 	    neglected.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  commctrl.c |    1 +
>  1 file changed, 1 insertion(+)
> 
>   Compile tested only, I don't have a way to test this properly, but I 
>   think it's fairly obvious.
> 
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index 645ddd9..33370fb 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
>  				     AAC_OPT_NEW_COMM) ?
>  				      (dev->scsi_host_ptr->max_sectors << 9) :
>  				      65536)) {
> +					kfree(usg);
>  					rcode = -EINVAL;
>  					goto cleanup;
>  				}
> 
> 
> 
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

