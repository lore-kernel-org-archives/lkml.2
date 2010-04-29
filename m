Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab0D3QzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:55:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab0D3QzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:07 -0400
Date: Thu, 29 Apr 2010 21:45:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 1/2] workqueues: flush_delayed_work: keep the original
	workqueue for re-queueing
Message-ID: <20100429194516.GB17280@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org> <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com> <20100429194447.GA17280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429194447.GA17280@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_delayed_work() always uses keventd_wq for re-queueing,
but it should use the workqueue this dwork was queued on.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/kernel/workqueue.c~FDW_DONT_USE_KEVENT_WQ	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/kernel/workqueue.c	2010-04-29 21:08:32.000000000 +0200
@@ -774,7 +774,7 @@ void flush_delayed_work(struct delayed_w
 {
 	if (del_timer_sync(&dwork->timer)) {
 		struct cpu_workqueue_struct *cwq;
-		cwq = wq_per_cpu(keventd_wq, get_cpu());
+		cwq = wq_per_cpu(get_wq_data(&dwork->work)->wq, get_cpu());
 		__queue_work(cwq, &dwork->work);
 		put_cpu();
 	}

