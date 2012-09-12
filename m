Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2ILPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:06:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab2ILPGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:06:45 -0400
Date: Wed, 12 Sep 2012 08:06:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] module: report -EFAULT on bytes remaining
Message-ID: <20120912150616.GA27343@www.outflux.net>
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

Clean up the copy_from_user() call to not report a positive value.
With this patch, init_module() will report errors from copy_from_user
(before it would always only report -EFAULT when err != 0).

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This change is on top of the finit_module patch series.
---
 kernel/module.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0ad03c4..05b8dde 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2441,8 +2441,11 @@ int copy_module_from_user(const void __user *umod, unsigned long len,
 		return -ENOMEM;
 
 	err = copy_from_user(info->hdr, umod, info->len);
-	if (err)
+	if (err) {
+		if (err > 0)
+			err = -EFAULT;
 		goto free_hdr;
+	}
 
 	err = check_info(info);
 	if (err)
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
