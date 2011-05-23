Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1EWMfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:35:15 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:42561
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab1EWMfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:35:13 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz179dN168aJ1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLNEYG-01-06A-02
X-M-MSG: 
Date: Mon, 23 May 2011 14:35:08 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3] dma-debug: print some unfreed allocations
Message-ID: <20110523123508.GC27867@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
 <20110516110029.GC31309@amd.com>
 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
 <20110519081931.GM31309@amd.com>
 <1305909418.4640.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305909418.4640.13.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:36:58PM -0400, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>  #define NAME_MAX_LEN	64
> @@ -641,6 +647,14 @@ static int dma_debug_fs_init(void)
>  	if (!filter_dent)
>  		goto out_err;
>  
> +#ifdef CONFIG_STACKTRACE
> +	num_show_pending_dent = debugfs_create_u32("num_show_pending", 0644,
> +						   dma_debug_dent,
> +						   &num_show_pending);
> +	if (!num_show_pending_dent)
> +		goto out_err;
> +#endif

Hmm, thinking more about this, do we need to introduce a new variable at
all? It should fit well into the dma-api/all_errors and
dma-api/num_errors configurables. 

> +#ifdef CONFIG_STACKTRACE
> +	if (count > 1 && num_show_pending > 0) {
> +		count = 0;
> +		/*
> +		 * If we have, print out some stack traces for the allocations.
> +		 * In case of module unload, the stack traces will be useless,
> +		 * but instead of unloading the module you can manually unbind
> +		 * the driver instead and get useful traces.
> +		 */
> +		printk(KERN_WARNING "Showing traces for %d allocations:\n",
> +		       num_show_pending);
> +
> +		for (i = 0; i < HASH_SIZE; ++i) {
> +			spin_lock(&dma_entry_hash[i].lock);
> +			list_for_each_entry(entry, &dma_entry_hash[i].list,
> +					    list) {
> +				if (entry->dev != dev)
> +					continue;
> +				count += 1;
> +				if (count > num_show_pending)
> +					break;
> +				dump_entry_trace(entry);
> +			}
> +			spin_unlock(&dma_entry_hash[i].lock);
> +
> +			if (count > num_show_pending)
> +				break;
> +		}
> +	}
> +#endif

This duplicates the loop above. The prints can be folded into one loop.
How about doing it this way (patch is only compile-tested):

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index db07bfd..ee21ef0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -187,11 +187,14 @@ static bool driver_filter(struct device *dev)
 	return ret;
 }
 
-#define err_printk(dev, entry, format, arg...) do {			\
+#define err_warn(format, arg...)		WARN(1, format, ## arg)
+#define err_no_warn(format, arg...)		pr_err(format, ## arg)
+
+#define __err_printk(func, dev, entry, format, arg...) do {		\
 		error_count += 1;					\
 		if (driver_filter(dev) &&				\
 		    (show_all_errors || show_num_errors > 0)) {		\
-			WARN(1, "%s %s: " format,			\
+			func("%s %s: " format,				\
 			     dev ? dev_driver_string(dev) : "NULL",	\
 			     dev ? dev_name(dev) : "NULL", ## arg);	\
 			dump_entry_trace(entry);			\
@@ -200,6 +203,12 @@ static bool driver_filter(struct device *dev)
 			show_num_errors -= 1;				\
 	} while (0);
 
+#define err_printk(dev, entry, format, arg...)				\
+	__err_printk(err_warn, dev, entry, format, ## arg)
+
+#define err_printk_no_warn(dev, entry, format, arg...)			\
+	__err_printk(err_no_warn, dev, entry, format, ## arg)
+
 /*
  * Hash related functions
  *
@@ -649,52 +658,38 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
+static void check_device_dma_allocations(struct device *dev)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
-	int count = 0, i;
+	int i;
 
 	local_irq_save(flags);
 
 	for (i = 0; i < HASH_SIZE; ++i) {
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev) {
-				count += 1;
-				*out_entry = entry;
-			}
+			if (entry->dev != dev)
+				continue;
+			err_printk_no_warn(dev, entry,
+				"DMA-API: device driver has pending DMA allocation\n");
 		}
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
 
 	local_irq_restore(flags);
-
-	return count;
 }
 
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct dma_debug_entry *uninitialized_var(entry);
-	int count;
 
 	if (global_disable)
 		return 0;
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		count = device_dma_allocations(dev, &entry);
-		if (count == 0)
-			break;
-		err_printk(dev, entry, "DMA-API: device driver has pending "
-				"DMA allocations while released from device "
-				"[count=%d]\n"
-				"One of leaked entries details: "
-				"[device address=0x%016llx] [size=%llu bytes] "
-				"[mapped with %s] [mapped as %s]\n",
-			count, entry->dev_addr, entry->size,
-			dir2name[entry->direction], type2name[entry->type]);
+		check_device_dma_allocations(dev);
 		break;
 	default:
 		break;

