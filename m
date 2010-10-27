Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0J0R6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:58:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25021 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0J0R6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:58:44 -0400
X-IronPort-AV: E=Sophos;i="4.58,247,1286164800"; 
   d="scan'208";a="10837756"
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Borislav Petkov <bp@alien8.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20101027174417.GA19194@a1.tnic>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <20101027174417.GA19194@a1.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 27 Oct 2010 18:58:41 +0100
Message-ID: <1288202321.10179.102.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 18:44 +0100, Borislav Petkov wrote:
> On Wed, Oct 27, 2010 at 10:31:37AM -0700, Jeremy Fitzhardinge wrote:
> > > Xen shouldn't have any users of this, since it's used for low-level
> > > operations like SMP bootstrap, suspend to RAM, reboot and low-level
> > > BIOS functionality.
> > >
> > Right, but it is being called smack in the middle of setup_arch().  It
> > looks like they could be hidden away in
> > native_pagetable_setup_start/done though.
> 
> I think I can put the second sync-back clone_pgd_range in
> native_pagetable_setup_done but the first one needs to take place right
> at the beginning of setup_arch() because a lot of code in-between relies
> on swapper_pg_dir containing proper entries.
> 
> Just to make sure I understand you correctly: best it would be for xen
> to not have the copy_pgd_range() calls in setup_arch, correct?

Yes, or to ensure that swapper_pg_dir has not yet been marked as a
pagetable at this point. Under Xen we are running on swapper_pg_dir when
setup_arch is called.

I think we could achieve this within the Xen pvops backend but e.g. the
following would likely work also.

(Note, untested. I also omitted the reindent for clarity at this point)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 95a3274..2d89d5a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -705,12 +705,14 @@ void __init setup_arch(char **cmdline_p)
 	 * copy kernel address range established so far and switch
 	 * to the proper swapper page table
 	 */
+	if (read_cr3() != __pa(swapper_pg_dir)) {
 	clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
 			initial_page_table + KERNEL_PGD_BOUNDARY,
 			KERNEL_PGD_PTRS);
 
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
+	}
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif


