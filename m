Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3ADEUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 23:20:43 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34043 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3ADEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 23:20:41 -0500
MIME-Version: 1.0
Date: Thu, 3 Jan 2013 23:15:10 -0500
Message-ID: <CAJoZ4U3s=WGne7yaQ9rJTT13-oPTX=M6NW_aOBaVpzvZxLWjHA@mail.gmail.com>
Subject: set_page_dirty_lock + migrate_pages
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an interesting hang on a kernel I am working on. I am working
with an out of tree driver that does get_user_pages and programs an
IOMMU with the physical pages. It also listens for MMU notifier
callbacks so that it may invalidate the IOMMU PTEs. After the
invalidate, it then calls set_page_dirty_lock and page_cache_release.

However, if memory compaction is initiated during a running job,
migrate_pages will try_to_unmap the page. When it gets down to
try_to_unmap_one, the MMU notifier callback will be issued while the
page is locked. Of course, once the MMU notifier callback is executing
the kernel deadlocks as set_page_dirty_lock will never complete. This
appears to be the only location the page is locked when calling
mmu_notifier_invalidate_page.

So, I would love to switch to calling set_page_dirty unconditionally.
I am worried about the mapping changes to the page though. I thought
set_page_dirty_lock is supposed to protect against remappings and
HWPoisoning. I can't distinguish when the page would be locked or not
inside the MMU notifier callback, so I would have to adopt a solution
that can work in both environments. I suppose I could call
TestSetPageLock, and if it fails then schedule a work queue to release
the page, but this would certainly have an impact on migrate pages
(and maybe fork). Also, wouldn't get_user_pages protect against
remappings as we hold a reference count on the page?

As an aside, if the page is anonymous, I don't even need
set_page_dirty_lock at all, right? I could just use set_page_dirty,
no? Could I get page->mapping and test for the PAGE_MAPPING_ANON bit
set? This wouldn't solve my problem, as we support file backed pages,
I am just querying to understand.

Thanks for the help,
-Kyle
