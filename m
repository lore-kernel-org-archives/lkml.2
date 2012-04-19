Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2DSXf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:35:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41177 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2DSXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:35:56 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 19:35:56 EDT
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET] block: fixes for long standing issues
Date: Thu, 19 Apr 2012 16:29:20 -0700
Message-Id: <1334878164-24788-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset fixes two long standing issues and one relatively new
css ref leak.

a. elvpriv alloc failure, including ioc and icq failures, fails
   request allocation.  As those aren't mempool backed and may fail
   indefinitely, this can lead to deadlock under memory pressure.

b. blkgs don't have proper indexing.  With enough number of
   request_queues and blk-throttle enabled, block layer can spend
   considerable amount of cpu cycles walking the same list over and
   over again.

c. __blkg_lookup_create() was leaking a css ref on failure path.

This patchset contains the following four patches.

 0001-block-collapse-blk_alloc_request-into-get_request.patch
 0002-block-fix-elvpriv-allocation-failure-handling.patch
 0003-blkcg-fix-blkcg-css-ref-leak-in-__blkg_lookup_create.patch
 0004-blkcg-use-radix-tree-to-index-blkgs-from-blkcg.patch

0001-0002 fix #a.  0003 fixes #c.  0004 fixes #b.

This patchset is on top of

  block/for-3.5/core 5bc4afb1ec "blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros"
+ [1] [PATCHSET] block: per-queue policy activation, take#2
+ [2] [PATCHSET] block: cosmetic updates to blkcg API

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-misc-fixes

diffstat follows.

 block/blk-cgroup.c |   71 ++++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h |    6 +++
 block/blk-core.c   |   87 ++++++++++++++++++++++++++++-------------------------
 3 files changed, 106 insertions(+), 58 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/4/13/380
[2] http://www.spinics.net/lists/cgroups/msg01748.html
