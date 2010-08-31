Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0HaFjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 01:39:53 -0400
Received: from ozlabs.org ([203.10.76.45]:59860 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0HaFjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 01:39:52 -0400
Date: Tue, 31 Aug 2010 15:36:13 +1000
From: Anton Blanchard <anton@samba.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
Message-ID: <20100831053613.GA14848@kryten>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
 <1281374816-904-4-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281374816-904-4-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> +	zram->stats = alloc_percpu(struct zram_stats_cpu);
> +	if (!zram->stats) {
> +		pr_err("Error allocating percpu stats\n");
> +		ret = -ENOMEM;
> +		goto fail;
> +	}

There doesn't seem to be a free_percpu() in the module exit path. Something
like this perhaps?

Anton
--

zram: Free percpu data on module exit.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: powerpc.git/drivers/staging/zram/zram_drv.c
===================================================================
--- powerpc.git.orig/drivers/staging/zram/zram_drv.c	2010-08-31 15:15:59.344290847 +1000
+++ powerpc.git/drivers/staging/zram/zram_drv.c	2010-08-31 15:17:00.383045836 +1000
@@ -483,8 +483,7 @@ void zram_reset_device(struct zram *zram
 	xv_destroy_pool(zram->mem_pool);
 	zram->mem_pool = NULL;
 
-	/* Reset stats */
-	memset(&zram->stats, 0, sizeof(zram->stats));
+	free_percpu(&zram->stats);
 
 	zram->disksize = zram_default_disksize();
 	mutex_unlock(&zram->init_lock);
