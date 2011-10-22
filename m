Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1JVNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 09:09:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43713 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1JVNJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 09:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <20111022125620.GA2256@ecki.lan>
References: <20111022125620.GA2256@ecki.lan>
Date: Sat, 22 Oct 2011 18:39:22 +0530
Message-ID: <CAD2nsn2pMma4y2RyX_tyxohV3AtNnOa_t8UOR4cJdrABzehMeg@mail.gmail.com>
Subject: Re: [PATCH] jme: fix irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Guo-Fu Tseng <cooldavid@cooldavid.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 6:26 PM, Clemens Buchacher <drizzd@aon.at> wrote:
> If the device is down during suspend/resume, interrupts are enabled
> without a registered interrupt handler, causing a storm of
> unhandled interrupts until the IRQ is disabled because "nobody
> cared".

thank you so much for fixing this. incredible persistence from your side!

>
> Instead, check that the device is up before touching it in the
> suspend/resume code.
>
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=39112
>
> Helped-by: Adrian Chadd <adrian@freebsd.org>
> Helped-by: Mohammed Shafi <shafi.wireless@gmail.com>
> Signed-off-by: Clemens Buchacher <drizzd@aon.at>
> ---
>
> Unfortunately, bugzilla.kernel.org is still down. There is at least
> one other person who reported the issue, and I don't have their
> email address. So for now, I am the only one who tested this fix.
>
> The patch applies to current tip (2efd7c0) of Linus' tree. I also
> tested it based on v3.0 and it worked the same.
>
> Many thanks to Adrian and Mohammed for helping me debug this issue.
> See this thread for the history:
>  http://mid.gmane.org/20110827113253.GA1444@ecki
>
>  drivers/net/jme.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/jme.c b/drivers/net/jme.c
> index 3ac262f..7a8a3b6 100644
> --- a/drivers/net/jme.c
> +++ b/drivers/net/jme.c
> @@ -3131,6 +3131,9 @@ jme_suspend(struct device *dev)
>        struct net_device *netdev = pci_get_drvdata(pdev);
>        struct jme_adapter *jme = netdev_priv(netdev);
>
> +       if (!netif_running(netdev))
> +               return 0;
> +
>        atomic_dec(&jme->link_changing);
>
>        netif_device_detach(netdev);
> @@ -3171,6 +3174,9 @@ jme_resume(struct device *dev)
>        struct net_device *netdev = pci_get_drvdata(pdev);
>        struct jme_adapter *jme = netdev_priv(netdev);
>
> +       if (!netif_running(netdev))
> +               return 0;
> +
>        jme_clear_pm(jme);
>        jme_phy_on(jme);
>        if (test_bit(JME_FLAG_SSET, &jme->flags))
> --
> 1.7.7
>
>



-- 
shafi
