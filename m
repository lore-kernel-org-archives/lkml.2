Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0D1AHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:07:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40505 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab0D1AHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:07:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Apr 2010 09:03:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs when
 page tables are being moved after the VMA has already moved
Message-Id: <20100428090302.5e69721f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	<1272403852-10479-4-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 22:30:52 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> During exec(), a temporary stack is setup and moved later to its final
> location. There is a race between migration and exec whereby a migration
> PTE can be placed in the temporary stack. When this VMA is moved under the
> lock, migration no longer knows where the PTE is, fails to remove the PTE
> and the migration PTE gets copied to the new location.  This later causes
> a bug when the migration PTE is discovered but the page is not locked.
> 
> This patch handles the situation by removing the migration PTE when page
> tables are being moved in case migration fails to find them. The alternative
> would require significant modification to vma_adjust() and the locks taken
> to ensure a VMA move and page table copy is atomic with respect to migration.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Mel, I don't like this fix. Consider following,

 1. try_to_unmap(oldpage)
 2. copy and replace
 3. remove_migration_ptes(oldpage, newpage)

What this patch handles is "3: remove_migration_ptes fails to remap it and
migration_pte will remain there case....The fact "new page is not mapped" means
"get_page() is not called against the new page".
So, the new page have been able to be freed until we restart move_ptes.

I bet calling __get_user_pages_fast() before vma_adjust() is the way to go. 
When page_count(page) != page_mapcount(page) +1, migration skip it.

Thanks,
-Kame

