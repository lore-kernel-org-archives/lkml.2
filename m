Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0LLXqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44934 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0LLXqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:05 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: richard@nod.at, tabbott@ksplice.com, jdike@addtoit.com, ak@linux.intel.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [66/223] um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
Message-Id: <20101212234604.75F7DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Richard Weinberger <richard@nod.at>

commit 6915e04f8847bea16d0890f559694ad8eedd026c upstream.

The linker script cleanup that I did in commit 5d150a97f93 ("um: Clean up
linker script using standard macros.") (2.6.32) accidentally introduced an
ALIGN(PAGE_SIZE) when converting to use INIT_TEXT_SECTION; Richard
Weinberger reported that this causes the kernel to segfault with
CONFIG_STATIC_LINK=y.

I'm not certain why this extra alignment is a problem, but it seems likely
it is because previously

__init_begin = _stext = _text = _sinittext

and with the extra ALIGN(PAGE_SIZE), _sinittext becomes different from the
rest.  So there is likely a bug here where something is assuming that
_sinittext is the same as one of those other symbols.  But reverting the
accidental change fixes the regression, so it seems worth committing that
now.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Reported-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested by: Antoine Martin <antoine@nagafix.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/kernel/uml.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/um/kernel/uml.lds.S
===================================================================
--- linux.orig/arch/um/kernel/uml.lds.S
+++ linux/arch/um/kernel/uml.lds.S
@@ -22,7 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
