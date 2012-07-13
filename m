Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2GMRfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab2GMRfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:35:41 -0400
Date: Fri, 13 Jul 2012 13:35:36 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120713173536.GB25432@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be trivially triggered from userspace by passing in something unexpected.

[126749.760961] kernel BUG at fs/locks.c:1468!
[126749.761849] invalid opcode: 0000 [#1] SMP 
[126749.762490] CPU 2 
[126749.811520] Pid: 15891, comm: trinity-child2 Not tainted 3.5.0-rc6+ #105
[126749.813723] RIP: 0010:[<ffffffff81222802>]  [<ffffffff81222802>] generic_setlease+0xc2/0x100
[126749.814823] RSP: 0018:ffff88011a979e88  EFLAGS: 00010286
[126749.815899] RAX: ffffffff81822b40 RBX: ffff8800912e0040 RCX: 0000000000000001
[126749.816970] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8800912e0040
[126749.818037] RBP: ffff88011a979eb8 R08: 0000000000000001 R09: fffffffff7380232
[126749.819098] R10: ffffffff82210560 R11: 0000000000000232 R12: ffff88011c879b80
[126749.820149] R13: ffffffff00000000 R14: ffff88011a979ee0 R15: 00000000000003e8
[126749.821189] FS:  00007fb7d1340740(0000) GS:ffff880148000000(0000) knlGS:0000000000000000
[126749.822222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[126749.823251] CR2: 00000000029a8000 CR3: 0000000119fd0000 CR4: 00000000001407e0
[126749.824278] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[126749.825287] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[126749.826274] Process trinity-child2 (pid: 15891, threadinfo ffff88011a978000, task ffff88000abf2690)
[126749.827260] Stack:
[126749.828225]  ffff88011a979eb8 ffffffff00000000 ffff88011c879b80 ffff8800085326c8
[126749.829202]  ffff880107f85810 00000000000000b1 ffff88011a979ec8 ffffffff81222875
[126749.830168]  ffff88011a979f18 ffffffff81222a06 ffff88011a979f18 ffff8800085326c8
[126749.831123] Call Trace:
[126749.832054]  [<ffffffff81222875>] __vfs_setlease+0x35/0x40
[126749.832979]  [<ffffffff81222a06>] fcntl_setlease+0x76/0x150
[126749.833905]  [<ffffffff811e1876>] sys_fcntl+0x1c6/0x810
[126749.834800]  [<ffffffff8134b4ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[126749.835687]  [<ffffffff81691d2d>] system_call_fastpath+0x1a/0x1f

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/fs/locks.c b/fs/locks.c
index 814c51d..fce6238 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1465,7 +1465,7 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	case F_WRLCK:
 		return generic_add_lease(filp, arg, flp);
 	default:
-		BUG();
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL(generic_setlease);
