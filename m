Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab0HTFWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:22:47 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:54877 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324Ab0HTFWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:22:41 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, npiggin@kernel.dk
Subject: [PATCH 0/2] radix-tree: fix writeback livelock avoidance code
Date: Fri, 20 Aug 2010 15:22:05 +1000
Message-Id: <1282281727-15088-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix bugs in the new radix tree functionality used to
implement the writeback livelock avoidance code. Both bugs manifest themselves
as stray PAGECACHE_TAG_TOWRITE tags in the mapping->page_tree radix tree
resulting in livelocks during tag lookups. More subtly, they also appear to
result in writeback tree walks occasionally terminating early and so not
actually writing all the pages they are supposed to.

Please review and test - these are pretty serious problems for the writeback code.

I've been reproducing the problems with xfstests test 013 using 2.6.36-rc1 and
a bunch of new XFS patches that worked just fine on 2.6.35. The XFS tree that
demonstrates the problem is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git for-oss

and the two patches following this mail make the problem go away. They are also
available in this branch here:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git radix-tree

Dave Chinner (2):
      radix-tree: clear all tags in radix_tree_node_rcu_free
      radix-tree: radix_tree_range_tag_if_tagged() can set incorrect tags

 lib/radix-tree.c |   63 +++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 15 deletions(-)

