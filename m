Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0K2JRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:17:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35839 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab0K2JRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:17:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p9mAD+4AyXr4Ax3+eIUWk8RORYy493g85+h1fzzSyAlosGUvfwj5rK0RKzbI8rSWqH
         cIcbgUL0moAcUhyKzgrjDJBgrERud7uew4kp9oVrLZHmQr2Ga/gh6dRHSt2T7OyGwkpv
         +vw1MRA858NqRdn/huiOUJ1LaeRvem4QFmmZw=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com
Subject: [PATCH v3 5/5] MIPS/Perf-events: Use unsigned delta for right shift in event update
Date: Mon, 29 Nov 2010 17:19:11 +0800
Message-Id: <1291022351-13152-6-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage the commit for ARM by Will Deacon:

- 446a5a8b1eb91a6990e5c8fe29f14e7a95b69132
    ARM: 6205/1: perf: ensure counter delta is treated as unsigned

    Hardware performance counters on ARM are 32-bits wide but atomic64_t
    variables are used to represent counter data in the hw_perf_event structure.

    The armpmu_event_update function right-shifts a signed 64-bit delta variable
    and adds the result to the event count. This can lead to shifting in sign-bits
    if the MSB of the 32-bit counter value is set. This results in perf output
    such as:

     Performance counter stats for 'sleep 20':

     18446744073460670464  cycles             <-- 0xFFFFFFFFF12A6000
            7783773  instructions             #      0.000 IPC
                465  context-switches
                161  page-faults
            1172393  branches

       20.154242147  seconds time elapsed

    This patch ensures that the delta value is treated as unsigned so that the
    right shift sets the upper bits to zero.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 8f7d2f8..a824485 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -169,7 +169,7 @@ static void mipspmu_event_update(struct perf_event *event,
 	unsigned long flags;
 	int shift = 64 - TOTAL_BITS;
 	s64 prev_raw_count, new_raw_count;
-	s64 delta;
+	u64 delta;
 
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
-- 
1.7.1

