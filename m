Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2DMOko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:40:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37729 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2DMOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:40:42 -0400
Date: Fri, 13 Apr 2012 17:35:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Matt Renzelmann <mjr@cs.wisc.edu>
Subject: [RFC] workqueue: do a sanity check on new work
Message-ID: <20120413143524.GA3668@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F8839B4.0113,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be a better way to do this.  If someone tries to call
shedule_work() on a work_struck before doing an INIT_WORK() then we
hit the BUG_ON(!list_empty(&work->entry)) in __queue_work() and hang.
Instead of that, we could just print a stack dump and return.

It only works if the work->func is NULL at the start but a lot of these
things get initialized with kzalloc() so it probably catches most of
them.

Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..45be34f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1088,6 +1088,11 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
+	if (!work->func) {
+		WARN_ON(1);
+		return 1;
+	}
+
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
 		ret = 1;
