Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab2HVIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:53:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2HVIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:53:33 -0400
Date: Wed, 22 Aug 2012 01:52:59 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-bf2ac312195155511a0f79325515cbb61929898a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1345595449-34965-5-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-5-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time: Avoid making adjustments if we haven'
 t accumulated anything
Git-Commit-ID: bf2ac312195155511a0f79325515cbb61929898a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 01:53:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf2ac312195155511a0f79325515cbb61929898a
Gitweb:     http://git.kernel.org/tip/bf2ac312195155511a0f79325515cbb61929898a
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 21 Aug 2012 20:30:49 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Aug 2012 10:42:13 +0200

time: Avoid making adjustments if we haven't accumulated anything

If update_wall_time() is called and the current offset isn't large
enough to accumulate, avoid re-calling timekeeping_adjust which may
change the clock freq and can cause 1ns inconsistencies with
CLOCK_REALTIME_COARSE/CLOCK_MONOTONIC_COARSE.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1345595449-34965-5-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a5a9389..0c1485e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1152,6 +1152,10 @@ static void update_wall_time(void)
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
+	/* Check if there's really nothing to do */
+	if (offset < tk->cycle_interval)
+		goto out;
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
