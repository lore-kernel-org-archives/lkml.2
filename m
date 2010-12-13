Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab0LMRN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:13:28 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4221 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab0LMRN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:13:26 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [PATCH 2/9] drivers/net: don't use flush_scheduled_work()
From: "Michael Chan" <mchan@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jay Cliburn" <jcliburn@gmail.com>, "Divy Le Ray" <divy@chelsio.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Vasanthy Kolluri" <vkolluri@cisco.com>,
        "Samuel Ortiz" <samuel@sortiz.org>,
        "Lennert Buytenhek" <buytenh@wantstofly.org>,
        "Andrew Gallatin" <gallatin@myri.com>,
        "Francois Romieu" <romieu@fr.zoreil.com>,
        "Ramkrishna Vepa" <ramkrishna.vepa@exar.com>,
        "Matthew Carlson" <mcarlson@broadcom.com>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Shreyas Bhatewara" <sbhatewara@vmware.com>
In-Reply-To: <1292169185-10579-3-git-send-email-tj@kernel.org>
References: <1292169185-10579-1-git-send-email-tj@kernel.org>
 <1292169185-10579-3-git-send-email-tj@kernel.org>
Date: Mon, 13 Dec 2010 09:08:59 -0800
Message-ID: <1292260139.7394.11.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 61188B905L82114331-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2010-12-12 at 07:52 -0800, Tejun Heo wrote:
> flush_scheduled_work() is on its way out.  This patch contains simple
> conversions to replace flush_scheduled_work() usage with direct
> cancels and flushes.
> 
> Directly cancel the used works on driver detach and flush them in
> other cases.
> 
> The conversions are mostly straight forward and the only dangers are,
> 
> * Forgetting to cancel/flush one or more used works.
> 
> * Cancelling when a work should be flushed (ie. the work must be
>   executed once scheduled whether the driver is detaching or not).
> 
> I've gone over the changes multiple times but it would be much
> appreciated if you can review with the above points in mind.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jay Cliburn <jcliburn@gmail.com>
> Cc: Michael Chan <mchan@broadcom.com>
> Cc: Divy Le Ray <divy@chelsio.com>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: Vasanthy Kolluri <vkolluri@cisco.com>
> Cc: Samuel Ortiz <samuel@sortiz.org>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Andrew Gallatin <gallatin@myri.com>
> Cc: Francois Romieu <romieu@fr.zoreil.com>
> Cc: Ramkrishna Vepa <ramkrishna.vepa@exar.com>
> Cc: Matt Carlson <mcarlson@broadcom.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> Cc: netdev@vger.kernel.org
> ---

> diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
> index 03209a3..5c811f3 100644
> --- a/drivers/net/bnx2.c
> +++ b/drivers/net/bnx2.c
> @@ -8393,7 +8393,7 @@ bnx2_remove_one(struct pci_dev *pdev)
>         struct net_device *dev = pci_get_drvdata(pdev);
>         struct bnx2 *bp = netdev_priv(dev);
> 
> -       flush_scheduled_work();
> +       cancel_work_sync(&bp->reset_task);

I think we can just remove flush_scheduled_work() altogether in
bnx2_remove_one().  The work has already been canceled in bnx2_close(),
so there is no possibility of it to be scheduled at this point.

> 
>         unregister_netdev(dev);
> 
> @@ -8431,7 +8431,7 @@ bnx2_suspend(struct pci_dev *pdev, pm_message_t
> state)
>         if (!netif_running(dev))
>                 return 0;
> 
> -       flush_scheduled_work();
> +       cancel_work_sync(&bp->reset_task);

This part ok.  Thanks.

Acked-by: Michael Chan <mchan@broadcom.com>

>         bnx2_netif_stop(bp, true);
>         netif_device_detach(dev);
>         del_timer_sync(&bp->timer);


