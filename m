Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1I1LxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 07:53:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53008 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1I1Lws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 07:52:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: trond.myklebust@netapp.com, smfrench@gmail.com, pavel@ucw.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, john@Calva.COM,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] freezer: make fake_signal_wake_up wake TASK_KILLABLE tasks too
Date: Wed, 28 Sep 2011 07:52:38 -0400
Message-Id: <1317210761-11518-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TASK_KILLABLE is often used to put tasks to sleep for quite some time.
One of the most common uses is to put tasks to sleep while waiting for
replies from a server on a networked filesystem (such as CIFS or NFS).

Unfortunately, fake_signal_wake_up does not currently wake up tasks
that are sleeping in TASK_KILLABLE state. This means that even if the
code were in place to allow them to freeze while in this sleep, it
wouldn't work anyway.

This patch changes this function to wake tasks in this state as well.
This should be harmless -- if the code doing the sleeping doesn't have
handling to deal with freezer events, it should just go back to sleep.
If it does, then this will allow that code to do the right thing.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/freezer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 7b01de9..66a594e 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -67,7 +67,7 @@ static void fake_signal_wake_up(struct task_struct *p)
 	unsigned long flags;
 
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 0);
+	signal_wake_up(p, 1);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 }
 
-- 
1.7.6.2

