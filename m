Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1DNSaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:30:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:37932 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab1DNRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Richard Weinberger <richard@nod.at>,
        Tim Abbott <tabbott@ksplice.com>, Jeff Dike <jdike@addtoit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 033/209] um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
Date: Thu, 14 Apr 2011 13:41:03 -0400
Message-Id: <1302803039-9400-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/kernel/uml.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..664f942 100644
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
-- 
1.7.4.4

