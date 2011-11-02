Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab1KCBfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:35:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1KCBfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:55 2011
Message-Id: <20111102221455.696501930@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Serge Hallyn <serge.hallyn@canonical.com>
Subject: [061/107] USB: pid_ns: ensure pid is not freed during kill_pid_info_as_uid
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Serge Hallyn <serge.hallyn@canonical.com>

commit aec01c5895051849ed842dc5b8794017a7751f28 upstream.

Alan Stern points out that after spin_unlock(&ps->lock) there is no
guarantee that ps->pid won't be freed.  Since kill_pid_info_as_uid() is
called after the spin_unlock(), the pid passed to it must be pinned.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -403,7 +403,7 @@ static void async_completed(struct urb *
 		sinfo.si_errno = as->status;
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
-		pid = as->pid;
+		pid = get_pid(as->pid);
 		uid = as->uid;
 		euid = as->euid;
 		secid = as->secid;
@@ -416,9 +416,11 @@ static void async_completed(struct urb *
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


