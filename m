Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2JGJ5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:57:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4487 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2JGJ52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:57:28 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@openvz.org>, "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] proc: don't show nonexistent capabilities (v2)
Date: Sun,  7 Oct 2012 13:56:54 +0400
Message-Id: <1349603814-1085468-1-git-send-email-avagin@openvz.org>
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

v2: Non-existent capabilities can not be removed from creds, because
    in this case user cannot set all=eip. This patch cleans up non-existent
    capabilities from content of /proc/pid/status

Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 fs/proc/array.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c5db89c..c814ba5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -308,6 +308,10 @@ static void render_cap_t(struct seq_file *m, const char *header,
 	seq_putc(m, '\n');
 }
 
+/* Remove non-existent capabilities */
+#define NORM_CAPS(v) (v.cap[CAP_TO_INDEX(CAP_LAST_CAP)] &= \
+				CAP_TO_MASK(CAP_LAST_CAP + 1) - 1)
+
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
 	const struct cred *cred;
@@ -321,6 +325,11 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	cap_bset	= cred->cap_bset;
 	rcu_read_unlock();
 
+	NORM_CAPS(cap_inheritable);
+	NORM_CAPS(cap_permitted);
+	NORM_CAPS(cap_effective);
+	NORM_CAPS(cap_bset);
+
 	render_cap_t(m, "CapInh:\t", &cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &cap_permitted);
 	render_cap_t(m, "CapEff:\t", &cap_effective);
-- 
1.7.1

