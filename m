Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0FJAKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:10:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab0FJAKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:10:07 -0400
Date: Thu, 10 Jun 2010 00:09:45 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       error27@gmail.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       error27@gmail.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hpa@linux.intel.com
In-Reply-To: <20100603100746.GU5483@bicker>
References: <20100603100746.GU5483@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, xsave: Cleanup return codes in check_for_xstate()
Message-ID: <tip-d6d4d4205cf4ce4ba13bc320305afbda25303496@git.kernel.org>
Git-Commit-ID: d6d4d4205cf4ce4ba13bc320305afbda25303496
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 00:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6d4d4205cf4ce4ba13bc320305afbda25303496
Gitweb:     http://git.kernel.org/tip/d6d4d4205cf4ce4ba13bc320305afbda25303496
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Thu, 3 Jun 2010 12:07:46 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Jun 2010 15:57:36 -0700

x86, xsave: Cleanup return codes in check_for_xstate()

The places which call check_for_xstate() only care about zero or
non-zero so this patch doesn't change how the code runs, but it's a
cleanup.  The main reason for this patch is that I'm looking for places
which don't return -EFAULT for copy_from_user() failures.

Signed-off-by: Dan Carpenter <error27@gmail.com>
LKML-Reference: <20100603100746.GU5483@bicker>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/xsave.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 37e68fc..9801498 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -36,15 +36,14 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 
 	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
 			       sizeof(struct _fpx_sw_bytes));
-
 	if (err)
-		return err;
+		return -EFAULT;
 
 	/*
 	 * First Magic check failed.
 	 */
 	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
-		return -1;
+		return -EINVAL;
 
 	/*
 	 * Check for error scenarios.
@@ -52,19 +51,21 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	if (fx_sw_user->xstate_size < min_xstate_size ||
 	    fx_sw_user->xstate_size > xstate_size ||
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
-		return -1;
+		return -EINVAL;
 
 	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
 					    fx_sw_user->extended_size -
 					    FP_XSTATE_MAGIC2_SIZE));
+	if (err)
+		return err;
 	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
 	 * fpstate layout with out copying the extended state information
 	 * in the memory layout.
 	 */
-	if (err || magic2 != FP_XSTATE_MAGIC2)
-		return -1;
+	if (magic2 != FP_XSTATE_MAGIC2)
+		return -EFAULT;
 
 	return 0;
 }
