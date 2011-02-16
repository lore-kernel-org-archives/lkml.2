Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab1BPA7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:59:16 -0500
Received: from kroah.org ([198.145.64.141]:46106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348Ab1BPAvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:13 2011
Message-Id: <20110216002113.054438838@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [patch 140/176] md: fix regression resulting in delays in clearing bits in a bitmap
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 6c9879101442b08581e8a0e3ae6b7f643a78fd63 upstream.

commit 589a594be1fb (2.6.37-rc4) fixed a problem were md_thread would
sometimes call the ->run function at a bad time.

If an error is detected during array start up after the md_thread has
been started, the md_thread is killed.  This resulted in the ->run
function being called once.  However the array may not be in a state
that it is safe to call ->run.

However the fix imposed meant that  ->run was not called on a timeout.
This means that when an array goes idle, bitmap bits do not get
cleared promptly.  While the array is busy the bits will still be
cleared when appropriate so this is not very serious.  There is no
risk to data.

Change the test so that we only avoid calling ->run when the thread
is being stopped.  This more explicitly addresses the problem situation.

This is suitable for 2.6.37-stable and any -stable kernel to which
589a594be1fb was applied.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6038,7 +6038,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
-		if (test_and_clear_bit(THREAD_WAKEUP, &thread->flags))
+		clear_bit(THREAD_WAKEUP, &thread->flags);
+		if (!kthread_should_stop())
 			thread->run(thread->mddev);
 	}
 


