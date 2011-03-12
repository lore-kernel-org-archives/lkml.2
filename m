Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1CLUba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 15:31:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:54353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1CLUb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 15:31:29 -0500
Date: Sat, 12 Mar 2011 20:30:50 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, johnstul@us.ibm.com, tglx@linutronix.de,
        richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, johnstul@us.ibm.com, tglx@linutronix.de,
        richard.cochran@omicron.at
In-Reply-To: <1299173174-348-4-git-send-email-torbenh@gmx.de>
References: <1299173174-348-4-git-send-email-torbenh@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-clocks: Check write permissions in posix syscalls
Message-ID: <tip-6e6823d17b157f185be09f4c70181299f9273f0b@git.kernel.org>
Git-Commit-ID: 6e6823d17b157f185be09f4c70181299f9273f0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 20:30:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e6823d17b157f185be09f4c70181299f9273f0b
Gitweb:     http://git.kernel.org/tip/6e6823d17b157f185be09f4c70181299f9273f0b
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 3 Mar 2011 18:26:14 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 12 Mar 2011 21:27:07 +0100

posix-clocks: Check write permissions in posix syscalls

pc_clock_settime() and pc_clock_adjtime() do not check whether the fd
was opened in write mode, so a clock can be set with a read only fd.

[ tglx: We deliberately do not return -EPERM as we want this to be
  	distingushable from the capability based permission check ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
LKML-Reference: <1299173174-348-4-git-send-email-torbenh@gmx.de>
Cc: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/posix-clock.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 04498cb..25028dd 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -287,11 +287,16 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
 	if (err)
 		return err;
 
+	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
+		err = -EACCES;
+		goto out;
+	}
+
 	if (cd.clk->ops.clock_adjtime)
 		err = cd.clk->ops.clock_adjtime(cd.clk, tx);
 	else
 		err = -EOPNOTSUPP;
-
+out:
 	put_clock_desc(&cd);
 
 	return err;
@@ -344,11 +349,16 @@ static int pc_clock_settime(clockid_t id, const struct timespec *ts)
 	if (err)
 		return err;
 
+	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
+		err = -EACCES;
+		goto out;
+	}
+
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else
 		err = -EOPNOTSUPP;
-
+out:
 	put_clock_desc(&cd);
 
 	return err;
