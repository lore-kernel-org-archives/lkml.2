Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1IZPSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:18:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1IZPSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:18:44 -0400
Date: Mon, 26 Sep 2011 10:18:29 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <greg@kroah.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        richard@nod.at, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: [PATCH] pid_ns: ensure pid is not freed during kill_pid_info_as_uid
Message-ID: <20110926151829.GA5190@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern points out that after spin_unlock(&ps->lock) there is no
guarantee that ps->pid won't be freed.  Since kill_pid_info_as_uid() is
called after the spin_unlock(), the pid passed to it must be pinned.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 drivers/usb/core/devio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..eea53eb 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -407,7 +407,7 @@ static void async_completed(struct urb *urb)
 		sinfo.si_errno = as->status;
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
-		pid = as->pid;
+		pid = get_pid(as->pid);
 		uid = as->uid;
 		euid = as->euid;
 		secid = as->secid;
@@ -422,9 +422,11 @@ static void async_completed(struct urb *urb)
 		cancel_bulk_urbs(ps, as->bulk_addr);
 	spin_unlock(&ps->lock);
 
-	if (signr)
+	if (signr) {
 		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
 				      euid, secid);
+		put_pid(pid);
+	}
 
 	wake_up(&ps->wait);
 }
-- 
1.7.0.4

