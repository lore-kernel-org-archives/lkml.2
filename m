Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab1LPXVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:21:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1LPXUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:20:55 -0500
Date: Fri, 16 Dec 2011 15:20:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] mm: compaction: Determine if dirty pages can be
 migrated without blocking within ->migratepage
Message-Id: <20111216152054.f7445e98.akpm@linux-foundation.org>
In-Reply-To: <1323877293-15401-6-git-send-email-mgorman@suse.de>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
	<1323877293-15401-6-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 15:41:27 +0000
Mel Gorman <mgorman@suse.de> wrote:

> Asynchronous compaction is used when allocating transparent hugepages
> to avoid blocking for long periods of time. Due to reports of
> stalling, there was a debate on disabling synchronous compaction
> but this severely impacted allocation success rates. Part of the
> reason was that many dirty pages are skipped in asynchronous compaction
> by the following check;
> 
> 	if (PageDirty(page) && !sync &&
> 		mapping->a_ops->migratepage != migrate_page)
> 			rc = -EBUSY;
> 
> This skips over all mapping aops using buffer_migrate_page()
> even though it is possible to migrate some of these pages without
> blocking. This patch updates the ->migratepage callback with a "sync"
> parameter. It is the responsibility of the callback to fail gracefully
> if migration would block.
> 
> ...
>
> @@ -259,6 +309,19 @@ static int migrate_page_move_mapping(struct address_space *mapping,
>  	}
>  
>  	/*
> +	 * In the async migration case of moving a page with buffers, lock the
> +	 * buffers using trylock before the mapping is moved. If the mapping
> +	 * was moved, we later failed to lock the buffers and could not move
> +	 * the mapping back due to an elevated page count, we would have to
> +	 * block waiting on other references to be dropped.
> +	 */
> +	if (!sync && head && !buffer_migrate_lock_buffers(head, sync)) {

Once it has been established that "sync" is true, I find it clearer to
pass in plain old "true" to buffer_migrate_lock_buffers().  Minor point.



I hadn't paid a lot of attention to buffer_migrate_page() before. 
Scary function.  I'm rather worried about its interactions with ext3
journal commit which locks buffers then plays with them while leaving
the page unlocked.  How vigorously has this been whitebox-tested?

