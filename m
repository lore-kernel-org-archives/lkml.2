Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1HVVk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:40:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab1HVVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:40:27 -0400
Date: Mon, 22 Aug 2011 14:39:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] vmscan: use atomic-long for shrinker batching
Message-Id: <20110822143954.18c1539c.akpm@linux-foundation.org>
In-Reply-To: <20110822101727.19462.55289.stgit@zurg>
References: <20110822101721.19462.63082.stgit@zurg>
	<20110822101727.19462.55289.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 14:17:27 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Use atomic-long operations instead of looping around cmpxchg().
> 

Seems nice.

> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 790651b..ac6b8ee 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -34,7 +34,7 @@ struct shrinker {
>  
>  	/* These are for internal use */
>  	struct list_head list;
> -	long nr;	/* objs pending delete */
> +	atomic_long_t nr_in_batch; /* objs pending delete */
>  };

This makes shrinker.h have a dependency on atomic.h.  shrinker.h is a
strange thing that doesn't include its own dependent header files - the
shrinker.h includer is responsible for that.  And they both need
fixups, for safety's sake:

 include/linux/fs.h |    2 +-
 include/linux/mm.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~vmscan-use-atomic-long-for-shrinker-batching-fix
+++ a/include/linux/mm.h
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
+#include <linux/atomic.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 #include <linux/range.h>
--- a/include/linux/fs.h~vmscan-use-atomic-long-for-shrinker-batching-fix
+++ a/include/linux/fs.h
@@ -394,8 +394,8 @@ struct inodes_stat_t {
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
 #include <linux/rculist_bl.h>
-#include <linux/shrinker.h>
 #include <linux/atomic.h>
+#include <linux/shrinker.h>
 
 #include <asm/byteorder.h>
 
_

