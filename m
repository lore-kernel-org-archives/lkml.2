Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab0DAW7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:59:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0DAW7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:59:00 -0400
Date: Thu, 1 Apr 2010 22:58:33 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
Cc: dhecht@vmware.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@gmail.com, akataria@vmware.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhecht@vmware.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@gmail.com, akataria@vmware.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <201003112200.o2BM0Hre012875@imap1.linux-foundation.org>
References: <201003112200.o2BM0Hre012875@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hpet: Fix bug in RTC emulation
Message-ID: <tip-b4a5e8a1deca7e61ebaffb37344766b0f0e9f327@git.kernel.org>
Git-Commit-ID: b4a5e8a1deca7e61ebaffb37344766b0f0e9f327
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 22:58:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4a5e8a1deca7e61ebaffb37344766b0f0e9f327
Gitweb:     http://git.kernel.org/tip/b4a5e8a1deca7e61ebaffb37344766b0f0e9f327
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Thu, 11 Mar 2010 14:00:16 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 1 Apr 2010 15:21:48 -0700

x86, hpet: Fix bug in RTC emulation

We think there exists a bug in the HPET code that emulates the RTC.

In the normal case, when the RTC frequency is set, the rtc driver tells
the hpet code about it here:

int hpet_set_periodic_freq(unsigned long freq)
{
        uint64_t clc;

        if (!is_hpet_enabled())
                return 0;

        if (freq <= DEFAULT_RTC_INT_FREQ)
                hpet_pie_limit = DEFAULT_RTC_INT_FREQ / freq;
        else {
                clc = (uint64_t) hpet_clockevent.mult * NSEC_PER_SEC;
                do_div(clc, freq);
                clc >>= hpet_clockevent.shift;
                hpet_pie_delta = (unsigned long) clc;
        }
        return 1;
}

If freq is set to 64Hz (DEFAULT_RTC_INT_FREQ) or lower, then
hpet_pie_limit (a static) is set to non-zero.  Then, on every one-shot
HPET interrupt, hpet_rtc_timer_reinit is called to compute the next
timeout.  Well, that function has this logic:

        if (!(hpet_rtc_flags & RTC_PIE) || hpet_pie_limit)
                delta = hpet_default_delta;
        else
                delta = hpet_pie_delta;

Since hpet_pie_limit is not 0, hpet_default_delta is used.  That
corresponds to 64Hz.

Now, if you set a different rtc frequency, you'll take the else path
through hpet_set_periodic_freq, but unfortunately no one resets
hpet_pie_limit back to 0.

Boom....now you are stuck with 64Hz RTC interrupts forever.

The patch below just resets the hpet_pie_limit value when requested freq
is greater than DEFAULT_RTC_INT_FREQ, which we think fixes this problem.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <201003112200.o2BM0Hre012875@imap1.linux-foundation.org>
Signed-off-by: Daniel Hecht <dhecht@vmware.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/hpet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3d422da..2bda5f0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1149,6 +1149,7 @@ int hpet_set_periodic_freq(unsigned long freq)
 		do_div(clc, freq);
 		clc >>= hpet_clockevent.shift;
 		hpet_pie_delta = clc;
+		hpet_pie_limit = 0;
 	}
 	return 1;
 }
