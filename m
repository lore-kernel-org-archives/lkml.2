Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324Ab2CNUgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:36:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64696 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761219Ab2CNUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:36:01 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: johnstul@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: davej@redhat.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] ntp: Fix integer overflow when setting time
Date: Wed, 14 Mar 2012 18:35:35 -0400
Message-Id: <1331764535-21079-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64bit machines, the difference between 'time_reftime' and current time
is 8 bits, this variable is used as the divisor in div_s64() to calculate
the frequency, but div_s64() assumes the divisor is 32bits.

This means that we are able to trigger a division by zero if the difference
has 0's in it's lower bytes. This way it would skip the sanity checks before
the div_64s() but when it gets to that div it would get truncated and
become 0.

This causes the following error:

[  135.947035] divide error: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  135.947095] CPU 3
[  135.947095] Pid: 28166, comm: trinity Tainted: G        W    3.3.0-rc6-next-20120309-sasha-00001-g10cf0bc-dirty #46
[  135.947095] RIP: 0010:[<ffffffff811066b0>]  [<ffffffff811066b0>] ntp_update_offset+0xb0/0x160
[  135.947095] RSP: 0018:ffff88001baa3e08  EFLAGS: 00010046
[  135.947095] RAX: 007d000000000000 RBX: 0000000001f40000 RCX: 0000000000000000
[  135.947095] RDX: 0000000000000000 RSI: ffffffff83240fd8 RDI: 0000000001f40000
[  135.947095] RBP: ffff88001baa3e18 R08: 0000000000000000 R09: 0000000000000001
[  135.947095] R10: 0000000000000000 R11: 0000000000000000 R12: 0000019800000000
[  135.947095] R13: ffffffff83b7b480 R14: 0000000001154600 R15: ffff88001baa3e78
[  135.947095] FS:  00007f11348c6700(0000) GS:ffff88003e400000(0000) knlGS:0000000000000000
[  135.947095] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.947095] CR2: 0000000001155608 CR3: 00000000050b2000 CR4: 00000000000406e0
[  135.947095] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  135.947095] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  135.947095] Process trinity (pid: 28166, threadinfo ffff88001baa2000, task ffff88001b7cb000)
[  135.947095] Stack:
[  135.947095]  ffff88001baa3e78 00000000ffffffff ffff88001baa3e58 ffffffff81106e19
[  135.947095]  0000000001154600 2c6d37333b315b1b 0000019800000017 0000000001e08c17
[  135.947095]  0000000000000000 fffffffffffffff2 ffff88001baa3e68 ffffffff810d14dc
[  135.947095] Call Trace:
[  135.947095]  [<ffffffff81106e19>] do_adjtimex+0x3c9/0x6d0
[  135.947095]  [<ffffffff810d14dc>] posix_clock_realtime_adj+0xc/0x10
[  135.947095]  [<ffffffff810d29a6>] sys_clock_adjtime+0xc6/0xf0
[  135.947095]  [<ffffffff8270073d>] system_call_fastpath+0x1a/0x1f
[  135.947095] Code: 02 7e 2b 49 81 fc 00 08 00 00 7f 05 83 e1 08 74 1d 80 ce 40 48 89 d8 89 15 6e a9 13 02 48 c1 e0 1e 49 63 cc 48 89 c2 48 c1 fa 3f <48> f7 f9 48 03 05 46 b4 a7 02 48 8b 35 67 a9 13 02 ba 01 00 00
[  135.947095] RIP  [<ffffffff811066b0>] ntp_update_offset+0xb0/0x160
[  135.947095]  RSP <ffff88001baa3e08>
[  135.947095] ---[ end trace f995700f304a6fef ]---

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 17fb1b9..efe894a 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -289,7 +289,7 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 
 	time_status |= STA_MODE;
 
-	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
+	return div64_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)
-- 
1.7.8.4

