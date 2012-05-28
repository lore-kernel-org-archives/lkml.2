Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2E1KTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:19:42 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:50314 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2E1KTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:19:40 -0400
X-IronPort-AV: E=Sophos;i="4.75,670,1330905600"; 
   d="scan'208";a="12692702"
Date: Mon, 28 May 2012 11:19:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "jbeulich@suse.com" <jbeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/blkback: Copy id field when doing
 BLKIF_DISCARD.
In-Reply-To: <1337982603-15692-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1205281119080.26786@kaball-desktop>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com> <1337982603-15692-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Konrad Rzeszutek Wilk wrote:
> We weren't copying the id field so when we sent the response
> back to the frontend (especially with a 64-bit host and 32-bit
> guest), we ended up using a random value. This lead to the
> frontend crashing as it would try to pass to __blk_end_request_all
> a NULL 'struct request' (b/c it would use the 'id' to find the
> proper 'struct request' in its shadow array) and end up crashing:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000e4
> IP: [<c0646d4c>] __blk_end_request_all+0xc/0x40
> .. snip..
> EIP is at __blk_end_request_all+0xc/0x40
> .. snip..
>  [<ed95db72>] blkif_interrupt+0x172/0x330 [xen_blkfront]
> 
> This fixes the bug by passing in the proper id for the response.
> 
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=824641
> CC: stable@kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  drivers/block/xen-blkback/common.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 773cf27..9ad3b5e 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -257,6 +257,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
>  		break;
>  	case BLKIF_OP_DISCARD:
>  		dst->u.discard.flag = src->u.discard.flag;
> +		dst->u.discard.id = src->u.discard.id;
>  		dst->u.discard.sector_number = src->u.discard.sector_number;
>  		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
>  		break;
> @@ -287,6 +288,7 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
>  		break;
>  	case BLKIF_OP_DISCARD:
>  		dst->u.discard.flag = src->u.discard.flag;
> +		dst->u.discard.id = src->u.discard.id;
>  		dst->u.discard.sector_number = src->u.discard.sector_number;
>  		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
>  		break;
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
