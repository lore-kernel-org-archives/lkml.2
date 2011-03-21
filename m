Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1CUXci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:32:38 -0400
Received: from kroah.org ([198.145.64.141]:52531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1CUXRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:23 2011
Message-Id: <20110321230322.983753991@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [13/78] microblaze: Fix /dev/zero corruption from __clear_user()
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven J. Magnani <steve@digidescorp.com>

commit 6f3946b421395ff853bc0bcdab9c26b50ebbba8f upstream.

A userland read of more than PAGE_SIZE bytes from /dev/zero results in
(a) not all of the bytes returned being zero, and
(b) memory corruption due to zeroing of bytes beyond the user buffer.

This is caused by improper constraints on the assembly __clear_user function.
The constrints don't indicate to the compiler that the pointer argument is
modified. Since the function is inline, this results in double-incrementing
of the pointer when __clear_user() is invoked through a multi-page read() of
/dev/zero.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/microblaze/include/asm/uaccess.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -120,16 +120,16 @@ static inline unsigned long __must_check
 {
 	/* normal memset with two words to __ex_table */
 	__asm__ __volatile__ (				\
-			"1:	sb	r0, %2, r0;"	\
+			"1:	sb	r0, %1, r0;"	\
 			"	addik	%0, %0, -1;"	\
 			"	bneid	%0, 1b;"	\
-			"	addik	%2, %2, 1;"	\
+			"	addik	%1, %1, 1;"	\
 			"2:			"	\
 			__EX_TABLE_SECTION		\
 			".word	1b,2b;"			\
 			".previous;"			\
-		: "=r"(n)				\
-		: "0"(n), "r"(to)
+		: "=r"(n), "=r"(to)			\
+		: "0"(n), "1"(to)
 	);
 	return n;
 }


