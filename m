Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0GBIft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:35:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab0GBIfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=pxJkEMSfepP1zhIxNYQq+DqBfJsVQEOZYkpM+tyFh1xcT/gb3pGfnkrNaUK8r9J9JC
         iFdPPJCzPif+wW4vbCww6Jh8+0ipkeyJfDTyc2lYRQdMzunDKEZaqzHvJIOB3dKZ+yhf
         DYqf5KReu+KKRxkwStaJT3yZ/c+DIO1qG+rKU=
Message-ID: <4C2DA4A5.10107@gmail.com>
Date: Fri, 02 Jul 2010 10:34:45 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH 2/4] workqueue: fix race condition in flush_workqueue()
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <4C2DA42C.7090804@gmail.com>
In-Reply-To: <4C2DA42C.7090804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one flusher is cascading to the next flusher, it first sets
wq->first_flusher to the next one and sets up the next flush cycle.
If there's nothing to do for the next cycle, it clears
wq->flush_flusher and proceeds to the one after that.

If the woken up flusher checks wq->first_flusher before it gets
cleared, it will incorrectly assume the role of the first flusher,
which triggers BUG_ON() sanity check.

Fix it by checking wq->first_flusher again after grabbing the mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5587338..b59c946 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2138,6 +2138,10 @@ void flush_workqueue(struct workqueue_struct *wq)

 	mutex_lock(&wq->flush_mutex);

+	/* we might have raced, check again with mutex held */
+	if (wq->first_flusher != &this_flusher)
+		goto out_unlock;
+
 	wq->first_flusher = NULL;

 	BUG_ON(!list_empty(&this_flusher.list));
-- 
1.6.4.2

