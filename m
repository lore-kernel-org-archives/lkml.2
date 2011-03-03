Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab1CCR1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:27:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41593 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758311Ab1CCR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:27:28 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19/el1f1i1/UpbDYh5eukpVlJRlK781TeCnAZyl5Y
	evcooofcd80Jc+
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: richard.cochran@omicron.at, johnstul@us.ibm.com, tglx@linutronix.de,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 3/3] Check for write permission on FD based posix-clocks
Date: Thu,  3 Mar 2011 18:26:14 +0100
Message-Id: <1299173174-348-4-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299173174-348-1-git-send-email-torbenh@gmx.de>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pc_clock_settime() and pc_clock_adjtime() did not check
whether the fd was opened in write mode.

It was possible to set a clock, when we only had read
permissions.

for completeness, we would also need to check for Read permissions
on the read operations. but that would be a bit paranoid, probably.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
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
-- 
1.7.2.3

