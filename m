Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab2HVIxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2HVIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:52:47 -0400
Date: Wed, 22 Aug 2012 01:52:04 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-6ea565a9be32a3c8d1092017686f183b6d8c4514@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwab@linux-m68k.org, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        schwab@linux-m68k.org, prarit@redhat.com
In-Reply-To: <1345595449-34965-4-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-4-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Avoid potential shift overflow with large shift values
Git-Commit-ID: 6ea565a9be32a3c8d1092017686f183b6d8c4514
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 01:52:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ea565a9be32a3c8d1092017686f183b6d8c4514
Gitweb:     http://git.kernel.org/tip/6ea565a9be32a3c8d1092017686f183b6d8c4514
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 21 Aug 2012 20:30:48 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Aug 2012 10:42:13 +0200

time: Avoid potential shift overflow with large shift values

Andreas Schwab noticed that the 1 << tk->shift could overflow if the
shift value was greater than 30, since 1 would be a 32bit long on
32bit architectures. This issue was introduced by 1e75fa8be (time:
Condense timekeeper.xtime into xtime_sec)

Use 1ULL instead to ensure we don't overflow on the shift.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1345595449-34965-4-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1dbf80e..a5a9389 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1184,9 +1184,9 @@ static void update_wall_time(void)
 	* the vsyscall implementations are converted to use xtime_nsec
 	* (shifted nanoseconds), this can be killed.
 	*/
-	remainder = tk->xtime_nsec & ((1 << tk->shift) - 1);
+	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
 	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1 << tk->shift;
+	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
 
 	/*
