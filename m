Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0CPTkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0CPTkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:40:47 -0400
Date: Tue, 16 Mar 2010 20:39:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 3/4] coredump: factor out put_cred() calls
Message-ID: <20100316193917.GD31632@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com> <20100316193750.GA31632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316193750.GA31632@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that do_coredump() calls put_cred() on exit path, it is a bit ugly
to do put_cred() + "goto fail" twice, just add the new "fail_creds" label.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- 34-rc1/fs/exec.c~3_CREDS	2010-03-16 18:09:13.000000000 +0100
+++ 34-rc1/fs/exec.c	2010-03-16 19:09:50.000000000 +0100
@@ -1859,10 +1859,8 @@ void do_coredump(long signr, int exit_co
 		goto fail;
 
 	cred = prepare_creds();
-	if (!cred) {
-		retval = -ENOMEM;
+	if (!cred)
 		goto fail;
-	}
 
 	down_write(&mm->mmap_sem);
 	/*
@@ -1870,8 +1868,7 @@ void do_coredump(long signr, int exit_co
 	 */
 	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
 		up_write(&mm->mmap_sem);
-		put_cred(cred);
-		goto fail;
+		goto fail_creds;
 	}
 
 	/*
@@ -1886,10 +1883,8 @@ void do_coredump(long signr, int exit_co
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
-	if (retval < 0) {
-		put_cred(cred);
-		goto fail;
-	}
+	if (retval < 0)
+		goto fail_creds;
 
 	old_cred = override_creds(cred);
 
@@ -2006,9 +2001,10 @@ fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	coredump_finish(mm);
 	revert_creds(old_cred);
+fail_creds:
 	put_cred(cred);
-	coredump_finish(mm);
 fail:
 	return;
 }

