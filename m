Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2HSUJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 16:09:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39719 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2HSUJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 16:09:08 -0400
X-Auth-Info: dHQNd5KBPcwgdkOHDm4/L3fET5l2mUtuFIXK75xMU3M=
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] time: Fix casting issue in timekeeping_forward_now
References: <1343074957-16541-1-git-send-email-john.stultz@linaro.org>
X-Yow: Here is my refrigerator full of FLANK STEAK...and over there is my
 UPHOLSTERED CANOE...I don't know WHY I OWN them!!
Date: Sun, 19 Aug 2012 22:09:01 +0200
In-Reply-To: <1343074957-16541-1-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Mon, 23 Jul 2012 16:22:37 -0400")
Message-ID: <m2mx1qlk4i.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_gettimeoffset returns a u32 value which when shifted by tk->shift can
overflow.  Cast it to u64 first.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
Found this by inspection, I don't know if any existing users of
ARCH_USES_GETTIMEOFFSET are affected.  In other words, this is untested,
but looks pretty obvious.

Can tk->shift be bigger than 30?  If so then the shifts in
update_wall_time need to be adjusted as well.

Andreas.

---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e16af19..8776d66 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -276,7 +276,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	tk->xtime_nsec += arch_gettimeoffset() << tk->shift;
+	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 
-- 
1.7.11.5

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
