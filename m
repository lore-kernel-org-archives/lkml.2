Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2HOUk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:40:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:36321 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2HOTsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 008/165] regset: Prevent null pointer reference on readonly regsets
Date: Wed, 15 Aug 2012 15:45:52 -0400
Message-ID: <1345060109-9187-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c8e252586f8d5de906385d8cf6385fee289a825e upstream.

The regset common infrastructure assumed that regsets would always
have .get and .set methods, but not necessarily .active methods.
Unfortunately people have since written regsets without .set methods.

Rather than putting in stub functions everywhere, handle regsets with
null .get or .set methods explicitly.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/binfmt_elf.c        | 2 +-
 include/linux/regset.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 535e763..c21da8a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1414,7 +1414,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 	for (i = 1; i < view->n; ++i) {
 		const struct user_regset *regset = &view->regsets[i];
 		do_thread_regset_writeback(t->task, regset);
-		if (regset->core_note_type &&
+		if (regset->core_note_type && regset->get &&
 		    (!regset->active || regset->active(t->task, regset))) {
 			int ret;
 			size_t size = regset->n * regset->size;
diff --git a/include/linux/regset.h b/include/linux/regset.h
index 8abee65..5150fd1 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -335,6 +335,9 @@ static inline int copy_regset_to_user(struct task_struct *target,
 {
 	const struct user_regset *regset = &view->regsets[setno];
 
+	if (!regset->get)
+		return -EOPNOTSUPP;
+
 	if (!access_ok(VERIFY_WRITE, data, size))
 		return -EIO;
 
@@ -358,6 +361,9 @@ static inline int copy_regset_from_user(struct task_struct *target,
 {
 	const struct user_regset *regset = &view->regsets[setno];
 
+	if (!regset->set)
+		return -EOPNOTSUPP;
+
 	if (!access_ok(VERIFY_READ, data, size))
 		return -EIO;
 
-- 
1.7.12.rc2

