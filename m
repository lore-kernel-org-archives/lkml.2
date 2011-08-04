Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1HDFUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:20:45 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:58342 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab1HDFUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:20:39 -0400
Message-ID: <4E3A2BFC.3070907@st.com>
Date: Thu, 4 Aug 2011 10:49:56 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
References: <cover.1312190881.git.viresh.kumar@st.com> <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com> <20110803123953.GB23953@n2100.arm.linux.org.uk>
In-Reply-To: <20110803123953.GB23953@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 06:09 PM, Russell King - ARM Linux wrote:
> On Mon, Aug 01, 2011 at 03:07:18PM +0530, Viresh Kumar wrote:
>> Insert notifiers for the runtime PM API. With this the runtime PM layer kicks in
>> to action where used. This will also handle enabling/disabling of interface
>> clock (Code will be added in amba/bus.c by Russell King).
> 
> I don't think this is correct...

Sorry, but i couldn't get this comment completely. Mentioning clock
stuff here is incorrect or mentioning about your code? Or both?
Or something else?

>> +	pm_runtime_resume(&pl08x->adev->dev);
> 
> Shouldn't this be pm_runtime_get_sync() ?

>> +	pm_runtime_suspend(&pl08x->adev->dev);
> 
> And pm_runtime_put() ?

>> +	pm_runtime_suspend(&adev->dev);
> 
> And pm_runtime_put() ?

I have already fixed above in V3.

> Lastly, we may want to make this even tighter to the actual period that
> the DMA is being used, rather than just the period that a driver has
> been allocated a channel.  I'd rather have it done that way now (and
> tested) so that we achieve maximal effect from runtime PM, rather than
> having something which needs to be revisited again.
> 
> IOW, if this is worth doing, then its worth doing properly first time.

Correct. What about this one:

---
 drivers/dma/amba-pl08x.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 3fbaf0e..24353df 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -84,6 +84,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <asm/hardware/pl080.h>
@@ -405,6 +406,7 @@ pl08x_get_phy_channel(struct pl08x_driver_data *pl08x,
 		return NULL;
 	}
 
+	pm_runtime_get_sync(&pl08x->adev->dev);
 	return ch;
 }
 
@@ -418,6 +420,8 @@ static inline void pl08x_put_phy_channel(struct pl08x_driver_data *pl08x,
 	/* Stop the channel and clear its interrupts */
 	pl08x_terminate_phy_chan(pl08x, ch);
 
+	pm_runtime_put(&pl08x->adev->dev);
+
 	/* Mark it as free */
 	ch->serving = NULL;
 	spin_unlock_irqrestore(&ch->lock, flags);
@@ -1855,6 +1859,9 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 		goto out_no_pl08x;
 	}
 
+	pm_runtime_set_active(&adev->dev);
+	pm_runtime_enable(&adev->dev);
+
 	/* Initialize memcpy engine */
 	dma_cap_set(DMA_MEMCPY, pl08x->memcpy.cap_mask);
 	pl08x->memcpy.dev = &adev->dev;
@@ -1993,6 +2000,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
 		 amba_part(adev), amba_rev(adev),
 		 (unsigned long long)adev->res.start, adev->irq[0]);
+
+	pm_runtime_put(&adev->dev);
 	return 0;
 
 out_no_slave_reg:
@@ -2011,6 +2020,9 @@ out_no_ioremap:
 	dma_pool_destroy(pl08x->pool);
 out_no_lli_pool:
 out_no_platdata:
+	pm_runtime_put(&adev->dev);
+	pm_runtime_disable(&adev->dev);
+
 	kfree(pl08x);
 out_no_pl08x:
 	amba_release_regions(adev);


-- 
viresh
