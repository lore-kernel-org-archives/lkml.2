Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0JKNn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:43:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:32876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab0JKNn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:43:57 -0400
Message-ID: <4CB3148C.5040902@kernel.org>
Date: Mon, 11 Oct 2010 15:43:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect,
 and shutdown
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de> <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
In-Reply-To: <tkrat.1433473bc081daa9@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Oct 2010 13:43:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/10/2010 04:57 PM, Stefan Richter wrote:
...
> Simply swap out the driver workqueue by system_nrt_wq.  It provides all
> the parallelism we will ever need, accepts long-running work, and
> provides the here necessary guarantee of non-reentrance across all CPUs.
               ^^^^
               this probably should go away?

> (The work items are scheduled from firewire-core's fw_device work items
> which themselves may change CPUs.)
> 
> This simple approach requires though that targets with multiple logical
> units accept multiple outstanding management requests.  The SBP-2 spec
> implicitly requires this capability, but who knows how real firmwares
> react.
> 
> I only have access to two dual-LU targets:  A OXUF924DSB based one from
> MacPower and a INIC-2430 based one from IOI.  They both work fine with
> this change, as do several single-LU targets of course.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/sbp2.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> Index: b/drivers/firewire/sbp2.c
> ===================================================================
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -835,8 +835,6 @@ static void sbp2_target_put(struct sbp2_
>  	kref_put(&tgt->kref, sbp2_release_target);
>  }
>  
> -static struct workqueue_struct *sbp2_wq;
> -
>  /*
>   * Always get the target's kref when scheduling work on one its units.
>   * Each workqueue job is responsible to call sbp2_target_put() upon return.
> @@ -844,7 +842,7 @@ static struct workqueue_struct *sbp2_wq;
>  static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
>  {
>  	sbp2_target_get(lu->tgt);
> -	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
> +	if (!queue_delayed_work(system_nrt_wq, &lu->work, delay))
>  		sbp2_target_put(lu->tgt);
>  }
>  
> @@ -1656,17 +1654,12 @@ MODULE_ALIAS("sbp2");
>  
>  static int __init sbp2_init(void)
>  {
> -	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
> -	if (!sbp2_wq)
> -		return -ENOMEM;
> -
>  	return driver_register(&sbp2_driver.driver);
>  }
>  
>  static void __exit sbp2_cleanup(void)
>  {
>  	driver_unregister(&sbp2_driver.driver);
> -	destroy_workqueue(sbp2_wq);

Hmmm... from glancing the code, there doesn't seem to anything which
can guarantee sbp2_release_target/reconnect() are finished before
sbp2_cleanup() returns, so the code section might go away with code
still running.  It seems like the right thing to do here would be
using alloc_workqueue(KBUILD_MODNAME, WQ_NON_REENTRANT, 0).  Am I
missing something?

Thanks.

-- 
tejun
