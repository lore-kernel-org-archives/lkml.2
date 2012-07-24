Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2GXO4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:56:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2GXO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:56:01 -0400
Date: Tue, 24 Jul 2012 07:55:42 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-b44d50dcacea0d485ca2ff9140f8cc28ee22f28d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
References: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Fix casting issue in tk_set_xtime and tk_xtime_add
Git-Commit-ID: b44d50dcacea0d485ca2ff9140f8cc28ee22f28d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:55:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b44d50dcacea0d485ca2ff9140f8cc28ee22f28d
Gitweb:     http://git.kernel.org/tip/b44d50dcacea0d485ca2ff9140f8cc28ee22f28d
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Mon, 23 Jul 2012 16:22:37 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 24 Jul 2012 16:48:45 +0200

time: Fix casting issue in tk_set_xtime and tk_xtime_add

commit 1e75fa8b (time: Condense timekeeper.xtime into xtime_sec)
introduced helper functions which apply a timespec to the core
internal timekeeper data. The internal storage type is u64. The
timespec tv_nsec value must be shifted before set or added to the
internal value. tv_nsec is a long, which is 32bit on a 32bit system,
so without casting tv_nsec to u64 we lose the bits which are shifted
over the 32bit boundary.

Add the proper typecasts.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1343074957-16541-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5980e90..8f2aba1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -108,13 +108,13 @@ static struct timespec tk_xtime(struct timekeeper *tk)
 static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
-	tk->xtime_nsec = ts->tv_nsec << tk->shift;
+	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
 }
 
 static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
-	tk->xtime_nsec += ts->tv_nsec << tk->shift;
+	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
 }
 
 /**
