Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936648Ab0COTuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936612Ab0COTuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:50:18 -0400
Date: Mon, 15 Mar 2010 20:48:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 5/6] call_usermodehelper: simplify/fix UMH_NO_WAIT case
Message-ID: <20100315194847.GF10896@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__call_usermodehelper(UMH_NO_WAIT) has 2 problems:

	- if kernel_thread() fails, call_usermodehelper_freeinfo()
	  is not called.

	- for unknown reason UMH_NO_WAIT has UMH_WAIT_PROC logic,
	  we spawn yet another thread which waits until the user
	  mode application exits.

Change the UMH_NO_WAIT code to use ____call_usermodehelper() instead of
wait_for_helper(), and do call_usermodehelper_freeinfo() unconditionally.
We can rely on CLONE_VFORK, do_fork(CLONE_VFORK) until the child exits
or execs.

With or without this patch UMH_NO_WAIT does not report the error if
kernel_thread() fails, this is correct since the caller doesn't wait
for result.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- 34-rc1/kernel/kmod.c~5_UMH_NO_WAIT	2010-03-15 20:28:31.000000000 +0100
+++ 34-rc1/kernel/kmod.c	2010-03-15 20:32:23.000000000 +0100
@@ -205,10 +205,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	if (sub_info->wait == UMH_NO_WAIT)
-		call_usermodehelper_freeinfo(sub_info);
-	else
-		complete(sub_info->complete);
+	complete(sub_info->complete);
 	return 0;
 }
 
@@ -217,13 +214,13 @@ static void __call_usermodehelper(struct
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
+	pid_t pid;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
+	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
@@ -232,6 +229,7 @@ static void __call_usermodehelper(struct
 
 	switch (wait) {
 	case UMH_NO_WAIT:
+		call_usermodehelper_freeinfo(sub_info);
 		break;
 
 	case UMH_WAIT_PROC:

