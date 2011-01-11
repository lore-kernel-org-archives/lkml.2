Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1AKPFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:05:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53452 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab1AKPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mY3uwxNNhT1bZS9x+Nm+5Pu7A+BcHqLgsYvTUi7/n1fvQz0FUht8C3VfoWr357vmoW
         9mt0zLXYh72FzRfVwMMsRIaj3igzII/U+6jR+CQgrItU/5mfSW4eeHESbFuvuL7jKHZs
         HFqHKB3iNnzq7l+Vd7kklf09i2MguAZLT6WOk=
Date: Tue, 11 Jan 2011 16:04:55 +0100
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: dhillf@gmail.com, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: note the nested NOT_RUNNING test in
 worker_clr_flags() isn't a noop
Message-ID: <20110111150455.GG30607@htj.dyndns.org>
References: <201101102132.p0ALWmi9012824@imap1.linux-foundation.org>
 <20110111143502.GD30607@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111143502.GD30607@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested NOT_RUNNING test in worker_clr_flags() is slightly
misleading in that if NOT_RUNNING were a single flag the nested test
would be always %true and thus noop.  Add a comment noting that the
test isn't a noop.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Let's avoid similar mistakes in the future.  Thanks.

 kernel/workqueue.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 930c239..11869fa 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -768,7 +768,11 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 
 	worker->flags &= ~flags;
 
-	/* if transitioning out of NOT_RUNNING, increment nr_running */
+	/*
+	 * If transitioning out of NOT_RUNNING, increment nr_running.  Note
+	 * that the nested NOT_RUNNING is not a noop.  NOT_RUNNING is mask
+	 * of multiple flags, not a single flag.
+	 */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
 		if (!(worker->flags & WORKER_NOT_RUNNING))
 			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
-- 
1.7.1

