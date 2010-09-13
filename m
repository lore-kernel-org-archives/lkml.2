Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0IMVVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392Ab0IMVVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:21:07 -0400
Date: Mon, 13 Sep 2010 14:20:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, david@fromorbit.com, kosaki.motohiro@jp.fujitsu.com,
        npiggin@kernel.dk, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 3/5] writeback: nr_dirtied and nr_written in
 /proc/vmstat
Message-Id: <20100913142017.2a426365.akpm@linux-foundation.org>
In-Reply-To: <1284357493-20078-4-git-send-email-mrubin@google.com>
References: <1284357493-20078-1-git-send-email-mrubin@google.com>
	<1284357493-20078-4-git-send-email-mrubin@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Sep 2010 22:58:11 -0700
Michael Rubin <mrubin@google.com> wrote:

> To help developers and applications gain visibility into writeback
> behaviour adding two entries to vm_stat_items and /proc/vmstat. This
> will allow us to track the "written" and "dirtied" counts.
> 
>    # grep nr_dirtied /proc/vmstat
>    nr_dirtied 3747
>    # grep nr_written /proc/vmstat
>    nr_written 3618
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/mmzone.h |    2 ++
>  mm/page-writeback.c    |    2 ++
>  mm/vmstat.c            |    3 +++
>  3 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6e6e626..d0d7454 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -104,6 +104,8 @@ enum zone_stat_item {
>  	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
>  	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
>  	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
> +	NR_FILE_DIRTIED,	/* accumulated dirty pages */
> +	NR_WRITTEN,		/* accumulated written pages */

I think we can make those comments less ambiguous>

--- a/include/linux/mmzone.h
+++ a/include/linux/mmzone.h
@@ -104,8 +104,8 @@ enum zone_stat_item {
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
-	NR_FILE_DIRTIED,	/* accumulated dirty pages */
-	NR_WRITTEN,		/* accumulated written pages */
+	NR_FILE_DIRTIED,	/* page dirtyings since bootup */
+	NR_WRITTEN,		/* page writings since bootup */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */

>
> ...
>
> index f389168..d448ef4 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -732,6 +732,9 @@ static const char * const vmstat_text[] = {
>  	"nr_isolated_anon",
>  	"nr_isolated_file",
>  	"nr_shmem",
> +	"nr_dirtied",
> +	"nr_written",
> +

The mismatch between "NR_FILE_DIRTIED" and "nr_dirtied" is a bit, umm,
dirty.  I can kinda see the logic in the naming but still..

