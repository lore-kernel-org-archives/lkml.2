Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2CBLWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:22:32 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57039 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2CBLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:22:30 -0500
Date: Fri, 2 Mar 2012 06:22:03 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] dma-debug: debugfs_create_bool() takes a u32 pointer
Message-ID: <20120302112203.GA14827@hmsreliant.think-freely.org>
References: <20120302065832.GE24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302065832.GE24508@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 09:58:32AM +0300, Dan Carpenter wrote:
> Even though it has "bool" in the name, you have pass a u32 pointer to
> debugfs_create_bool().  Otherwise you get memory corruption in
> write_file_bool().  Fortunately in this case the corruption happens in
> an alignment hole between variables so it doesn't cause any problems.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 13ef233..08cd5a6 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -78,7 +78,7 @@ static LIST_HEAD(free_entries);
>  static DEFINE_SPINLOCK(free_entries_lock);
>  
>  /* Global disable flag - will be set in case of an error */
> -static bool global_disable __read_mostly;
> +static u32 global_disable __read_mostly;
>  
>  /* Global error count */
>  static u32 error_count;
> @@ -657,7 +657,7 @@ static int dma_debug_fs_init(void)
>  
>  	global_disable_dent = debugfs_create_bool("disabled", 0444,
>  			dma_debug_dent,
> -			(u32 *)&global_disable);
> +			&global_disable);
>  	if (!global_disable_dent)
>  		goto out_err;
>  
> 


This certainly works, but a quick search of call sites shows this isn't the only
place someone passes a bool to debugfs_create_bool. I think the better solution
would be to change debugfs_create_bool and its corresponding read/write methods
to actually work with a bool type, and then clean all the call sites to pass in
a bool properly, instead of a u32.

Thanks
Neil

