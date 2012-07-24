Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab2GXSMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab2GXSMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:12:17 -0400
Date: Tue, 24 Jul 2012 14:12:10 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: law@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] posix_types.h: make __NFDBITS match glibc definition
Message-ID: <20120724181209.GA10534@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent glibc made a change to suppress sign-conversion warnings from FD_SET
(glibc commit ceb9e56b3d1).  That patch solved the particular error it was
aiming to, however applications that #include <linux/types.h> after
including <sys/select.h> can now hit a build failure if -Werror=sign-compare
and -D_FORTIFY_SOURCE=2 is passed to gcc.  This can be seen when building
this trivial application against a recent enough glibc:

| #include <sys/select.h>
| #include <linux/types.h>
|
| int main(int argc, char **argv)
| {
|   fd_set fds;
|   FD_ZERO(&fds);
|   FD_SET(0, &fds);
|   return FD_ISSET(0, &fds);
| }

It was suggested the kernel should either match the glibc definition of
__NFDBITS in linux/posix_types.h or remove it entirely.  Given that we
don't know what applications may be relying on the header having a
definition, we opt for the former.

This resolves https://bugzilla.redhat.com/show_bug.cgi?id=837641

Reported-by: Jeff Law <law@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 include/linux/posix_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/posix_types.h b/include/linux/posix_types.h
index f04c98c..cc8530e 100644
--- a/include/linux/posix_types.h
+++ b/include/linux/posix_types.h
@@ -19,7 +19,7 @@
  * use the ones here. 
  */
 #undef __NFDBITS
-#define __NFDBITS	(8 * sizeof(unsigned long))
+#define __NFDBITS	(8 * (int) sizeof(long int))
 
 #undef __FD_SETSIZE
 #define __FD_SETSIZE	1024
-- 
1.7.10.4

