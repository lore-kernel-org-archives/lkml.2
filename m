Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab2K3Ohy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:37:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2K3Ohw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:37:52 -0500
Date: Fri, 30 Nov 2012 23:37:44 +0900
From: Minchan Kim <minchan.kernel.2@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] zram: reduce metadata overhead
Message-ID: <20121130143744.GB22196@blaptop>
References: <1354258489-2703-1-git-send-email-ngupta@vflare.org>
 <1354258489-2703-2-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354258489-2703-2-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:54:49PM -0800, Nitin Gupta wrote:
> Changelog v2 vs v1:
>  - Use is_zero_page() instead of direct handle comparison
>  - Use 1 as invalid handle value instead of -1 since handle
> is unsigned and thus -1 may refer to a valid object. While 1
> is guaranteed to be invalid since <pfn:0,offset:1> can never
> refer to (end of) a valid object.

Ho, Hmm, another coupling between zram and zsmalloc.
The zram knows internal of zsmalloc very well. Sigh.
I don't like it really. Nonetheless, if you really want it,
please put "#define ZS_INVALID_HANDLE 1" in zsmalloc.h and use it.
But the concern about my suggestion is that user can imagine
it's equal to 0 so they might try to use it instead of 0.
Maybe we need more clear name.

Off-topic:
Anyway, my assumption about user's mistake is only vaild in case of
general allocator but zsmalloc already wasn't general allocator by
following as.

zs_map_object
zs_get_objsize
ZS_INVALID_HANDLE

Now I'm sure we shouldn't put it in under /lib. :(

>  - Remove references to 'table' in comments and messages since
> we just have a plain array of handles now.
> 
> For every allocated object, zram maintains the the handle, size,
> flags and count fields. Of these, only the handle is required
> since zsmalloc now provides the object size given the handle.
> The flags field was needed only to mark a given page as zero-filled.
> Instead of this field, we now use an invalid value (-1) to mark such

                                                      ZS_INAVLID_HANDLE or something.

> pages. Lastly, the count field was unused, so was simply removed.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reviewed-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  drivers/staging/zram/zram_drv.c |   97 ++++++++++++++++-----------------------
>  drivers/staging/zram/zram_drv.h |   20 ++------
>  2 files changed, 43 insertions(+), 74 deletions(-)
> 

Otherwise, looks good to me.
-- 
Kind regards,
Minchan Kim
