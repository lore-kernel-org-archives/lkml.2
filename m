Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1CBQg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:36:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1CBQg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:36:57 -0500
Date: Wed, 2 Mar 2011 17:27:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH v3 1/4] exec: introduce get_arg_ptr() helper
Message-ID: <20110302162712.GB26810@redhat.com>
References: <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com> <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com> <20110226174408.GA17442@redhat.com> <20110301204739.GA30406@redhat.com> <AANLkTikVecxcGoZ9a4hmkoi4wynrNfH9_AU7Vb+hOvbH@mail.gmail.com> <20110302162650.GA26810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302162650.GA26810@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce get_arg_ptr() helper, convert count() and copy_strings()
to use it.

No functional changes, preparation. This helper is trivial, it just
reads the pointer from argv/envp user-space array.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- 38/fs/exec.c~1_get_arg_ptr	2011-03-02 15:15:27.000000000 +0100
+++ 38/fs/exec.c	2011-03-02 15:16:44.000000000 +0100
@@ -395,6 +395,17 @@ err:
 	return err;
 }
 
+static const char __user *
+get_arg_ptr(const char __user * const __user *argv, int argc)
+{
+	const char __user *ptr;
+
+	if (get_user(ptr, argv + argc))
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
+			const char __user *p = get_arg_ptr(argv, i);
 
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
+		str = get_arg_ptr(argv, argc);
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

