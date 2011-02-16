Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1BPAuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:50:52 -0500
Received: from kroah.org ([198.145.64.141]:46004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933270Ab1BPAum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:11 2011
Message-Id: <20110216002111.543251796@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [patch 125/176] cfq-iosched: Dont wait if queue already has requests.
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Justin TerAvest <teravest@google.com>

commit 02a8f01b5a9f396d0327977af4c232d0f94c45fd upstream.

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
Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3402,6 +3402,10 @@ static bool cfq_should_wait_busy(struct
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
 
+	/* If the queue already has requests, don't wait */
+	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
+		return false;
+
 	/* If there are other queues in the group, don't wait */
 	if (cfqq->cfqg->nr_cfqq > 1)
 		return false;


