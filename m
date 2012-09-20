Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2ITKeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:34:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7166 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2ITKeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:34:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="208665077"
Message-ID: <505AF126.2050806@citrix.com>
Date: Thu, 20 Sep 2012 11:34:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Oliver Chick <oliver.chick@citrix.com>
CC: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
In-Reply-To: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/12 11:51, Oliver Chick wrote:
> This patch implements persistent grants for the xen-blk{front,back}
> mechanism.
[...]
> We (ijc, and myself) have introduced a new constant,
> BLKIF_MAX_PERS_REQUESTS_PER_DEV. This is to prevent a malicious guest
> from attempting a DoS, by supplying fresh grefs, causing the Dom0
> kernel from to map excessively. 
[...]
> 2) Otherwise, we revert to non-persistent grants for all future grefs.

Why fallback instead of immediately failing the request?

> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 73f196c..f95dee9 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -78,6 +78,7 @@ struct pending_req {
>  	unsigned short		operation;
>  	int			status;
>  	struct list_head	free_list;
> +	u8			is_pers;

Using "pers" as an abbreviation for "persistent" isn't obvious.  For
readability it may be better spell it in full.

> +/*
> + * Maximum number of persistent grants that can be mapped by Dom0 for each
> + * interface. This is set to be the size of the ring, as this is a limit on
> + * the number of requests that can be inflight at any one time. 256 imposes
> + * an overhead of 11MB of mapped kernel space per interface.
> + */
> +#define BLKIF_MAX_PERS_REQUESTS_PER_DEV 256

This 11MB per VBD seems like a lot.  With 150 VMs each with 2 VBDs this
requires > 3 GB.  Is this a scalability problem?

Does there need to be a mechanism to expire old maps in blkback?

David
