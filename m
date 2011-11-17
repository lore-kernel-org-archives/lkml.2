Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1KQXoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:44:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43868 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1KQXoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:44:54 -0500
Date: Thu, 17 Nov 2011 15:44:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, linux-arch@vger.kernel.org,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and
 HPAGE_SIZE
In-Reply-To: <20111117153526.f90ee248.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1111171538540.13555@chino.kir.corp.google.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com> <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <20111117153526.f90ee248.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Andrew Morton wrote:

> > So, just remove the dummy and dangerous definitions since they are no
> > longer needed and reveals the correct dependencies.  Tested on
> > architectures using the definitions with allyesconfig: x86 (even with
> > thp), hppa, mips, powerpc, s390, sh3, sh4, sparc, and sparc64, and
> > with defconfig on ia64.
> 
> How could arch/mips/mm/tlb-r4k.c:local_flush_tlb_range() compile OK
> with this change?
> 

This was tested on Linus' tree, not on Ralf's linux-next tree.  All uses 
of HPAGE_* are protected by CONFIG_HUGETLB_PAGE as it appropriately should 
be in Linus' tree in that file.

> What that function is doing looks reasonable to me.  Why fill the poor
> thing with an ifdef mess?
> 
> otoh, catching mistakes is good too.  Doing it at runtime as David
> proposes is OK.
> 

Nobody else needs it other than Ralf's pending change, and you're 
suggesting we need them in a generic header file when any sane arch that 
uses hugepages (all of them, in the current tree) declares these 
themselves in arch/*/include/asm/page.h where it's supposed to be done?

Why on earth do we have CONFIG_HUGETLB_PAGE for at all, then?  To catch 
code that's operating on hugepages when our kernel doesn't support it.  
I'd much rather break the build than get a runtime BUG() because we want 
to avoid an #ifdef or actually write well-written code like every other 
arch has!  Panicking the code to find errors like this is just insanity.
