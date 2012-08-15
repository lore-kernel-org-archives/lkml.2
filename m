Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2HOUWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:22:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:36817 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2HOTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@canonical.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 073/165] USB: pid_ns: ensure pid is not freed during kill_pid_info_as_uid
Date: Wed, 15 Aug 2012 15:46:57 -0400
Message-ID: <1345060109-9187-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit aec01c5895051849ed842dc5b8794017a7751f28 upstream.

Alan Stern points out that after spin_unlock(&ps->lock) there is no
guarantee that ps->pid won't be freed.  Since kill_pid_info_as_uid() is
called after the spin_unlock(), the pid passed to it must be pinned.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/devio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6088192..85a4967 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -409,7 +409,7 @@ static void async_completed(struct urb *urb)
 		sinfo.si_errno = as->status;
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
-		pid = as->pid;
+		pid = get_pid(as->pid);
 		uid = as->uid;
 		euid = as->euid;
 		secid = as->secid;
@@ -424,9 +424,11 @@ static void async_completed(struct urb *urb)
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
1.7.12.rc2

