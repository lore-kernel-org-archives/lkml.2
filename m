Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163092Ab1FAI1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:27:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162005Ab1FAI1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:13 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:12 2011
Message-Id: <20110601081212.190419866@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:46 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Tettamanti <kronos.it@gmail.com>,
        Massimo Dal Zotto <dz@debian.org>, Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [136/165] i8k: Avoid lahf in 64-bit code
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1060
Lines: 35

From: Luca Tettamanti <kronos.it@gmail.com>

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
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -139,8 +139,8 @@ static int i8k_smm(struct smm_regs *regs
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


