Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2IHUsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:48:51 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2IHUst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:48:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH] PM QoS: Add a metric : Bus Throughput.
Date: Sat, 8 Sep 2012 22:55:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
References: <25039060.6131344561170907.JavaMail.weblogic@epml26>
In-Reply-To: <25039060.6131344561170907.JavaMail.weblogic@epml26>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209082255.02291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 10, 2012, ÇÔ¸íÁÖ wrote:
> > + Myungjoo Ham,
> > 
> > It used at devfreq. Mr. Ham can you explain it in detail?
> > 
> > Thank you,
> > Kyungmin Park
> > ,
> > On 8/9/12, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Wednesday, August 08, 2012, Jonghwa Lee wrote:
> > >> Bus throughput metric is added to PM QoS in order to control the
> > >> frequency of memory interfaces and busses with PM QoS.
> > >>
> > >> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> > >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > >
> > > I said some time ago I didn't want any new global PM QoS classes to be
> > > added this way.
> > >
> > > Can you please post a driver patch using this new thing?
> > >
> > > Rafael
> 
> It'd be too early for V4L2 device driver QoS patches as they are undergoing
> major updates and the previous QoS patches over they are now obsolete.
> 
> However, I've found that one QoS patch is still intact with the current one.
> Here goes the example driver that uses Bus-Throughput for its operation.
> (Fortunately, it is not V4L2, but DRM driver)
> 
> It is a G2D (2D graphics acceleration) device driver that gets command lists
> from userspace and then process them via DMA. Many command lists finish even
> before any DVFS mechanism may react while the response time of a command list
> is still important for the user processes.
> 
> Here we go:

Well, so my questions are:

> ---
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> index d2d88f2..969b2c5 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -14,6 +14,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_qos.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> @@ -135,6 +136,7 @@ struct g2d_data {
>  	struct workqueue_struct		*g2d_workq;
>  	struct work_struct		runqueue_work;
>  	struct exynos_drm_subdrv	subdrv;
> +	struct pm_qos_request_list	pm_qos;
>  	bool				suspended;
>  
>  	/* cmdlist */
> @@ -314,6 +316,9 @@ static void g2d_dma_start(struct g2d_data *g2d,
>  	pm_runtime_get_sync(g2d->dev);
>  	clk_enable(g2d->gate_clk);
>  
> +	/* 416MHz w/ 64b 30% saturating bus */
> +	pm_qos_update_request(&g2d->pm_qos, 1000000);
> +

(1) What's the unit of that number and (2) why is it global?

Rafael
