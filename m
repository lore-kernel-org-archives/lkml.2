Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2FTSYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:24:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2FTSYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:02 -0400
Message-Id: <20120620173026.161726264@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 61/61] target: Return error to initiator if SET TARGET PORT GROUPS emulation fails
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_alua.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -351,9 +351,11 @@ int target_emulate_set_target_port_group
 
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


