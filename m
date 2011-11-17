Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1KQAId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:08:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46258 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1KQAIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:08:32 -0500
Date: Wed, 16 Nov 2011 16:08:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if
 !CONFIG_HUGETLB_PAGE
In-Reply-To: <4EC44AD0.5070800@gmail.com>
Message-ID: <alpine.DEB.2.00.1111161552450.25089@chino.kir.corp.google.com>
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com> <4EC43488.3070400@gmail.com> <alpine.DEB.2.00.1111161512371.16596@chino.kir.corp.google.com> <4EC44AD0.5070800@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-723309168-1321487821=:25089"
Content-ID: <alpine.DEB.2.00.1111161557030.25089@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-723309168-1321487821=:25089
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1111161557031.25089@chino.kir.corp.google.com>

On Wed, 16 Nov 2011, David Daney wrote:

> > > > > This is required now to get MIPS kernels to compile with
> > > > > !CONFIG_HUGETLB_PAGE.
> > > > > 
> > > > 
> > > > Why?
> > > 
> > > I should have been more specific.  The failure is in Ralf's
> > > mips-for-linux-next branch.
> > > 
> > 
> > I can't find that branch (it's not in Ralf's tree at git.kernel.org), so
> > I'm looking at next-20111116.  It doesn't compile for mips for other
> > reasons related to arch/mips/sgi-ip22/ip22-gio.c.
> 
> Ralf's various trees are accessible via linux-mips.org
> 

Wow, we've certainly gone a long way from a patch that appears to be 
fixing a problem in Linus' tree based on your commit message.  You're 
working from ralf/upstream-sfr.git#mips-for-linux-next from 
git.linux-mips.org.

Might want to have mentioned that for a patch labeled "hugetlb".

> > Which is wrong.  MIPS code should not be using HPAGE_SHIFT without
> > CONFIG_HUGETLB_PAGE and in fact defines it itself for such a configuration
> > in arch/mips/include/asm/page.h.  The only generic uses are in
> > page_alloc.c where we need CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which isn't
> > available on mips, and in mm/hugetlb.c which requires CONFIG_HUGETLB_PAGE
> > by way of CONFIG_HUGETLBFS.
> > 
> > So feel free to show the actual compile error this time and I'll suggest a
> > mips fix for it.
> 
> arch/mips/mm/tlb-r4k.c: In function ‘local_flush_tlb_range’:
> arch/mips/mm/tlb-r4k.c:129:28: error: ‘HPAGE_SHIFT’ undeclared (first use in
> this function)
> 

Do you see where that file has #ifdef's for CONFIG_HUGETLB_PAGE?  You need 
them here too.  The problem is that is_vm_hugetlb_page() is not #define to 
0 for CONFIG_HUGETLB_PAGE=n so the clauses using HPAGE_* aren't compiled 
out like the author is expecting.

> However, I call B.S. on your reasoning.
> 
> It is a well established kernel idiom to supply dummy values for symbols that
> are required to be defined in order to form a syntactically correct C program,
> but that are known by the programmer to be used only on dead code paths.
> 
> This is exactly what we are doing here.
> 
> To do otherwise requires that code be cluttered with #ifdefery.
> 

You're wrong, nobody should be using HPAGE_SHIFT unless they are working 
with hugepages and, in fact, that code that placed those "dummy values" 
for HPAGE_MASK and HPAGE_SIZE there has since been removed since 2005.

Defining HPAGE_SHIFT to be PAGE_SHIFT is just stupid and doing so may 
allow the program to compile but will hide real bugs later on.  In 
fact if you merged your patch, it would be a bug since the vma would have 
VM_HUGETLB but you'd now be operating on PAGE_SIZE pages!

Like I said, we should be removing those existing definitions of 
HPAGE_MASK and HPAGE_SIZE rather than leaving them so someone like you can 
come along and pretend there's any legitimacy to them whatsoever and 
extend the insanity.

You may not realize it, but changes to include/linux/hugetlb.h go through 
Andrew; Ralf won't be merging anything into this generic header file 
because of a mips problem.
--397155492-723309168-1321487821=:25089--
