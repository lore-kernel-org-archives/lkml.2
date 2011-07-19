Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1GSUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:55:45 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34520 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1GSUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:55:44 -0400
Date: Tue, 19 Jul 2011 13:55:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove useless rcu lock-unlock from
 mapping_tagged()
Message-ID: <20110719205541.GQ2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110717113522.17196.13682.stgit@localhost6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717113522.17196.13682.stgit@localhost6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 03:35:23PM +0400, Konstantin Khlebnikov wrote:
> radix_tree_tagged() is lockless, it does not require any protection.

Indeed.  The radix_tree_root structure is a field in the address_space
structure, so no protection is required to get at the field.  If
protection is required on the mapping pointer itself, that would have
to happen in writeback_single_inode() and friends.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  mm/page-writeback.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 31f6988..919b45e 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1405,10 +1405,6 @@ EXPORT_SYMBOL(test_set_page_writeback);
>   */
>  int mapping_tagged(struct address_space *mapping, int tag)
>  {
> -	int ret;
> -	rcu_read_lock();
> -	ret = radix_tree_tagged(&mapping->page_tree, tag);
> -	rcu_read_unlock();
> -	return ret;
> +	return radix_tree_tagged(&mapping->page_tree, tag);
>  }
>  EXPORT_SYMBOL(mapping_tagged);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
