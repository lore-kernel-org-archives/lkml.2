Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0J1JXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:23:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38028 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0J1JXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:23:19 -0400
X-IronPort-AV: E=Sophos;i="4.58,250,1286164800"; 
   d="scan'208";a="120052048"
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Borislav Petkov <bp@alien8.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1288202321.10179.102.camel@localhost.localdomain>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <20101027174417.GA19194@a1.tnic>
	 <1288202321.10179.102.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 28 Oct 2010 10:23:17 +0100
Message-ID: <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 18:58 +0100, Ian Campbell wrote:
> I think we could achieve this within the Xen pvops backend but e.g.
> the following would likely work also.
> 
> (Note, untested. I also omitted the reindent for clarity at this
> point)

Now tested and it works. Patch below.

I'm also going to look into switching Xen to startup on
initial_page_table, since I think the consistency with native would be
useful from a principle of least surprise PoV. However the following is
a useful stopgap if nothing else.

BTW, are there plans to unify 32 and 64 bit WRT the use of
swapper_pg_dir vs initial_page_table?

Ian.

8<-------------------------

>From 9bbce2e6b198cc7efeeebb87131e5b4e9ac923bd Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Thu, 28 Oct 2010 10:16:52 +0100
Subject: [PATCH] x86/32: skip early initialisation of swapper_pg_dir if it is already current

In particular in the Xen PV case the Xen early startup code has
already initialised swapper_pg_dir and switched to it. In this case
initial_page_table is uninitialised since Xen has no use for it so
copying it over swapper_pg_dir is not correct.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/setup.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 95a3274..2d89d5a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -705,12 +705,14 @@ void __init setup_arch(char **cmdline_p)
 	 * copy kernel address range established so far and switch
 	 * to the proper swapper page table
 	 */
-	clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
-			initial_page_table + KERNEL_PGD_BOUNDARY,
-			KERNEL_PGD_PTRS);
+	if (read_cr3() != __pa(swapper_pg_dir)) {
+		clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+				initial_page_table + KERNEL_PGD_BOUNDARY,
+				KERNEL_PGD_PTRS);
 
-	load_cr3(swapper_pg_dir);
-	__flush_tlb_all();
+		load_cr3(swapper_pg_dir);
+		__flush_tlb_all();
+	}
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
-- 
1.5.6.5



