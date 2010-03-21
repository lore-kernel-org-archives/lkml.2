Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0CUStb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:49:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab0CUSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:49:29 -0400
Date: Sun, 21 Mar 2010 19:48:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Janak Desai <janak@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] check_unshare_flags: kill the bogus
	CLONE_SIGHAND/sig->count check
Message-ID: <20100321184801.GA29085@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_unshare_flags(CLONE_SIGHAND) adds CLONE_THREAD to *flags_ptr if the
task is multithreaded to ensure unshare_thread() will fail.

Not only this is a bit strange way to return the error, this is absolutely
meaningless. If signal->count > 1 then sighand->count must be also > 1,
and unshare_sighand() will fail anyway.

In fact, all CLONE_THREAD/SIGHAND/VM checks inside sys_unshare() do not
look right. Fortunately this code doesn't really work anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |    8 --------
 1 file changed, 8 deletions(-)

--- 34-rc1/kernel/fork.c~UNSHARE_DONT_USE_SIG_COUNT	2010-03-21 18:37:31.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-21 19:08:06.000000000 +0100
@@ -1519,14 +1519,6 @@ static void check_unshare_flags(unsigned
 		*flags_ptr |= CLONE_SIGHAND;
 
 	/*
-	 * If unsharing signal handlers and the task was created
-	 * using CLONE_THREAD, then must unshare the thread
-	 */
-	if ((*flags_ptr & CLONE_SIGHAND) &&
-	    (atomic_read(&current->signal->count) > 1))
-		*flags_ptr |= CLONE_THREAD;
-
-	/*
 	 * If unsharing namespace, must also unshare filesystem information.
 	 */
 	if (*flags_ptr & CLONE_NEWNS)

