Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2FGEQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:16:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2FGEQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:09 -0400
Message-Id: <20120607040338.436136890@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John David Anglin <dave.anglin@bell.net>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 14/82] PARISC: fix boot failure on 32-bit systems caused by branch stubs placed before .text
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/vmlinux.lds.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
 


