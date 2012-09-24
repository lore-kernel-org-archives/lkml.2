Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2IXPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:17:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26978 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2IXPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:17:35 -0400
Date: Mon, 24 Sep 2012 11:06:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
Cc: Oliver Chick <oliver.chick@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Persistent grant maps for xen blk drivers
Message-ID: <20120924150616.GA694@phenom.dumpdata.com>
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com>
 <20120921184123.GA27502@phenom.dumpdata.com>
 <20120921185622.GA5042@phenom.dumpdata.com>
 <20120921204646.GB30614@phenom.dumpdata.com>
 <43E8FEC9-DE7D-4352-87F2-63FB8984D556@gridcentric.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43E8FEC9-DE7D-4352-87F2-63FB8984D556@gridcentric.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:38:48AM -0400, Andres Lagar-Cavilla wrote:
> On Sep 21, 2012, at 4:46 PM, Konrad Rzeszutek Wilk wrote:
> 
> > On Fri, Sep 21, 2012 at 02:56:22PM -0400, Konrad Rzeszutek Wilk wrote:
> >>> *: With a PVHVM guest I get
> >>> 
> >>> [  261.927218] privcmd_fault: vma=ffff88002a31dce8 7f4edc095000-7f4edc195000, pgoff=c8, uv=00007f4edc15d000
> >>> 
> >>> thought if I applied your patch on top of v3.6-rc6 I didn't see the privcmd_fault but
> >>> I did see the guest crash.
> >> 
> >> And that is due to c571898ffc24a1768e1b2dabeac0fc7dd4c14601 which I've reverted in my
> >> #linux-next branch
> > 
> > Nevermind. Andres' patch by itself (so without yours) works just fine. There is
> > something your patch and his aren't agreeing on.
> 
> Apart from interacting badly in combination, would either patch in isolation work well?

"work well" is not exactly the right phase I would use.

Your patch by itself (so on top v3.6-rc6) works great.
On top of #linux-next (so v3.6-rc6 + lot of other patches for v3.7) works great.

Oliver's patch for blkback/blkfront on top of v3.6-rc6 falls flat on its face in the guest.
Oliver's patch for blkback/blkfront on top of v3.6-rc6 + lot of other patches for v3.7 - your patch)
falls flat on its face in the guest.

Oliver's patch for blkback/blkfront on top of v3.6-rc6 + lot of other patches for v3.7 + your patch)
falls flat on its face in the backend with the privcmd_fault.

I think I need to figure on what tree does Oliver's patch work properly and
figure out why it dies first in the guest and then find out why in the backend
it dies with your patch.

Your patch is still on the train for v3.7

> 
> I can think of only one hunk in my patch disagreeing with blkback stuff:

I can try it out.. but I am not going to get to it today or in the next
few days.

> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index eea81cf..f5681c8 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -836,6 +883,12 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  	if (ret)
>  		return ret;
>  
> +	/* Retry eagain maps */
> +	for (i = 0; i < count; i++)
> +		if (map_ops[i].status == GNTST_eagain)
> +			gnttab_retry_eagain_gop(GNTTABOP_map_grant_ref, map_ops + i,
> +                                    &map_ops[i].status, __func__);
> +
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> How would you like to proceed?
> Andres
> 
> > 
