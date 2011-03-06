Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1CFRL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 12:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab1CFRLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 12:11:25 -0500
Date: Sun, 6 Mar 2011 18:02:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v5 1/4] exec: introduce get_user_arg_ptr() helper
Message-ID: <20110306170221.GB24175@redhat.com>
References: <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com> <20110305203040.GA7546@redhat.com> <20110306210334.6CD5.A69D9226@jp.fujitsu.com> <20110306170156.GA24175@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306170156.GA24175@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce get_user_arg_ptr() helper, convert count() and copy_strings()
to use it.

No functional changes, preparation. This helper is trivial, it just
reads the pointer from argv/envp user-space array.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 fs/exec.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- 38/fs/exec.c~1_get_arg_ptr	2011-03-06 17:48:00.000000000 +0100
+++ 38/fs/exec.c	2011-03-06 17:51:01.000000000 +0100
@@ -395,6 +395,17 @@ err:
 	return err;
 }
 
+static const char __user *
+get_user_arg_ptr(const char __user * const __user *argv, int nr)
+{
+	const char __user *ptr;
+
+	if (get_user(ptr, argv + nr))
+		return ERR_PTR(-EFAULT);
+
+	return ptr;
+}
+
 /*
  * count() counts the number of strings in array ARGV.
  */
@@ -404,13 +415,14 @@ static int count(const char __user * con
 
 	if (argv != NULL) {
 		for (;;) {
-			const char __user * p;
+			const char __user *p = get_user_arg_ptr(argv, i);
 
-			if (get_user(p, argv))
-				return -EFAULT;
 			if (!p)
 				break;
-			argv++;
+
+			if (IS_ERR(p))
+				return -EFAULT;
+
 			if (i++ >= max)
 				return -E2BIG;
 
@@ -440,16 +452,18 @@ static int copy_strings(int argc, const 
 		int len;
 		unsigned long pos;
 
-		if (get_user(str, argv+argc) ||
-				!(len = strnlen_user(str, MAX_ARG_STRLEN))) {
-			ret = -EFAULT;
+		ret = -EFAULT;
+		str = get_user_arg_ptr(argv, argc);
+		if (IS_ERR(str))
 			goto out;
-		}
 
-		if (!valid_arg_len(bprm, len)) {
-			ret = -E2BIG;
+		len = strnlen_user(str, MAX_ARG_STRLEN);
+		if (!len)
+			goto out;
+
+		ret = -E2BIG;
+		if (!valid_arg_len(bprm, len))
 			goto out;
-		}
 
 		/* We're going to work our way backwords. */
 		pos = bprm->p;

