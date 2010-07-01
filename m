Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0GAWGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:06:37 -0400
Received: from kroah.org ([198.145.64.141]:47590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab0GAUuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:32 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.628588375@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anfei Zhou <anfei.zhou@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 081/164] ARM: 6166/1: Proper prefetch abort handling on pre-ARMv6
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anfei <anfei.zhou@gmail.com>

commit 5e27fb78df95e027723af2c90ecc9b4527ae59e9 upstream.

Instruction faults on pre-ARMv6 CPUs are interpreted as
a 'translation fault', but do_translation_fault doesn't
handle well if user mode trying to run instruction above
TASK_SIZE, and result in the infinite retry of that
instruction.

Signed-off-by: Anfei Zhou <anfei.zhou@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/fault.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -386,6 +386,9 @@ do_translation_fault(unsigned long addr,
 	if (addr < TASK_SIZE)
 		return do_page_fault(addr, fsr, regs);
 
+	if (user_mode(regs))
+		goto bad_area;
+
 	index = pgd_index(addr);
 
 	/*


