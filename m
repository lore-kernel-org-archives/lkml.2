Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2HTXmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 19:42:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41776 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2HTXl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 19:41:58 -0400
Date: Mon, 20 Aug 2012 16:41:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        neilb@suse.de
Subject: Re: [PATCH 1/3] raid: replace	list_for_each_continue_rcu with new
 interface
Message-ID: <20120820234153.GN2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <502CB924.10200@linux.vnet.ibm.com>
 <502DC999.1040407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502DC999.1040407@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082023-2356-0000-0000-00000172FD8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:33:29PM +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> This patch replaces list_for_each_continue_rcu() with
> list_for_each_entry_continue_rcu() to save a few lines
> of code and allow removing list_for_each_continue_rcu().
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Getting rid of list_for_each_continue_rcu() would indeed be a good thing!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  drivers/md/bitmap.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 15dbe03..b160828 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -163,20 +163,17 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
>  	 * As devices are only added or removed when raid_disk is < 0 and
>  	 * nr_pending is 0 and In_sync is clear, the entries we return will
>  	 * still be in the same position on the list when we re-enter
> -	 * list_for_each_continue_rcu.
> +	 * list_for_each_entry_continue_rcu.
>  	 */
> -	struct list_head *pos;
>  	rcu_read_lock();
>  	if (rdev == NULL)
>  		/* start at the beginning */
> -		pos = &mddev->disks;
> +		rdev = list_entry_rcu(&mddev->disks, struct md_rdev, same_set);
>  	else {
>  		/* release the previous rdev and start from there. */
>  		rdev_dec_pending(rdev, mddev);
> -		pos = &rdev->same_set;
>  	}
> -	list_for_each_continue_rcu(pos, &mddev->disks) {
> -		rdev = list_entry(pos, struct md_rdev, same_set);
> +	list_for_each_entry_continue_rcu(rdev, &mddev->disks, same_set) {
>  		if (rdev->raid_disk >= 0 &&
>  		    !test_bit(Faulty, &rdev->flags)) {
>  			/* this is a usable devices */
> -- 
> 1.7.4.1
> 
> 

