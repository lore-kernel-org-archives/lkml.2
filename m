Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2JJWqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:46:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2JJWqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:46:38 -0400
Date: Wed, 10 Oct 2012 15:46:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH v2] fix stack memory content leak via UNAME26
Message-Id: <20121010154637.5b201ed7.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJCQ3RxoFJ5FrGo=FJLSApK2PKX0PAt=E8y=PECNn4XWg@mail.gmail.com>
References: <20121009225401.GA10219@www.outflux.net>
	<20121010134646.4e9bba55.akpm@linux-foundation.org>
	<CAGXu5jJCQ3RxoFJ5FrGo=FJLSApK2PKX0PAt=E8y=PECNn4XWg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 15:31:07 -0700
Kees Cook <keescook@chromium.org> wrote:

> > This looks unecessarily complicated.  Is there a reason to be copying
> > all 65 bytes out to userspace?
> >
> > If not, then couldn't we just do
> >
> >         len = scnprintf(...);
> >         ret = copy_to_user(..., len + 1);
> >
> > ?
> 
> As it is, nothing calls override_release with crazy "len" values, but,
> to make the code less fragile, there should be checking for
> sizeof(buf) vs len. In the patch I sent, bounding the sprintf was
> sizeof(buf), and the copy_to_user was bounded by effectively
> min(sizeof(buf), len). If you wanted to use scnprintf, you'd have to
> reorganize the checks and explicitly handle len == 0:
> 
> if (!len)
>     return -EFAULT;
> if (sizeof(buf) < len)
>     len = sizeof(buf)
> len = scnprintf(buf, len, "2.6.%u%s", v, rest);
> ret = copy_to_user(release, buf, len + 1);

It would be pretty absurd for someone to call override_release() with
len==0?  All callers use sizeof() on some pretty well-defined array.

So I'd have thought that something like

--- a/kernel/sys.c~a
+++ a/kernel/sys.c
@@ -1265,7 +1265,7 @@ DECLARE_RWSEM(uts_sem);
  * Work around broken programs that cannot handle "Linux 3.0".
  * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
  */
-static int override_release(char __user *release, int len)
+static int override_release(char __user *release, size_t len)
 {
 	int ret = 0;
 	char buf[65];
@@ -1274,6 +1274,7 @@ static int override_release(char __user 
 		char *rest = UTS_RELEASE;
 		int ndots = 0;
 		unsigned v;
+		size_t copy;
 
 		while (*rest) {
 			if (*rest == '.' && ++ndots >= 3)
@@ -1283,8 +1284,9 @@ static int override_release(char __user 
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		snprintf(buf, len, "2.6.%u%s", v, rest);
-		ret = copy_to_user(release, buf, len);
+		copy = scnprintf(buf, min(len, sizeof(buf)),
+				  "2.6.%u%s", v, rest);
+		ret = copy_to_user(release, buf, copy + 1);
 	}
 	return ret;
 }

would suffice?

Not a big deal I guess, but copying out stuff beyond the NUL is a bit odd.

