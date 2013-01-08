Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3AHXvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:51:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53645 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3AHXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 51/77] linux/log2.h: Fix rounddown_pow_of_two(1)
Date: Tue, 8 Jan 2013 18:35:30 -0500
Message-ID: <1357688156-25387-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 13c07b0286d340275f2d97adf085cecda37ede37 upstream.

Exactly like roundup_pow_of_two(1), the rounddown version was buggy for
the case of a compile-time constant '1' argument.  Probably because it
originated from the same code, sharing history with the roundup version
from before the bugfix (for that one, see commit 1a06a52ee1b0: "Fix
roundup_pow_of_two(1)").

However, unlike the roundup version, the fix for rounddown is to just
remove the broken special case entirely.  It's simply not needed - the
generic code

    1UL << ilog2(n)

does the right thing for the constant '1' argment too.  The only reason
roundup needed that special case was because rounding up does so by
subtracting one from the argument (and then adding one to the result)
causing the obvious problems with "ilog2(0)".

But rounddown doesn't do any of that, since ilog2() naturally truncates
(ie "rounds down") to the right rounded down value.  And without the
ilog2(0) case, there's no reason for the special case that had the wrong
value.

tl;dr: rounddown_pow_of_two(1) should be 1, not 0.

Acked-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/log2.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 25b8086..fd7ff3d 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -185,7 +185,6 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 #define rounddown_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
 		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )
-- 
1.7.12.1

