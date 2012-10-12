Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2JLFrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:47:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54298 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2JLFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
Date: Fri, 12 Oct 2012 11:17:29 +0530
X-Google-Sender-Auth: 4omjt2BAqZLQIZc7WNXPmQw2uus
Message-ID: <CAOh2x=karuuGbzwACPL8GNL4ivuLypqBj=sGCrJLupBBy52Uwg@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: viresh kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:14 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> dw_dmac driver already supports device tree but it used to have its platform
> data passed the non-DT way.
>
> This patch does following changes:
> - pass platform data via DT, non-DT way still takes precedence if both are used.
> - create generic filter routine
> - Earlier slave information was made available by slave specific filter routines
>   in chan->private field. Now, this information would be passed from within dmac
>   DT node. Slave drivers would now be required to pass bus_id (a string) as
>   parameter to this generic filter(), which would be compared against the slave
>   data passed from DT, by the generic filter routine.
> - Update binding document

DT parsing of this patch can be tested with following non-official patch :)


    dmaengine: dw_dmac: Add dt params debug routine

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 05c1dff..569914d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1504,6 +1504,43 @@ static inline int dw_dma_parse_dt(struct
platform_device *pdev)
 }
 #endif

+static void dw_dma_parse_dt_debug(struct dw_dma_platform_data *pdata)
+{
+       int i = -1;
+
+       if (!pdata) {
+               printk(KERN_ERR "dw_dma: unable to read info from DT\n");
+               return;
+       }
+
+       printk(KERN_ERR "\nPrinting dw_dma DT info\n");
+
+       printk(KERN_ERR "nr_channels: %x\n", pdata->nr_channels);
+       printk(KERN_ERR "is_private: %x\n", pdata->is_private);
+       printk(KERN_ERR "chan_allocation_order: %x\n",
+               pdata->chan_allocation_order);
+
+       printk(KERN_ERR "chan_priority: %x\n", pdata->chan_priority);
+       printk(KERN_ERR "block_size: %x\n", pdata->block_size);
+
+       printk(KERN_ERR "nr_masters: %x\n", pdata->nr_masters);
+       printk(KERN_ERR "data_width: %d %d %d %d\n", pdata->data_width[0],
+               pdata->data_width[1], pdata->data_width[2],
+               pdata->data_width[3]);
+
+       /* parse slave data */
+       printk(KERN_ERR "slave_info\n");
+
+       while (++i < pdata->sd_count) {
+               printk(KERN_INFO "bus_id: %s\n", pdata->sd[i].bus_id);
+               printk(KERN_INFO "cfg_hi: %x\n", pdata->sd[i].cfg_hi);
+               printk(KERN_INFO "cfg_lo: %x\n", pdata->sd[i].cfg_lo);
+               printk(KERN_INFO "src_master: %x\n",
+                               pdata->sd[i].src_master);
+               printk(KERN_INFO "dst_master: %x\n",
+                               pdata->sd[i].dst_master);
+       }
+}
 static int __devinit dw_probe(struct platform_device *pdev)
 {
        struct dw_dma_platform_data *pdata;
@@ -1515,9 +1552,12 @@ static int __devinit dw_probe(struct
platform_device *pdev)
        int                     i;

        pdata = dev_get_platdata(&pdev->dev);
-       if (!pdata)
+       if (!pdata) {
                pdata = dw_dma_parse_dt(pdev);
+               dw_dma_parse_dt_debug(pdata);
+       }
