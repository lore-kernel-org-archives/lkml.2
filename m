Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1FGOqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:46:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22474 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1FGOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:46:31 -0400
Date: Tue, 7 Jun 2011 16:38:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: sparclinux@vger.kernel.org
cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel() message.
Message-ID: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/sparc/kernel/traps_32.c::do_priv_instruction() we have this:

  die_if_kernel("Penguin instruction from Penguin mode??!?!", regs);

If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
preprocessor, so the final string will end up either as
  "Penguin instruction from Penguin mode|?!"
which I assume is not what we want, or as the correct string but with a 
warning about an ignored trigraph which I assume we don't want either. So, 
in order to elliminate the trigraph but keep the original string intact I 
changed it to

  die_if_kernel("Penguin instruction from Penguin mode?""?!?!", regs);

I've tested with a small test program on my x86-64 host and it behaves as 
I would expect, but I've not tested the actual code in 
arch/sparc/kernel/traps_32.c since I have no way to compile for sparc 
(which is why I submit this as a [RFC] patch).

Please take a look and apply if you agree :-)

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 traps_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index c0490c7..d99ca40 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -137,7 +137,7 @@ void do_priv_instruction(struct pt_regs *regs, unsigned long pc, unsigned long n
 	siginfo_t info;
 
 	if(psr & PSR_PS)
-		die_if_kernel("Penguin instruction from Penguin mode??!?!", regs);
+		die_if_kernel("Penguin instruction from Penguin mode?""?!?!", regs);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_PRVOPC;


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

