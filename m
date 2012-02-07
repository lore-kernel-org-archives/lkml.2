Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2BGHzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:55:02 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40289 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2BGHzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:55:00 -0500
Subject: [PATCH 0/4] radix-tree: iterating general cleanup
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 07 Feb 2012 11:54:56 +0400
Message-ID: <20120207074905.29797.60353.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements common radix-tree iteration routine and
reworks page-cache lookup functions with using it.

radix_tree_gang_lookup_*slot() now mostly unused (the last user somethere in
drivers/sh/intc/virq.c), but they are exported, we cannot remove them for now.

Also there some shmem-related radix-tree hacks can be reworked,
radix_tree_locate_item() can be removed. I already have a few extra patches.

And as usual my lovely bloat-o-meter:

add/remove: 4/3 grow/shrink: 4/4 up/down: 1232/-964 (268)
function                                     old     new   delta
radix_tree_next_chunk                          -     499    +499
static.shmem_find_get_pages_and_swap           -     404    +404
find_get_pages_tag                           354     488    +134
find_get_pages                               362     438     +76
find_get_pages_contig                        345     407     +62
__kstrtab_radix_tree_next_chunk                -      22     +22
shmem_truncate_range                        1633    1652     +19
__ksymtab_radix_tree_next_chunk                -      16     +16
radix_tree_gang_lookup_tag_slot              208     180     -28
radix_tree_gang_lookup_tag                   247     207     -40
radix_tree_gang_lookup_slot                  204     162     -42
radix_tree_gang_lookup                       231     160     -71
__lookup                                     217       -    -217
__lookup_tag                                 242       -    -242
shmem_find_get_pages_and_swap                324       -    -324

---

Konstantin Khlebnikov (4):
      bitops: implement "optimized" __find_next_bit()
      radix-tree: introduce bit-optimized iterator
      radix-tree: rewrite gang lookup with using iterator
      radix-tree: use iterators in find_get_pages* functions


 include/asm-generic/bitops/find.h |   36 +++
 include/linux/radix-tree.h        |  129 +++++++++++
 lib/radix-tree.c                  |  422 +++++++++++++------------------------
 mm/filemap.c                      |   75 ++++---
 mm/shmem.c                        |   23 +-
 5 files changed, 375 insertions(+), 310 deletions(-)

-- 
Signature
