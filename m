Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1AaRxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:53:21 -0500
Received: from service87.mimecast.com ([94.185.240.25]:50261 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752394Ab1AaRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:53:19 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net
Cc: Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH v2] oprofile: add SMP barriers for hrtimer hotplug code
Date: Mon, 31 Jan 2011 17:53:09 +0000
Message-Id: <1296496389-30647-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 31 Jan 2011 17:53:13.0681 (UTC) FILETIME=[BB393410:01CBC16F]
X-MC-Unique: 111013117531700201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p0VHrSQa003837

OProfile uses a CPU notifier to start and stop any hrtimers when CPUs change
between ONLINE and DEAD. A static int ctr_running is used to keep track of
the counter state.

This can lead to problems where writes to the state variable are re-ordered
with repect to reads of the variable occurring on other CPUs, meaning that
__oprofile_hrtimer_start may read ctr_running as 0 and not initialise the
hrtimer. Potential deadlock can occur in __oprofile_hrtimer_stop because
lock_hrtimer_base will poll until timer->base != NULL, which will never
happen.

This patch adds an smp_mb() before initialising the hrtimers to ensure that
ctr_running mirrors the correct counter state.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

Changes since v1: Removed redundant barrier from stop() code.

 drivers/oprofile/timer_int.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 0107251..a3a94ea 100644
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
-- 
1.7.0.4


