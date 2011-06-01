Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490Ab1FAIKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161183Ab1FAIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:09 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:07 2011
Message-Id: <20110601080306.612397116@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:40 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [044/146] jbd: Fix forever sleeping process in do_get_write_access()
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 2842bb20eed2e25cde5114298edc62c8883a1d9a upstream.

In do_get_write_access() we wait on BH_Unshadow bit for buffer to get
from shadow state. The waking code in journal_commit_transaction() has
a bug because it does not issue a memory barrier after the buffer is moved
from the shadow state and before wake_up_bit() is called. Thus a waitqueue
check can happen before the buffer is actually moved from the shadow state
and waiting process may never be woken. Fix the problem by issuing proper
barrier.

Reported-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -722,8 +722,13 @@ wait_for_iobuf:
                    required. */
 		JBUFFER_TRACE(jh, "file as BJ_Forget");
 		journal_file_buffer(jh, commit_transaction, BJ_Forget);
-		/* Wake up any transactions which were waiting for this
-		   IO to complete */
+		/*
+		 * Wake up any transactions which were waiting for this
+		 * IO to complete. The barrier must be here so that changes
+		 * by journal_file_buffer() take effect before wake_up_bit()
+		 * does the waitqueue check.
+		 */
+		smp_mb();
 		wake_up_bit(&bh->b_state, BH_Unshadow);
 		JBUFFER_TRACE(jh, "brelse shadowed buffer");
 		__brelse(bh);


