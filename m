Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0FWULy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:11:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53197 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0FWULw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=odyMAnZJR7IJhVjayGwvbuPSuFUY6uhxaaPXkvdmCpopzpEnAF/uzpqC4+SdZ3r5vS
         Ka8gOGXCAug4RwO6vrnSluP7QlMEr00+fITd4ax+RZebeZ0ZItNfjIvbCK796sT/PTIB
         koLX4szx9uK8Ek5foBfV0N0Fd/XWgLR9C3WEk=
Date: Thu, 24 Jun 2010 00:11:48 +0400
From: Ilya Loginov <isloginov@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix problem with reschenduling in rest_init (2.6.35-rc3)
Message-Id: <20100624001148.61e9da1c.isloginov@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There is a bug in rest_init function. The problem is that kernel_init
thread starts before initialization of kthreadd_task when
CONFIG_PREEMPT_VOLUNTARY is enabled.

kernel_init thread do wake_up_process(kthreadd_task) and I have kernel Oops in
try_to_wake_up when I try to get p->state.

	I found this problem on 2.6.34 on FPGA. It is very slow, and
find_task_by_pid is done after reschenduling. I have no this problem on
2.6.35-rc3 because kernel code is moved. But if I write simple loop like
	volatile int tmp;
	for(i = 0; i < preset_lpj; i++)
		tmp++;
right after kernel_thread(kernel_init,.... , I have this problem on
2.6.35-rc3 too.

	I understand that real problem is reschenduling in init code, but
I have no ability to fix it.

Signed-off-by: Ilya Loginov <isloginov@gmail.com>
---
diff --git a/init/main.c b/init/main.c
index 3bdb152..9febd69 100644
--- a/init/main.c
+++ b/init/main.c
@@ -428,12 +428,12 @@ static noinline void __init_refok rest_init(void)
 	int pid;
 
 	rcu_scheduler_starting();
-	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	rcu_read_unlock();
+	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	unlock_kernel();
 
 	/*
