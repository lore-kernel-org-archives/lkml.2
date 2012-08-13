Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2HMWEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58152 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2HMWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Theodore Tso" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [ 19/44] drivers/char/random.c: fix boot id uniqueness race
Date: Mon, 13 Aug 2012 15:02:26 -0700
Message-Id: <20120813220143.832063659@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1260,10 +1260,15 @@ static int proc_do_uuid(ctl_table *table
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
 


