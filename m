Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab2HGLlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:41:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2HGLl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:41:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH] PM / Domains: Not return error when dev_pm_get_subsys_data returns 1
Date: Tue, 7 Aug 2012 13:47:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, pavel@ucw.cz, patches@linaro.org,
        Heiko =?iso-8859-2?q?St=FCbner?= <heiko@sntech.de>
References: <1344330256-6939-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1344330256-6939-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208071347.22811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 07, 2012, Tushar Behera wrote:
> Commit 1d5fcfec22 ("PM / Domains: Add device domain data reference
> counter") returns error when dev_pm_get_subsys_data() returns a
> non-zero value.
> 
> However, dev_pm_get_subsys_data() returns 1 when dev->power.subsys_data
> is allocated during this call. Hence we should only check for the error
> codes in the return value.
> 
> Without this patch, following errors are encountered while adding
> devices to powerdomain on Origen board (based on EXYNOS4210).
> 
> exynos_pm_add_dev_to_genpd: error in adding exynos4-fb.0 device to pd-lcd0 powerdomain
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

First of all, this particular problem has been reported already and patches
addressing it were queued up for merging later in this cycle.  However,
your patch below shows that those two patches were incomplete, so I'm going
to use the appended one instead.

> ---
>  drivers/base/power/domain.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index ba3487c..f6802cb 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1323,7 +1323,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>  		}
>  
>  	ret = dev_pm_get_subsys_data(dev);
> -	if (ret)
> +	if (ret < 0)
>  		goto out;
>  
>  	genpd->device_count++;
> @@ -1358,7 +1358,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>  	if (gpd_data != gpd_data_new)
>  		__pm_genpd_free_dev_data(dev, gpd_data_new);
>  
> -	return ret;
> +	return (ret < 0) ? : 0;
>  }
>  
>  /**
> 

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Make dev_pm_get_subsys_data() always return 0 on success

Commits 1d5fcfec22 (PM / Domains: Add device domain data reference
counter) and 62d4490294 (PM / Domains: Allow device callbacks to be
added at any time) added checks for the return value of
dev_pm_get_subsys_data(), but those checks were incorrect, because
that function returned 1 on success in some cases.

Since all of the existing users of dev_pm_get_subsys_data() don't use
the positive value returned by it on success, change its definition
so that it always returns 0 when successful.

Reported-by: Heiko Stübner <heiko@sntech.de>
Reported-by: Tushar Behera <tushar.behera@linaro.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/clock_ops.c |    3 +--
 drivers/base/power/common.c    |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: linux/drivers/base/power/clock_ops.c
===================================================================
--- linux.orig/drivers/base/power/clock_ops.c
+++ linux/drivers/base/power/clock_ops.c
@@ -171,8 +171,7 @@ void pm_clk_init(struct device *dev)
  */
 int pm_clk_create(struct device *dev)
 {
-	int ret = dev_pm_get_subsys_data(dev);
-	return ret < 0 ? ret : 0;
+	return dev_pm_get_subsys_data(dev);
 }
 
 /**
Index: linux/drivers/base/power/common.c
===================================================================
--- linux.orig/drivers/base/power/common.c
+++ linux/drivers/base/power/common.c
@@ -24,7 +24,6 @@
 int dev_pm_get_subsys_data(struct device *dev)
 {
 	struct pm_subsys_data *psd;
-	int ret = 0;
 
 	psd = kzalloc(sizeof(*psd), GFP_KERNEL);
 	if (!psd)
@@ -40,7 +39,6 @@ int dev_pm_get_subsys_data(struct device
 		dev->power.subsys_data = psd;
 		pm_clk_init(dev);
 		psd = NULL;
-		ret = 1;
 	}
 
 	spin_unlock_irq(&dev->power.lock);
@@ -48,7 +46,7 @@ int dev_pm_get_subsys_data(struct device
 	/* kfree() verifies that its argument is nonzero. */
 	kfree(psd);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dev_pm_get_subsys_data);
 
