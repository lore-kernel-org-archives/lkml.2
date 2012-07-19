Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2GSVPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:15:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2GSVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:15:15 -0400
Date: Thu, 19 Jul 2012 14:15:10 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCHSET] kthread_worker: reimplement flush_kthread_work() to
 allow freeing during execution
Message-ID: <20120719211510.GA32763@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

kthread_worker was introduced together with concurrency managed
workqueue to serve workqueue users which need a special dedicated
worker - e.g. RT scheduling.  This is minimal queue / flush / flush
all iterface on top of kthread and each provided interface matches the
workqueue counterpart so that switching isn't difficult.

However, one noticeable difference was that kthread_worker doesn't
allow a work item to be freed while being executed.  The intention was
to keep the code simpler but it didn't really and the restriction is
subtle and does prevent some valid use cases.

This two-patch series reimplements flush_kthread_work() so that it
uses an extra work item for flushing.  While this takes a bit more
lines, this is easier to understand and removes the annoying
difference.

This patchset contains the following two patches.

 0001-kthread_worker-reorganize-to-prepare-for-flush_kthre.patch
 0002-kthread_worker-reimplement-flush_kthread_work-to-all.patch

The first one is a prep patch which makes no functional changes.  The
second reimplements flush_kthread_work().

All current kthread_worker users are cc'd.  If no one objects, I'll
push it through the workqueue branch.  This patchset is also available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-kthread_worker-flush

diffstat follows.  Thanks.

 include/linux/kthread.h |    8 +---
 kernel/kthread.c        |   86 +++++++++++++++++++++++++++---------------------
 2 files changed, 52 insertions(+), 42 deletions(-)

-- 
tejun
