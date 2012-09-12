Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2ILQVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:21:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60250 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2ILQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:21:36 -0400
Date: Wed, 12 Sep 2012 09:21:02 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v2] module: report -EFAULT on bytes remaining
Message-ID: <20120912162102.GA16676@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caught by smatch:
kernel/module.c:2450 copy_module_from_user() warn: maybe return -EFAULT instead of the bytes remaining?

Fix the check of copy_from_user() to report -EFAULT as was done before.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Should be applied on top of the finit_module syscall patches.

v2:
 - copy_from_user never returns negative, thanks to Dan Carpenter.
---
 kernel/module.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0ad03c4..461e7d4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2440,9 +2440,10 @@ int copy_module_from_user(const void __user *umod, unsigned long len,
 	if (!info->hdr)
 		return -ENOMEM;
 
-	err = copy_from_user(info->hdr, umod, info->len);
-	if (err)
+	if (copy_from_user(info->hdr, umod, info->len) != 0) {
+		err = -EFAULT;
 		goto free_hdr;
+	}
 
 	err = check_info(info);
 	if (err)
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
