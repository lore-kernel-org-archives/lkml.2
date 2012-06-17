Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab2FQSfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:35:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50239 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758138Ab2FQSWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:42 -0400
Message-Id: <20120617175949.555437505@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 57/69] target: Return error to initiator if SET TARGET PORT GROUPS
 emulation fails
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 59e4f541baf728dbb426949bfa9f6862387ffd0e upstream.

The error paths in target_emulate_set_target_port_groups() are all
essentially "rc = -EINVAL; goto out;" but the code at "out:" ignores
rc and always returns success.  This means that even if eg explicit
ALUA is turned off, the initiator will always see a good SCSI status
for SET TARGET PORT GROUPS.

Fix this by returning rc as is intended.  It appears this bug was
added by the following patch:

commit 05d1c7c0d0db4cc25548d9aadebb416888a82327
Author: Andy Grover <agrover@redhat.com>
Date:   Wed Jul 20 19:13:28 2011 +0000

    target: Make all control CDBs scatter-gather

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: we have transport_complete_task()
 and not target_complete_cmd()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_alua.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -352,9 +352,11 @@
 
 out:
 	transport_kunmap_data_sg(cmd);
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-	return 0;
+	if (!rc) {
+		task->task_scsi_status = GOOD;
+		transport_complete_task(task, 1);
+	}
+	return rc;
 }
 
 static inline int core_alua_state_nonoptimized(


