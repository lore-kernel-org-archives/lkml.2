Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1KCXJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 19:09:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54012 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1KCXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 19:09:16 -0400
Date: Thu, 3 Nov 2011 16:09:10 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH pm-for-3.2 2/2] freezer: revert 27920651fe "PM / Freezer:
 Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111103230910.GT4417@google.com>
References: <20111103230749.GS4417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103230749.GS4417@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
TASK_KILLABLE tasks too" updated fake_signal_wake_up() used by freezer
to wake up KILLABLE tasks.  Sending unsolicited wakeups to tasks in
killable sleep is dangerous as there are code paths which depend on
tasks not waking up spuriously from KILLABLE sleep.

For example. sys_read() or page can sleep in TASK_KILLABLE assuming
that wait/down/whatever _killable can only fail if we can not return
to the usermode.  TASK_TRACED is another obvious example.

The previous patch updated wait_event_freezekillable() such that it
doesn't depend on the spurious wakeup.  This patch reverts the
offending commit.

Note that the spurious KILLABLE wakeup had other implicit effects in
KILLABLE sleeps in nfs and cifs and those will need further updates to
regain freezekillable behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>
LKML-Reference: <20111031221743.GA18855@google.com>
---
This will cause conflict with the pending linux-next patches but the
resolution should be trivial.  Simply changing @resume from 0 to 1 is
enough.

Thanks.

 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/kernel/freezer.c
===================================================================
--- work.orig/kernel/freezer.c
+++ work/kernel/freezer.c
@@ -67,7 +67,7 @@ static void fake_signal_wake_up(struct t
 	unsigned long flags;
 
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 1);
+	signal_wake_up(p, 0);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 }
 
