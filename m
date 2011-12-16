Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab1LPTwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964782Ab1LPTvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:58 2011
Message-Id: <20111216194558.749862947@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@vmware.com>
Subject: [29/53] linux/log2.h: Fix rounddown_pow_of_two(1)
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/log2.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -185,7 +185,6 @@ unsigned long __rounddown_pow_of_two(uns
 #define rounddown_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
 		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )


