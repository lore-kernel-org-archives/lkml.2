Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab0FCKIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:08:09 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:59617 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab0FCKIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Q8VrvsUjz0t+cPUudCI5/rEKzMQ/OQfcwcX1JlZMnuui9aAdx832E6VqnRy623WYjf
         R4TnJmRX6ofMZ7SEVjz9SbO+kde1qc9SvskHNvHnPfQZFo+4UkntqqgLwBdbjEyK0Dak
         ueKDJBaGfTFlWV8DfXEblvNq9OOHNRer3y/OY=
Date: Thu, 3 Jun 2010 12:07:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Avi Kivity <avi@redhat.com>, Hongjiu Lu <hjl.tools@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] x86: xsave: cleanup return codes in check_for_xstate()
Message-ID: <20100603100746.GU5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
	Avi Kivity <avi@redhat.com>, Hongjiu Lu <hjl.tools@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The places which call check_for_xstate() only care about zero or
non-zero so this patch doesn't change how the code runs, but it's a 
cleanup.  The main reason for this patch is that I'm looking for places
which don't return -EFAULT for copy_from_user() failures.

Signed-off-by: Dan Carpenter <error27@gmail.com>

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
