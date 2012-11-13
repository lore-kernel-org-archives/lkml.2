Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2KMXBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:01:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2KMXBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:01:38 -0500
Date: Tue, 13 Nov 2012 15:01:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xi Wang <xi.wang@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix null dev in dma_pool_create()
In-Reply-To: <50A2BE19.7000604@gmail.com>
Message-ID: <alpine.DEB.2.00.1211131458440.17623@chino.kir.corp.google.com>
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com> <50A2BE19.7000604@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Xi Wang wrote:

> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index c5ab33b..bf7f8f0 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -135,6 +135,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  {
>  	struct dma_pool *retval;
>  	size_t allocation;
> +	int node;
>  
>  	if (align == 0) {
>  		align = 1;
> @@ -159,7 +160,9 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  		return NULL;
>  	}
>  
> -	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
> +	node = WARN_ON(!dev) ? -1 : dev_to_node(dev);
> +
> +	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
>  	if (!retval)
>  		return retval;
>  

Begs the question why we don't just do something like this generically?
---
diff --git a/include/linux/device.h b/include/linux/device.h
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -718,7 +718,7 @@ int dev_set_name(struct device *dev, const char *name, ...);
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-	return dev->numa_node;
+	return WARN_ON(!dev) ? NUMA_NO_NODE : dev->numa_node;
 }
 static inline void set_dev_node(struct device *dev, int node)
 {
