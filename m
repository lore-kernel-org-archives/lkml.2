Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab0HJS7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:59:06 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35454 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932507Ab0HJS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:59:04 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] param: allow omitting set() methods for truly read-only params
Date: Tue, 10 Aug 2010 11:58:44 -0700
Message-Id: <1281466725-22549-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain "parameters", such as acpica version and upcoming VMware Balloon
version, are need to be purely read-only. They are exported as
parameters so that they are visible in sysfs even in cases when the
module is built directly into the kernel, but their values should be
immutable. Specifying S_IRUGO takes care of sysfs interface, but it
has no effect on kernel command line or modprobe configuration files and
so these "parameters" attempt to omit set() method. Unfortunately
kernel expects set() to be always present and crashes if it is not
there, so let's add appropriate check.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 kernel/params.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0b30ecd..d0bb910 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -49,7 +49,7 @@ static inline int parameq(const char *input, const char *paramname)
 
 static int parse_one(char *param,
 		     char *val,
-		     struct kernel_param *params, 
+		     struct kernel_param *params,
 		     unsigned num_params,
 		     int (*handle_unknown)(char *param, char *val))
 {
@@ -58,9 +58,9 @@ static int parse_one(char *param,
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {
-			DEBUGP("They are equal!  Calling %p\n",
-			       params[i].set);
-			return params[i].set(val, &params[i]);
+			DEBUGP("They are equal! set() is %p\n", params[i].set);
+			return params[i].set ?
+				params[i].set(val, &params[i]) : -EPERM;
 		}
 	}
 
-- 
1.7.0

