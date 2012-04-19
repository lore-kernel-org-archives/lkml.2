Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2DSJ0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:26:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51206 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2DSJ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:26:00 -0400
Date: Thu, 19 Apr 2012 11:25:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/3] x86, extable: Carve out the main extable searching
 routine
Message-ID: <20120419092544.GC29542@aftab>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419092255.GA29542@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Mon, 26 Mar 2012 23:11:11 +0200
Subject: [PATCH 2/3] x86, extable: Carve out the main extable searching
 routine

For early exception handling and fixup we don't need the modules extable
so fork out the routine that searches the kernel's main extable.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/uaccess.h |    1 +
 kernel/extable.c               |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8be5f54d9360..66ef1c1d4087 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -96,6 +96,7 @@ struct exception_table_entry {
 };
 
 extern int fixup_exception(struct pt_regs *regs);
+extern const struct exception_table_entry *search_main_extable(unsigned long);
 
 /*
  * These are the main single-value transfer routines.  They automatically
diff --git a/kernel/extable.c b/kernel/extable.c
index 5339705b8241..d95188c2f723 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,12 +41,17 @@ void __init sort_main_extable(void)
 	sort_extable(__start___ex_table, __stop___ex_table);
 }
 
+const struct exception_table_entry *search_main_extable(unsigned long addr)
+{
+	return search_extable(__start___ex_table, __stop___ex_table-1, addr);
+}
+
 /* Given an address, look for it in the exception tables. */
 const struct exception_table_entry *search_exception_tables(unsigned long addr)
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___ex_table, __stop___ex_table-1, addr);
+	e = search_main_extable(addr);
 	if (!e)
 		e = search_module_extables(addr);
 	return e;
-- 
1.7.5.3.401.gfb674


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
