Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0EZOTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:19:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:60493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0EZOTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:19:17 -0400
Date: Wed, 26 May 2010 14:19:08 GMT
From: tip-bot for Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stf_xl@wp.pl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stf_xl@wp.pl, tglx@linutronix.de
In-Reply-To: <20100525214912.GA1934@r2bh72.net.upc.cz>
References: <20100525214912.GA1934@r2bh72.net.upc.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Avoid double seqlock
Message-ID: <tip-174bd1994ec67a6e6191c4ed8e5dac17fa221b84@git.kernel.org>
Git-Commit-ID: 174bd1994ec67a6e6191c4ed8e5dac17fa221b84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 May 2010 14:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  174bd1994ec67a6e6191c4ed8e5dac17fa221b84
Gitweb:     http://git.kernel.org/tip/174bd1994ec67a6e6191c4ed8e5dac17fa221b84
Author:     Stanislaw Gruszka <stf_xl@wp.pl>
AuthorDate: Tue, 25 May 2010 23:49:12 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 May 2010 16:15:37 +0200

hrtimer: Avoid double seqlock

hrtimer_get_softirq_time() has it's own xtime lock protection, so it's
safe to use plain __current_kernel_time() and avoid the double seqlock
loop.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
LKML-Reference: <20100525214912.GA1934@r2bh72.net.upc.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/hrtimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b9b134b..5c69e99 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -89,7 +89,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xts = current_kernel_time();
+		xts = __current_kernel_time();
 		tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
