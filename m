Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab1DGAqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:46:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:32921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab1DGAqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:46:12 -0400
Date: Thu, 7 Apr 2011 00:45:59 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1302106003-366952-1-git-send-email-hans.rosenfeld@amd.com>
References: <1302106003-366952-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, fpu: Fix FPU exception handling on non-SSE systems
Message-ID: <tip-f994d99cf140dbb637e49882891c89b3fd84becd@git.kernel.org>
Git-Commit-ID: f994d99cf140dbb637e49882891c89b3fd84becd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 00:46:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f994d99cf140dbb637e49882891c89b3fd84becd
Gitweb:     http://git.kernel.org/tip/f994d99cf140dbb637e49882891c89b3fd84becd
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Wed, 6 Apr 2011 18:06:43 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 16:53:01 -0700

x86-32, fpu: Fix FPU exception handling on non-SSE systems

On 32bit systems without SSE (that is, they use FSAVE/FRSTOR for FPU
context switches), FPU exceptions in user mode cause Oopses, BUGs,
recursive faults and other nasty things:

fpu exception: 0000 [#1]
last sysfs file: /sys/power/state
Modules linked in: psmouse evdev pcspkr serio_raw [last unloaded: scsi_wait_scan]

Pid: 1638, comm: fxsave-32-excep Not tainted 2.6.35-07798-g58a992b-dirty #633 VP3-596B-DD/VT82C597
EIP: 0060:[<c1003527>] EFLAGS: 00010202 CPU: 0
EIP is at math_error+0x1b4/0x1c8
EAX: 00000003 EBX: cf9be7e0 ECX: 00000000 EDX: cf9c5c00
ESI: cf9d9fb4 EDI: c1372db3 EBP: 00000010 ESP: cf9d9f1c
DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process fxsave-32-excep (pid: 1638, ti=cf9d8000 task=cf9be7e0 task.ti=cf9d8000)
Stack:
00000000 00000301 00000004 00000000 00000000 cf9d3000 cf9da8f0 00000001
<0> 00000004 cf9b6b60 c1019a6b c1019a79 00000020 00000242 000001b6 cf9c5380
<0> cf806b40 cf791880 00000000 00000282 00000282 c108a213 00000020 cf9c5380
Call Trace:
[<c1019a6b>] ? need_resched+0x11/0x1a
[<c1019a79>] ? should_resched+0x5/0x1f
[<c108a213>] ? do_sys_open+0xbd/0xc7
[<c108a213>] ? do_sys_open+0xbd/0xc7
[<c100353b>] ? do_coprocessor_error+0x0/0x11
[<c12d5965>] ? error_code+0x65/0x70
Code: a8 20 74 30 c7 44 24 0c 06 00 03 00 8d 54 24 04 89 d9 b8 08 00 00 00 e8 9b 6d 02 00 eb 16 8b 93 5c 02 00 00 eb 05 e9 04 ff ff ff <9b> dd 32 9b e9 16 ff ff ff 81 c4 84 00 00 00 5b 5e 5f 5d c3 c6
EIP: [<c1003527>] math_error+0x1b4/0x1c8 SS:ESP 0068:cf9d9f1c

This usually continues in slight variations until the system is reset.

This bug was introduced by commit 58a992b9cbaf449aeebd3575c3695a9eb5d95b5e:
	x86-32, fpu: Rewrite fpu_save_init()

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302106003-366952-1-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ef32890..c9e09ea 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -237,7 +237,7 @@ static inline void fpu_save_init(struct fpu *fpu)
 	} else if (use_fxsr()) {
 		fpu_fxsave(fpu);
 	} else {
-		asm volatile("fsave %[fx]; fwait"
+		asm volatile("fnsave %[fx]; fwait"
 			     : [fx] "=m" (fpu->state->fsave));
 		return;
 	}
