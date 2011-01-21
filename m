Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1AUIUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:20:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52164 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1AUIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N8ePVK8h95hOelUaJjfMr2le4YmokLWdSwZiaTXcl5fBYVLyNO0Pg9qPjn2yfJn6QP
         iqUKJSfREhtIO5HD3t6QMvJwNUoScUwid8VKW7zL4KUzedjj8Ez/OSxwdRXe45fsRPTq
         3+W6p39EIb+dW36DpNnKAxEb0UGN8MhL10iig=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com,
        ddaney@caviumnetworks.com
Subject: [PATCH v4 5/5] MIPS/Perf-events: Use unsigned delta for right shift in event update
Date: Fri, 21 Jan 2011 16:19:21 +0800
Message-Id: <1295597961-7565-6-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
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

Changes:
v4 - v3:
o None
v3 - v2:
o Keep all mentioned commits in the form of number + title + original
summary + (MIPS specific info when needed).
v2 - v1:
o None

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
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

