Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2IIXbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:31:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51216 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889Ab2IIXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:14 -0400
Message-Id: <20120909224201.580292462@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Theodore Tso" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [ 80/95] drivers/char/random.c: fix boot id uniqueness race
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 54ca8b2..4ec04a7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1260,10 +1260,15 @@ static int proc_do_uuid(ctl_table *table, int write,
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
 
 	sprintf(buf, "%pU", uuid);
 


