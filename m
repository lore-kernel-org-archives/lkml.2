Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2GMFWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:22:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51475 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2GMFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:26 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 1/8] ntp: Fix STA_INS/DEL clearing bug
Date: Fri, 13 Jul 2012 01:21:50 -0400
Message-Id: <1342156917-25092-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-7282-0000-0000-00000AE1D554
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

In commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d, I
introduced a bug that kept the STA_INS or STA_DEL bit
from being cleared from time_status via adjtimex()
without forcing STA_PLL first.

Usually once the STA_INS is set, it isn't cleared
until the leap second is applied, so its unlikely this
affected anyone. However during testing I noticed it
took some effort to cancel a leap second once STA_INS
was set.

This issue affects 3.4 and up.

Since this isn't urgent (issue is only observed in testing,
the behavior doesn't affect ntpd, nor is a leapsecond due
for at least ~6 months), and we're late in the 3.5-rc
cycle, I'm holding this off for 3.6 merge window,
where I'll then backport to 3.5-stable and 3.4-stable.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/ntp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 70b33ab..b7fbadc 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -409,7 +409,9 @@ int second_overflow(unsigned long secs)
 			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (secs % 86400 == 0) {
+		if (!(time_status & STA_INS))
+			time_state = TIME_OK;
+		else if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
 			time_tai++;
@@ -418,7 +420,9 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_DEL:
-		if ((secs + 1) % 86400 == 0) {
+		if (!(time_status & STA_DEL))
+			time_state = TIME_OK;
+		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
 			time_tai--;
 			time_state = TIME_WAIT;
-- 
1.7.9.5

