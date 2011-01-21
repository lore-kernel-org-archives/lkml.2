Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1AUIUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:20:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52164 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1AUIUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:20:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pKIHyPZf4EjI7Kprg1fa8XnUydwMUZkTzLOifrW37WumJLtQgx3SqUqD3ROueSnpha
         p3KzjlncPbVVKQtj2gxb2ITmhCTL/oJVKHXiFv6aMy/03UeZVebP7lwtOwo6r/kBKg1B
         Uv3AGIE5BDAkhV17ar5Ce3HY728aP5Q8vlDqM=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com,
        ddaney@caviumnetworks.com
Subject: [PATCH v4 3/5] MIPS/Perf-events: Fix event check in validate_event()
Date: Fri, 21 Jan 2011 16:19:19 +0800
Message-Id: <1295597961-7565-4-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore events that are in off/error state or belong to a different PMU.

This patch originates from the following commit for ARM by Will Deacon:

- 65b4711ff513767341aa1915c822de6ec0de65cb
    ARM: 6352/1: perf: fix event validation

    The validate_event function in the ARM perf events backend has the
    following problems:

    1.) Events that are disabled count towards the cost.
    2.) Events associated with other PMUs [for example, software events or
        breakpoints] do not count towards the cost, but do fail validation,
        causing the group to fail.

    This patch changes validate_event so that it ignores events in the
    PERF_EVENT_STATE_OFF state or that are scheduled for other PMUs.

Changes:
v4 - v3:
o None
v3 - v2:
o Keep all mentioned commits in the form of number + title + original
summary + (MIPS specific info when needed).
v2 - v1:
o Corrected the return value of the event check in validate_event().

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
index 1ee44a3..3d55761 100644
--- a/arch/mips/kernel/perf_event.c
+++ b/arch/mips/kernel/perf_event.c
@@ -486,8 +486,9 @@ static int validate_event(struct cpu_hw_events *cpuc,
 {
 	struct hw_perf_event fake_hwc = event->hw;
 
-	if (event->pmu && event->pmu != &pmu)
-		return 0;
+	/* Allow mixed event group. So return 1 to pass validation. */
+	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
+		return 1;
 
 	return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
 }
-- 
1.7.1

