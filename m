Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2JBUab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:30:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30915 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab2JBUaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:30:30 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] proc: don't show nonexistent capabilities
Date: Wed,  3 Oct 2012 00:30:32 +0400
Message-Id: <1349209832-279922-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch it is really hard to interpret a bounding set,
if CAP_LAST_CAP is unknown for a current kernel.

Non-existant capabilities can not be deleted from a bounding set
with help of prctl.

E.g.: Here are two examples without/with this patch.
CapBnd:	ffffffe0fdecffff
CapBnd:	00000000fdecffff

I suggest to hide non-existent capabilities. Here is two reasons.
* It's logically and easier for using.
* It helps to checkpoint-restore capabilities of tasks, because tasks
can be restored on another kernel, where CAP_LAST_CAP is bigger.

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/capability.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index d10b7ed..1642778 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -420,7 +420,8 @@ extern const kernel_cap_t __cap_init_eff_set;
 #else /* HAND-CODED capability initializers */
 
 # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
-# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
+# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, \
+					CAP_TO_MASK(CAP_LAST_CAP + 1) - 1 } })
 # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
 				    | CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
 				    CAP_FS_MASK_B1 } })
-- 
1.7.1

