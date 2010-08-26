Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0HZMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:02:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:33998 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab0HZMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:02:19 -0400
From: Dongdong Deng <dongdong.deng@windriver.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, fweisbec@gmail.com
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: fix possible divide-by-zero in perf_swevent_overflow()
Date: Thu, 26 Aug 2010 20:07:18 +0800
Message-Id: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 26 Aug 2010 12:01:48.0322 (UTC) FILETIME=[761A4020:01CB4516]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event->hw.last_period is possible to zero, thus it will
cause divide_by_zero later in perf_swevent_set_period().

This patch checks event->hw.last_period before invoke
perf_swevent_set_period() and replaces "event->hw" with "hwc".

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..ccba741 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4050,8 +4050,8 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 	struct hw_perf_event *hwc = &event->hw;
 	int throttle = 0;
 
-	data->period = event->hw.last_period;
-	if (!overflow)
+	data->period = hwc->last_period;
+	if (!overflow && hwc->last_period)
 		overflow = perf_swevent_set_period(event);
 
 	if (hwc->interrupts == MAX_INTERRUPTS)
-- 
1.6.0.4

