Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0IFMqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:46:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:50749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0IFMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:37 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Subject: [PATCHSET] backing-dev: replace private thread pool with workqueue
Date: Mon,  6 Sep 2010 14:46:17 +0200
Message-Id: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset converts backing-dev to use workqueue instead of the
private thread pool.  The conversion is pretty straight forward.  The
only notable thing is that the writeback work skips usual
bdi->work_list processing if it's being executed from the rescuer
thread.  Being executed from the rescuer thread means that the system
is under memory pressure and it just starts writeouts by calling
bdi_flush_io() and reschedules itself if necessary.  This effectly is
the same to what bdi_forker_thread() did when it failed to create a
thread for a pending BDI.

This patch contains the following five patches.

 0001-workqueue-implement-workqueue_on_rescuer.patch
 0002-backing-dev-kill-unused-bdi_writeback-nr.patch
 0003-backing-dev-replace-private-thread-pool-with-workque.patch
 0004-backing-dev-update-trace-points.patch
 0005-backing-dev-replace-sync_supers_tsk-timer-with-a-del.patch

It's currently based on v2.6.36-rc3 + wq#for-linus.  Once Linus pulls
from wq#for-linus, I'll rebase these, but the patches apply on
v2.6.36-rc3 too.  These patches are also available in the following
git tree,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git wq-wb

and contains the following changes.

 fs/fs-writeback.c                |   91 +----------
 include/linux/backing-dev.h      |   18 --
 include/linux/workqueue.h        |    1 
 include/trace/events/writeback.h |    9 -
 kernel/workqueue.c               |   15 +
 mm/backing-dev.c                 |  302 ++++++++++-----------------------------
 6 files changed, 111 insertions(+), 325 deletions(-)

Thanks.

--
tejun
