Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0LHBAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:52 -0500
Received: from kroah.org ([198.145.64.141]:48856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153Ab0LHBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005731.943729010@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Abbott <tabbott@ksplice.com>, Jeff Dike <jdike@addtoit.com>
Subject: [106/289] um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Tested by: Antoine Martin <antoine@nagafix.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/kernel/uml.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -22,7 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :


