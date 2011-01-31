Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1AaPIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:08:37 -0500
Received: from service87.mimecast.com ([94.185.240.25]:49568 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755740Ab1AaPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:08:36 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net
Cc: Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile: add SMP barriers for hrtimer hotplug code
Date: Mon, 31 Jan 2011 15:08:21 +0000
Message-Id: <1296486501-25848-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 31 Jan 2011 15:08:27.0950 (UTC) FILETIME=[B6DE5CE0:01CBC158]
X-MC-Unique: 111013115083100401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0VF8oGs002976

OProfile uses a CPU notifier to start and stop any hrtimers when CPUs change
between ONLINE and DEAD. A static int ctr_running is used to keep track of
the counter state.

This can lead to problems where writes to the state variable are re-ordered
with repect to reads of the variable occurring on other CPUs, meaning that
__oprofile_hrtimer_start may read ctr_running as 0 and not initialise the
hrtimer. Potential deadlock can occur in __oprofile_hrtimer_stop because
lock_hrtimer_base will poll until timer->base != NULL, which will never
happen.

This patch adds smp_mb()s to ensure that ctr_running mirrors the correct
counter state.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/oprofile/timer_int.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 0107251..38c1e1b 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -48,6 +48,7 @@ static int oprofile_hrtimer_start(void)
 {
 	get_online_cpus();
 	ctr_running = 1;
+	smp_mb();
 	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
 	put_online_cpus();
 	return 0;
@@ -70,6 +71,7 @@ static void oprofile_hrtimer_stop(void)
 	get_online_cpus();
 	for_each_online_cpu(cpu)
 		__oprofile_hrtimer_stop(cpu);
+	smp_mb();
 	ctr_running = 0;
 	put_online_cpus();
 }
-- 
1.7.0.4


