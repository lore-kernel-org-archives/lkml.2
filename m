Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0HVOTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 10:19:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52927 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0HVOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 10:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pt9Fxb3seCLRdbU9S3juzk1+Uib40II7UFiidRoAko0nkjxhFeiQD93YVVCvC/pyJX
         89Cby3aTxAyytVYVIhI4efRa/90GzLFsqe4iFGOZBlvrDb2ZFvmK/FNhkKBkqTo20sUm
         YWuOe0vy+pnz1y/Otil7W2VC7TWjBRqjHR2kg=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueue: annotate lock context change
Date: Sun, 22 Aug 2010 23:19:42 +0900
Message-Id: <1282486783-4573-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of internal functions called within gcwq->lock context releases and
regrabs the lock but were missing proper annotations. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/workqueue.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2994a0e..be0b71d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1485,6 +1485,8 @@ static void gcwq_mayday_timeout(unsigned long __gcwq)
  * otherwise.
  */
 static bool maybe_create_worker(struct global_cwq *gcwq)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	if (!need_to_create_worker(gcwq))
 		return false;
@@ -1722,6 +1724,8 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
  * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct global_cwq *gcwq = cwq->gcwq;
@@ -3230,6 +3234,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
  * multiple times.  To be used by cpu_callback.
  */
 static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
+__releases(&gcwq->lock)
+__acquires(&gcwq->lock)
 {
 	if (!(gcwq->trustee_state == state ||
 	      gcwq->trustee_state == TRUSTEE_DONE)) {
-- 
1.7.0.4

