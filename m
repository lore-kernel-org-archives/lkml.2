Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1BRQHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:07:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:48853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab1BRQHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:07:36 -0500
Date: Fri, 18 Feb 2011 16:07:20 GMT
From: tip-bot for Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, tglx@linutronix.de,
        richard.cochran@omicron.at
In-Reply-To: <20110218090724.GA2924@riccoc20.at.omicron.at>
References: <20110218090724.GA2924@riccoc20.at.omicron.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Remove redundant and incorrect parameter check
Message-ID: <tip-db1c1cce4a653dcbe6949c72ae7b9f42cab1b929@git.kernel.org>
Git-Commit-ID: db1c1cce4a653dcbe6949c72ae7b9f42cab1b929
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 16:07:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db1c1cce4a653dcbe6949c72ae7b9f42cab1b929
Gitweb:     http://git.kernel.org/tip/db1c1cce4a653dcbe6949c72ae7b9f42cab1b929
Author:     Richard Cochran <richardcochran@gmail.com>
AuthorDate: Fri, 18 Feb 2011 10:07:25 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Feb 2011 17:01:12 +0100

ntp: Remove redundant and incorrect parameter check

The ADJ_SETOFFSET code redundantly checks the range of the nanoseconds
field of the time value. This field is checked again in the subsequent
call to timekeeping_inject_offset(). Also, as is, the check will not
detect whether the number of microseconds is out of range.

Let timekeeping_inject_offset() do the error checking.
 
Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Cc: johnstul@us.ibm.com
LKML-Reference: <20110218090724.GA2924@riccoc20.at.omicron.at>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/ntp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5ac5932..5f1bb8e 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -650,13 +650,13 @@ int do_adjtimex(struct timex *txc)
 
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec delta;
-		if ((unsigned long)txc->time.tv_usec >= NSEC_PER_SEC)
-			return -EINVAL;
 		delta.tv_sec  = txc->time.tv_sec;
 		delta.tv_nsec = txc->time.tv_usec;
 		if (!(txc->modes & ADJ_NANO))
 			delta.tv_nsec *= 1000;
-		timekeeping_inject_offset(&delta);
+		result = timekeeping_inject_offset(&delta);
+		if (result)
+			return result;
 	}
 
 	getnstimeofday(&ts);
