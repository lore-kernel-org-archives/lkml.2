Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1IEVDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 17:03:24 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:40523 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1IEVDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 17:03:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 05 Sep 2011 22:03:15 +0100
From: "J.I. Cameron" <jic23@cam.ac.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] regmap: Remove bitrotted module_put()s
Message-ID: <Prayer.1.3.4.1109052203150.9756@hermes-2.csi.cam.ac.uk>
In-Reply-To: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Prayer v1.3.4
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 5 2011, Mark Brown wrote:

>The conversion to per bus type registration functions means we don't need
>to do module_get()s to hold the bus types in memory (their users will link
>to them) so we removed all those calls. This left module_put() calls in
>the cleanup paths which aren't needed and which cause unbalanced puts if
>we ever try to unload anything.
>
Thanks Mark, all three look good to me.  Thanks also for your comments
on my driver changes, I'll clean it up and repost tomorrow.

>Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
>Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> drivers/base/regmap/regmap.c |    5 +----
> 1 files changed, 1 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
>index fa2bd89..86b1847 100644
>--- a/drivers/base/regmap/regmap.c
>+++ b/drivers/base/regmap/regmap.c
>@@ -198,15 +198,13 @@ struct regmap *regmap_init(struct device *dev,
> 	map->work_buf = kmalloc(map->format.buf_size, GFP_KERNEL);
> 	if (map->work_buf == NULL) {
> 		ret = -ENOMEM;
>-		goto err_bus;
>+		goto err_map;
> 	}
> 
> 	regmap_debugfs_init(map);
> 
> 	return map;
> 
>-err_bus:
>-	module_put(map->bus->owner);
> err_map:
> 	kfree(map);
> err:
>@@ -221,7 +219,6 @@ void regmap_exit(struct regmap *map)
> {
> 	regmap_debugfs_exit(map);
> 	kfree(map->work_buf);
>-	module_put(map->bus->owner);
> 	kfree(map);
> }
> EXPORT_SYMBOL_GPL(regmap_exit);
>
