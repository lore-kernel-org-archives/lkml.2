Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab0FPXoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:44:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556Ab0FPXo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:44:29 -0400
Date: Wed, 16 Jun 2010 16:43:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 08/12] vmscan: Setup pagevec as late as possible in
 shrink_inactive_list()
Message-Id: <20100616164309.254b1a0d.akpm@linux-foundation.org>
In-Reply-To: <1276514273-27693-9-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-9-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 12:17:49 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> shrink_inactive_list() sets up a pagevec to release unfreeable pages. It
> uses significant amounts of stack doing this. This patch splits
> shrink_inactive_list() to take the stack usage out of the main path so
> that callers to writepage() do not contain an unused pagevec on the
> stack.

You can get the entire pagevec off the stack - just make it a
static-to-shrink_inactive_list() pagevec-per-cpu.

Locking just requires pinning to a CPU.  We could trivially co-opt
shrink_inactive_list()'s spin_lock_irq() for that, but
pagevec_release() can be relatively expensive so it'd be sad to move
that inside spin_lock_irq().  It'd be better to slap a
get_cpu()/put_cpu() around the whole thing.

