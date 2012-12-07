Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424161Ab2LGUU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:20:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29323 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2LGUUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:20:24 -0500
Date: Fri, 7 Dec 2012 15:20:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH 2/2] xen-blkfront: implement safe version of
 llist_for_each_entry
Message-ID: <20121207202003.GA9462@phenom.dumpdata.com>
References: <1354630913-17287-1-git-send-email-roger.pau@citrix.com>
 <1354630913-17287-2-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1354630913-17287-2-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 03:21:53PM +0100, Roger Pau Monne wrote:
> Implement a safe version of llist_for_each_entry, and use it in
> blkif_free. Previously grants where freed while iterating the list,
> which lead to dereferences when trying to fetch the next item.

Looks like xen-blkfront is the only user of this llist_for_each_entry.

Would it be more prudent to put the macro in the llist.h file?

> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> Cc: xen-devel@lists.xen.org
> ---
>  drivers/block/xen-blkfront.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 96e9b00..df21b05 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -143,6 +143,13 @@ static DEFINE_SPINLOCK(minor_lock);
>  
>  #define DEV_NAME	"xvd"	/* name in /dev */
>  
> +#define llist_for_each_entry_safe(pos, n, node, member)		\
> +	for ((pos) = llist_entry((node), typeof(*(pos)), member),	\
> +	     (n) = (pos)->member.next;					\
> +	     &(pos)->member != NULL;					\
> +	     (pos) = llist_entry(n, typeof(*(pos)), member),		\
> +	     (n) = (&(pos)->member != NULL) ? (pos)->member.next : NULL)
> +
>  static int get_id_from_freelist(struct blkfront_info *info)
>  {
>  	unsigned long free = info->shadow_free;
> @@ -792,6 +799,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  {
>  	struct llist_node *all_gnts;
>  	struct grant *persistent_gnt;
> +	struct llist_node *n;
>  
>  	/* Prevent new requests being issued until we fix things up. */
>  	spin_lock_irq(&info->io_lock);
> @@ -804,7 +812,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	/* Remove all persistent grants */
>  	if (info->persistent_gnts_c) {
>  		all_gnts = llist_del_all(&info->persistent_gnts);
> -		llist_for_each_entry(persistent_gnt, all_gnts, node) {
> +		llist_for_each_entry_safe(persistent_gnt, n, all_gnts, node) {
>  			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
>  			__free_page(pfn_to_page(persistent_gnt->pfn));
>  			kfree(persistent_gnt);
> -- 
> 1.7.7.5 (Apple Git-26)
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
