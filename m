Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1FPHGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:06:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54716 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597Ab1FPHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:58 -0400
X-Sasl-enc: 2VGh1i37TND4eswlcmDKX7NcI8Hc9B37SrDM3ORvI/dG 1308207958
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:13 2011
Message-Id: <20110616001613.251602035@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luca Tettamanti <kronos.it@gmail.com>,
        Massimo Dal Zotto <dz@debian.org>, Jean Delvare <khali@linux-fr.org>
Subject: [40/91] i8k: Avoid lahf in 64-bit code
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -138,8 +138,8 @@ static int i8k_smm(struct smm_regs *regs
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


