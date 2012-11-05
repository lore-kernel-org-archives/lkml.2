Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2KEWBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:01:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43306 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab2KEWBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:01:12 -0500
Date: Mon, 5 Nov 2012 14:00:59 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
Message-ID: <20121105220059.GA6379@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not call timekeeping functions unless they are available. If we dump
before they have resumed, avoid a WARN_ON by setting the timestamp to 0.

Since the "ram" pstore driver can be a module, we must have
timekeeping_suspended exported.

Reported-by: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - export needed for timekeeping_suspended (thanks to Fengguang Wu).
---
 fs/pstore/ram.c           |    8 +++++++-
 kernel/time/timekeeping.c |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..6d014e0 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -171,7 +171,13 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 	struct timeval timestamp;
 	size_t len;
 
-	do_gettimeofday(&timestamp);
+	/* Handle dumping before timekeeping has resumed. */
+	if (unlikely(timekeeping_suspended)) {
+		timestamp.tv_sec = 0;
+		timestamp.tv_usec = 0;
+	} else
+		do_gettimeofday(&timestamp);
+
 	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
 		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	WARN_ON_ONCE(!hdr);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e424970..24ea968 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -33,6 +33,7 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
+EXPORT_SYMBOL_GPL(timekeeping_suspended);
 
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
