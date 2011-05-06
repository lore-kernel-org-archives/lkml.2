Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1EFMwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:52:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43271 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1EFMwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=w9slFvbA879BGoTFW5AMYIi5Aj9tFitQMyCLki4kQmbqjmQyvZkFVfNrhhFZDdzQK1
         s1EZolAlHGBoGSjF5UncFFpQvea3Of7ytuISAYfd6RdBB3eguVUp749H96D5y0iTfHY6
         zTxYOLMZgp9i4VXFSdA62vAA3RwkzUR93vmi0=
MIME-Version: 1.0
Date: Fri, 6 May 2011 20:52:15 +0800
Message-ID: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
Subject: [PATCH] sched: shorten setting the allowed cpu mask of task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting the allowed cpu mask for a given task, if the task is
already bound to certain cpu, after checking the validity of the new
mask of allowed cpus, job is done, and no further efforts needed for
the valid case as well.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched.c	2011-05-06 20:39:58.000000000 +0800
@@ -5899,9 +5899,9 @@ again:
 		goto out;
 	}

-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
-		ret = -EINVAL;
+	if ((p->flags & PF_THREAD_BOUND) && p != current) {
+		if (!cpumask_equal(&p->cpus_allowed, new_mask))
+			ret = -EINVAL;
 		goto out;
 	}
