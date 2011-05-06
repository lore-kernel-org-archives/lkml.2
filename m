Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1EFA3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:29:36 -0400
Received: from kroah.org ([198.145.64.141]:37658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745Ab1EFA1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:10 2011
Message-Id: <20110506002610.769666521@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jim Bos <jim876@xs4all.nl>, Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [36/43] i8k: Tell gcc that *regs gets clobbered
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jim Bos <jim876@xs4all.nl>

commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48 upstream.

More recent GCC caused the i8k driver to stop working, on Slackware
compiler was upgraded from gcc-4.4.4 to gcc-4.5.1 after which it didn't
work anymore, meaning the driver didn't load or gave total nonsensical
output.

As it turned out the asm(..) statement forgot to mention it modifies the
*regs variable.

Credits to Andi Kleen and Andreas Schwab for providing the fix.

Signed-off-by: Jim Bos <jim876@xs4all.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/i8k.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -141,7 +141,7 @@ static int i8k_smm(struct smm_regs *regs
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,8 @@ static int i8k_smm(struct smm_regs *regs
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif


