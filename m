Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2HOTu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62947 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2HOTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 082/165] kmod: prevent kmod_loop_msg overflow in __request_module()
Date: Wed, 15 Aug 2012 15:47:06 -0400
Message-ID: <1345060109-9187-83-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 37252db6aa576c34fd794a5a54fb32d7a8b3a07a upstream.

Due to post-increment in condition of kmod_loop_msg in __request_module(),
the system log can be spammed by much more than 5 instances of the 'runaway
loop' message if the number of events triggering it makes the kmod_loop_msg
to overflow.

Fix that by making sure we never increment it past the threshold.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/kmod.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index bf0e231..f50a996 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -106,10 +106,12 @@ int __request_module(bool wait, const char *fmt, ...)
 	atomic_inc(&kmod_concurrent);
 	if (atomic_read(&kmod_concurrent) > max_modprobes) {
 		/* We may be blaming an innocent here, but unlikely */
-		if (kmod_loop_msg++ < 5)
+		if (kmod_loop_msg < 5) {
 			printk(KERN_ERR
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
+			kmod_loop_msg++;
+		}
 		atomic_dec(&kmod_concurrent);
 		return -ENOMEM;
 	}
-- 
1.7.12.rc2

