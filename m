Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab2JAXeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:34:16 -0400
Received: from 1wt.eu ([62.212.114.60]:35134 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab2JAXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:20 -0400
Message-Id: <20121001225204.647398665@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Theodore Tso" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 166/180] drivers/char/random.c: fix boot id uniqueness race
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 44e4360fa3384850d65dd36fb4e6e5f2f112709b upstream.

/proc/sys/kernel/random/boot_id can be read concurrently by userspace
processes.  If two (or more) user-space processes concurrently read
boot_id when sysctl_bootid is not yet assigned, a race can occur making
boot_id differ between the reads.  Because the whole point of the boot id
is to be unique across a kernel execution, fix this by protecting this
operation with a spinlock.

Given that this operation is not frequently used, hitting the spinlock
on each call should not be an issue.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5e106b1..0c38849 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1258,10 +1258,15 @@ static int proc_do_uuid(ctl_table *table, int write,
 	uuid = table->data;
 	if (!uuid) {
 		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
+	} else {
+		static DEFINE_SPINLOCK(bootid_spinlock);
+
+		spin_lock(&bootid_spinlock);
+		if (!uuid[8])
+			generate_random_uuid(uuid);
+		spin_unlock(&bootid_spinlock);
+	}
 
 	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
 		"%02x%02x%02x%02x%02x%02x",
-- 
1.7.2.1.45.g54fbc



