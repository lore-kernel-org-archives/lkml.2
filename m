Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2LMOiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:38:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab2LMOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 137/241] fix user-triggerable panic on parisc
Date: Thu, 13 Dec 2012 11:58:22 -0200
Message-Id: <1355407206-17100-138-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 441a179dafc0f99fc8b3a8268eef66958621082e upstream.

int sys32_rt_sigprocmask(int how, compat_sigset_t __user *set, compat_sigset_t __user *oset,
                                    unsigned int sigsetsize)
{
        sigset_t old_set, new_set;
        int ret;

        if (set && get_sigset32(set, &new_set, sigsetsize))

...
static int
get_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
{
        compat_sigset_t s;
        int r;

        if (sz != sizeof *set) panic("put_sigset32()");

In other words, rt_sigprocmask(69, (void *)69, 69) done by 32bit process
will promptly panic the box.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/parisc/kernel/signal32.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/signal32.c b/arch/parisc/kernel/signal32.c
index fd49aed..5dede04 100644
--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -65,7 +65,8 @@ put_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
 {
 	compat_sigset_t s;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 	sigset_64to32(&s, set);
 
 	return copy_to_user(up, &s, sizeof s);
@@ -77,7 +78,8 @@ get_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
 	compat_sigset_t s;
 	int r;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 
 	if ((r = copy_from_user(&s, up, sz)) == 0) {
 		sigset_32to64(set, &s);
-- 
1.7.9.5

