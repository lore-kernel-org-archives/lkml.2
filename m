Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2E0A5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:57:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2E0A5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:57:43 -0400
Message-Id: <20120527002614.312238425@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:17 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Bottomley <JBottomley@Parallels.com>
Subject: [ 04/55] PARISC: fix PA1.1 oops on boot
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 5e185581d7c46ddd33cd9c01106d1fc86efb9376 upstream.

All PA1.1 systems have been oopsing on boot since

commit f311847c2fcebd81912e2f0caf8a461dec28db41
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed Dec 22 10:22:11 2010 -0600

    parisc: flush pages through tmpalias space

because a PA2.0 instruction was accidentally introduced into the PA1.1 TLB
insertion interruption path when it was consolidated with the do_alias macro.
Fix the do_alias macro only to use PA2.0 instructions if compiled for 64 bit.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/entry.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -581,7 +581,11 @@
 	 */
 	cmpiclr,=	0x01,\tmp,%r0
 	ldi		(_PAGE_DIRTY|_PAGE_READ|_PAGE_WRITE),\prot
+#ifdef CONFIG_64BIT
 	depd,z		\prot,8,7,\prot
+#else
+	depw,z		\prot,8,7,\prot
+#endif
 	/*
 	 * OK, it is in the temp alias region, check whether "from" or "to".
 	 * Check "subtle" note in pacache.S re: r23/r26.


