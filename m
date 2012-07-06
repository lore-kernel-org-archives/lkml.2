Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2GFOGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:06:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56271 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2GFOGx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 6 Jul 2012 10:06:53 -0400
Message-Id: <4FF70D54020000780008E179@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 15:07:48 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix alignment determination in range_to_mtrr()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the variable operated on being of "unsigned long" type, neither
ffs() nor fls() are suitable to use on them, as those truncate their
arguments to 32 bits. Using __ffs() and __fls() respectively at once
eliminates the need t subtract 1 from their results.

Additionally, with the alignment value subsequently used as a shift
count, it must be enforced to be less than BITS_PER_LONG (and on 64-bit
there's no need for it to be any smaller).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.5-rc5/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ 3.5-rc5-x86-mtrr-cleanup-types/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -258,11 +258,11 @@ range_to_mtrr(unsigned int reg, unsigned
 
 		/* Compute the maximum size with which we can make a range: */
 		if (range_startk)
-			max_align = ffs(range_startk) - 1;
+			max_align = __ffs(range_startk);
 		else
-			max_align = 32;
+			max_align = BITS_PER_LONG - 1;
 
-		align = fls(range_sizek) - 1;
+		align = __fls(range_sizek);
 		if (align > max_align)
 			align = max_align;
 



