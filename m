Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1BHTTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:19:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48965 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1BHTTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:19:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=oxABctuiYrOfJ7boCIVzs9nwN6wcqnJqQ8YNxqpTnwL0mvxvUILp6HphbG/lsN7Y/
	4sdqi/2hujPVMQwX/wMQw==
From: Justin TerAvest <teravest@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: ctalbott@google.com, mrubin@google.com, jmoyer@redhat.com,
        guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH] Don't wait if queue already has requests.
Date: Tue,  8 Feb 2011 11:18:17 -0800
Message-Id: <1297192697-29978-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1 added logic to wait for
the last queue of the group to become busy (have at least one request),
so that the group does not lose out for not being continuously
backlogged. The commit did not check for the condition that the last
queue already has some requests. As a result, if the queue already has
requests, wait_busy is set. Later on, cfq_select_queue() checks the
flag, and decides that since the queue has a request now and wait_busy
is set, the queue is expired.  This results in early expiration of the
queue.

This patch fixes the problem by adding a check to see if queue already
has requests. If it does, wait_busy is not set. As a result, time slices
do not expire early.

The queues with more than one request are usually buffered writers.
Testing shows improvement in isolation between buffered writers.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 501ffdf..5dcc353 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3432,6 +3432,10 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
 
+	/* If the queue already has requests, don't wait */
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
+		return false;
+
 	/* If there are other queues in the group, don't wait */
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;
-- 
1.7.3.1

