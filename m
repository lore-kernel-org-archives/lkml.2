Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2GOH6F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 03:58:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2GOH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 03:57:56 -0400
Date: Sun, 15 Jul 2012 00:57:29 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-6b1859dba01c7d512b72d77e3fd7da8354235189@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, richardcochran@gmail.com,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, a.p.zijlstra@chello.nl, richardcochran@gmail.com,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1342156917-25092-2-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] ntp: Fix STA_INS/DEL clearing bug
Git-Commit-ID: 6b1859dba01c7d512b72d77e3fd7da8354235189
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 00:57:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b1859dba01c7d512b72d77e3fd7da8354235189
Gitweb:     http://git.kernel.org/tip/6b1859dba01c7d512b72d77e3fd7da8354235189
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 13 Jul 2012 01:21:50 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 09:48:49 +0200

ntp: Fix STA_INS/DEL clearing bug

In commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d, I
introduced a bug that kept the STA_INS or STA_DEL bit
from being cleared from time_status via adjtimex()
without forcing STA_PLL first.

Usually once the STA_INS is set, it isn't cleared
until the leap second is applied, so its unlikely this
affected anyone. However during testing I noticed it
took some effort to cancel a leap second once STA_INS
was set.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org # 3.4
Link: http://lkml.kernel.org/r/1342156917-25092-2-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

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
