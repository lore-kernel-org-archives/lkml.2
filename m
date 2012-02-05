Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2BEW1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:17 -0500
Received: from 1wt.eu ([62.212.114.60]:62129 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab2BEW1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:04 -0500
Message-Id: <20120205220953.271302918@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Luca Tettamanti <kronos.it@gmail.com>, Massimo Dal Zotto <dz@debian.org>,
        Jean Delvare <khali@linux-fr.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 89/91] i8k: Avoid lahf in 64-bit code
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit bc1f419c76a2d6450413ce4349f4e4a07be011d5 upstream.

i8k uses lahf to read the flag register in 64-bit code; early x86-64
CPUs, however, lack this instruction and we get an invalid opcode
exception at runtime.
Use pushf to load the flag register into the stack instead.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Reported-by: Jeff Rickman <jrickman@myamigos.us>
Tested-by: Jeff Rickman <jrickman@myamigos.us>
Tested-by: Harry G McGavran Jr <w5pny@arrl.net>
Cc: Massimo Dal Zotto <dz@debian.org>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/i8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/drivers/char/i8k.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/i8k.c	2012-02-05 22:34:47.136914619 +0100
+++ longterm-2.6.27/drivers/char/i8k.c	2012-02-05 22:34:47.574914836 +0100
@@ -138,8 +138,8 @@
 		"movl %%edi,20(%%rax)\n\t"
 		"popq %%rdx\n\t"
 		"movl %%edx,0(%%rax)\n\t"
-		"lahf\n\t"
-		"shrl $8,%%eax\n\t"
+		"pushfq\n\t"
+		"popq %%rax\n\t"
 		"andl $1,%%eax\n"
 		:"=a"(rc)
 		:    "a"(regs)


