Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768963Ab2K3TQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:16:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:59358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992899Ab2K3TB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:01:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 16/54] PARISC: fix user-triggerable panic on parisc
Date: Fri, 30 Nov 2012 10:55:47 -0800
Message-Id: <20121130185209.536812235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/signal32.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -65,7 +65,8 @@ put_sigset32(compat_sigset_t __user *up,
 {
 	compat_sigset_t s;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 	sigset_64to32(&s, set);
 
 	return copy_to_user(up, &s, sizeof s);
@@ -77,7 +78,8 @@ get_sigset32(compat_sigset_t __user *up,
 	compat_sigset_t s;
 	int r;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 
 	if ((r = copy_from_user(&s, up, sz)) == 0) {
 		sigset_32to64(set, &s);


