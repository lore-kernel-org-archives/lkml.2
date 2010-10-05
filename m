Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0JEV2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:28:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755675Ab0JEV2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:28:20 -0400
Date: Tue, 5 Oct 2010 14:27:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] vmstat: include compaction.h when
 CONFIG_COMPACTION
Message-Id: <20101005142748.37f186da.akpm@linux-foundation.org>
In-Reply-To: <1285818621-29890-13-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
	<1285818621-29890-13-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some of these patches do make the code significantly more complex to
read and follow.  Boy, I hope it's all useful!

On Thu, 30 Sep 2010 12:50:21 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> This removes following warning from sparse:
> 
>  mm/vmstat.c:466:5: warning: symbol 'fragmentation_index' was not declared. Should it be static?
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  mm/vmstat.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 355a9e6..30054ea 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -394,6 +394,8 @@ void zone_statistics(struct zone *preferred_zone, struct zone *z)
>  #endif
>  
>  #ifdef CONFIG_COMPACTION
> +#include <linux/compaction.h>
> +
>  struct contig_page_info {
>  	unsigned long free_pages;
>  	unsigned long free_blocks_total;

This isn't a good idea: there's a good chance that someone will later
add a #include <linux/compaction.h> at the top of the file to support
future changes.  So we end up including it twice.

So I assume the below will work OK??

--- a/mm/vmstat.c~vmstat-include-compactionh-when-config_compaction-fix
+++ a/mm/vmstat.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/math64.h>
 #include <linux/writeback.h>
+#include <linux/compaction.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -395,7 +396,6 @@ void zone_statistics(struct zone *prefer
 #endif
 
 #ifdef CONFIG_COMPACTION
-#include <linux/compaction.h>
 
 struct contig_page_info {
 	unsigned long free_pages;
_

