Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1FGNlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:41:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50604 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1FGNlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bgOjXlKwj5TWoa+RebUBUvVdvGwjM5WIClsRm7r6mXycYY2b85Nj9aNdIUeUzUiD+a
         hiIdScaY4XKLmEXUOWndVEhKI6RT3AXZ8hieQXT+lz6WiTJNEhInegWvkUcHhJDEqLGD
         WbcqCSscoxtDMhFVX5NPes5xsz34nQuxBF2aQ=
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 21:41:03 +0800
Message-ID: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
Subject: [PATCH] sched: correct testing need_resched in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is suppose to check the owner task that is not absolutly running on the
local CPU, and if NEED_RESCHED is happenly set on the current task of local
CPU, we get incorrect result.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd18f39..3ea64fe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4326,7 +4326,7 @@ int mutex_spin_on_owner(struct mutex *lock,
struct task_struct *owner)
 		return 0;

 	while (owner_running(lock, owner)) {
-		if (need_resched())
+		if (test_tsk_need_resched(owner))
 			return 0;

 		arch_mutex_cpu_relax();
