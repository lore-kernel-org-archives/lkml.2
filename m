Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2JVBQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:16:17 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:50874 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2JVBQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:16:16 -0400
Message-ID: <50849E39.2040609@ce.jp.nec.com>
Date: Mon, 22 Oct 2012 10:15:37 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] blkcg: stop iteration early if root_rl is the only request
 list
References: <50750367.2070508@ce.jp.nec.com> <20121010155929.GA18733@redhat.com> <50762182.5090806@ce.jp.nec.com> <20121016232040.GH16166@google.com> <507DF58E.8060804@ce.jp.nec.com> <20121017134704.GB31663@redhat.com> <507F6FE2.3030303@ce.jp.nec.com> <20121018133149.GA18147@redhat.com> <20121018212053.GK13370@google.com>
In-Reply-To: <20121018212053.GK13370@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__blk_queue_next_rl() finds next request list based on blkg_list
while skipping root_blkg in the list.
OTOH, root_rl is special as it may exist even without root_blkg.

Though the later part of the function handles such a case correctly,
exiting early is good for readability of the code.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 54f35d1..a31e678 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -333,6 +333,9 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
 	 */
 	if (rl == &q->root_rl) {
 		ent = &q->blkg_list;
+		/* There are no more block groups, hence no request lists */
+		if (list_empty(ent))
+			return NULL;
 	} else {
 		blkg = container_of(rl, struct blkcg_gq, rl);
 		ent = &blkg->q_node;

