Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab0J2Mz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:55:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37667 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab0J2Mzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fUBRwLDspQNECKxy5PrfP+14gtMcvfr6IWe9u1WVuaLBqCmgNJAGDzYQBVuppRRPdU
         ypso5an0Uv0scV03YHqbFB73nG4uNorEu3r6dDwO3RuM0hpRs8tnLj1y+U82qbrswEQO
         ELUxxw/U2RVCFmdtY+yVEM+Y7Nl+vaHEj6FLs=
Date: Fri, 29 Oct 2010 15:55:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101029125550.GA3932@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4221a9918e38b7494cee341dda7b7b4bb8c04bde "Add RCU check for 
find_task_by_vpid()" introduced rcu_lockdep_assert to find_task_by_pid_ns.
Assertion failed in sys_ioprio_get. The patch is fixing assertion
failure in ioprio_set as well. 

 ===================================================
 [ INFO: suspicious rcu_dereference_check() usage. ]
 ---------------------------------------------------
 kernel/pid.c:419 invoked rcu_dereference_check() without protection!
 
 rcu_scheduler_active = 1, debug_locks = 0
 1 lock held by iotop/4254:
 #0:  (tasklist_lock){.?.?..}, at: [<ffffffff811104b4>] sys_ioprio_get+0x22/0x2da
 
 stack backtrace:
 Pid: 4254, comm: iotop Not tainted
 Call Trace:
 [<ffffffff810656f2>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff81053c67>] find_task_by_pid_ns+0x4f/0x68
 [<ffffffff81053c9d>] find_task_by_vpid+0x1d/0x1f
 [<ffffffff811104e2>] sys_ioprio_get+0x50/0x2da
 [<ffffffff81002182>] system_call_fastpath+0x16/0x1b
 

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/ioprio.c b/fs/ioprio.c
index 748cfb9..666343d 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -113,8 +113,11 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 		case IOPRIO_WHO_PROCESS:
 			if (!who)
 				p = current;
-			else
+			else {
+				rcu_read_lock();
 				p = find_task_by_vpid(who);
+				rcu_read_unlock();
+			}
 			if (p)
 				ret = set_task_ioprio(p, ioprio);
 			break;
@@ -202,8 +205,11 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 		case IOPRIO_WHO_PROCESS:
 			if (!who)
 				p = current;
-			else
+			else {
+				rcu_read_lock();
 				p = find_task_by_vpid(who);
+				rcu_read_unlock();
+			}
 			if (p)
 				ret = get_task_ioprio(p);
 			break;

