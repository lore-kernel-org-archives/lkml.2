Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2LCOvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:51:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43687 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab2LCOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:11 -0500
Message-Id: <20121203143158.546633036@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 78/89] [PARISC] fix user-triggerable panic on parisc
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


