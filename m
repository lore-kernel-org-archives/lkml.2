Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2BVRlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:41:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab2BVRlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:41:39 -0500
Date: Wed, 22 Feb 2012 18:34:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] signalfd: signalfd_cleanup() can race with
	remove_wait_queue()
Message-ID: <20120222173442.GC7147@redhat.com>
References: <20120222173326.GA7139@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222173326.GA7139@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signalfd_cleanup() checks waitqueue_active() lockless, this can
race with ep_unregister_pollwait(). We can see list_empty() == T
before remove_wait_queue() completes and list_empty_careful()
can't help. Add spin_unlock_wait() to serialize.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Cc: <stable@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/signalfd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 838ba21..6e51887 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -34,6 +34,10 @@ void signalfd_cleanup(struct sighand_struct *sighand)
 {
 	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
 
+	/* make sure we can't race with remove_wait_queue() in progress */
+	spin_unlock_wait(&wqh->lock);
+	smp_rmb();
+
 	if (likely(!waitqueue_active(wqh)))
 		return;
 
-- 
1.5.5.1


