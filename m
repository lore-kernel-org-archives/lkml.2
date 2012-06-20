Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2FTVH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:07:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2FTVH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:07:27 -0400
Date: Wed, 20 Jun 2012 14:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [Resend with ACK][PATCH] memory hotplug: fix invalid memory
 access caused by stale kswapd pointer
Message-Id: <20120620140723.5c2214de.akpm@linux-foundation.org>
In-Reply-To: <1340184113-5028-1-git-send-email-jiang.liu@huawei.com>
References: <1340184113-5028-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 17:21:53 +0800
Jiang Liu <jiang.liu@huawei.com> wrote:

> Function kswapd_stop() will be called to destroy the kswapd work thread
> when all memory of a NUMA node has been offlined. But kswapd_stop() only
> terminates the work thread without resetting NODE_DATA(nid)->kswapd to NULL.
> The stale pointer will prevent kswapd_run() from creating a new work thread
> when adding memory to the memory-less NUMA node again. Eventually the stale
> pointer may cause invalid memory access.

whoops.

>
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2961,8 +2961,10 @@ void kswapd_stop(int nid)
>  {
>  	struct task_struct *kswapd = NODE_DATA(nid)->kswapd;
>  
> -	if (kswapd)
> +	if (kswapd) {
>  		kthread_stop(kswapd);
> +		NODE_DATA(nid)->kswapd = NULL;
> +	}
>  }
>  
>  static int __init kswapd_init(void)

OK.

This function is full of races (ones which we'll never hit ;)) unless
the caller provides locking.  It appears that lock_memory_hotplug() is
the locking, so I propose this addition:

--- a/mm/vmscan.c~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/mm/vmscan.c
@@ -2955,7 +2955,8 @@ int kswapd_run(int nid)
 }
 
 /*
- * Called by memory hotplug when all memory in a node is offlined.
+ * Called by memory hotplug when all memory in a node is offlined.  Caller must
+ * hold lock_memory_hotplug().
  */
 void kswapd_stop(int nid)
 {
--- a/include/linux/mmzone.h~memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix
+++ a/include/linux/mmzone.h
@@ -693,7 +693,7 @@ typedef struct pglist_data {
 					     range, including holes */
 	int node_id;
 	wait_queue_head_t kswapd_wait;
-	struct task_struct *kswapd;
+	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 } pg_data_t;
_


Also, I think kswapd_lock() and perhaps pglist_data.kswapd itself could
be placed under CONFIG_MEMORY_HOTPLUG to save a bit of space.

