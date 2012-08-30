Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2H3Rzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:55:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41694 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2H3Rzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:55:49 -0400
Date: Fri, 31 Aug 2012 02:55:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: zcache: fix cleancache race condition with
 shrinker
Message-ID: <20120830175543.GA3534@barrios>
References: <1346277525-22062-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346277525-22062-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 04:58:45PM -0500, Seth Jennings wrote:
> This patch fixes a race condition that results in memory
> corruption when using cleancache.
> 
> The race exists between the zcache shrinker handler,
> shrink_zcache_memory() and cleancache_get_page().
> 
> In most cases, the shrinker will both evict a zbpg
> from its buddy list and flush it from tmem before a
> cleancache_get_page() occurs on that page. A subsequent
> cleancache_get_page() will fail in the tmem layer.
> 
> In the rare case that two occur together and the
> cleancache_get_page() path gets through the tmem
> layer before the shrinker path can flush tmem,
> zbud_decompress() does a check to see if the zbpg is a
> "zombie", i.e. not on a buddy list, which means the shrinker
> is in the process of reclaiming it. If the zbpg is a zombie,
> zbud_decompress() returns -EINVAL.
> 
> However, this return code is being ignored by the caller,
> zcache_pampd_get_data_and_free(), which results in the
> caller of cleancache_get_page() thinking that the page has
> been properly retrieved when it has not.
> 
> This patch modifies zcache_pampd_get_data_and_free() to
> convey the failure up the stack so that the caller of
> cleancache_get_page() knows the page retrieval failed.
> 
> ---
> Based on v3.6-rc3.
> 
> This needs to be applied to stable trees as well.
> zcache-main.c was named zcache.c before v3.1, so
> I'm not sure how you want to handle trees earlier
> than that.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

Thanks!
