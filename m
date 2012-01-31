Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2AaUk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:40:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2AaUk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:40:27 -0500
Date: Tue, 31 Jan 2012 12:40:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>,
        Michal Nazarewicz <mina86@mina86.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: compaction: Check pfn_valid when entering a new
 MAX_ORDER_NR_PAGES block during isolation for migration
Message-Id: <20120131124026.15c0f495.akpm@linux-foundation.org>
In-Reply-To: <20120131163528.GR4065@suse.de>
References: <20120131163528.GR4065@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 16:35:28 +0000
Mel Gorman <mgorman@suse.de> wrote:

> When isolating for migration, migration starts at the start of a zone
> which is not necessarily pageblock aligned. Further, it stops isolating
> when COMPACT_CLUSTER_MAX pages are isolated so migrate_pfn is generally
> not aligned.
> 
> The problem is that pfn_valid is only called on the first PFN being
> checked. Lets say we have a case like this
> 
> H = MAX_ORDER_NR_PAGES boundary
> | = pageblock boundary
> m = cc->migrate_pfn
> f = cc->free_pfn
> o = memory hole
> 
> H------|------H------|----m-Hoooooo|ooooooH-f----|------H
> 
> The migrate_pfn is just below a memory hole and the free scanner is
> beyond the hole. When isolate_migratepages started, it scans from
> migrate_pfn to migrate_pfn+pageblock_nr_pages which is now in a memory
> hole. It checks pfn_valid() on the first PFN but then scans into the
> hole where there are not necessarily valid struct pages.
> 
> This patch ensures that isolate_migratepages calls pfn_valid when
> necessary.
> 
> Reported-and-tested-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

The changelog forgot to describe the user-visible effects of the bug.

> Cc: stable@kernel.org

So he (and others) will be confused.
