Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1LSUeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:34:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46916 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1LSUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:34:20 -0500
Date: Mon, 19 Dec 2011 12:34:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mm: Fix BUILD_BUG assertion in
 pmdp_clear_flush_young()
In-Reply-To: <4EEF960F.1070909@gmail.com>
Message-ID: <alpine.DEB.2.00.1112191230510.22060@chino.kir.corp.google.com>
References: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au> <1324316288-2367-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1112191125320.19949@chino.kir.corp.google.com> <4EEF960F.1070909@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, David Daney wrote:

> > The problem here is that HPAGE_PMD_MASK is being referenced without
> > CONFIG_TRANSPARENT_HUGEPAGE.  pmdp_clear_flush_young() is only applicable
> > with that config option enabled.  So rather than trying to minimize lines
> > captured under an #ifdef by placing the BUG() directly in the function for
> > asm-generic, you'll need to wrap pmd_clear_flush_young() with
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE and define its equivalent for
> > CONFIG_TRANSPARENT_HUGEPAGE=n that breaks the build if not enabled.
> > 
> 
> That does sound like a better option.
> 
> I still think having the BUILD_BUG defined as we do in Andrew Morton's tree is
> the correct approach, and I don't want to see that reverted because of this
> ugliness.
> 

Agreed, the problem here is that we have existing code, such as 
pmdp_clear_flush_young() that is calling BUG() at runtime for 
non-supported configurations.  So when BUILD_BUG_ON() for HPAGE_PMD_MASK 
and friends was introduced, it detects improper use that needs to be fixed 
and you've found one of those cases.

> Really this is hackery that should be cleaned up as you suggest, instead of
> being papered over with this BUG() thing.  I can't test SH things, otherwise I
> might look at it.  The SH maintainers should probably take a look instead.
> 

It's not only about sh, this will affect any architecture that uses the 
generic version of pmdp_clear_flush_young(), which is everything except 
x86.
