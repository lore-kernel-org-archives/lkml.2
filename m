Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2KVUiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:38:08 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40103 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab2KVTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:14:21 -0500
Message-ID: <1353598680.2449.39.camel@dabdike.int.hansenpartnership.com>
Subject: [GIT PULL] parisc fixes for 3.6-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Nov 2012 15:38:00 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is two bug fixes: one fixes a loophole where rt_sigprocmask() with
the wrong values panics the box (Denial of Service) and the other fixes
an aliasing problem with get_shared_area() which could cause data
corruption.

The patches are here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-fixes

The short changelog is:

Al Viro (1):
      fix user-triggerable panic on parisc

James Bottomley (1):
      fix virtual aliasing issue in get_shared_area()

And the diffstat:

 arch/parisc/kernel/signal32.c   | 6 ++++--
 arch/parisc/kernel/sys_parisc.c | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

Full diff is below.

James

---

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
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 7426e40..f76c108 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -73,6 +73,8 @@ static unsigned long get_shared_area(struct address_space *mapping,
 	struct vm_area_struct *vma;
 	int offset = mapping ? get_offset(mapping) : 0;
 
+	offset = (offset + (pgoff << PAGE_SHIFT)) & 0x3FF000;
+
 	addr = DCACHE_ALIGN(addr - offset) + offset;
 
 	for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {


