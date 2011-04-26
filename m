Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1DZFMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:12:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41653 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1DZFMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:12:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read
Cc: kosaki.motohiro@jp.fujitsu.com, bookjovi@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.1104252048190.6978@sister.anvils>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com> <alpine.LSU.2.00.1104252048190.6978@sister.anvils>
Message-Id: <20110426141449.F37C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 14:12:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi High,

> On Sun, 17 Apr 2011, bookjovi@gmail.com wrote:
> > From: Jovi Zhang <bookjovi@gmail.com>
> > 
> > It should be better if put check_mem_permission before __get_free_page
> > in mem_read, to be same as function mem_write.
> > 
> > Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> 
> Sorry to be contrary, but I disagree with this.  I'm all for consistency,
> but is there a particular reason why you think the mem_write ordering is
> right and mem_read wrong?
> 
> My reason for preferring the current mem_read ordering is this:
> 
> check_mem_permission gets a reference to the mm.  If we __get_free_page
> after check_mem_permission, imagine what happens if the system is out
> of memory, and the mm we're looking at is selected for killing by the
> OOM killer: while we wait in __get_free_page for more memory, no memory
> is freed from the selected mm because it cannot reach exit_mmap while
> we hold that reference.

Right.

sorry for that. I missed this point.


> (I may be overstating the case: a little memory may be freed from the
> exiting task's stack, and kswapd should still be able to pick some pages
> off the mm.  But nonetheless, we would do better to let this mm go.)
> 
> No doubt there are plenty of other places in /proc which try to
> allocate memory after taking a reference on an mm; but I think
> we should be working to eliminate those rather than add to them.

then, Should we change mem_write instead?


>From 74f827ce74e1c4f846905e940edfa5f639b5a2ce Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 13:57:02 +0900
Subject: [PATCH] [PATCH] proc: put check_mem_permission after __get_free_page in mem_write

It should be better if put check_mem_permission after __get_free_page
in mem_write, to be same as function mem_read.

Hugh Dickins explained the reason.

    check_mem_permission gets a reference to the mm.  If we __get_free_page
    after check_mem_permission, imagine what happens if the system is out
    of memory, and the mm we're looking at is selected for killing by the
    OOM killer: while we wait in __get_free_page for more memory, no memory
    is freed from the selected mm because it cannot reach exit_mmap while
    we hold that reference.


Reported-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4deef2e..e93be6e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -894,20 +894,20 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	if (!task)
 		goto out_no_task;
 
+	copied = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out_task;
+
 	mm = check_mem_permission(task);
 	copied = PTR_ERR(mm);
 	if (IS_ERR(mm))
-		goto out_task;
+		goto out_free;
 
 	copied = -EIO;
 	if (file->private_data != (void *)((long)current->self_exec_id))
 		goto out_mm;
 
-	copied = -ENOMEM;
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		goto out_mm;
-
 	copied = 0;
 	while (count > 0) {
 		int this_len, retval;
@@ -929,9 +929,11 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 		count -= retval;			
 	}
 	*ppos = dst;
-	free_page((unsigned long) page);
+
 out_mm:
 	mmput(mm);
+out_free:
+	free_page((unsigned long) page);
 out_task:
 	put_task_struct(task);
 out_no_task:
-- 
1.7.3.1



