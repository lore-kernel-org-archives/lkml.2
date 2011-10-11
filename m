Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1JKRF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:05:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab1JKRF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:26 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:12 2011
Message-Id: <20111011165712.614913168@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:38 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, Maxim Uvarov <muvarov@gmail.com>
Subject: [28/38] exec: do not call request_module() twice from search_binary_handler()
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 912193521b719fbfc2f16776febf5232fe8ba261 upstream.

Currently, search_binary_handler() tries to load binary loader module
using request_module() if a loader for the requested program is not yet
loaded.  But second attempt of request_module() does not affect the result
of search_binary_handler().

If request_module() triggered recursion, calling request_module() twice
causes 2 to the power of MAX_KMOD_CONCURRENT (= 50) repetitions.  It is
not an infinite loop but is sufficient for users to consider as a hang up.

Therefore, this patch changes not to call request_module() twice, making 1
to the power of MAX_KMOD_CONCURRENT repetitions in case of recursion.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Uvarov <muvarov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 fs/exec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1411,6 +1411,8 @@ int search_binary_handler(struct linux_b
 			    printable(bprm->buf[2]) &&
 			    printable(bprm->buf[3]))
 				break; /* -ENOEXEC */
+			if (try)
+				break; /* -ENOEXEC */
 			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
 		}


