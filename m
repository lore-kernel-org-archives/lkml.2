Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1JRV4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:56:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40284 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754167Ab1JRVys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:54:48 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        Serge Hallyn <serge.hallyn@canonical.com>, linux-usb@vger.kernel.org
Subject: [PATCH 1/9] pid_ns: ensure pid is not freed during kill_pid_info_as_uid
Date: Tue, 18 Oct 2011 21:54:50 +0000
Message-Id: <1318974898-21431-2-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318974898-21431-1-git-send-email-serge@hallyn.com>
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@canonical.com>

[ This is in Greg's USB tree, but not yet in Linus' tree;  it's here
just to give a full context. ]

Alan Stern points out that after spin_unlock(&ps->lock) there is no
guarantee that ps->pid won't be freed.  Since kill_pid_info_as_uid() is
called after the spin_unlock(), the pid passed to it must be pinned.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
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
1.7.5.4

