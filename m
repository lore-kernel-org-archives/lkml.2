Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426Ab2FHFHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43132 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759724Ab2FHFHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:10 -0400
Message-Id: <20120608041843.424970197@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John David Anglin <dave.anglin@bell.net>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 19/82] [PARISC] fix boot failure on 32-bit systems caused by branch stubs
 placed before .text
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit ed5fb2471b7060767957fb964eb1aaec71533ab1 upstream.

In certain configurations, the resulting kernel becomes too large to boot
because the linker places the long branch stubs for the merged .text section
at the very start of the image.  As a result, the initial transfer of control
jumps to an unexpected location.  Fix this by placing the head text in a
separate section so the stubs for .text are not at the start of the image.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/kernel/vmlinux.lds.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index fa6f2b8..64a9998 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -50,8 +50,10 @@ SECTIONS
 	. = KERNEL_BINARY_TEXT_START;
 
 	_text = .;		/* Text and read-only data */
-	.text ALIGN(16) : {
+	.head ALIGN(16) : {
 		HEAD_TEXT
+	} = 0
+	.text ALIGN(16) : {
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -65,7 +67,7 @@ SECTIONS
 		*(.fixup)
 		*(.lock.text)		/* out-of-line lock text */
 		*(.gnu.warning)
-	} = 0
+	}
 	/* End of text section */
 	_etext = .;
 


