Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1ANRcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:32:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:45832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625Ab1ANRc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:32:29 -0500
Date: Fri, 14 Jan 2011 17:32:02 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1295024788-15619-1-git-send-email-johnstul@us.ibm.com>
References: <1295024788-15619-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: tsc: Fix calibration refinement conditionals to avoid divide by zero
Message-ID: <tip-62627bec8a601c5679bf3d20a2096a1206d61b71@git.kernel.org>
Git-Commit-ID: 62627bec8a601c5679bf3d20a2096a1206d61b71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 Jan 2011 17:32:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62627bec8a601c5679bf3d20a2096a1206d61b71
Gitweb:     http://git.kernel.org/tip/62627bec8a601c5679bf3d20a2096a1206d61b71
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 14 Jan 2011 09:06:28 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Jan 2011 18:28:01 +0100

x86: tsc: Fix calibration refinement conditionals to avoid divide by zero

Konrad Wilk reported that the new delayed calibration crashes with a
divide by zero on Xen. The reason is that Xen sets the pmtimer
address, but reading from it returns 0xffffff. That results in the
ref_start and ref_stop value being the same, so the delta is zero
which causes the divide by zero later in the calculation.

The conditional (!hpet && !ref_start && !ref_stop) which sanity checks
the calibration reference values doesn't really make sense. If the
refs are null, but hpet is on, we still want to break out.

The div by zero would be possible to trigger by chance if both reads
from the hardware provided the exact same value (due to hardware
wrapping).

So checking if both the ref values are the same should handle if we
don't have hardware (both null) or if they are the same value (either by
invalid hardware, or by chance), avoiding the div by zero issue.

[ tglx: Applied the same fix to native_calibrate_tsc() where this
  	check was copied from ]

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1295024788-15619-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 463901e..ae09f97 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -464,7 +464,7 @@ unsigned long native_calibrate_tsc(void)
 		tsc_pit_min = min(tsc_pit_min, tsc_pit_khz);
 
 		/* hpet or pmtimer available ? */
-		if (!hpet && !ref1 && !ref2)
+		if (ref1 == ref2)
 			continue;
 
 		/* Check, whether the sampling was disturbed by an SMI */
@@ -935,7 +935,7 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 	tsc_stop = tsc_read_refs(&ref_stop, hpet);
 
 	/* hpet or pmtimer available ? */
-	if (!hpet && !ref_start && !ref_stop)
+	if (ref_start == ref_stop)
 		goto out;
 
 	/* Check, whether the sampling was disturbed by an SMI */
